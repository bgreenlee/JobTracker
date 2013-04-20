//
//  JTJobTests.m
//  JobTracker
//
//  Created by Brad Greenlee on 4/19/13.
//  Copyright (c) 2013 Hack Arts. All rights reserved.
//

#import "JTJobTests.h"

@implementation JTJobTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testJobDisplayName {
    JTJob *job = [[JTJob alloc] initWithDictionary:
                  [NSDictionary dictionaryWithObjectsAndKeys:
                   @"alice", @"user",
                   @"[C297F973D20FD321ECF4D9D72FB1C175/F466234BCA54D2B94B8EBB844F5134B9] my awesome job/(14/27)", @"name",
                   nil]];
    STAssertTrue([[job displayName] isEqualToString:@"my awesome job/(14/27) (alice)"], @"Display name was: %@", [job displayName]);
    
    job = [[JTJob alloc] initWithDictionary:
           [NSDictionary dictionaryWithObjectsAndKeys:
            @"alice", @"user",
            @"com.example.jobs.UserRecommendations/(39/40)", @"name",
            nil]];
    STAssertTrue([[job displayName] isEqualToString:@"com.example.jobs.UserRecommendations/(39/40) (alice)"], @"Display name was: %@", [job displayName]);
}
@end
