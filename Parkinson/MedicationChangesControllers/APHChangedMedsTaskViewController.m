//
//  APHChangedMedsTaskViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 9/3/14.
//  Copyright (c) 2014 Henry McGilton. All rights reserved.
//

#import "APHChangedMedsTaskViewController.h"

#import "APHChangedMedsOverviewViewController.h"

static  NSString  *kMedicationsStep101Key = @"Medications Step 101";

@implementation APHChangedMedsTaskViewController

#pragma  mark  -  Initialisation

+ (instancetype)customTaskViewController
{
    RKTask  *task = [self createTask];
    APHChangedMedsTaskViewController  *controller = [[APHChangedMedsTaskViewController alloc] initWithTask:task taskInstanceUUID:[NSUUID UUID]];
    controller.taskDelegate = controller;
    return  controller;
}

+ (RKTask *)createTask
{
    NSMutableArray  *steps = [NSMutableArray array];
    
    {
        RKIntroductionStep  *step = [[RKIntroductionStep alloc] initWithIdentifier:kMedicationsStep101Key name:@"Introduction Step"];
        step.caption = @"Changed Medications Survey";
        step.explanation = @"";
        step.instruction = @"";
        [steps addObject:step];
    }
    
    RKTask  *task = [[RKTask alloc] initWithName:@"Changed Medications Survey" identifier:@"Changed Medications Task" steps:steps];
    
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
                                             kMedicationsStep101Key : [APHChangedMedsOverviewViewController  class],
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
