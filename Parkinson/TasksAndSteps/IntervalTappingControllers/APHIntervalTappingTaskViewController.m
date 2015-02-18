// 
//  APHIntervalTappingTaskViewController.m 
//  mPower 
// 
//  Copyright (c) 2014 Apple, Inc. All rights reserved. 
// 
 
#import "APHIntervalTappingTaskViewController.h"
#import "APHIntervalTappingRecorderDataKeys.h"

#import <AVFoundation/AVFoundation.h>

typedef  enum  _TappingStepOrdinals
{
    TappingStepOrdinalsIntroductionStep = 0,
    TappingStepOrdinalsInstructionStep,
    TappingStepOrdinalsTappingStep,
    TappingStepOrdinalsConclusionStep,
}  TappingStepOrdinals;

static  NSString       *kTaskViewControllerTitle      = @"Tapping Activity";

static  NSString       *kIntervalTappingTitle         = @"Tapping Activity";

static  NSTimeInterval  kTappingStepCountdownInterval = 20.0;

static NSString        *kConclusionStepIdentifier     = @"conclusion";

@interface APHIntervalTappingTaskViewController  ( ) <NSObject>

@property  (nonatomic, assign)  TappingStepOrdinals  tappingStepOrdinal;

@property  (nonatomic, assign)  BOOL                 preferStatusBarShouldBeHidden;

@end

@implementation APHIntervalTappingTaskViewController

#pragma  mark  -  Task Creation Methods

+ (ORKOrderedTask *)createTask:(APCScheduledTask *)scheduledTask
{
    ORKOrderedTask  *task = [ORKOrderedTask twoFingerTappingIntervalTaskWithIdentifier:kIntervalTappingTitle
                                                                intendedUseDescription:nil
                                                                              duration:kTappingStepCountdownInterval
                                                                                options:0];

#warning TODO: Replace this next line with a proper search for the Info step with the correct identifier.
    [task.steps[0] setText: @"This test evaluates your tapping speed and coordination."];
    
    [[UIView appearance] setTintColor:[UIColor appPrimaryColor]];
    
    return  task;
}

#pragma  mark  -  Results For Dashboard

- (NSString *)createResultSummary
{
    ORKTaskResult  *taskResults = self.result;
    ORKTappingIntervalResult  *tapsterResults = nil;
    BOOL  found = NO;
    for (ORKStepResult  *stepResult  in  taskResults.results) {
        if (stepResult.results.count > 0) {
            for (id  object  in  stepResult.results) {
                if ([object isKindOfClass:[ORKTappingIntervalResult class]] == YES) {
                    found = YES;
                    tapsterResults = object;
                    break;
                }
            }
            if (found == YES) {
                break;
            }
        }
    }
    NSUInteger  numberOfSamples = 0;
    NSDictionary  *summary = nil;
    if (tapsterResults == nil) {
        summary = @{ kSummaryNumberOfRecordsKey : @(numberOfSamples) };
    } else {
        numberOfSamples = [tapsterResults.samples count];
        summary = @{ kSummaryNumberOfRecordsKey : @(numberOfSamples) };
    }
    NSError  *error = nil;
    NSData  *data = [NSJSONSerialization dataWithJSONObject:summary options:0 error:&error];
    NSString  *contentString = nil;
    if (data == nil) {
        APCLogError2 (error);
    } else {
        contentString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return  contentString;
}

#pragma  mark  -  Task View Controller Delegate Methods

- (void)taskViewController:(ORKTaskViewController *)taskViewController stepViewControllerWillAppear:(ORKStepViewController *)stepViewController
{
    if (self.tappingStepOrdinal == TappingStepOrdinalsTappingStep) {
        self.preferStatusBarShouldBeHidden = YES;
        [[UIApplication sharedApplication] setStatusBarHidden: YES];
    }
    if (self.tappingStepOrdinal == TappingStepOrdinalsConclusionStep) {
        self.preferStatusBarShouldBeHidden = NO;
        [[UIApplication sharedApplication] setStatusBarHidden: NO];
        [[UIView appearance] setTintColor:[UIColor appTertiaryColor1]];
    }
    self.tappingStepOrdinal = self.tappingStepOrdinal + 1;
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

#pragma  mark  -  View Controller Methods

- (BOOL)prefersStatusBarHidden
{
    return  self.preferStatusBarShouldBeHidden;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBar.topItem.title = NSLocalizedString(kTaskViewControllerTitle, nil);
    
    self.tappingStepOrdinal = TappingStepOrdinalsIntroductionStep;
    self.preferStatusBarShouldBeHidden = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

@end
