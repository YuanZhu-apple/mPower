// 
//  APHWalkingTaskViewController.m 
//  mPower 
// 
//  Copyright (c) 2014 Apple, Inc. All rights reserved. 
// 
 
#import "APHWalkingTaskViewController.h"
//#import <HealthKit/HealthKit.h>
//#import <AVFoundation/AVFoundation.h>
//#import <AudioToolbox/AudioToolbox.h>
//#import "APHActiveStepViewController.h"

#import <objc/message.h>

static  NSString       *kWalkingActivityTitle = @"Timed Walking Task";

static  NSUInteger      kNumberOfStepsPerLeg  = 20;
static  NSTimeInterval  kStandStillDuration   = 30.0;


@implementation APHWalkingTaskViewController

#pragma  mark  -  Initialisation

+ (RKSTOrderedTask *)createTask:(APCScheduledTask *)scheduledTask
{
    RKSTOrderedTask  *task = [RKSTOrderedTask shortWalkTaskWithIdentifier:kWalkingActivityTitle
                            intendedUseDescription:nil
                            numberOfStepsPerLeg:kNumberOfStepsPerLeg
                            restDuration:kStandStillDuration
                            options:0];
    return  task;
}


#pragma  mark  -  Results For Dashboard

- (NSString *)createResultSummary
{
    return @"";
}

#pragma  mark  -  View Controller Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBar.topItem.title = NSLocalizedString(kWalkingActivityTitle, nil);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

@end
