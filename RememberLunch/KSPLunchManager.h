//
//  KSPLunchManager.h
//  RememberLunch
//
//  Created by kiran on 04/03/2016.
//  Copyright © 2016 Nativ Mobile LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSPLunchManager : NSObject

@property (assign, nonatomic, readonly) BOOL reminderCurrentlySet;

/**
 *  The method to access singleton instance
 *
 *  @return A singleton instance of the KSPLunchManager
 */
+ (KSPLunchManager *)sharedManager;

- (void)initialise;

- (void)setLunchReminderForDate:(NSDate *)date;

- (void)cancelLunchReminder;

- (void)handleActionWithIdentifier:(NSString *)string;

@end
