//
//  APHActivitiesViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 8/20/14.
//  Copyright (c) 2014 Henry McGilton. All rights reserved.
//

#import "APHActivitiesViewController.h"

#import "APHActivitiesWalkingTask.h"

#import "APHActivitiesTableViewCell.h"
#import "APHStepDictionaryKeys.h"
#import "NSString+CustomMethods.h"

#import <ResearchKit/ResearchKit.h>

@implementation APHActivitiesViewController (WalkingTask)

#pragma  mark  -  Task Creation Methods

- (void)createWalkingTask
{
    self.stepsConfigurations = @[
                                  @{
                                      APHStepStepTypeKey  : APHActiveStepType,
                                      APHStepIdentiferKey : @"Walking 101",
                                      APHStepNameKey : @"active step",
                                      APHActiveTextKey : @"Please put the phone in a pocket or armband. Then wait for voice instruction.",
                                      APHActiveCountDownKey : @(2.0),
                                      },
                                  @{
                                      APHStepStepTypeKey  : APHActiveStepType,
                                      APHStepIdentiferKey : @"Walking 102",
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
                                      APHStepIdentiferKey : @"Walking 103",
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
                                      APHStepIdentiferKey : @"Walking 104",
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
                                      APHStepIdentiferKey : @"Walking 105",
                                      APHStepNameKey : @"active step",
                                      APHActiveTextKey : @"",
                                      APHActiveVoicePromptKey : APHActiveTextKey,
                                      },
//                                  @{
//                                      APHStepStepTypeKey  : APHActiveStepType,
//                                      APHStepIdentiferKey : @"Walking 106",
//                                      APHStepNameKey : @"active step",
//                                      APHActiveTextKey : @"",
//                                      APHActiveVoicePromptKey : APHActiveTextKey,
//                                      },
                                  ];
    
    NSMutableArray  *steps = [[NSMutableArray alloc] initWithCapacity:[self.stepsConfigurations count]];
                              
    for (NSDictionary  *dictionary  in  self.stepsConfigurations) {
        NSString  *className = dictionary[APHStepStepTypeKey];
        Class  class = NSClassFromString(className);
        RKStep  *step = [[class alloc] initWithIdentifier:dictionary[APHStepIdentiferKey] name:dictionary[APHStepNameKey]];
        
        for (NSString  *key  in  self.keysToPropertiesMap) {
            id  object = [dictionary objectForKey: key];
            if (object != nil) {
                NSString  *propertyName = [self.keysToPropertiesMap objectForKey:key];
                [step setValue:object forKey:propertyName];
            }
        }
        [steps addObject:step];
    }
    RKTask  *task = [[RKTask alloc] initWithName:@"Measures Gait and Balance" identifier:@"Walking Task" steps:steps];
    RKTaskViewController  *controller = [[RKTaskViewController alloc] initWithTask:task taskInstanceUUID:[NSUUID UUID]];
    
    controller.delegate = self;

    [self presentViewController:controller animated:YES completion:^{
        NSLog(@"task Presented");
    }];
}

@end
