//
//  JTPreferencesWindowController.m
//  JobTracker
//
//  Created by Brad Greenlee on 11/11/12.
//  Copyright (c) 2012 Etsy. All rights reserved.
//

#import "JTPreferencesWindowController.h"
#import "LaunchAtLoginController.h"

@interface JTPreferencesWindowController ()

@end

@implementation JTPreferencesWindowController

@synthesize delegate;

- (id)init {
    JTGeneralPreferencesViewController *_generalViewController = [[JTGeneralPreferencesViewController alloc] init];
    JTAboutViewController *_aboutViewController = [[JTAboutViewController alloc] init];
    NSArray *controllers = [[NSArray alloc] initWithObjects:_generalViewController, _aboutViewController, nil];
    NSString *title = NSLocalizedString(@"Preferences", @"Common title for Preferences window");
    if ((self = [super initWithViewControllers:controllers title:title])) {
        generalViewController = _generalViewController;
        aboutViewController = _aboutViewController;
    }
    return self;
}

- (void)showWindow:(id)sender {
    [[self window] center];
    [self selectControllerAtIndex:0]; // always show General prefs on startup
    [NSApp activateIgnoringOtherApps:YES];
    [super showWindow:sender];
    [self loadSettings];
}

- (void)loadSettings {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *usernames = [defaults stringForKey:@"usernames"];
    if (usernames != nil) {
        [generalViewController.usernamesCell setStringValue:usernames];
    }
    
    NSInteger refreshInterval = [defaults integerForKey:@"refreshInterval"];
    if (refreshInterval == 0) {
        refreshInterval = DEFAULT_REFRESH_INTERVAL;
    }
    [generalViewController.refreshIntervalCell setIntegerValue:refreshInterval];
    
    // this replace just fixes the url generated by an earlier version and can eventually be removed
    NSString *jobTrackerURL = [[defaults stringForKey:@"jobTrackerURL"] stringByReplacingOccurrencesOfString:@"/jobtracker.jsp" withString:@""];
    if (jobTrackerURL != nil) {
        [generalViewController.jobTrackerURLCell setStringValue:jobTrackerURL];
    }
    
    [generalViewController.startingJobNotificationPreference setState:[defaults boolForKey:@"startingJobNotificationsEnabled"] ? NSOnState : NSOffState];
    [generalViewController.completedJobNotificationPreference setState:[defaults boolForKey:@"completedJobNotificationsEnabled"] ? NSOnState : NSOffState];
    [generalViewController.failedJobNotificationPreference setState:[defaults boolForKey:@"failedJobNotificationsEnabled"] ? NSOnState : NSOffState];
    
    LaunchAtLoginController *launchController = [[LaunchAtLoginController alloc] init];
    BOOL launchAtLoginEnabled = [launchController launchAtLogin];
    
    if (launchAtLoginEnabled) {
        [generalViewController.launchAtLoginPreference setState:NSOnState];
    } else {
        [generalViewController.launchAtLoginPreference setState:NSOffState];
    }
    
    // set version on about pane
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    [aboutViewController.version setStringValue:version];
}

- (void)saveSettings {
    NSString *jobTrackerURL = [[generalViewController.jobTrackerURLCell stringValue] stringByReplacingOccurrencesOfString:@"/jobtracker.jsp" withString:@""];
    NSString *usernames = [[generalViewController.usernamesCell stringValue] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSInteger refreshInterval = [generalViewController.refreshIntervalCell integerValue];
    if (refreshInterval < 1) {
        refreshInterval = 1;
    }
    BOOL startingJobNotificationsEnabled = [generalViewController.startingJobNotificationPreference state] == NSOnState;
    BOOL completedJobNotificationsEnabled = [generalViewController.completedJobNotificationPreference state] == NSOnState;
    BOOL failedJobNotificationsEnabled = [generalViewController.failedJobNotificationPreference state] == NSOnState;
    BOOL launchOnLoginEnabled = [generalViewController.launchAtLoginPreference state] == NSOnState;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // Save the Launch-on-Login preference.
    LaunchAtLoginController *launchController = [[LaunchAtLoginController alloc] init];
	[launchController setLaunchAtLogin:launchOnLoginEnabled];
    
    [defaults setObject:jobTrackerURL forKey:@"jobTrackerURL"];
    [defaults setObject:usernames forKey:@"usernames"];
    [defaults setInteger:refreshInterval forKey:@"refreshInterval"];
    [defaults setBool:startingJobNotificationsEnabled forKey:@"startingJobNotificationsEnabled"];
    [defaults setBool:completedJobNotificationsEnabled forKey:@"completedJobNotificationsEnabled"];
    [defaults setBool:failedJobNotificationsEnabled forKey:@"failedJobNotificationsEnabled"];
    
    [[self window] close];
    [self.delegate preferencesUpdated];    
}

-(BOOL)windowShouldClose:(id)sender {
    [self saveSettings];
    return YES;
}

@end
