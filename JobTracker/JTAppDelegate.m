//
//  JTAppDelegate.m
//  JobTracker
//
//  Created by Brad Greenlee on 10/21/12.
//  Copyright (c) 2012 Etsy. All rights reserved.
//

#import "JTAppDelegate.h"

@implementation JTAppDelegate
@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    #pragma unused (aNotification)
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
}

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification {
    #pragma unused (center, notification)
    return YES;
}

@end
