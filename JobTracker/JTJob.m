//
//  JTJob.m
//  JobTracker
//
//  Created by Brad Greenlee on 11/9/12.
//  Copyright (c) 2012 Hack Arts. All rights reserved.
//

#import "JTJob.h"

@implementation JTJob

@synthesize jobId, priority, user, name, displayName, mapPctComplete, mapTotal, mapsCompleted,
reducePctComplete, reduceTotal, reducesComplete, jobSchedulingInfo, diagnosticInfo;

- (id)initWithDictionary:(NSDictionary *)dict {
    if ((self = [super init])) {
        jobData = dict;
    }
    return self;
}

- (NSString *)jobId {
    return [jobData objectForKey:@"job_id"];
}

- (NSString *)priority {
    return [jobData objectForKey:@"priority"];
}

- (NSString *)user {
    return [jobData objectForKey:@"user"];
}

- (NSString *)name {
    return [jobData objectForKey:@"name"];
}

- (NSString *)displayName {
    NSArray *parts = [self.name componentsSeparatedByString:@" "];
    return [NSString stringWithFormat:@"%@ (%@)", [parts objectAtIndex:[parts count]-1], self.user];
}

- (NSString *)mapPctComplete {
    return [jobData objectForKey:@"map_pct_complete"];
}

- (NSString *)mapTotal {
    return [jobData objectForKey:@"map_total"];
}

- (NSString *)mapsCompleted {
    return [jobData objectForKey:@"maps_completed"];
}

- (NSString *)reducePctComplete {
    return [jobData objectForKey:@"reduce_pct_complete"];
}

- (NSString *)reduceTotal {
    return [jobData objectForKey:@"reduce_total"];
}

- (NSString *)reducesComplete {
    return [jobData objectForKey:@"reduces_complete"];
}

- (NSString *)jobSchedulingInfo {
    return [jobData objectForKey:@"job_scheduling_info"];
}

- (NSString *)diagnosticInfo {
    return [jobData objectForKey:@"diagnostic_info"];
}

@end
