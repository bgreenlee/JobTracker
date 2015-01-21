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

@synthesize targetURLs;

- (id)initWithURLs:(NSArray *)urls {
    if ((self = [super init])) {
        [self setTargetURLs:urls];
    }
    return self;
}

- (void)main {
    for (NSURL *targetURL in targetURLs) {
        // make the request. We used to just pass the url to NSXMLDocument's initWithContentsOfURL, but that
        // seems to send the wrong content-type, and CDH5 gives us back json, which NSXMLDocument kindly wraps
        // in XTHML for us.
        NSLog(@"sending request: %@", targetURL);
        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:targetURL];
        [req setValue:@"application/xml;level=1, */*" forHTTPHeaderField:@"Accept"];
        NSHTTPURLResponse *httpResponse = nil;
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:req
                                              returningResponse:&httpResponse
                                                          error:&error];
        
        JTState *jtState = [JTState sharedInstance];
        NSXMLDocument *document = nil;
        if (data) {
            NSLog(@"received %ld bytes", [data length]);
            document = [[NSXMLDocument alloc] initWithData:data
                                                   options:NSXMLDocumentTidyHTML
                                                     error:&error];
            
            if (document) {
                document.URI = [targetURL absoluteString]; // so we know where this came from
                [jtState performSelector:@selector(pageLoadedWithDocument:)
                              withObject:document];
            }
        }
        
        if (document == nil) {
            [jtState performSelector:@selector(errorLoadingPage:)
                          withObject:error];
        }
    }
}

@end
