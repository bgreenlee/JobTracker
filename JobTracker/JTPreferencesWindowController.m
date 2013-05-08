//
//  JTPreferencesWindowController.m
//  JobTracker
//
//  Created by Brad Greenlee on 11/11/12.
//  Copyright (c) 2012 Etsy. All rights reserved.
//

#import "JTPreferencesWindowController.h"

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
}

-(BOOL)windowShouldClose:(id)sender {
    #pragma unused (sender)
    [generalViewController saveSettings];
    [delegate preferencesUpdated];
    return YES;
}

@end
