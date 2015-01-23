//
//  JTStateTests.m
//  JTStateTests
//
//  Created by Brad Greenlee on 10/21/12.
//  Copyright (c) 2012 Hack Arts. All rights reserved.
//

#import "JTStateTests.h"

@implementation JTStateTests

- (void)setUp {
    [super setUp];
    NSBundle *thisBundle = [NSBundle bundleForClass:[self class]];
    NSString *filePath = [thisBundle pathForResource:@"jobtracker" ofType:@"html"];
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    NSXMLDocument *document = [[NSXMLDocument alloc] initWithContentsOfURL:fileUrl
                                                                   options:NSXMLDocumentTidyHTML
                                                                     error:nil];
    jtState = [JTState sharedInstance];
    jtState.urls = @[fileUrl];
    [jtState parseCDH4:document];
}

- (void)tearDown { 
    [super tearDown];
}

- (void)testClusterSummary {
    NSDictionary *answerDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"39.13", @"avg_tasks_per_node",
                                @"0", @"blacklisted_nodes",
                                @"0", @"excluded_nodes",
                                @"3481", @"map_task_capacity",
                                @"148", @"nodes",
                                @"1000", @"occupied_map_slots",
                                @"528", @"occupied_reduce_slots",
                                @"2310", @"reduce_task_capacity",
                                @"0", @"reserved_map_slots",
                                @"0", @"reserved_reduce_slots",
                                @"1000", @"running_map_tasks",
                                @"528", @"running_reduce_tasks",
                                @"110129", @"total_submissions", nil];
    XCTAssertTrue([jtState.clusterSummary isEqualToDictionary:answerDict], @"Cluster summary incorrect");
}

- (void)testRunningJobs {
    NSArray *jobs = [jtState.jobs objectForKey:@"running"];
    XCTAssertTrue([jobs count] == 2, @"Incorrect job count");
}

- (void)testCompletedJobs {
    NSArray *jobs = [jtState.jobs objectForKey:@"completed"];
    XCTAssertTrue([jobs count] == 2, @"Incorrect job count");
}

- (void)testFailedJobs {
    NSArray *jobs = [jtState.jobs objectForKey:@"failed"];
    XCTAssertTrue([jobs count] == 1, @"Incorrect job count");
}

@end
