//
//  JTAppDelegate.m
//  JobTracker
//
//  Created by Brad Greenlee on 10/21/12.
//  Copyright (c) 2012 Hack Arts. All rights reserved.
//

#import "JTAppDelegate.h"

@implementation JTAppDelegate
@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
}

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification {
    return YES;
}

@end
