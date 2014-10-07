//
//  APHWalkingTaskViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 9/3/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHWalkingTaskViewController.h"

#import "APHWalkingIntroViewController.h"
#import "APHWalkingStepsViewController.h"
#import "APHWalkingResultsViewController.h"
#import <objc/message.h>

static  NSString  *kWalkingStep101Key = @"Walking Step 101";
static  NSString  *kWalkingStep102Key = @"Walking Step 102";
static  NSString  *kWalkingStep103Key = @"Walking Step 103";
static  NSString  *kWalkingStep104Key = @"Walking Step 104";
static  NSString  *kWalkingStep105Key = @"Walking Step 105";

@interface APHWalkingTaskViewController  ( )
{
    NSInteger _count;
}

@end

@implementation APHWalkingTaskViewController

#pragma  mark  -  Initialisation


+ (RKTask *)createTask: (APCScheduledTask*) scheduledTask
{
    NSMutableArray  *steps = [NSMutableArray array];
    
    {
        RKActiveStep* step = [[RKActiveStep alloc] initWithIdentifier:kWalkingStep101Key name:@"active step"];
        step.caption = NSLocalizedString(@"Measures Gait and Balance", @"");
        step.text = NSLocalizedString(@"You have 10 seconds to put this device in your pocket."
        @"After the phone vibrates, follow the instructions to begin.", @"");
        step.buzz = YES;
        step.vibration = YES;
        step.countDown = 10.0;
        [steps addObject:step];
    }
    {
        RKActiveStep* step = [[RKActiveStep alloc] initWithIdentifier:kWalkingStep102Key name:@"active step"];
        step.caption = NSLocalizedString(@"Walk out 20 Steps", @"");
        step.text = NSLocalizedString(@"Now please walk out 20 steps.", @"");
        step.buzz = YES;
        step.vibration = YES;
        step.countDown = 20.0;
        step.recorderConfigurations = @[ [[RKAccelerometerRecorderConfiguration alloc] initWithFrequency:100.0]];
        [steps addObject:step];
    }
    {
        RKActiveStep* step = [[RKActiveStep alloc] initWithIdentifier:kWalkingStep103Key name:@"active step"];
        step.caption = NSLocalizedString(@"Turn around and walk back", @"");
        step.text = NSLocalizedString(@"Now please turn 180 degrees, and walk back to your starting point.", @"");
        step.buzz = YES;
        step.vibration = YES;
        step.countDown = 20.0;
        step.recorderConfigurations = @[ [[RKAccelerometerRecorderConfiguration alloc] initWithFrequency:100.0]];
        [steps addObject:step];
    }
    {
        RKActiveStep* step = [[RKActiveStep alloc] initWithIdentifier:kWalkingStep104Key name:@"active step"];
        step.caption = NSLocalizedString(@"Standing Still", @"");
        step.text = NSLocalizedString(@"Now please stand still for 30 seconds.", @"");
        step.buzz = YES;
        step.vibration = YES;
        step.countDown = 30.0;
        step.recorderConfigurations = @[ [[RKAccelerometerRecorderConfiguration alloc] initWithFrequency:100.0]];
        [steps addObject:step];
    }
    {
        RKActiveStep* step = [[RKActiveStep alloc] initWithIdentifier:kWalkingStep105Key name:@"active step"];
        step.caption = NSLocalizedString(@"Great Job!", @"");
        step.text = NSLocalizedString(@"Your gait symptoms seem to appear mild."
                    @"Insert easy to understand meaning of this interpretation here.", @"");
        step.buzz = YES;
        step.vibration = YES;
        step.countDown = 0.0;
        [steps addObject:step];
    }
    
    RKTask  *task = [[RKTask alloc] initWithName:@"Timed Walking Task" identifier:@"Timed Walking Task" steps:steps];
    
    return  task;
}

- (instancetype)initWithTask:(id<RKLogicalTask>)task taskInstanceUUID:(NSUUID *)taskInstanceUUID
{
    self = [super initWithTask:task taskInstanceUUID:taskInstanceUUID];
    if (self) {
        _count = 0;
    }
    return self;
}

#pragma  mark  -  Task View Controller Delegate Methods
- (BOOL)taskViewController:(RKTaskViewController *)taskViewController shouldShowMoreInfoOnStep:(RKStep *)step
{
    return  NO;
}

- (BOOL)taskViewController:(RKTaskViewController *)taskViewController shouldPresentStep:(RKStep*)step
{
    return  YES;
}

- (void)taskViewController:(RKTaskViewController *)taskViewController willPresentStepViewController:(RKStepViewController *)stepViewController
{
//    stepViewController.continueButtonOnToolbar = NO;
}

- (void)taskViewController:(RKTaskViewController *)taskViewController didReceiveLearnMoreEventFromStepViewController:(RKStepViewController *)stepViewController
{
}

- (RKStepViewController *)taskViewController:(RKTaskViewController *)taskViewController viewControllerForStep:(RKStep *)step
{
    NSDictionary  *stepsToControllersMap = @{
                                             kWalkingStep101Key : @[ [APHWalkingIntroViewController class], @(0) ],
                                             kWalkingStep102Key : @[ [APHWalkingStepsViewController class], @(WalkingStepsPhaseWalkSomeDistance) ],
                                             kWalkingStep103Key : @[ [APHWalkingStepsViewController class], @(WalkingStepsPhaseWalkBackToBase) ],
                                             kWalkingStep104Key : @[ [APHWalkingStepsViewController class], @(WalkingStepsPhaseStandStill) ],
                                             kWalkingStep105Key : @[ [APHWalkingResultsViewController  class], @(0) ],
                                           };
    
    RKStepViewController  *controller = nil;
    
    NSArray  *descriptor = stepsToControllersMap[step.identifier];
    
    Class  classToCreate = descriptor[0];
    NSUInteger  phase = [descriptor[1] unsignedIntegerValue];
    controller = [[classToCreate alloc] initWithStep:step];
    if ([controller respondsToSelector:@selector(setWalkingPhase:)] == YES) {
        ((APHWalkingStepsViewController *)controller).walkingPhase = (WalkingStepsPhase)phase;
    }
    controller.delegate = self;
    return  controller;
}


@end
