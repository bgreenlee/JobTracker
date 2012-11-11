//
//  JTPreferencesWindowController.h
//  JobTracker
//
//  Created by Brad Greenlee on 11/11/12.
//  Copyright (c) 2012 Hack Arts. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface JTPreferencesWindowController : NSWindowController

@property(nonatomic, retain) IBOutlet NSTextFieldCell *jobTrackerURLCell;
@property(nonatomic, retain) IBOutlet NSTextFieldCell *usernamesCell;
@property(nonatomic, retain) IBOutlet NSButton *launchAtLoginPreference;
@property(nonatomic, retain) IBOutlet NSButton *okayButton;
@property(nonatomic, retain) IBOutlet NSButton *cancelButton;
@property(nonatomic, retain) id delegate;

@end

@protocol JTPreferencesDelegate

- (void)preferencesUpdated;

@end