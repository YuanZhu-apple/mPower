//
//  APHSleepQualityTaskViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 9/3/14.
//  Copyright (c) 2014 Henry McGilton. All rights reserved.
//

#import "APHSleepQualityTaskViewController.h"

@implementation APHSleepQualityTaskViewController

static  const  NSString  *kQuestionStep101Key = @"Question Step 101";

#pragma  mark  -  Initialisation

+ (instancetype)customTaskViewController
{
    RKTask  *task = [self createTask];
    APHSleepQualityTaskViewController  *controller = [[APHSleepQualityTaskViewController alloc] initWithTask:task taskInstanceUUID:[NSUUID UUID]];
    controller.delegate = controller;
    return  controller;
}

+ (RKTask *)createTask
{
    NSArray  *configurations = @[
                                 @{
                                     APHStepStepTypeKey  : APHActiveStepType,
                                     APHStepIdentiferKey : kQuestionStep101Key,
                                     APHStepNameKey : @"question step",
                                     APHActiveTextKey : @"How long do  you need to get to sleep?",
                                     }
                                 ];
    
    RKTask  *task = [self mapConfigurationsToTask:configurations];
    
    return  task;
}

@end
