//
//  JTAboutViewController.m
//  JobTracker
//
//  Created by Brad Greenlee on 4/20/13.
//  Copyright (c) 2013 Hack Arts. All rights reserved.
//

#import "JTAboutViewController.h"

@implementation JTAboutViewController

@synthesize version;

- (id)init {
    return [super initWithNibName:@"AboutView" bundle:nil];
}

#pragma mark -
#pragma mark MASPreferencesViewController

- (NSString *)identifier {
    return @"About";
}

- (NSImage *)toolbarItemImage {
    return [NSImage imageNamed:NSImageNameInfo];
}

- (NSString *)toolbarItemLabel {
    return NSLocalizedString(@"About", @"Toolbar item name for the About pane");
}

- (void)awakeFromNib {
    NSString *_version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    [version setStringValue:_version];
}

@end

