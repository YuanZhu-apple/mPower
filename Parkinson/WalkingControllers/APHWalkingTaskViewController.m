//
//  APHWalkingTaskViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 9/3/14.
//  Copyright (c) 2014 Henry McGilton. All rights reserved.
//

#import "APHWalkingTaskViewController.h"

#import "APHWalkingOverviewViewController.h"
#import "APHWalkingStepsViewController.h"
#import "APHWalkingResultsViewController.h"

//#import "APHStepDictionaryKeys.h"

static  const  NSString  *kWalkingStep101Key = @"Walking Step 101";
static  const  NSString  *kWalkingStep102Key = @"Walking Step 102";
static  const  NSString  *kWalkingStep103Key = @"Walking Step 103";
static  const  NSString  *kWalkingStep104Key = @"Walking Step 104";
static  const  NSString  *kWalkingStep105Key = @"Walking Step 105";

@interface APHWalkingTaskViewController  ( )

@property  (nonatomic, strong)  NSArray  *stepsConfigurations;

@end

@implementation APHWalkingTaskViewController

#pragma  mark  -  Initialisation

+ (instancetype)customTaskViewController
{
    RKTask  *task = [self createTask];
    APHWalkingTaskViewController  *controller = [[APHWalkingTaskViewController alloc] initWithTask:task taskInstanceUUID:[NSUUID UUID]];
    controller.delegate = controller;
    return  controller;
}

+ (RKTask *)createTask
{
    //
    //    configurations are an array of dictionaries that describe the parameters for a step
    //
    //    The Keys in the dictionary are defined in  APHStepDictionaryKeys.h
    //
    //    The Keys in the  dictionary are more or less self-explanatory,
    //        except for the very first, which is the string representation
    //        of the type of step, if you need to perform dynamic instantiation of that class
    //
    //     In the inner loop below, Key-Value Coding is used to set the properties in
    //        the  Step object, and the names of  the Step properties are also defined in  APHStepDictionaryKeys.h
    //
    NSArray  *configurations = @[
                                 @{
                                     APHStepStepTypeKey  : APHActiveStepType,
                                     APHStepIdentiferKey : kWalkingStep101Key,
                                     APHStepNameKey : @"active step",
                                     APHActiveTextKey : @"Please put the phone in a pocket or armband. Then wait for voice instruction.",
                                     APHActiveCountDownKey : @(2.0),
                                     },
                                 @{
                                     APHStepStepTypeKey  : APHActiveStepType,
                                     APHStepIdentiferKey : kWalkingStep102Key,
                                     APHStepNameKey : @"active step",
                                     APHActiveTextKey : @"Now please walk out 20 steps.",
                                     APHActiveCountDownKey : @(20.0),
                                     APHActiveBuzzKey : @(YES),
                                     APHActiveVibrationKey : @(YES),
                                     APHActiveVoicePromptKey : APHActiveTextKey,
                                     APHActiveRecorderConfigurationsKey : @[ [[RKAccelerometerRecorderConfiguration alloc] initWithFrequency:100.0]],
                                     },
                                 @{
                                     APHStepStepTypeKey  : APHActiveStepType,
                                     APHStepIdentiferKey : kWalkingStep103Key,
                                     APHStepNameKey : @"active step",
                                     APHActiveTextKey : @"Now please turn 180 degrees, and walk back.",
                                     APHActiveCountDownKey : @(20.0),
                                     APHActiveBuzzKey : @(YES),
                                     APHActiveVibrationKey : @(YES),
                                     APHActiveVoicePromptKey : APHActiveTextKey,
                                     APHActiveRecorderConfigurationsKey : @[ [[RKAccelerometerRecorderConfiguration alloc] initWithFrequency:100.0]],
                                     },
                                 @{
                                     APHStepStepTypeKey  : APHActiveStepType,
                                     APHStepIdentiferKey : kWalkingStep104Key,
                                     APHStepNameKey : @"active step",
                                     APHActiveTextKey : @"Now please stand still for 30 seconds.",
                                     APHActiveCountDownKey : @(30.0),
                                     APHActiveBuzzKey : @(YES),
                                     APHActiveVibrationKey : @(YES),
                                     APHActiveVoicePromptKey : APHActiveTextKey,
                                     APHActiveRecorderConfigurationsKey : @[ [[RKAccelerometerRecorderConfiguration alloc] initWithFrequency:100.0]],
                                     },
                                 @{
                                     APHStepStepTypeKey  : APHActiveStepType,
                                     APHStepIdentiferKey : kWalkingStep105Key,
                                     APHStepNameKey : @"active step",
                                     APHActiveTextKey : @"",
                                     APHActiveVoicePromptKey : APHActiveTextKey,
                                     },
                                 ];
    
    RKTask  *task = [self mapConfigurationsToTask:configurations];
    
    return  task;
}

#pragma  mark  -  Task View Controller Delegate Methods

- (void)taskViewControllerDidComplete: (RKTaskViewController *)taskViewController
{
    [taskViewController suspend];
}

- (void)taskViewController: (RKTaskViewController *)taskViewController didFailWithError:(NSError*)error
{
    [taskViewController suspend];
}

- (void)taskViewControllerDidCancel:(RKTaskViewController *)taskViewController
{
    [taskViewController suspend];
}

- (BOOL)taskViewController:(RKTaskViewController *)taskViewController shouldShowMoreInfoOnStep:(RKStep *)step
{
    return  YES;
}

- (RKStepViewController *)taskViewController:(RKTaskViewController *)taskViewController viewControllerForStep:(RKStep *)step
{
    NSLog(@"taskViewController viewControllerForStep = %@", step);
    
    NSDictionary  *stepsToControllersMap = @{
                                             kWalkingStep101Key : @[ [APHWalkingOverviewViewController class], @(0) ],
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

- (BOOL)taskViewController:(RKTaskViewController *)taskViewController shouldPresentStep:(RKStep*)step
{
    return  YES;
}

- (void)taskViewController:(RKTaskViewController *)taskViewController
willPresentStepViewController:(RKStepViewController *)stepViewController
{
}

- (void)taskViewController:(RKTaskViewController *)taskViewController didReceiveLearnMoreEventFromStepViewController:(RKStepViewController *)stepViewController
{
}

@end
