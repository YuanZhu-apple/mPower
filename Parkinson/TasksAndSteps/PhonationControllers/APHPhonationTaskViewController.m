//
//  APHPhonationTaskViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 9/3/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHPhonationTaskViewController.h"
#import "APHPhonationIntroViewController.h"
#import <objc/message.h>
#import <AVFoundation/AVFoundation.h>

static NSString * kPhonationStep101Key = @"Phonation_Step_101";
static NSString * kPhonationStep102Key = @"Phonation_Step_102";
static NSString * kPhonationStep103Key = @"Phonation_Step_103";
static NSString * kPhonationStep104Key = @"Phonation_Step_104";
static NSString * kPhonationStep105Key = @"Phonation_Step_105";

@implementation APHPhonationTaskViewController

#pragma  mark  -  Initialisation

+ (RKTask *)createTask:(APCScheduledTask*) scheduledTask
{
    
    NSMutableArray *steps = [NSMutableArray array];
    
    {
        RKIntroductionStep *step = [[RKIntroductionStep alloc] initWithIdentifier:kPhonationStep101Key name:@"Introduction Step"];
        step.caption = @"Tests Speech Difficulties";
        step.explanation = @"";
        step.instruction = @"In the next screen you will be asked to say “Aaaahhh” for 10 seconds.";
        [steps addObject:step];
    }
    {
        RKActiveStep* step = [[RKActiveStep alloc] initWithIdentifier:kPhonationStep102Key name:@"active step"];
        step.text = @"Please say “Aaaahhh” for 10 seconds";
        step.countDown = 10.0;
        step.buzz = YES;
        step.vibration = YES;
        step.recorderConfigurations = @[[[RKAudioRecorderConfiguration alloc] initWithRecorderSettings:@{AVFormatIDKey : @(kAudioFormatAppleLossless),
                                                                                                         AVNumberOfChannelsKey : @(2),
                                                                                                         AVSampleRateKey: @(44100.0)
                                                                                                         }]];
        [steps addObject:step];
    }
    {
        RKActiveStep* step = [[RKActiveStep alloc] initWithIdentifier:kPhonationStep103Key name:@"active step"];
        step.caption = @"Great Job!";
        step.countDown = 5.0;
        [steps addObject:step];
    }
    
    RKTask  *task = [[RKTask alloc] initWithName:@"Sustained Phonation" identifier:@"Phonation Task" steps:steps];
    
    return  task;
}

#pragma  mark  -  Task View Controller Delegate Methods

- (BOOL)taskViewController:(RKTaskViewController *)taskViewController shouldPresentStepViewController:(RKStepViewController *)stepViewController
{
    return  YES;
}

- (void)taskViewController:(RKTaskViewController *)taskViewController willPresentStepViewController:(RKStepViewController *)stepViewController
{
    stepViewController.cancelButton = nil;
    stepViewController.backButton = nil;
}

- (RKStepViewController *)taskViewController:(RKTaskViewController *)taskViewController viewControllerForStep:(RKStep *)step
{
    NSDictionary  *controllers = @{
                                     kPhonationStep101Key : [APHPhonationIntroViewController class],
//                                   kIntervalTappingStep102 : [APHIntervalTappingStepsViewController   class],
//                                   kIntervalTappingStep103 : [APHIntervalTappingResultsViewController class]
                                   };
    Class  aClass = [controllers objectForKey:step.identifier];
    APCStepViewController  *controller = [[aClass alloc] initWithNibName:nil bundle:nil];
    controller.resultCollector = self;
    controller.delegate = self;
    controller.title = @"Interval Tapping";
    controller.step = step;
    return  controller;
}

@end
