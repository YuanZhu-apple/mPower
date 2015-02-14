// 
//  APHPhonationTaskViewController.m 
//  mPower 
// 
//  Copyright (c) 2014 Apple, Inc. All rights reserved. 
// 
 
#import "APHPhonationTaskViewController.h"

#import <AVFoundation/AVFoundation.h>

typedef  enum  _PhonationStepOrdinals
{
    PhonationStepOrdinalsIntroductionStep = 0,
    PhonationStepOrdinalsInstructionStep,
    PhonationStepOrdinalsCountdownStep,
    PhonationStepOrdinalsVoiceRecordingStep,
    PhonationStepOrdinalsConclusionStep,
}  PhonationStepOrdinals;

static  NSString       *kTaskViewControllerTitle   = @"Voice Activity";

static  NSTimeInterval  kGetSoundingAaahhhInterval = 10.0;

static  NSString       *kConclusionStepIdentifier  = @"conclusion";

@interface APHPhonationTaskViewController ( )  <ORKTaskViewControllerDelegate>

@property  (nonatomic, assign)  PhonationStepOrdinals  voiceRecordingStepOrdinal;

@end

@implementation APHPhonationTaskViewController

#pragma  mark  -  Initialisation

+ (ORKOrderedTask *)createTask:(APCScheduledTask *)scheduledTask
{
    NSDictionary  *audioSettings = @{ AVFormatIDKey         : @(kAudioFormatAppleLossless),
                                      AVNumberOfChannelsKey : @(1),
                                      AVSampleRateKey       : @(44100.0)
                                    };
    
      ORKOrderedTask  *task = [ORKOrderedTask audioTaskWithIdentifier:kTaskViewControllerTitle
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

- (void)taskViewController:(ORKTaskViewController *)taskViewController stepViewControllerWillAppear:(ORKStepViewController *)stepViewController
{
    if (self.voiceRecordingStepOrdinal == PhonationStepOrdinalsVoiceRecordingStep) {
        [[UIView appearance] setTintColor:[UIColor appTertiaryBlueColor]];
    }
    if (self.voiceRecordingStepOrdinal == PhonationStepOrdinalsConclusionStep) {
        [[UIView appearance] setTintColor:[UIColor appTertiaryColor1]];
    }
    self.voiceRecordingStepOrdinal = self.voiceRecordingStepOrdinal + 1;
}

- (void)taskViewControllerDidComplete:(ORKTaskViewController *)taskViewController
{
    [[UIView appearance] setTintColor:[UIColor appPrimaryColor]];
    
    [super taskViewControllerDidComplete:taskViewController];
    
}

- (void)taskViewControllerDidCancel:(ORKTaskViewController *)taskViewController
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
    
    self.voiceRecordingStepOrdinal = PhonationStepOrdinalsIntroductionStep;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

@end
