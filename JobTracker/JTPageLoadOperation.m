//
//  JTLoadOperation.m
//  JobTracker
//
//  Created by Brad Greenlee on 11/9/12.
//  Copyright (c) 2012 Hack Arts. All rights reserved.
//

#import "JTPageLoadOperation.h"
#import "JTState.h"

@implementation JTPageLoadOperation

@synthesize targetURL;

- (id)initWithURL:(NSURL *)url {
    if (![super init]) return nil;
    [self setTargetURL:url];
    return self;
}

- (void)main {
    NSError *error;
    NSXMLDocument *document = [[NSXMLDocument alloc] initWithContentsOfURL:targetURL
                                                                   options:NSXMLDocumentTidyHTML
                                                                     error:&error];
    
    if (!document) {
        NSLog(@"Error loading document: %@", error);
    }
    
    [[[JTState alloc] init] performSelectorOnMainThread:@selector(pageLoaded:)
                                       withObject:document
                                    waitUntilDone:YES];
}

@end
