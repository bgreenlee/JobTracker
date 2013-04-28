//
//  JTAboutViewController.h
//  JobTracker
//
//  Created by Brad Greenlee on 4/20/13.
//  Copyright (c) 2013 Hack Arts. All rights reserved.
//

#import "MASPreferencesViewController.h"
#import "NSAttributedString+Hyperlink.h"

@interface JTAboutViewController : NSViewController <MASPreferencesViewController>

@property(nonatomic) IBOutlet NSTextField *version;
@property(nonatomic) IBOutlet HyperlinkTextField *etsyLink;
@property(nonatomic) IBOutlet HyperlinkTextField *homepageLink;

@end
