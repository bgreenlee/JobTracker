//
//  JTLoadOperation.h
//  JobTracker
//
//  Created by Brad Greenlee on 11/9/12.
//  Copyright (c) 2012 Hack Arts. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JTPageLoadOperation : NSOperation {
    NSURL *targetURL;
}

@property(retain) NSURL *targetURL;

- (id)initWithURL:(NSURL*)url;

@end
