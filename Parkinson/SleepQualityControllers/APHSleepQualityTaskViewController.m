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

+ (instancetype)customTaskViewController
{
    RKTask  *task = [self createTask];
    APHSleepQualityTaskViewController  *controller = [[APHSleepQualityTaskViewController alloc] initWithTask:task taskInstanceUUID:[NSUUID UUID]];
    controller.taskDelegate = controller;
    return  controller;
}

+ (RKTask *)createTask
{
    
    NSMutableArray  *steps = [NSMutableArray array];
    
    {
        RKIntroductionStep *step = [[RKIntroductionStep alloc] initWithIdentifier:kSleepQualityStep101Key name:@"Introduction Step"];
        step.caption = @"Sleep Quality Test";
        step.explanation = @"";
        step.instruction = @"";
        [steps addObject:step];
    }
    
    RKTask  *task = [[RKTask alloc] initWithName:@"Sleep Quality Survey" identifier:@"Sleep Quality Task" steps:steps];
    
    return  task;
}

- (instancetype)initWithTask:(id<RKLogicalTask>)task taskInstanceUUID:(NSUUID *)taskInstanceUUID
{
    self = [super initWithTask:task taskInstanceUUID:taskInstanceUUID];
    if (self != nil) {
    }
    return self;
}

#pragma  mark  -  Task View Controller Delegate Methods

- (void)taskViewControllerDidComplete: (RKTaskViewController *)taskViewController
{
    [taskViewController suspend];
    [taskViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)taskViewController: (RKTaskViewController *)taskViewController didFailWithError:(NSError*)error
{
    //    [taskViewController suspend];
}

- (void)taskViewControllerDidCancel:(RKTaskViewController *)taskViewController
{
    //    [taskViewController suspend];
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

- (void)taskViewController:(RKTaskViewController *)taskViewController didProduceResult:(RKResult *)result
{
    NSLog(@"Result: %@", result);
    
}

@end
