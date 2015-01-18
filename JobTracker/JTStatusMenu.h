//
//  JTStatusMenu.h
//  JobTracker
//
//  Created by Brad Greenlee on 10/21/12.
//  Copyright (c) 2012 Etsy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JTState.h"
#import "JTJob.h"
#import "JTPreferencesWindowController.h"
#import "JTGeneralPreferencesViewController.h"
#import "JTAboutViewController.h"
#import "MASPreferencesWindowController.h"
#import "Growl/GrowlApplicationBridge.h"

#define RUNNING_JOBS_TAG 1
#define COMPLETED_JOBS_TAG 2
#define FAILED_JOBS_TAG 3
#define REFRESH_TAG 4

@interface JTStatusMenu : NSObject <JTPreferencesDelegate, JTStateDelegate, GrowlApplicationBridgeDelegate> {
    IBOutlet NSMenu *statusMenu;
    NSStatusItem *statusItem;
    NSImage *statusImage;
    NSImage *statusHighlightImage;
    NSImage *statusDisabledHighlightImage;
    JTState *jtState;
    NSTimer *refreshTimer;
    JTPreferencesWindowController *_preferencesWindowController;
}

@property (nonatomic, readonly) JTPreferencesWindowController *preferencesWindowController;
@property(nonatomic, copy) NSString *jobTrackerURL;
@property(nonatomic, copy) NSString *usernames;
@property(nonatomic) NSInteger refreshInterval;
@property(nonatomic) BOOL startingJobNotificationsEnabled;
@property(nonatomic) BOOL completedJobNotificationsEnabled;
@property(nonatomic) BOOL failedJobNotificationsEnabled;
@property(nonatomic) NSInteger cdhVersion;

- (IBAction)refresh:(id)sender;
- (void)setError:(NSError *)error;
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
// GrowlApplicationBridgeDelegate methods
- (void) growlNotificationWasClicked:(id)clickContext;

@end
