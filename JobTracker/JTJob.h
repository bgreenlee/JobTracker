//
//  JTJob.h
//  JobTracker
//
//  Created by Brad Greenlee on 11/9/12.
//  Copyright (c) 2012 Etsy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JTJob : NSObject {
    NSDictionary *jobData;
}

- (id)initWithDictionary:(NSDictionary *)dict;
- (NSString *)jobId;
- (NSString *)priority;
- (NSString *)user;
- (NSString *)name;
- (NSString *)displayName;
- (NSString *)mapPctComplete;
- (NSString *)mapTotal;
- (NSString *)mapsCompleted;
- (NSString *)reducePctComplete;
- (NSString *)reduceTotal;
- (NSString *)reducesComplete;
- (NSString *)jobSchedulingInfo;
- (NSString *)diagnosticInfo;
- (BOOL)isEqual:(id)other;
- (NSUInteger)hash;

@end
