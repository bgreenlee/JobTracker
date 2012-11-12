//
//  JTJob.h
//  JobTracker
//
//  Created by Brad Greenlee on 11/9/12.
//  Copyright (c) 2012 Hack Arts. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JTJob : NSObject {
    NSDictionary *jobData;
}

@property (nonatomic, copy) NSString *jobId;
@property (nonatomic, copy) NSString *priority;
@property (nonatomic, copy) NSString *user;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, copy) NSString *mapPctComplete;
@property (nonatomic, copy) NSString *mapTotal;
@property (nonatomic, copy) NSString *mapsCompleted;
@property (nonatomic, copy) NSString *reducePctComplete;
@property (nonatomic, copy) NSString *reduceTotal;
@property (nonatomic, copy) NSString *reducesComplete;
@property (nonatomic, copy) NSString *jobSchedulingInfo;
@property (nonatomic, copy) NSString *diagnosticInfo;

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
