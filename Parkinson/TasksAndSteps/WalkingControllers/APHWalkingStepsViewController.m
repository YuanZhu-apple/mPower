//
//  APHWalkingStepsViewController.m
//  Parkinson's
//
//  Copyright (c) 2014 <INSTITUTION-NAME-TBD>. All rights reserved.
//

#import "APHWalkingStepsViewController.h"
#include <math.h>

static  NSTimeInterval  kDefaultTimeInterval = 5.0;

@interface APHWalkingStepsViewController  ( ) <RKSTRecorderDelegate>

@property  (nonatomic, strong)  IBOutlet  UIView   *phaseEgressView;
@property  (nonatomic, strong)  IBOutlet  UILabel  *phaseEgressViewCounterDisplay;

@property  (nonatomic, strong)  IBOutlet  UIView   *phaseIngressView;
@property  (nonatomic, strong)  IBOutlet  UILabel  *phaseIngressViewCounterDisplay;

@property  (nonatomic, strong)  IBOutlet  UIView   *phaseStandingView;
@property  (nonatomic, strong)  IBOutlet  UILabel  *phaseStandingViewCounterDisplay;

@property  (nonatomic, strong)            NSTimer  *timer;
@property  (nonatomic, assign)            NSUInteger  counter;

@property  (nonatomic, strong)            RKSTAccelerometerRecorder  *recorder;

@end

@implementation APHWalkingStepsViewController

#pragma  mark  -  Recorder Delegate Methods

- (void)recorder:(RKSTRecorder *)recorder didCompleteWithResult:(RKSTResult *)result
{
//  NSLog(@"recorder didCompleteWithResult = %@", result);
}

- (void)recorder:(RKSTRecorder *)recorder didFailWithError:(NSError *)error
{
//  NSLog(@"recorder didFailWithError = %@", error);
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
        [self.recorder stop];

        if (self.delegate != nil) {
            if ([self.delegate respondsToSelector:@selector(stepViewControllerDidFinish:navigationDirection:)] == YES) {
                [self.delegate stepViewControllerDidFinish:self navigationDirection:RKSTStepViewControllerNavigationDirectionForward];
            }
        }
    }
}

#pragma  mark  -  View Controller Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self switchToWalkingPhaseView:self.walkingPhase];
    
    NSArray  *recorderConfigurations = nil;
    NSTimeInterval  countDownValue = kDefaultTimeInterval;
    if ([self.step isKindOfClass:[RKSTActiveStep class]] == YES) {
        countDownValue = [(RKSTActiveStep *)[self step] countDownInterval];
        recorderConfigurations = [(RKSTActiveStep *)[self step] recorderConfigurations];
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

    RKSTAccelerometerRecorderConfiguration  *configuration = (RKSTAccelerometerRecorderConfiguration *)(recorderConfigurations[0]);
    
    double  frequency = configuration.frequency;
    self.recorder = [[RKSTAccelerometerRecorder alloc] initWithFrequency:frequency
                                            step:self.step
                                            outputDirectory:nil];
    
    [self.recorder viewController:self willStartStepWithView:self.view];
    [self.recorder start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
