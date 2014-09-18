//
//  APHIntervalTappingTaskViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 9/3/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHIntervalTappingTaskViewController.h"
#import "CustomRecorder.h"

static float tapInterval = 20.0;

@interface APHIntervalTappingTaskViewController  ( )

@end

@implementation APHIntervalTappingTaskViewController


#pragma  mark  -  Initialisation

+ (RKTask *)createTask:(APCScheduledTask*) scheduledTask
{
    NSMutableArray *steps = [[NSMutableArray alloc] init];
    
    {
        RKIntroductionStep *step = [[RKIntroductionStep alloc] initWithIdentifier:@"aid_000a" name:@"Tap intro"];
        step.caption = @"Tests Bradykinesia";
        step.explanation = @"";
        step.instruction = @"Interval tapping will give you a set of intervals in which you will need to tap the screen.";
        [steps addObject:step];
    }
    
    {
        RKActiveStep* step = [[RKActiveStep alloc] initWithIdentifier:@"aid_001b" name:@"active step"];
        step.caption = @"Button Tap";
        step.text = @"Please tap the blue box below when it appears.";
        step.countDown = tapInterval;
        step.recorderConfigurations = @[[CustomRecorderConfiguration new]];
        [steps addObject:step];
    }
        
    RKTask  *task = [[RKTask alloc] initWithName:@"Interval Touches" identifier:@"Tapping Task" steps:steps];
    return  task;
}


@end
