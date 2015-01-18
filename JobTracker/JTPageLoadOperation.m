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
    // make the request. We used to just pass the url to NSXMLDocument's initWithContentsOfURL, but that
    // seems to send the wrong content-type, and CDH5 gives us back json, which NSXMLDocument kindly wraps
    // in XTHML for us.
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:targetURL];
    [req setValue:@"application/xml;level=1, */*" forHTTPHeaderField:@"Accept"];
    NSHTTPURLResponse *httpResponse = nil;
    NSError *error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:req
                                          returningResponse:&httpResponse
                                                      error:&error];
    
    JTState *jtState = [JTState sharedInstance];
    if (data) {
        NSXMLDocument *document = [[NSXMLDocument alloc] initWithData:data
                                                              options:NSXMLDocumentTidyHTML
                                                                error:&error];
        
        if (document) {
            [jtState performSelectorOnMainThread:@selector(pageLoaded:)
                                        withObject:document
                                   waitUntilDone:YES];
            return;
        }
    }
    [jtState performSelectorOnMainThread:@selector(errorLoadingPage:)
                              withObject:error
                           waitUntilDone:NO];
}

@end
