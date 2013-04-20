//
//  JTParser.m
//  JobTracker
//
//  Created by Brad Greenlee on 11/6/12.
//  Copyright (c) 2012 Hack Arts. All rights reserved.
//

#import "JTState.h"
#import "JTPageLoadOperation.h"

@implementation JTState
static JTState *shared;

@synthesize clusterSummary, jobs, url, usernames, delegate;

- (id)init {
    if (shared) {
        return shared;
    }
    if ((self = [super init])) {
        clusterSummary = [[NSMutableDictionary alloc] init];
        jobs = [[NSMutableDictionary alloc] init];
        queue = [[NSOperationQueue alloc] init];
    }
    shared = self;
    return self;
}

- (id)initWithURL:(NSURL *)_url withUsernames:(NSString *)_usernames{
    self = [self init];
    url = _url;
    if (_usernames == nil || [_usernames isEqualToString:@""]) {
        usernames = nil;
    } else {
        usernames = [_usernames componentsSeparatedByString:@","];
    }
    return self;
}

- (void)pageLoaded:(NSXMLDocument *)document {
    [self parse:document];
}

- (void)refresh {
    if (!refreshRunning) {
        JTPageLoadOperation *plo = [[JTPageLoadOperation alloc] initWithURL:url];
        [queue addOperation:plo];
        refreshRunning = YES;
    }
}

- (void)parse:(NSXMLDocument *)document {
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
                NSString *value = [[[nodes objectAtIndex:idx] stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                [clusterSummary setObject:value forKey:attrib];
            }];
        }
    }
        
    // Jobs tables
    NSArray *dataTables = [document nodesForXPath:@".//table[@class='datatable']" error:nil];
    NSArray *jobTypes = [NSArray arrayWithObjects:@"running", @"completed", @"failed", nil];
    [jobTypes enumerateObjectsUsingBlock:^(id jobType, NSUInteger idx, BOOL *stop) {
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
    refreshRunning = NO;
    [self.delegate stateUpdated];
}
@end
