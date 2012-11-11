//
//  JTParser.h
//  JobTracker
//
//  Created by Brad Greenlee on 11/6/12.
//  Copyright (c) 2012 Hack Arts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JTJob.h"

@interface JTState : NSObject {
  	NSOperationQueue *queue;
}

@property(nonatomic, retain) NSMutableDictionary *clusterSummary;
@property(nonatomic, retain) NSMutableDictionary *jobs;
@property(nonatomic, retain) NSURL *url;
@property(nonatomic, retain) NSArray *usernames;
@property(nonatomic, retain) id delegate;

- (id)initWithURL:(NSURL *)url withUsernames:(NSString *)usernames;
- (void)pageLoaded:(NSXMLDocument *)document;
- (void)refresh;
- (void)parse:(NSXMLDocument *)document;
@end

@protocol JTStateDelegate

- (void)stateUpdated;

@end