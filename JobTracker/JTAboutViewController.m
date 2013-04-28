//
//  JTAboutViewController.m
//  JobTracker
//
//  Created by Brad Greenlee on 4/20/13.
//  Copyright (c) 2013 Hack Arts. All rights reserved.
//

#import "JTAboutViewController.h"

@implementation JTAboutViewController

@synthesize version, homepageLink, etsyLink;

- (id)init {
    return [super initWithNibName:@"AboutView" bundle:nil];
}

#pragma mark -
#pragma mark MASPreferencesViewController

- (NSString *)identifier {
    return @"About";
}

- (NSImage *)toolbarItemImage {
    return [NSImage imageNamed:@"Pith Helmet"];
}

- (NSString *)toolbarItemLabel {
    return NSLocalizedString(@"About", @"Toolbar item name for the About pane");
}

- (void)awakeFromNib {
    // set version
    NSString *_version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    [version setStringValue:_version];
    
    // linkify text
    [homepageLink setAttributedStringValue:
        [NSAttributedString hyperlinkFromString:@"https://github.com/bgreenlee/JobTracker"
                                        withURL:[NSURL URLWithString:@"https://github.com/bgreenlee/JobTracker"]]];

    [etsyLink setAttributedStringValue:
        [NSAttributedString hyperlinkFromString:@"Etsy, Inc."
                                        withURL:[NSURL URLWithString:@"https://www.etsy.com"]]];
}

@end

