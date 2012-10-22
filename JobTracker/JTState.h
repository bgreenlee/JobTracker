//
//  JTParser.h
//  JobTracker
//
//  Created by Brad Greenlee on 11/6/12.
//  Copyright (c) 2012 Hack Arts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JTJob.h"

#define JT_URL @"http://jobtracker.doop.ny4.etsy.com:50030/jobtracker.jsp"

@interface JTState : NSObject {
    NSMutableDictionary *clusterSummary;
    NSMutableDictionary *jobs;
}

@property(nonatomic, retain) NSMutableDictionary *clusterSummary;
@property(nonatomic, retain) NSMutableDictionary *jobs;

- (void)refresh;
- (void)parse:(NSXMLDocument *)document;
@end
