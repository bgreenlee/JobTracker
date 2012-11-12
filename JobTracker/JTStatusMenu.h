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
#import "JTPreferencesWindowController.h"

#define RUNNING_JOBS_TAG 1
#define COMPLETED_JOBS_TAG 2
#define FAILED_JOBS_TAG 3
#define REFRESH_TAG 4
#define REFRESH_INTERVAL 5

@interface JTStatusMenu : NSObject <JTPreferencesDelegate, JTStateDelegate, NSUserNotificationCenterDelegate> {
    IBOutlet NSMenu *statusMenu;
    NSStatusItem *statusItem;
    NSImage *statusImage;
    NSImage *statusHighlightImage;
    NSImage *statusDisabledHighlightImage;
    JTState *jtState;
    JTPreferencesWindowController *prefs;
    NSTimer *refreshTimer;
    NSInteger refreshInterval;
    NSUserNotificationCenter *notificationCenter;
}

@property(nonatomic, copy) NSString *jobTrackerURL;
@property(nonatomic, copy) NSString *usernames;
@property(nonatomic) BOOL startingJobNotificationsEnabled;
@property(nonatomic) BOOL completedJobNotificationsEnabled;
@property(nonatomic) BOOL failedJobNotificationsEnabled;

- (IBAction)refresh:(id)sender;
- (IBAction)openInBrowser:(id)sender;
- (void)updateMenuItemWithTag:(NSInteger)tag withJobs:(NSArray *)jobs;
- (void)jobSelected:(id)sender;
- (IBAction)showPreferences:(id)sender;
- (void)preferencesUpdated;
- (BOOL)isConfigured;
- (void)startTimer;
- (void)stopTimer;
- (void)receiveWakeNote:(NSNotification*)note;
// JTStateDelegate methods
- (void)stateUpdated;
- (void)jobStarted:(JTJob *)job;
- (void)jobCompleted:(JTJob *)job;
- (void)jobFailed:(JTJob *)job;
// NSUserNotificationCenterDelegate methods
- (void)userNotificationCenter:(NSUserNotificationCenter *)center didActivateNotification:(NSUserNotification *)notification;

@end
