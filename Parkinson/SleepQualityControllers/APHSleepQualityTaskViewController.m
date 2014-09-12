//
//  APHSleepQualityTaskViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 9/3/14.
//  Copyright (c) 2014 Henry McGilton. All rights reserved.
//

#import "APHSleepQualityTaskViewController.h"

#import "APHSleepQualityOverviewViewController.h"

static  NSString  *kSleepQualityStep101Key = @"Sleep Quality Step 101";

@implementation APHSleepQualityTaskViewController

static  const  NSString  *kQuestionStep101Key = @"Question Step 101";

#pragma  mark  -  Initialisation

+ (instancetype)customTaskViewController: (APCScheduledTask*) scheduledTask
{
    RKTask  *task = [self createTask: scheduledTask];
    APHSleepQualityTaskViewController  *controller = [[APHSleepQualityTaskViewController alloc] initWithTask:task taskInstanceUUID:[NSUUID UUID]];
    controller.taskDelegate = controller;
    return  controller;
}

+ (RKTask *)createTask: (APCScheduledTask*) scheduledTask
{
    RKTask * task = [scheduledTask.task generateRKTaskFromTaskDescription];
    return  task;
}

- (instancetype)initWithTask:(id<RKLogicalTask>)task taskInstanceUUID:(NSUUID *)taskInstanceUUID
{
    self = [super initWithTask:task taskInstanceUUID:taskInstanceUUID];
    return self;
}

#pragma  mark  -  Task View Controller Delegate Methods

- (void)taskViewControllerDidComplete: (RKTaskViewController *)taskViewController
{
    [taskViewController suspend];
    [taskViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (BOOL)taskViewController:(RKTaskViewController *)taskViewController shouldShowMoreInfoOnStep:(RKStep *)step
{
    return  YES;
}

- (RKStepViewController *)taskViewController:(RKTaskViewController *)taskViewController viewControllerForStep:(RKStep *)step
{
    NSLog(@"taskViewController viewControllerForStep = %@", step);

    NSDictionary  *stepsToControllersMap = @{
                                             kSleepQualityStep101Key : [APHSleepQualityOverviewViewController  class],
                                           };
    RKStepViewController  *controller = nil;
    Class  classToCreate = stepsToControllersMap[step.identifier];
    controller = [[classToCreate alloc] initWithStep:step];
    controller.delegate = self;
    
    return  controller;
}

- (BOOL)taskViewController:(RKTaskViewController *)taskViewController shouldPresentStep:(RKStep*)step
{
    return  YES;
}

- (void)taskViewController:(RKTaskViewController *)taskViewController willPresentStepViewController:(RKStepViewController *)stepViewController
{
    stepViewController.continueButtonOnToolbar = NO;
}

- (void)taskViewController:(RKTaskViewController *)taskViewController didReceiveLearnMoreEventFromStepViewController:(RKStepViewController *)stepViewController
{
}

@end
