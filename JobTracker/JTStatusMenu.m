//
//  JTStatusMenu.m
//  JobTracker
//
//  Created by Brad Greenlee on 10/21/12.
//  Copyright (c) 2012 Hack Arts. All rights reserved.
//

#import "JTStatusMenu.h"
#import "JTState.h"

@implementation JTStatusMenu

- (void)awakeFromNib {
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    statusImage = [NSImage imageNamed:@"elephant_icon_big_black.png"];
    statusHighlightImage = [NSImage imageNamed:@"elephant_icon_big_white.png"];
    [statusItem setImage:statusImage];
    [statusItem setAlternateImage:statusHighlightImage];
    [statusItem setHighlightMode:YES];
    [statusMenu setAutoenablesItems:NO];
    [statusItem setMenu:statusMenu];
    
    // Listen for events when the computer wakes from sleep, which otherwise
    // throws off the refresh schedule.
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self
                                                           selector:@selector(receiveWakeNote:)
                                                               name:NSWorkspaceDidWakeNotification
                                                             object:nil];
    
    if (jtState == nil) {
        jtState = [[JTState alloc] init];
    }
    [self refresh:self];
}

- (IBAction)refresh:(id)sender {
    [jtState refresh];
    [self updateMenuItemWithTag:RUNNING_JOBS_TAG withJobs:[jtState.jobs objectForKey:@"running"]];
    [self updateMenuItemWithTag:COMPLETED_JOBS_TAG withJobs:[jtState.jobs objectForKey:@"completed"]];
    [self updateMenuItemWithTag:FAILED_JOBS_TAG withJobs:[jtState.jobs objectForKey:@"failed"]];
}

- (IBAction)openInBrowser:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:JT_URL]];
}

- (void)updateMenuItemWithTag:(NSInteger)tag withJobs:(NSArray *)jobs {
    NSMenu *jobsMenu = [[NSMenu alloc] init];
    NSMenuItem *jobsMenuItem = [statusMenu itemWithTag:tag];
    if ([jobs count] == 0) {
        NSMenuItem *noneItem = [[NSMenuItem alloc] initWithTitle:@"None" action:nil keyEquivalent:@""];
        [noneItem setEnabled:NO];
        [jobsMenu addItem:noneItem];
    } else {
        for (JTJob *job in jobs) {
            NSMenuItem *jobItem = [[NSMenuItem alloc] initWithTitle:job.displayName action:@selector(jobSelected:) keyEquivalent:@""];
            [jobItem setRepresentedObject:job];
            [jobItem setTarget:self];
            [jobItem setEnabled:YES];
            [jobsMenu addItem:jobItem];
        }
    }
    [statusMenu setSubmenu:jobsMenu forItem:jobsMenuItem];
}

- (void)jobSelected:(id)sender {
    NSMenuItem *menuItem = sender;
    JTJob *job = [menuItem representedObject];
    NSString *jobUrl = [NSString stringWithFormat:@"%@?job_id=%@", JT_URL, job.jobId];
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:jobUrl]];
}
@end
