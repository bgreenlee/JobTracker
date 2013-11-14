//
//  LVUpdateActivityProtocol.h
//  Sparkle
//
//  Created by Kelly Sutton on 5/13/13.
//
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

/*!
 @protocol
 @abstract    Implement this protocol to provide automatic update checking methods to Sparkle.
 */
@protocol LVUpdateActivityProtocol <NSObject>

/*!
 @method
 @abstract   An abstract method to report when the application was last active
 @discussion Should return an NSDate object for the last significant user-driven action taken in the app.
 */
- (NSDate *)lastActivity;

/*!
 @method
 @abstract   An abstract method to report how often an update should be run
 @discussion Although Sparkle does not trigger the automatic update check, it makes sure to not update if a user action has been taken within the threshold before restarting.
 */
- (NSTimeInterval)updateThreshold;


/**
 *	If the update fails, report to the delegate
 *
 *	@param	error	The error returned when update failed.
 */
- (void)updateFailedWithError:(NSError *)error;

@end
