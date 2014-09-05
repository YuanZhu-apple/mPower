//
//  APHChangedMedsTaskViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 9/3/14.
//  Copyright (c) 2014 Henry McGilton. All rights reserved.
//

#import "APHChangedMedsTaskViewController.h"

static  const  NSString  *kQuestionStep101Key = @"Question Step 101";

@implementation APHChangedMedsTaskViewController

#pragma  mark  -  Initialisation

+ (instancetype)customTaskViewController
{
    RKTask  *task = [self createTask];
    APHChangedMedsTaskViewController  *controller = [[APHChangedMedsTaskViewController alloc] initWithTask:task taskInstanceUUID:[NSUUID UUID]];
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
                                     APHActiveTextKey : @"Have your changed yor medications recently?",
                                     }
                                 ];
    
    RKTask  *task = [self mapConfigurationsToTask:configurations];
    
    return  task;
}

@end
