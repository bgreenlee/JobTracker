//
//  JTJob.m
//  JobTracker
//
//  Created by Brad Greenlee on 11/9/12.
//  Copyright (c) 2012 Etsy. All rights reserved.
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
    // strip anything at the start of the string in brackets
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^(\\[.*?\\])?\\s*"
                                                                           options:0
                                                                             error:nil];
    NSString *dispName = [regex stringByReplacingMatchesInString:self.name
                                                         options:0
                                                           range:NSMakeRange(0, [self.name length])
                                                    withTemplate:@""];
    
    return [NSString stringWithFormat:@"%@ (%@)", dispName, self.user];
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

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    return [[self jobId] isEqualToString:[other jobId]];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash += [[self jobId] hash];
    return hash;
}

@end
