//
//  JTParser.m
//  JobTracker
//
//  Created by Brad Greenlee on 11/6/12.
//  Copyright (c) 2012 Hack Arts. All rights reserved.
//

#import "JTState.h"

@implementation JTState

@synthesize clusterSummary, jobs;

- (id)init {
    if ((self = [super init])) {
        clusterSummary = [[NSMutableDictionary alloc] init];
        jobs = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)refresh {
    NSError *err;
    NSXMLDocument *document = [[NSXMLDocument alloc] initWithContentsOfURL:[NSURL URLWithString:JT_URL]
                                                                   options:NSXMLDocumentTidyHTML error:&err];
    
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"jt_sample" ofType:@"html"];
//    NSData *data = [NSData dataWithContentsOfFile:filePath];
//    NSXMLDocument *document = [[NSXMLDocument alloc] initWithData:data options:NSXMLDocumentTidyHTML error:nil];
    
    if (err) {
        NSLog(@"ERROR: %@", err);
    }

    if (document) {
        [self parse:document];
    }
}

- (void)parse:(NSXMLDocument *)document {
    // Cluster Summary
    NSArray *nodes = [document nodesForXPath:@".//table[1]" error:nil];
    NSXMLElement *clusterSummaryTable;
    if ([nodes count] > 0) {
        clusterSummaryTable = [nodes objectAtIndex:0];
        nodes = [clusterSummaryTable nodesForXPath:@"./tr[2]//td" error:nil];
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
    
    NSLog(@"cluster summary: %@", clusterSummary);
    
    // Jobs tables
    NSArray *dataTables = [document nodesForXPath:@".//table[@class='datatable']" error:nil];
    NSArray *jobTypes = [NSArray arrayWithObjects:@"running", @"completed", @"failed", nil];
    [jobTypes enumerateObjectsUsingBlock:^(id jobType, NSUInteger idx, BOOL *stop) {
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
            [jobList addObject:[[JTJob alloc] initWithDictionary:jobData]];
        }
        [jobs setObject:jobList forKey:jobType];
    }];
    
    NSLog(@"jobs: %@", jobs);
}
@end
