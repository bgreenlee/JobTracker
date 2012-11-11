//
//  JTPreferencesWindowController.m
//  JobTracker
//
//  Created by Brad Greenlee on 11/11/12.
//  Copyright (c) 2012 Hack Arts. All rights reserved.
//

#import "JTPreferencesWindowController.h"
#import "LaunchAtLoginController.h"

@interface JTPreferencesWindowController ()

@end

@implementation JTPreferencesWindowController

@synthesize jobTrackerURLCell, usernamesCell, launchAtLoginPreference, okayButton, cancelButton, delegate;

- (id)initWithWindow:(NSWindow *)window {
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    [self loadCurrentSettings];
    [[self window] center];
    [NSApp activateIgnoringOtherApps:YES];
}

- (void)loadCurrentSettings {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //BOOL configured = [defaults boolForKey:@"configured"];
    
    NSString *usernames = [defaults stringForKey:@"usernames"];
    if (usernames != nil) {
        [self.usernamesCell setStringValue:usernames];
    }

    NSString *jobTrackerURL = [defaults stringForKey:@"jobTrackerURL"];
    if (jobTrackerURL != nil) {
        [self.jobTrackerURLCell setStringValue:jobTrackerURL];
    }

    LaunchAtLoginController *launchController = [[LaunchAtLoginController alloc] init];
    BOOL launchAtLoginEnabled = [launchController launchAtLogin];
    
    if (launchAtLoginEnabled) {
        [self.launchAtLoginPreference setState:NSOnState];
    } else {
        [self.launchAtLoginPreference setState:NSOffState];
    }    
}

- (IBAction)okayPressed:(id)sender {
    NSString *jobTrackerURL = [self.jobTrackerURLCell stringValue];
    NSString *usernames = [[self.usernamesCell stringValue] stringByReplacingOccurrencesOfString:@" " withString:@""];
    BOOL launchOnLoginEnabled = [self.launchAtLoginPreference state] == NSOnState;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // Save the Launch-on-Login preference.
    LaunchAtLoginController *launchController = [[LaunchAtLoginController alloc] init];
	[launchController setLaunchAtLogin:launchOnLoginEnabled];
    
    // Save the jobTrackerURL
    [defaults setObject:jobTrackerURL forKey:@"jobTrackerURL"];
    // Save the username.
    [defaults setObject:usernames forKey:@"usernames"];
        
    [[self window] close];
    [self.delegate preferencesUpdated];
}


- (IBAction)cancelPressed:(id)sender {
    [[self window] close];
}


@end
