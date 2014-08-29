//
//  APHActivitiesViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 8/20/14.
//  Copyright (c) 2014 Henry McGilton. All rights reserved.
//

#import "APHActivitiesViewController.h"

#import "APHActivitiesTableViewCell.h"
#import "NSString+CustomMethods.h"

@interface APHActivitiesViewController ()

@property  (nonatomic, strong)  NSArray  *stepsConfigurations;

@end

@implementation APHActivitiesViewController (WalkingTask)

#pragma  mark  -  Task Creation Methods

- (void)createWalkingTask
{
    NSMutableArray  *steps = [NSMutableArray new];
    
    self.stepsConfigurations = @[
                                      @{
                                          @"StepIdentifer" : @"Walking 101",
                                          @"StepName" : @"active step",
                                          @"StepText" : @"Please put the phone in a pocket or armband. Then wait for voice instruction.",
                                          @"StepCountDown" : @(8.0),
                                          },
                                      @{
                                          @"StepIdentifer" : @"Walking 102",
                                          @"StepName" : @"active step",
                                          @"StepText" : @"Now please walk 20 yards, turn 180 degrees, and walk back.",
                                          @"StepCountDown" : @(60.0),
                                          @"StepBuzz" : @(YES),
                                          @"StepVibration" : @(YES),
                                          @"StepVoicePrompt" : @"StepText",
                                          @"StepRecorderConfigurations" : @[ [[RKAccelerometerRecorderConfiguration alloc] initWithFrequency:100.0]],
                                          @"StepCountDown" : @(60.0),
                                          @"StepCountDown" : @(60.0),
                                          },
                                      @{
                                          @"StepIdentifer" : @"Walking 103",
                                          @"StepName" : @"active step",
                                          @"StepText" : @"Thank you for completing this task.",
                                          @"StepVoicePrompt" : @"StepText",
                                          },
                                      ];
    NSMutableArray  *steps = [[NSMutableArray alloc] initWithCapacity:[self.stepsConfigurations count]];
                              
    for (NSDictionary  *dictionary  in  self.stepsConfigurations) {
    }
    
//    {
//        RKActiveStep* step = [[RKActiveStep alloc] initWithIdentifier:@"gait_001" name:@"active step"];
//        step.text = @"Please put the phone in a pocket or armband. Then wait for voice instruction.";
//        step.countDown = 8.0;
//        [steps addObject:step];
//    }
//    
//    {
//        RKActiveStep* step = [[RKActiveStep alloc] initWithIdentifier:@"gait_002" name:@"active step"];
//        step.text = @"Now please walk 20 yards, turn 180 degrees, and walk back.";
//        step.buzz = YES;
//        step.vibration = YES;
//        step.voicePrompt = step.text;
//        step.countDown = 60.0;
//        step.recorderConfigurations = @[ [[RKAccelerometerRecorderConfiguration alloc] initWithFrequency:100.0]];
//        [steps addObject:step];
//    }
//    
//    {
//        RKActiveStep* step = [[RKActiveStep alloc] initWithIdentifier:@"gait_003" name:@"active step"];
//        step.text = @"Thank you for completing this task.";
//        step.voicePrompt = step.text;
//        [steps addObject:step];
//    }
//    
//    RKTask* task = [[RKTask alloc] initWithName:@"GAIT" identifier:@"tid_001" steps:steps];
//    self.taskVC = [[RKTaskViewController alloc] initWithTask:task taskInstanceUUID:[NSUUID UUID]];
//    self.taskVC.delegate = self;
//    
//    [self presentViewController:_taskVC animated:YES completion:^{
//        NSLog(@"task Presented");
//    }];
    
    
}


@end
