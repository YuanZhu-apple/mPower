//
//  APHIntervalTappingTaskViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 9/3/14.
//  Copyright (c) 2014 Henry McGilton. All rights reserved.
//

#import "APHIntervalTappingTaskViewController.h"
#import "CustomRecorder.h"

@interface APHIntervalTappingTaskViewController  ( )

@end

@implementation APHIntervalTappingTaskViewController

#pragma  mark  -  Initialisation


+ (instancetype)customTaskViewController
{
    RKTask  *task = [self createTask];
    APHIntervalTappingTaskViewController  *controller = [[APHIntervalTappingTaskViewController alloc] initWithTask:task taskInstanceUUID:[NSUUID UUID]];
    controller.delegate = controller;
    return  controller;
}

+ (RKTask *)createTask
{
    NSMutableArray *steps = [[NSMutableArray alloc] init];
    {
        RKActiveStep* step = [[RKActiveStep alloc] initWithIdentifier:@"aid_001a" name:@"active step"];
        step.caption = @"Touch";
        step.text = @"An active test, touch collection";
        step.clickButtonToStartTimer = YES;
        step.countDown = 20.0;
        step.voicePrompt = @"An active test, touch collection";

        step.recorderConfigurations = @[[RKTouchRecorderConfiguration configuration]];
        [steps addObject:step];
    }
    
    {
        RKActiveStep* step = [[RKActiveStep alloc] initWithIdentifier:@"aid_001b" name:@"active step"];
        step.caption = @"Button Tap";
        step.text = @"Please tap the green button above when it appears.";
        step.countDown = 10.0;
        step.recorderConfigurations = @[[CustomRecorderConfiguration new]];
        [steps addObject:step];
    }
    
    
    RKTask  *task = [[RKTask alloc] initWithName:@"Interval Touches" identifier:@"Tapping Task" steps:steps];
    return  task;
}


@end
