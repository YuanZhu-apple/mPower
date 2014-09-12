//
//  APHTracingObjectsTaskViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 9/10/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHTracingObjectsTaskViewController.h"

#import "APHTracingObjectsOverviewViewController.h"

static  NSString  *kTracingObjectsStep101Key = @"Tracing Objects Step 101";

@interface APHTracingObjectsTaskViewController ()

@end

@implementation APHTracingObjectsTaskViewController

#pragma  mark  -  Initialisation

+ (instancetype)customTaskViewController
{
    RKTask  *task = [self createTask];
    APHTracingObjectsTaskViewController  *controller = [[APHTracingObjectsTaskViewController alloc] initWithTask:task taskInstanceUUID:[NSUUID UUID]];
    controller.taskDelegate = controller;
    return  controller;
}

+ (RKTask *)createTask
{
    NSMutableArray  *steps = [NSMutableArray array];
    
    {
        RKIntroductionStep  *step = [[RKIntroductionStep alloc] initWithIdentifier:kTracingObjectsStep101Key name:@"Introduction Step"];
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
                                             kTracingObjectsStep101Key : [APHTracingObjectsOverviewViewController  class],
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
