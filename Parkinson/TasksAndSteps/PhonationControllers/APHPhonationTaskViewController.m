//
//  APHPhonationTaskViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 9/3/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHPhonationTaskViewController.h"
#import "APHPhonationIntroViewController.h"
#import "APHCommonTaskSummaryViewController.h"
#import <objc/message.h>
#import <AVFoundation/AVFoundation.h>

static  NSString       *MainStudyIdentifier        = @"com.parkinsons.phonation";
static  NSTimeInterval  kGetReadyCountDownInterval = 5.0;
static  NSString       *kPhonationStep101Key       = @"Phonation_Step_101";
static  NSString       *kGetReadyStep              = @"Get Ready";
static  NSString       *kPhonationStep102Key       = @"Phonation_Step_102";
static  NSTimeInterval  kGetSoundingAaahhhInterval = 10.0;
static  NSString       *kPhonationStep103Key       = @"Phonation_Step_103";
static  NSString       *kPhonationStep104Key       = @"Phonation_Step_104";
static  NSString       *kPhonationStep105Key       = @"Phonation_Step_105";

static  NSString  *kTaskViewControllerTitle = @"Sustained Phonation";

@interface APHPhonationTaskViewController ()

@property (strong, nonatomic) RKSTDataArchive *taskArchive;

@end

@implementation APHPhonationTaskViewController

#pragma  mark  -  Initialisation

+ (RKSTOrderedTask *)createTask:(APCScheduledTask*) scheduledTask
{
    
    NSMutableArray *steps = [NSMutableArray array];
    
    {
        RKSTInstructionStep  *step = [[RKSTInstructionStep alloc] initWithIdentifier:kPhonationStep101Key];
        step.title = @"Tests Speech Difficulties";
        step.text = @"";
        step.detailText = @"In the next screen you will be asked to say “Aaaahhh” for 10 seconds.";
        [steps addObject:step];
    }
    
    {
        //Introduction to fitness test
        RKSTActiveStep  *step = [[RKSTActiveStep alloc] initWithIdentifier:kGetReadyStep];
        step.title = NSLocalizedString(@"Sustained Phonation", @"");
        step.text = NSLocalizedString(@"Get Ready!", @"");
        step.countDownInterval = kGetReadyCountDownInterval;
        step.shouldStartTimerAutomatically = YES;
        step.shouldUseNextAsSkipButton = NO;
        step.shouldPlaySoundOnStart = YES;
        step.shouldSpeakCountDown = YES;
        
        [steps addObject:step];
    }
    
    {
        RKSTActiveStep  *step = [[RKSTActiveStep alloc] initWithIdentifier:kPhonationStep102Key];
        step.text = @"Please say “Aaaahhh” for 10 seconds";
        step.countDownInterval = kGetSoundingAaahhhInterval;
        step.shouldStartTimerAutomatically = YES;
        step.shouldPlaySoundOnStart = YES;
        step.shouldVibrateOnStart = YES;
        step.recorderConfigurations = @[[[RKSTAudioRecorderConfiguration alloc] initWithRecorderSettings:@{ AVFormatIDKey : @(kAudioFormatAppleLossless),
                                                                                                            AVNumberOfChannelsKey : @(2),
                                                                                                            AVSampleRateKey: @(44100.0)
                                                                                                         }]];
        [steps addObject:step];
    }
    {
        RKSTInstructionStep  *step = [[RKSTInstructionStep alloc] initWithIdentifier:kPhonationStep103Key];
        step.title = @"Great Job!";
        [steps addObject:step];
    }
    
    RKSTOrderedTask  *task = [[RKSTOrderedTask alloc] initWithIdentifier:@"Phonation Task" steps:steps];
    
    return  task;
}

#pragma  mark  -  Task View Controller Delegate Methods

- (BOOL)taskViewController:(RKSTTaskViewController *)taskViewController shouldPresentStepViewController:(RKSTStepViewController *)stepViewController
{
    return  YES;
}

- (void)taskViewController:(RKSTTaskViewController *)taskViewController willPresentStepViewController:(RKSTStepViewController *)stepViewController
{
    stepViewController.cancelButton = nil;
    stepViewController.backButton = nil;
    stepViewController.continueButton = nil;
}

- (RKSTStepViewController *)taskViewController:(RKSTTaskViewController *)taskViewController viewControllerForStep:(RKSTStep *)step
{
    NSDictionary  *controllers = @{
                                   kPhonationStep101Key : [APHPhonationIntroViewController class],
                                   kPhonationStep103Key : [APHCommonTaskSummaryViewController class]
                                   };
    Class  aClass = [controllers objectForKey:step.identifier];
    APCStepViewController  *controller = [[aClass alloc] initWithNibName:nil bundle:nil];
    controller.delegate = self;
    controller.title = @"Interval Tapping";
    controller.step = step;
    return  controller;
}

#pragma  mark  - View Controller methods

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBar.topItem.title = NSLocalizedString(kTaskViewControllerTitle, nil);
}


/*********************************************************************************/
#pragma  mark  - TaskViewController delegates
/*********************************************************************************/

- (void)taskViewControllerDidFail: (RKSTTaskViewController *)taskViewController withError:(NSError*)error{
    
    [self.taskArchive resetContent];
    self.taskArchive = nil;
    
}

/*********************************************************************************/
#pragma mark - StepViewController Delegate Methods
/*********************************************************************************/

//- (void)stepViewControllerWillBePresented:(RKSTStepViewController *)viewController
- (void)stepViewControllerWillAppear:(RKSTStepViewController *)viewController
{
    viewController.skipButton = nil;
    viewController.continueButton = nil;
}

- (void)stepViewControllerDidFinish:(RKSTStepViewController *)stepViewController navigationDirection:(RKSTStepViewControllerNavigationDirection)direction
{
    [super stepViewControllerDidFinish:stepViewController navigationDirection:direction];
    
    stepViewController.continueButton = nil;
}

@end
