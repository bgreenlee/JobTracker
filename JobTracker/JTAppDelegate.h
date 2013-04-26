//
//  JTAppDelegate.h
//  JobTracker
//
//  Created by Brad Greenlee on 10/21/12.
//  Copyright (c) 2012 Etsy. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface JTAppDelegate : NSObject <NSApplicationDelegate, NSUserNotificationCenterDelegate>

@property (assign) IBOutlet NSWindow *window;

@end
