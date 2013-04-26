//
//  JTPreferencesWindowController.h
//  JobTracker
//
//  Created by Brad Greenlee on 11/11/12.
//  Copyright (c) 2012 Etsy. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define DEFAULT_REFRESH_INTERVAL 5

@interface JTPreferencesWindowController : NSWindowController

@property(nonatomic, retain) IBOutlet NSTextFieldCell *jobTrackerURLCell;
@property(nonatomic, retain) IBOutlet NSTextFieldCell *usernamesCell;
@property(nonatomic, retain) IBOutlet NSTextFieldCell *refreshIntervalCell;
@property(nonatomic, retain) IBOutlet NSButton *startingJobNotificationPreference;
@property(nonatomic, retain) IBOutlet NSButton *completedJobNotificationPreference;
@property(nonatomic, retain) IBOutlet NSButton *failedJobNotificationPreference;
@property(nonatomic, retain) IBOutlet NSButton *launchAtLoginPreference;
@property(nonatomic, retain) IBOutlet NSButton *okayButton;
@property(nonatomic, retain) IBOutlet NSButton *cancelButton;
@property(nonatomic, retain) id delegate;

@end

@protocol JTPreferencesDelegate

- (void)preferencesUpdated;

@end