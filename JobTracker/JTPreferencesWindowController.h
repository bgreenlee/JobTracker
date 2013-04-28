//
//  JTPreferencesWindowController.h
//  JobTracker
//
//  Created by Brad Greenlee on 11/11/12.
//  Copyright (c) 2012 Etsy. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MASPreferencesWindowController.h"
#import "JTGeneralPreferencesViewController.h"
#import "JTAboutViewController.h"

#define DEFAULT_REFRESH_INTERVAL 5

@interface JTPreferencesWindowController : MASPreferencesWindowController {
    JTGeneralPreferencesViewController *generalViewController;
    JTAboutViewController *aboutViewController;
}

@property(nonatomic, retain) id delegate;

@end

@protocol JTPreferencesDelegate

- (void)preferencesUpdated;

@end