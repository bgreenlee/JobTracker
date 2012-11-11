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

@synthesize jobTrackerURL, usernames;

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
    [self loadPreferences];
    if ([self isConfigured]) {
        jtState = [[JTState alloc] initWithURL:[NSURL URLWithString:jobTrackerURL] withUsernames:usernames];
        jtState.delegate = self;
        [self refresh:nil];
        [self startTimer];
    } else {
        [self showPreferences:nil];
    }
}

- (void)loadPreferences {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    jobTrackerURL = [defaults stringForKey:@"jobTrackerURL"];
    usernames = [defaults stringForKey:@"usernames"];
}

- (BOOL)isConfigured {
    if (self.jobTrackerURL == nil || [self.jobTrackerURL isEqualToString:@""]) {
        return NO;
    }
    return YES;
}

- (void)startTimer {
    [self stopTimer];
    
    refreshTimer = [NSTimer scheduledTimerWithTimeInterval:REFRESH_INTERVAL
                                                    target:self
                                                  selector:@selector(refresh:)
                                                  userInfo:nil
                                                   repeats:YES];
}


- (void)stopTimer {
    if (refreshTimer != nil) {
        [refreshTimer invalidate];
        refreshTimer = nil;
    }
}

- (void)receiveWakeNote:(NSNotification*)note {
    if ([self isConfigured]) {
        // Kill off the current refresh schedule.
        [self stopTimer];
        
        // Wait a bit after wake before refreshing, so we don't make wake slower.
        [NSTimer scheduledTimerWithTimeInterval:10.0
                                         target:self
                                       selector:@selector(refresh:)
                                       userInfo:nil
                                        repeats:NO];
        
        // Reset the refresh schedule after the wake refresh.
        [self startTimer];
    }
}

- (IBAction)refresh:(id)sender {
    [self startRefresh];
    [jtState refresh];
}

- (void)stateUpdated {
    [self updateMenuItemWithTag:RUNNING_JOBS_TAG withJobs:[jtState.jobs objectForKey:@"running"]];
    [self updateMenuItemWithTag:COMPLETED_JOBS_TAG withJobs:[jtState.jobs objectForKey:@"completed"]];
    [self updateMenuItemWithTag:FAILED_JOBS_TAG withJobs:[jtState.jobs objectForKey:@"failed"]];
    [self endRefresh];
}

- (IBAction)openInBrowser:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:jobTrackerURL]];
}

- (void)startRefresh {
    NSMenuItem *refresh = [statusMenu itemWithTag:REFRESH_TAG];
    [refresh setTitle:@"Refreshing..."];
    [refresh setEnabled:NO];
}

- (void)endRefresh {
    NSMenuItem *refresh = [statusMenu itemWithTag:REFRESH_TAG];
    [refresh setTitle:@"Refresh"];
    [refresh setEnabled:YES];
}

- (void)updateMenuItemWithTag:(NSInteger)tag withJobs:(NSArray *)jobs {
    NSMenu *jobsMenu = [[NSMenu alloc] init];
    NSMenuItem *jobsMenuItem = [statusMenu itemWithTag:tag];
    if ([jobs count] == 0) {
        NSMenuItem *noneItem = [[NSMenuItem alloc] init];
        [noneItem setTitle:@"None"];
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
    NSString *jobUrl = [NSString stringWithFormat:@"%@?job_id=%@", jobTrackerURL, job.jobId];
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:jobUrl]];
}

- (IBAction)showPreferences:(id)sender {
    prefs = [[JTPreferencesWindowController alloc] initWithWindowNibName:@"PreferencesWindow"];
    prefs.delegate = self;
    [prefs showWindow:self];
}

- (void)preferencesUpdated {
    [self loadPreferences];
    if ([self isConfigured]) {
        jtState = [[JTState alloc] initWithURL:[NSURL URLWithString:jobTrackerURL] withUsernames:usernames];
        jtState.delegate = self;
        [self refresh:nil];
        [self startTimer];
    } else {
        [self showPreferences:nil];
    }
}

@end
