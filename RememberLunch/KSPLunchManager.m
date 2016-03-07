//
//  KSPLunchManager.m
//  RememberLunch
//
//  Created by kiran on 04/03/2016.
//  Copyright © 2016 Nativ Mobile LLC. All rights reserved.
//

#import "KSPLunchManager.h"

@import UIKit;

#import <EstimoteSDK/EstimoteSDK.h>

@interface KSPLunchManager () <ESTBeaconManagerDelegate>

@property (nonatomic) ESTBeaconManager *beaconManager;

@end

@implementation KSPLunchManager

+ (KSPLunchManager *)sharedManager {
    static KSPLunchManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;
}

- (void)initialise {
    // Override point for customization after application launch.
    self.beaconManager = [ESTBeaconManager new];
    self.beaconManager.delegate = self;
    
    [self.beaconManager requestAlwaysAuthorization];
    
    // add this below:
    CLBeaconRegion *region = [[CLBeaconRegion alloc]
                              initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"]
                              major:56582 minor:61191 identifier:@"monitored region"];
    
    [self.beaconManager startMonitoringForRegion:region];
    
    
    UIMutableUserNotificationAction *action = [[UIMutableUserNotificationAction alloc] init];
    action.identifier = @"got_it_action";
    action.destructive = NO;
    action.title = @"Got it!";
    action.authenticationRequired = NO;
    action.activationMode = UIUserNotificationActivationModeBackground;
    
    UIMutableUserNotificationCategory *category = [UIMutableUserNotificationCategory new];
    category.identifier = @"actions_identifier";
    [category setActions:@[action]
              forContext:UIUserNotificationActionContextDefault];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings
                                       settingsForTypes:UIUserNotificationTypeAlert
                                       categories:[NSSet setWithObject:category]]];
    
}

- (BOOL)reminderCurrentlySet {
    return ([[NSUserDefaults standardUserDefaults] objectForKey:@"reminder_date"]);
}

- (void)setLunchReminderForDate:(NSDate *)date {
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f", [date timeIntervalSince1970]]
                                              forKey:@"reminder_date"];

    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)cancelLunchReminder {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"reminder_date"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)beaconManager:(id)manager didEnterRegion:(CLBeaconRegion *)region {
    NSString *dateString = [[NSUserDefaults standardUserDefaults] objectForKey:@"reminder_date"];

    if (!dateString) {
        return;
    }
    
    NSTimeInterval date = [dateString doubleValue];
    
//    if ([[NSCalendar currentCalendar] isDate:[NSDate dateWithTimeIntervalSince1970:date] inSameDayAsDate:[NSDate date]]) {
        UILocalNotification *notification = [UILocalNotification new];
    notification.category = @"actions_identifier";
    
        notification.alertBody = @"Did you bring lunch today? 🍞";
        
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
//    }
}

- (void)handleActionWithIdentifier:(NSString *)string {
    [self cancelLunchReminder];
}

@end
