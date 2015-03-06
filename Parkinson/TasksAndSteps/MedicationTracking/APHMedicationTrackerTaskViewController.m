// 
//  APHMedicationTrackerTaskViewController.m
//  mPower 
// 
//  Copyright (c) 2014 Apple, Inc. All rights reserved. 
//


#import "APHMedicationTrackerTaskViewController.h"
#import <AVFoundation/AVFoundation.h>

static  NSString  *kTaskViewControllerTitle = @"Medication Tracker";

@interface APHMedicationTrackerTaskViewController  ( ) <NSObject>

@end

@implementation APHMedicationTrackerTaskViewController

#pragma  mark  -  Task Creation Methods

+ (ORKOrderedTask *)createTask:(APCScheduledTask *) __unused scheduledTask
{
    ORKStep  *step = [[ORKStep alloc] initWithIdentifier:kTaskViewControllerTitle];
    NSArray  *steps = @[ step ];
    ORKOrderedTask  *task = [[ORKOrderedTask alloc] initWithIdentifier:kTaskViewControllerTitle steps:steps];

    [[UIView appearance] setTintColor:[UIColor appPrimaryColor]];
    
    return  task;
}

#pragma  mark  -  Task View Controller Delegate Methods

- (ORKStepViewController *)taskViewController:(ORKTaskViewController *) __unused taskViewController viewControllerForStep:(ORKStep *)step
{
    APCMedicationTrackerCalendarViewController  *controller = [[APCMedicationTrackerCalendarViewController alloc] initWithNibName:nil bundle:[NSBundle appleCoreBundle]];
    controller.step = step;
    return  controller;
}

- (void)taskViewController:(ORKTaskViewController *) __unused taskViewController stepViewControllerWillAppear:(ORKStepViewController *) __unused stepViewController
{
}

#pragma  mark  -  View Controller Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.showsProgressInNavigationBar = NO;
    self.navigationBar.topItem.title = NSLocalizedString(kTaskViewControllerTitle, nil);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

@end
