//
//  JTState.m
//  JobTracker
//
//  Created by Brad Greenlee on 11/6/12.
//  Copyright (c) 2012 Etsy. All rights reserved.
//

#import "JTState.h"

@implementation JTState
static JTState *shared;

@synthesize clusterSummary, jobs, urls, usernames, delegate, currentError;

+ (id)sharedInstance {
    return shared;
}

+ (void)initialize {
    static BOOL initialized = NO;
    if (!initialized) {
        initialized = YES;
        shared = [[JTState alloc] init];
    }
}

- (id)init {
    if ((self = [super init])) {
        clusterSummary = [[NSMutableDictionary alloc] init];
        jobs = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)setUsernameString:(NSString *)usernameString{
    if (usernameString == nil || [usernameString isEqualToString:@""]) {
        usernames = @[];
    } else {
        usernames = [usernameString componentsSeparatedByString:@","];
    }
}

- (void)refresh {
    @synchronized(self) {
        [self fetchDataFromURLs:urls];
    }
}

// TODO: move this and the parsing code elsewhere
- (void)fetchDataFromURLs:(NSArray *)targetURLs {
    for (NSURL *targetURL in targetURLs) {
        // make the request. We used to just pass the url to NSXMLDocument's initWithContentsOfURL, but that
        // seems to send the wrong content-type, and CDH5 gives us back json, which NSXMLDocument kindly wraps
        // in XTHML for us.
        NSLog(@"sending request: %@", targetURL);
        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:targetURL];
        [req setValue:@"application/xml;level=1, */*" forHTTPHeaderField:@"Accept"];
        NSHTTPURLResponse *httpResponse = nil;
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:req
                                             returningResponse:&httpResponse
                                                         error:&error];
        
        NSXMLDocument *document = nil;
        if (data) {
            NSLog(@"received %ld bytes", [data length]);
            document = [[NSXMLDocument alloc] initWithData:data
                                                   options:NSXMLDocumentTidyHTML
                                                     error:&error];
            
            if (document) {
                currentError = nil;
                document.URI = [targetURL absoluteString]; // so we know where this came from
                [self parse:document];
            }
        }
        
        if (document == nil) {
            currentError = error;
        }
    }
}

- (void)parse:(NSXMLDocument *)document {
    NSInteger cdhVersion = [[NSUserDefaults standardUserDefaults] integerForKey:@"cdhVersion"];
    if (cdhVersion == 4) {
        [self parseCDH4:document];
    } else {
        [self parseCDH5:document];
    }
    [self.delegate performSelectorOnMainThread:@selector(stateUpdated) withObject:nil waitUntilDone:NO];
}

- (void)parseCDH5:(NSXMLDocument *)document {
    // Ugh, so hacky. We need to know if this is the RUNNING apps-only document
    // so we know which lists to update
    bool isRunningList = [document.URI rangeOfString:@"RUNNING"].location != NSNotFound;
    
    NSMutableArray *runningList = [[NSMutableArray alloc] init];
    NSMutableArray *completedList = [[NSMutableArray alloc] init];
    NSMutableArray *failedList = [[NSMutableArray alloc] init];

    NSArray *apps = [document nodesForXPath:@"/apps/*" error:nil];
    NSLog(@"found %ld apps in response", [apps count]);
    for (NSXMLElement *app in apps) {
        NSMutableDictionary *jobData = [[NSMutableDictionary alloc] init];
        jobData[@"user"] = [[[app nodesForXPath:@"./user" error:nil] objectAtIndex:0] stringValue];
        if (self.usernames == nil || [self.usernames count] == 0 || [self.usernames containsObject:jobData[@"user"]]) {
            jobData[@"job_id"] = [[[app nodesForXPath:@"./id" error:nil] objectAtIndex:0] stringValue];
            jobData[@"name"] = [[[app nodesForXPath:@"./name" error:nil] objectAtIndex:0] stringValue];
            NSString *state = [[[app nodesForXPath:@"./state" error:nil] objectAtIndex:0] stringValue];
            JTJob *job = [[JTJob alloc] initWithDictionary:jobData];

            if ([state isEqualToString:@"RUNNING"]) {
                [runningList addObject:job];
            } else if ([state isEqualToString:@"FINISHED"]) {
                [completedList addObject:job];
            } else if ([state isEqualToString:@"FAILED"]) {
                [failedList addObject:job];
            }
        }
    }
    if (isRunningList) {
        [jobs setObject:runningList forKey:@"running"];
    } else {
        [jobs setObject:completedList forKey:@"completed"];
        [jobs setObject:failedList forKey:@"failed"];
    }
    
    // check/update last running job list
    if (lastRunningJobs != nil) {
        NSArray *runningJobs = [jobs objectForKey:@"running"];
        for (JTJob *job in runningJobs) {
            if (![lastRunningJobs containsObject:job]) {
                [self.delegate jobStarted:job];
            }
        }
        for (JTJob *job in lastRunningJobs) {
            NSArray *completedJobs = [jobs objectForKey:@"completed"];
            if ([completedJobs containsObject:job]) {
                [self.delegate jobCompleted:job];
            }
            NSArray *failedJobs = [jobs objectForKey:@"failed"];
            if ([failedJobs containsObject:job]) {
                [self.delegate jobFailed:job];
            }
        }
    }
    
    if (isRunningList) {
        lastRunningJobs = [jobs objectForKey:@"running"];
    }
}

// TODO: set an error if we can't parse the page
- (void)parseCDH4:(NSXMLDocument *)document {
    // Cluster Summary
    NSArray *nodes = [document nodesForXPath:@".//table[1]" error:nil];
    NSXMLElement *clusterSummaryTable;
    if ([nodes count] > 0) {
        clusterSummaryTable = [nodes objectAtIndex:0];
        nodes = [clusterSummaryTable nodesForXPath:@".//tr[2]//td" error:nil];
        if ([nodes count] > 0) {
            NSArray *attribs = [NSArray arrayWithObjects:@"running_map_tasks", @"running_reduce_tasks", @"total_submissions",
                                @"nodes", @"occupied_map_slots", @"occupied_reduce_slots", @"reserved_map_slots",
                                @"reserved_reduce_slots", @"map_task_capacity", @"reduce_task_capacity", @"avg_tasks_per_node",
                                @"blacklisted_nodes", @"excluded_nodes", nil];
            [attribs enumerateObjectsUsingBlock:^(id attrib, NSUInteger idx, BOOL *stop) {
                #pragma unused (stop)
                NSString *value = [[[nodes objectAtIndex:idx] stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                [clusterSummary setObject:value forKey:attrib];
            }];
        }
    }
        
    // Jobs tables
    NSArray *dataTables = [document nodesForXPath:@".//table[@class='datatable']" error:nil];
    NSArray *jobTypes = [NSArray arrayWithObjects:@"running", @"completed", @"failed", nil];
    [jobTypes enumerateObjectsUsingBlock:^(id jobType, NSUInteger idx, BOOL *stop __unused) {
        if (idx >= [dataTables count]) {
            return;
        }
        NSXMLElement *jobsTable = [dataTables objectAtIndex:idx];
        NSArray *jobRows = [jobsTable nodesForXPath:@"./tbody/tr" error:nil];
        NSMutableArray *jobList = [[NSMutableArray alloc] init];
        for (NSXMLElement *jobRow in jobRows) {
            NSArray *jobCells = [jobRow nodesForXPath:@"./td" error:nil];
            NSArray *attribs = [NSArray arrayWithObjects:@"job_id", @"priority", @"user", @"name", @"map_pct_complete",
                                @"map_total", @"maps_completed", @"reduce_pct_complete", @"reduce_total", @"reduces_complete",
                                @"job_scheduling_info", @"diagnostic_info", nil];
            NSMutableDictionary *jobData = [[NSMutableDictionary alloc] init];
            [attribs enumerateObjectsUsingBlock:^(id attrib, NSUInteger idx, BOOL *stop) {
                #pragma unused (stop)
                NSString *value = [[[jobCells objectAtIndex:idx] stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                [jobData setObject:value forKey:attrib];
            }];
            JTJob *job = [[JTJob alloc] initWithDictionary:jobData];
            if (self.usernames == nil || [self.usernames count] == 0 || [self.usernames containsObject:job.user]) {
                [jobList addObject:job];
            }
        }
        [jobs setObject:jobList forKey:jobType];
    }];
    
    // check/update last running job list
    if (lastRunningJobs != nil) {
        NSArray *runningJobs = [jobs objectForKey:@"running"];
        for (JTJob *job in runningJobs) {
            if (![lastRunningJobs containsObject:job]) {
                [self.delegate jobStarted:job];
            }
        }
        for (JTJob *job in lastRunningJobs) {
            NSArray *completedJobs = [jobs objectForKey:@"completed"];
            if ([completedJobs containsObject:job]) {
                [self.delegate jobCompleted:job];
            }
            NSArray *failedJobs = [jobs objectForKey:@"failed"];
            if ([failedJobs containsObject:job]) {
                [self.delegate jobFailed:job];
            }
        }
    }
    lastRunningJobs = [jobs objectForKey:@"running"];
}
@end
