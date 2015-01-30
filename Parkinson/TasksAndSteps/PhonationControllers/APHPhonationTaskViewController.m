// 
//  APHPhonationTaskViewController.m 
//  mPower 
// 
//  Copyright (c) 2014 Apple, Inc. All rights reserved. 
// 
 
#import "APHPhonationTaskViewController.h"

#import <AVFoundation/AVFoundation.h>

static  NSString       *kTaskViewControllerTitle   = @"Speaking Activity";

static  NSString       *kIntendedUseDescription    = @"Hear Me Aaaaahhhhh";
static  NSString       *kShortSpeechInstruction    = @"Get Ready to Record";
static  NSString       *kLongSpeechInstruction     = @"Get Ready to Record";
static  NSTimeInterval  kGetSoundingAaahhhInterval = 10.0;

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
                                intendedUseDescription:NSLocalizedString(kIntendedUseDescription, kIntendedUseDescription)
                                speechInstruction:kShortSpeechInstruction
                                shortSpeechInstruction:kLongSpeechInstruction
                                duration:kGetSoundingAaahhhInterval
                                recordingSettings:audioSettings
                                options:0];
    
    return  task;
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
