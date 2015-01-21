//
//  JTLoadOperation.h
//  JobTracker
//
//  Created by Brad Greenlee on 11/9/12.
//  Copyright (c) 2012 Etsy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JTPageLoadOperation : NSOperation {
    NSArray *targetURLs;
}

@property(nonatomic, retain) NSArray *targetURLs;

- (id)initWithURLs:(NSArray *)urls;

@end
