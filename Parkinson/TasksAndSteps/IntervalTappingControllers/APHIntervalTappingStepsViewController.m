//
//  APHIntervalTappingStepsViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 9/16/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHIntervalTappingStepsViewController.h"
#import "APHIntervalTappingRecorder.h"
#import "APHIntervalTappingTargetContainer.h"
#import "APHIntervalTappingTapView.h"

typedef  enum  _CountingTapsState
{
    CountingTapsStateIsNotCounting,
    CountingTapsStateIsCounting
} CountingTapsState;

static  NSUInteger      kInitialCountDownValue =  5;
static  NSTimeInterval  kTappingTestDuration   = 20.0;
//static  NSTimeInterval  kTappingTestDuration   =  5.0;
static  NSTimeInterval  kCountDownInterval     =  1.0;
    //
    //    The '16' values below must change in synch
    //
static  CGFloat         kStepsCountMultiplier  =  16.0;
static  NSTimeInterval  kCountTapsInterval     =  1.0 / 16.0;

static  NSString  *kFileNameForResults   = @"tapTheButton.json";
static  NSString  *kMimeTypeForResults   = @"application/json";

@interface APHIntervalTappingStepsViewController  ( )  <APHIntervalTappingRecorderDelegate>

@property  (nonatomic, weak)            APCStepProgressBar          *progressor;

@property  (nonatomic, weak)  IBOutlet  UIView                      *countdownView;
@property  (nonatomic, weak)  IBOutlet  UILabel                     *countdownLabel;

@property  (nonatomic, weak)  IBOutlet  UIView                      *countTapsView;
@property  (nonatomic, weak)  IBOutlet  UILabel                     *numberOfTapsLabel;

@property  (nonatomic, weak)  IBOutlet  APHIntervalTappingTargetContainer  *tapperContainer;
@property  (nonatomic, weak)          IBOutlet  APHIntervalTappingTapView  *tapperLeft;
@property  (nonatomic, weak)          IBOutlet  APHIntervalTappingTapView  *tapperRight;

@property  (nonatomic, strong)          NSTimer                     *countdownTimer;
@property  (nonatomic, assign)          NSUInteger                   counter;
@property  (nonatomic, assign)          NSUInteger                   tapsCounter;

@property  (nonatomic, strong)          APHIntervalTappingRecorder  *recorder;

@end

@implementation APHIntervalTappingStepsViewController

#pragma  mark  -  Format Test Taps Counter

- (void)formatTotalTapsCounter:(NSUInteger)tapCount
{
    NSString  *totalTaps = [NSString stringWithFormat:@"%lu", (unsigned long)(tapCount)];
    self.numberOfTapsLabel.text = totalTaps;
}

#pragma  mark  -  Tap Recorder Delegate Method

- (void)recorder:(APHIntervalTappingRecorder *)recorder didRecordTap:(NSNumber *)tapCount
{
    [self formatTotalTapsCounter:[tapCount unsignedIntegerValue]];
}

#pragma  mark  -  Format Initial Countdown Counter

- (void)formatCountDownCounter
{
    NSString  *countdown = [NSString stringWithFormat:@"%lu", (unsigned long)(self.counter)];
    self.countdownLabel.text = countdown;
}

- (void)countdownTimerDidFire:(NSTimer *)aTimer
{
    self.counter = self.counter - 1;
    [self formatCountDownCounter];
    if (self.counter == 0) {
        [self.countdownTimer invalidate];
        self.countdownTimer = nil;
        
        [self setupDisplay:CountingTapsStateIsCounting];
        
        self.tapperContainer.tapperLeft = self.tapperLeft;
        self.tapperContainer.tapperRight = self.tapperRight;
        [self.recorder viewController:self willStartStepWithView:self.tapperContainer];
        
        NSError  *error = nil;
        BOOL  startedSuccessfully = [self.recorder start:&error];
        
        if (startedSuccessfully == YES) {
            self.counter = 0;
            self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:kCountTapsInterval target:self selector:@selector(tapsCountTimerDidFire:) userInfo:nil repeats:YES];
        } else {
            NSLog(@"Failed to Start APHIntervalTappingRecorder");
        }
    }
}

- (void)sendNextStepDelegateMessage:(id)object
{
    if ([self.delegate respondsToSelector:@selector(stepViewControllerDidFinish:navigationDirection:)] == YES) {
        [self.delegate stepViewControllerDidFinish:self navigationDirection:RKStepViewControllerNavigationDirectionForward];
    }
}

- (void)tapsCountTimerDidFire:(NSTimer *)aTimer
{
    self.counter = self.counter + 1;
    if (self.counter < self.progressor.numberOfSteps) {
        [self.progressor setCompletedSteps:self.counter animation:NO];
    } else {
        [self.countdownTimer invalidate];
        self.countdownTimer = nil;

        [self setupDisplay:CountingTapsStateIsNotCounting];
        
        NSError  *error = nil;
        BOOL  stoppedSuccessfully = [self.recorder stop:&error];
        
        if (stoppedSuccessfully == YES) {
            if (self.delegate != nil) {
                [self performSelector:@selector(sendNextStepDelegateMessage:) withObject:nil afterDelay:1.0];
            }
        } else {
            NSLog(@"Failed to Stop APHIntervalTappingRecorder and Save Results");
        }
    }
}

#pragma  mark  -  View Controller Methods

- (void)setupDisplay:(CountingTapsState)countingTaps
{
    if (countingTaps == CountingTapsStateIsCounting) {
        self.progressor.numberOfSteps = (NSUInteger)kTappingTestDuration * kStepsCountMultiplier;
        [self.progressor setCompletedSteps:0 animation:NO];
        
        self.countdownView.hidden = self.tapperLeft.enabled = self.tapperRight.enabled = YES;
        
        self.countTapsView.alpha = self.tapperContainer.alpha = 0.0;
        self.progressor.hidden = self.countTapsView.hidden = NO;
        
        [UIView animateWithDuration:1.0 animations:^{
            self.countTapsView.alpha = self.tapperContainer.alpha = 1.0;
        }];
    } else {
        self.progressor.hidden = self.countTapsView.hidden = YES;
        self.countdownView.hidden = self.tapperLeft.enabled = self.tapperRight.enabled = NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat  topPosition = self.topLayoutGuide.length;
    CGRect  frame = CGRectMake(0.0, topPosition, CGRectGetWidth(self.view.frame), 5.0);
    APCStepProgressBar  *bar = [[APCStepProgressBar alloc] initWithFrame:frame style:APCStepProgressBarStyleDefault];
    bar.numberOfSteps = (NSUInteger)kTappingTestDuration * kStepsCountMultiplier;
    [self.view addSubview:bar];
    self.progressor = bar;
    
    [self setupDisplay:CountingTapsStateIsNotCounting];
    
    RKActiveStep  *step = (RKActiveStep *)self.step;
    APHIntervalTappingRecorderConfiguration  *configuration = step.recorderConfigurations[0];
    self.recorder = (APHIntervalTappingRecorder *)[configuration recorderForStep:self.step taskInstanceUUID:self.taskViewController.taskInstanceUUID];
    self.recorder.tappingDelegate = self;
    
    self.counter = kInitialCountDownValue;
    [self formatCountDownCounter];
    self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:kCountDownInterval target:self selector:@selector(countdownTimerDidFire:) userInfo:nil repeats:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.navigationItem.backBarButtonItem  = nil;
    self.navigationItem.leftBarButtonItem  = nil;
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    self.navigationItem.backBarButtonItem  = nil;
    self.navigationItem.leftBarButtonItem  = nil;
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
