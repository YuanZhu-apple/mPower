//
//  APHWalkingStepsViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 8/20/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHWalkingStepsViewController.h"
#include <math.h>

static  NSTimeInterval  kDefaultTimeInterval = 5.0;

@interface APHWalkingStepsViewController  ( ) <RKRecorderDelegate>

@property  (nonatomic, strong)  IBOutlet  UIView   *phaseEgressView;
@property  (nonatomic, strong)  IBOutlet  UILabel  *phaseEgressViewCounterDisplay;

@property  (nonatomic, strong)  IBOutlet  UIView   *phaseIngressView;
@property  (nonatomic, strong)  IBOutlet  UILabel  *phaseIngressViewCounterDisplay;

@property  (nonatomic, strong)  IBOutlet  UIView   *phaseStandingView;
@property  (nonatomic, strong)  IBOutlet  UILabel  *phaseStandingViewCounterDisplay;

@property  (nonatomic, strong)            NSTimer  *timer;
@property  (nonatomic, assign)            NSUInteger  counter;

@property  (nonatomic, strong)            RKAccelerometerRecorder  *recorder;

@end

@implementation APHWalkingStepsViewController

#pragma  mark  -  Recorder Delegate Methods

- (void)recorder:(RKRecorder *)recorder didCompleteWithResult:(RKResult *)result
{
    NSLog(@"recorder didCompleteWithResult = %@", result);
}

- (void)recorder:(RKRecorder *)recorder didFailWithError:(NSError *)error
{
    NSLog(@"recorder didFailWithError = %@", error);
}

#pragma  mark  -  Helper Methods

- (void)switchToWalkingPhaseView:(WalkingStepsPhase)phase
{
    if (phase == WalkingStepsPhaseWalkSomeDistance) {
        self.phaseIngressView.hidden = YES;
        self.phaseEgressView.hidden = NO;
        self.phaseStandingView.hidden = YES;
    } else if (phase == WalkingStepsPhaseWalkBackToBase) {
        self.phaseIngressView.hidden = NO;
        self.phaseEgressView.hidden = YES;
        self.phaseStandingView.hidden = YES;
    } else if (phase == WalkingStepsPhaseStandStill) {
        self.phaseIngressView.hidden = YES;
        self.phaseEgressView.hidden = YES;
        self.phaseStandingView.hidden = NO;
    }
    self.walkingPhase = phase;
}

#pragma  mark  -  Timer Fired Methods

- (void)formatCounterValue:(NSUInteger)value forPhase:(WalkingStepsPhase)phase
{
    NSString  *formatted = [NSString stringWithFormat:@"%02lu", (unsigned long)value];
    if (phase == WalkingStepsPhaseWalkSomeDistance) {
        self.phaseEgressViewCounterDisplay.text = formatted;
    } else if (phase == WalkingStepsPhaseWalkBackToBase) {
        self.phaseIngressViewCounterDisplay.text = formatted;
    } else if (phase == WalkingStepsPhaseStandStill) {
        self.phaseStandingViewCounterDisplay.text = formatted;
    }
}

- (void)countdownTimerFired:(NSTimer *)timer
{
    self.counter = self.counter - 1;
    [self formatCounterValue:self.counter forPhase:self.walkingPhase];
    if (self.counter == 0) {
        [self.timer invalidate];
        self.timer = nil;
        NSError  *error = nil;
        BOOL  success = [self.recorder stop:&error];
        if (success == YES) {
            NSLog(@"Recorder Stopped Okay");
        } else {
            NSLog(@"Recorder Failed to Stop with Error = %@", error);
        }
    }
}

#pragma  mark  -  View Controller Methods

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.delegate = self.taskViewController;
    
    [self switchToWalkingPhaseView:self.walkingPhase];
    
    NSArray  *recorderConfigurations = nil;
    NSTimeInterval  countDownValue = kDefaultTimeInterval;
    if ([self.step isKindOfClass:[RKActiveStep class]] == YES) {
        countDownValue = [(RKActiveStep *)[self step] countDown];
        recorderConfigurations = [(RKActiveStep *)[self step] recorderConfigurations];
    }
    if (isfinite(countDownValue) == 0) {
        countDownValue = kDefaultTimeInterval;
    }
    countDownValue = fabs(countDownValue);
    self.counter = countDownValue;
    
    [self formatCounterValue:self.counter forPhase:self.walkingPhase];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                    target:self  selector:@selector(countdownTimerFired:)
                                                  userInfo:nil repeats:YES];

    RKAccelerometerRecorderConfiguration  *configuration = (RKAccelerometerRecorderConfiguration *)(recorderConfigurations[0]);
    
    double  frequency = configuration.frequency;
    self.recorder = [[RKAccelerometerRecorder alloc] initWithFrequency:frequency
                                            step:self.step
                                            taskInstanceUUID:self.taskViewController.taskInstanceUUID];
    [self.recorder viewController:self willStartStepWithView:self.view];
    NSError  *error = nil;
    BOOL  success = [self.recorder start:&error];
    if (success == YES) {
        NSLog(@"Recorder Started Okay");
    } else {
        NSLog(@"Recorder Failed to Start with Error = %@", error);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
