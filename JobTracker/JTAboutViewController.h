//
//  JTAboutViewController.h
//  JobTracker
//
//  Created by Brad Greenlee on 4/20/13.
//  Copyright (c) 2013 Hack Arts. All rights reserved.
//

#import "MASPreferencesViewController.h"

@interface JTAboutViewController : NSViewController <MASPreferencesViewController>

@property(nonatomic, retain) IBOutlet NSTextField *version;

@end
