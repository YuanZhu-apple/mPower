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
#import <objc/message.h>

#define INTERVAL 2.0

//#import "APHStepDictionaryKeys.h"

static  const  NSString  *kWalkingStep101Key = @"Walking Step 101";
static  const  NSString  *kWalkingStep102Key = @"Walking Step 102";
static  const  NSString  *kWalkingStep103Key = @"Walking Step 103";
static  const  NSString  *kWalkingStep104Key = @"Walking Step 104";
static  const  NSString  *kWalkingStep105Key = @"Walking Step 105";

@interface APHWalkingTaskViewController  ( )
{
    NSInteger _count;
}

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
                                     APHIntroductionTitleTextKey: @"Measures Gait and Balance",
                                     APHActiveTextKey : @"You have 10 seconds to put this device in your pocket. After the phone vibrates, follow the instructions to begin.",
                                     APHActiveCountDownKey : @(10.0),
                                     APHActiveBuzzKey : @(YES),
                                     APHActiveVibrationKey : @(YES),
                                     APHActiveVoicePromptKey : @"You have 10 seconds to put this device in your pocket. After the phone vibrates, follow the instructions to begin.",
                                     },
                                 @{
                                     APHStepStepTypeKey  : APHActiveStepType,
                                     APHStepIdentiferKey : kWalkingStep102Key,
                                     APHStepNameKey : @"active step",
                                     APHActiveTextKey : @"Now please walk out 20 steps.",
                                     APHActiveCountDownKey : @(20.0),
                                     APHActiveBuzzKey : @(YES),
                                     APHActiveVibrationKey : @(YES),
                                     APHActiveVoicePromptKey : @"Now please walk out 20 steps.",
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
                                     APHActiveVoicePromptKey : @"Now please turn 180 degrees, and walk back.",
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
                                     APHActiveVoicePromptKey : @"Now please stand still for 30 seconds.",
                                     APHActiveRecorderConfigurationsKey : @[ [[RKAccelerometerRecorderConfiguration alloc] initWithFrequency:100.0]],
                                     },
                                 @{
                                     APHStepStepTypeKey  : APHActiveStepType,
                                     APHStepIdentiferKey : kWalkingStep105Key,
                                     APHIntroductionTitleTextKey: @"Great Job!",
                                     APHActiveTextKey : @"Your gait symptoms seem to appear mild. Insert easy to understand meaning of this interpretation here.",
                                     APHActiveCountDownKey : @(5.0),
                                     },
                                 ];
    
    RKTask  *task = [self mapConfigurationsToTask:configurations];
    
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

- (void)taskViewControllerDidComplete: (RKTaskViewController *)taskViewController
{
    [taskViewController suspend];
    [taskViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)taskViewControllerDidCancel:(RKTaskViewController *)taskViewController
{
    [taskViewController suspend];
    [taskViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (BOOL)taskViewController:(RKTaskViewController *)taskViewController shouldShowMoreInfoOnStep:(RKStep *)step
{
    return  YES;
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
    NSError * error;
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self filePath]]) {
        [[NSFileManager defaultManager] removeItemAtPath:[self filePath] error:&error];
        if (error) {
            NSLog(@"%@",[self descriptionForObject:error]);
        }
    }
    [[NSFileManager defaultManager] moveItemAtPath:[(RKFileResult*)result fileUrl].path toPath:[self filePath] error:&error];
    if (error) {
        NSLog(@"%@",[self descriptionForObject:error]);
    }
}


- (NSString *)filePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[paths lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", [NSUUID UUID].UUIDString]];
}

//- (RKStepViewController *)taskViewController:(RKTaskViewController *)taskViewController viewControllerForStep:(RKStep *)step
//{
//    NSLog(@"taskViewController viewControllerForStep = %@", step);
//    
//    NSDictionary  *stepsToControllersMap = @{
//                                             kWalkingStep101Key : @[ [APHWalkingOverviewViewController class], @(0) ],
//                                             kWalkingStep102Key : @[ [APHWalkingStepsViewController class], @(WalkingStepsPhaseWalkSomeDistance) ],
//                                             kWalkingStep103Key : @[ [APHWalkingStepsViewController class], @(WalkingStepsPhaseWalkBackToBase) ],
//                                             kWalkingStep104Key : @[ [APHWalkingStepsViewController class], @(WalkingStepsPhaseStandStill) ],
//                                             kWalkingStep105Key : @[ [APHWalkingResultsViewController  class], @(0) ],
//                                           };
//    
//    RKStepViewController  *controller = nil;
//    
//    NSArray  *descriptor = stepsToControllersMap[step.identifier];
//    
//    Class  classToCreate = descriptor[0];
//    NSUInteger  phase = [descriptor[1] unsignedIntegerValue];
//    controller = [[classToCreate alloc] initWithStep:step];
//    if ([controller respondsToSelector:@selector(setWalkingPhase:)] == YES) {
//        ((APHWalkingStepsViewController *)controller).walkingPhase = (WalkingStepsPhase)phase;
//    }
//    controller.delegate = self;
//    return  controller;
//}

/*********************************************************************************/
#pragma mark - Misc
/*********************************************************************************/
-(NSString *)descriptionForObject:(id)objct
{
    unsigned int varCount;
    NSMutableString *descriptionString = [[NSMutableString alloc]init];
    
    
    objc_property_t *vars = class_copyPropertyList(object_getClass(objct), &varCount);
    
    for (int i = 0; i < varCount; i++)
    {
        objc_property_t var = vars[i];
        const char* name = property_getName (var);
        
        NSString *keyValueString = [NSString stringWithFormat:@"\n%@ = %@",[NSString stringWithUTF8String:name],[objct valueForKey:[NSString stringWithUTF8String:name]]];
        [descriptionString appendString:keyValueString];
    }
    
    free(vars);
    return descriptionString;
}


@end
