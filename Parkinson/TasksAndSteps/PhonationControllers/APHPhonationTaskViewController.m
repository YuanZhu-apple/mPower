// 
//  APHPhonationTaskViewController.m 
//  mPower 
// 
//  Copyright (c) 2014 Apple, Inc. All rights reserved. 
// 
 
#import "APHPhonationTaskViewController.h"

#import <AVFoundation/AVFoundation.h>

static  NSString       *kTaskViewControllerTitle   = @"Voice Activity";

static  NSTimeInterval  kGetSoundingAaahhhInterval = 10.0;

static  NSString       *kConclusionStepIdentifier  = @"conclusion";

@interface APHPhonationTaskViewController ( )  <RKSTTaskViewControllerDelegate>

@end

@implementation APHPhonationTaskViewController

#pragma  mark  -  Initialisation

+ (RKSTOrderedTask *)createTask:(APCScheduledTask *)scheduledTask
{
    NSDictionary  *audioSettings = @{ AVFormatIDKey         : @(kAudioFormatAppleLossless),
                                      AVNumberOfChannelsKey : @(1),
                                      AVSampleRateKey       : @(44100.0)
                                    };
    
      RKSTOrderedTask  *task = [RKSTOrderedTask audioTaskWithIdentifier:kTaskViewControllerTitle
                                intendedUseDescription:nil
                                speechInstruction:nil
                                shortSpeechInstruction:nil
                                duration:kGetSoundingAaahhhInterval
                                recordingSettings:audioSettings
                                options:0];
    
    [[UIView appearance] setTintColor:[UIColor appPrimaryColor]];
    
    return  task;
}

#pragma  mark  -  Task View Controller Delegate Methods

- (void)taskViewController:(RKSTTaskViewController *)taskViewController stepViewControllerWillAppear:(RKSTStepViewController *)stepViewController {
    
    if ([stepViewController.step.identifier isEqualToString:kConclusionStepIdentifier]) {
        [[UIView appearance] setTintColor:[UIColor appTertiaryColor1]];
    }
}

- (void)taskViewControllerDidComplete:(RKSTTaskViewController *)taskViewController
{
    [[UIView appearance] setTintColor:[UIColor appPrimaryColor]];
    
    [super taskViewControllerDidComplete:taskViewController];
    
}

- (void)taskViewControllerDidCancel:(RKSTTaskViewController *)taskViewController
{
    [[UIView appearance] setTintColor:[UIColor appPrimaryColor]];
    
    [super taskViewControllerDidCancel:taskViewController];
}

#pragma  mark  -  Results For Dashboard

- (NSString *)createResultSummary
{
    return @"";
}

#pragma  mark  - View Controller methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBar.topItem.title = NSLocalizedString(kTaskViewControllerTitle, nil);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

@end
