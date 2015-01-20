//
//  JTGeneralPreferencesViewController.h
//  JobTracker
//
//  Created by Brad Greenlee on 4/20/13.
//  Copyright (c) 2012 Etsy. All rights reserved.
//

#import "MASPreferencesViewController.h"
#import "LaunchAtLoginController.h"

#define DEFAULT_REFRESH_INTERVAL 10

@interface JTGeneralPreferencesViewController : NSViewController <MASPreferencesViewController>

@property(nonatomic, retain) IBOutlet NSTextFieldCell *jobTrackerURLCell;
@property(nonatomic, retain) IBOutlet NSTextFieldCell *usernamesCell;
@property(nonatomic, retain) IBOutlet NSTextFieldCell *refreshIntervalCell;
@property(nonatomic, retain) IBOutlet NSButton *startingJobNotificationPreference;
@property(nonatomic, retain) IBOutlet NSButton *completedJobNotificationPreference;
@property(nonatomic, retain) IBOutlet NSButton *failedJobNotificationPreference;
@property(nonatomic, retain) IBOutlet NSButton *launchAtLoginPreference;

- (void)saveSettings;

@end
