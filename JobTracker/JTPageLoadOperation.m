//
//  JTLoadOperation.m
//  JobTracker
//
//  Created by Brad Greenlee on 11/9/12.
//  Copyright (c) 2012 Etsy. All rights reserved.
//

#import "JTPageLoadOperation.h"
#import "JTState.h"

@implementation JTPageLoadOperation

@synthesize targetURL;

- (id)initWithURL:(NSURL *)url {
    if ((self = [super init])) {
        [self setTargetURL:url];
    }
    return self;
}

- (void)main {
    NSError *error;
    NSXMLDocument *document = [[NSXMLDocument alloc] initWithContentsOfURL:targetURL
                                                                   options:NSXMLDocumentTidyHTML
                                                                     error:&error];
    JTState *jtState = [JTState sharedInstance];
    
    if (document) {
        [jtState performSelectorOnMainThread:@selector(pageLoaded:)
                                    withObject:document
                               waitUntilDone:YES];

    } else {
        [jtState performSelectorOnMainThread:@selector(errorLoadingPage:)
                                  withObject:error
                               waitUntilDone:NO];
    }
    
}

@end
