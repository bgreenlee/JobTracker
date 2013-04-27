//
//  JTGeneralPreferencesViewController.m
//  JobTracker
//
//  Created by Brad Greenlee on 4/20/13.
//  Copyright (c) 2012 Etsy. All rights reserved.
//

#import "JTGeneralPreferencesViewController.h"

@implementation JTGeneralPreferencesViewController

@synthesize jobTrackerURLCell, usernamesCell, refreshIntervalCell, startingJobNotificationPreference,
completedJobNotificationPreference, failedJobNotificationPreference, launchAtLoginPreference;

- (id)init {
    return [super initWithNibName:@"GeneralPreferencesView" bundle:nil];
}

#pragma mark -
#pragma mark MASPreferencesViewController

- (NSString *)identifier {
    return @"GeneralPreferences";
}

- (NSImage *)toolbarItemImage {
    return [NSImage imageNamed:NSImageNamePreferencesGeneral];
}

- (NSString *)toolbarItemLabel {
    return NSLocalizedString(@"General", @"Toolbar item name for the General preference pane");
}

@end
