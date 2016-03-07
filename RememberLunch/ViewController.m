//
//  ViewController.m
//  RememberLunch
//
//  Created by kiran on 04/03/2016.
//  Copyright © 2016 Nativ Mobile LLC. All rights reserved.
//

#import "ViewController.h"

#import "KSPLunchManager.h"

@interface ViewController ()

- (void)lunchTomorrow;

@property (strong, nonatomic, readwrite) UIButton *lunchButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.lunchButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.lunchButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.lunchButton setTitle:([[KSPLunchManager sharedManager] reminderCurrentlySet] ? @"Cancel Lunch Reminder" : @"Set Lunch Reminder")
                      forState:UIControlStateNormal];
    
    [self.lunchButton addTarget:self action:@selector(lunchTomorrow) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.lunchButton];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[lunchButton]-|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:@{@"lunchButton": self.lunchButton}]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=0)-[lunchButton(80.0)]-(>=0)-|"
                                                                      options:NSLayoutFormatAlignAllCenterY
                                                                      metrics:nil
                                                                        views:@{@"lunchButton": self.lunchButton}]];
}

- (void)lunchTomorrow {
    if ([[KSPLunchManager sharedManager] reminderCurrentlySet]) {
        [[KSPLunchManager sharedManager] cancelLunchReminder];
    } else {
        NSDateComponents *deltaComps = [[NSDateComponents alloc] init];
        
        [deltaComps setDay:1];
        
        NSDate *tomorrow = [[NSCalendar currentCalendar] dateByAddingComponents:deltaComps toDate:[NSDate date] options:0];
        
        [[KSPLunchManager sharedManager] setLunchReminderForDate:tomorrow];
    }
    
    [self.lunchButton setTitle:([[KSPLunchManager sharedManager] reminderCurrentlySet] ? @"Cancel Lunch Reminder" : @"Set Lunch Reminder")
                      forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
