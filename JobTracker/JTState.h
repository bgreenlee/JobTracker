//
//  JTState.h
//  JobTracker
//
//  Created by Brad Greenlee on 11/6/12.
//  Copyright (c) 2012 Etsy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JTJob.h"

@interface JTState : NSObject {
    NSArray *lastRunningJobs;
    BOOL refreshRunning;
}

@property(nonatomic, retain) NSMutableDictionary *clusterSummary;
@property(nonatomic, retain) NSMutableDictionary *jobs;
@property(nonatomic, retain) NSArray *urls;
@property(nonatomic, retain) NSArray *usernames;
@property(nonatomic, retain) id delegate;
@property(nonatomic, retain) NSError *currentError;

+ (id)sharedInstance;
- (void)setUsernameString:(NSString *)usernames;
- (void)refresh;
- (void)parse:(NSXMLDocument *)document;
- (void)parseCDH4:(NSXMLDocument *)document;
- (void)parseCDH5:(NSXMLDocument *)document;
@end

@protocol JTStateDelegate

- (void)stateUpdated;
- (void)jobStarted:(JTJob *)job;
- (void)jobCompleted:(JTJob *)job;
- (void)jobFailed:(JTJob *)job;

@end