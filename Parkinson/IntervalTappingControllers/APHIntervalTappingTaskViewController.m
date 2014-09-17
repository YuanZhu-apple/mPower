//
//  APHIntervalTappingTaskViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 9/3/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHIntervalTappingTaskViewController.h"
#import "APHStepViewController.h"

#import "APHIntervalTappingIntroViewController.h"
#import "APHIntervalTappingStepsViewController.h"
#import "APHIntervalTappingResultsViewController.h"

#import "CustomRecorder.h"

static  NSString  *kIntervalTappingStep101 = @"IntervalTappingStep101";
static  NSString  *kIntervalTappingStep102 = @"IntervalTappingStep102";
static  NSString  *kIntervalTappingStep103 = @"IntervalTappingStep103";

static float tapInterval = 20.0;

@interface APHIntervalTappingTaskViewController  ( )

@end

@implementation APHIntervalTappingTaskViewController


#pragma  mark  -  Initialisation


+ (instancetype)customTaskViewController: (APCScheduledTask*) scheduledTask
{
    RKTask  *task = [self createTask: scheduledTask];
    APHIntervalTappingTaskViewController  *controller = [[APHIntervalTappingTaskViewController alloc] initWithTask:task taskInstanceUUID:[NSUUID UUID]];
    controller.taskDelegate = controller;
    controller.title = @"Interval Tapping";
    return  controller;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"Interval Tapping";
    self.navigationController.title = @"Interval Tapping";
}

+ (RKTask *)createTask:(APCScheduledTask*) scheduledTask
{
    NSMutableArray *steps = [[NSMutableArray alloc] init];
    
    {
        RKIntroductionStep *step = [[RKIntroductionStep alloc] initWithIdentifier:kIntervalTappingStep101 name:@"Tap intro"];
        step.caption = @"Tests Bradykinesia";
        step.explanation = @"";
        step.instruction = @"";
        [steps addObject:step];
    }
    
    {
        RKActiveStep* step = [[RKActiveStep alloc] initWithIdentifier:kIntervalTappingStep102 name:@"active step"];
        step.caption = @"Button Tap";
        step.text = @"";
        step.countDown = tapInterval;
        step.recorderConfigurations = @[[CustomRecorderConfiguration new]];
        [steps addObject:step];
    }
        
    RKTask  *task = [[RKTask alloc] initWithName:@"Interval Touches" identifier:@"Tapping Task" steps:steps];
    
    return  task;
}

#pragma  mark  -  Task View Controller Delegate Methods

- (BOOL)taskViewController:(RKTaskViewController *)taskViewController shouldPresentStepViewController:(RKStepViewController *)stepViewController
{
    return  YES;
}

- (void)taskViewController:(RKTaskViewController *)taskViewController willPresentStepViewController:(RKStepViewController *)stepViewController
{
    stepViewController.continueButtonOnToolbar = NO;
}

- (RKStepViewController *)taskViewController:(RKTaskViewController *)taskViewController viewControllerForStep:(RKStep *)step
{
    NSDictionary  *controllers = @{
                                   kIntervalTappingStep101 : [APHIntervalTappingIntroViewController   class],
                                   kIntervalTappingStep102 : [APHIntervalTappingStepsViewController   class],
                                   kIntervalTappingStep103 : [APHIntervalTappingResultsViewController class]
                                  };
    Class  aClass = [controllers objectForKey:step.identifier];
    APHStepViewController  *controller = [[aClass alloc] initWithNibName:nil bundle:nil];
    controller.continueButtonOnToolbar = NO;
    controller.step = step;
    return  controller;
}


@end
