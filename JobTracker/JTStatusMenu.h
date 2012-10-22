//
//  JTStatusMenu.h
//  JobTracker
//
//  Created by Brad Greenlee on 10/21/12.
//  Copyright (c) 2012 Hack Arts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JTState.h"
#import "JTJob.h"

#define RUNNING_JOBS_TAG 1
#define COMPLETED_JOBS_TAG 2
#define FAILED_JOBS_TAG 3

@interface JTStatusMenu : NSObject {
    IBOutlet NSMenu *statusMenu;
    NSStatusItem *statusItem;
    NSImage *statusImage;
    NSImage *statusHighlightImage;
    NSImage *statusDisabledHighlightImage;
    JTState *jtState;
}

- (IBAction)refresh:(id)sender;
- (IBAction)openInBrowser:(id)sender;
- (void)updateMenuItemWithTag:(NSInteger)tag withJobs:(NSArray *)jobs;
- (void)jobSelected:(id)sender;

@end
