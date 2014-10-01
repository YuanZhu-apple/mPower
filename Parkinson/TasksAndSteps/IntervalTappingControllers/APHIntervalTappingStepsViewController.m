//
//  APHIntervalTappingStepsViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 9/16/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHIntervalTappingStepsViewController.h"
#import "APHIntervalTappingRecorder.h"
#import "APHIntervalTappingTapView.h"

static  NSUInteger      kInitialCountDownValue =  5;
static  NSTimeInterval  kTappingTestDuration   = 20.0;
//static  NSTimeInterval  kTappingTestDuration   =  5.0;
static  NSTimeInterval  kCountDownInterval     =  1.0;
    //
    //    The '16' values below must change in synch
    //
static  CGFloat         kStepsCountMultiplier  =  16;
static  NSTimeInterval  kCountTapsInterval     =  1.0 / 16.0;

static  NSString  *kLeftTargetRecordKey  = @"LeftTarget";
static  NSString  *kRightTargetRecordKey = @"RightTarget";
static  NSString  *kXCoordinateRecordKey = @"XCoordinate";
static  NSString  *kYCoordinateRecordKey = @"YCoordinate";
static  NSString  *kYTimeStampRecordKey  = @"TimeStamp";

static  NSString  *kFileNameForResults   = @"tapTheButton.json";
static  NSString  *kMimeTypeForResults   = @"application/json";

@interface APHIntervalTappingStepsViewController ()

@property  (nonatomic, weak)            APCStepProgressBar         *progressor;

@property  (nonatomic, weak)  IBOutlet  UIView                     *countdownView;
@property  (nonatomic, weak)  IBOutlet  UILabel                    *countdownLabel;

@property  (nonatomic, weak)  IBOutlet  UIView                     *countTapsView;
@property  (nonatomic, weak)  IBOutlet  UILabel                    *numberOfTapsLabel;

@property  (nonatomic, weak)  IBOutlet  APHIntervalTappingTapView  *tapperLeft;
@property  (nonatomic, weak)  IBOutlet  APHIntervalTappingTapView  *tapperRight;

@property  (nonatomic, strong)          NSTimer                    *countdownTimer;
@property  (nonatomic, assign, getter = isCountingTaps)  BOOL       countingTaps;
@property  (nonatomic, assign)          NSUInteger                  counter;
@property  (nonatomic, assign)          NSUInteger                  tapsCounter;

@property  (nonatomic, strong)          NSMutableArray             *records;
@property  (nonatomic, strong)          APHIntervalTappingRecorder *recorder;

@end

@implementation APHIntervalTappingStepsViewController

#pragma  mark  -  Gesture Recogniser Methods

- (void)formatTotalTapsCounter
{
    NSString  *totalTaps = [NSString stringWithFormat:@"%lu", (unsigned long)(self.tapsCounter)];
    self.numberOfTapsLabel.text = totalTaps;
}

- (BOOL)doesTargetContainPoint:(CGPoint)point inView:(UIView *)view
{
    BOOL  answer = YES;
    
    CGFloat  dx = point.x - CGRectGetMidX(view.bounds);
    CGFloat  dy = point.y - CGRectGetMidY(view.bounds);
    CGFloat  h = hypot(dx, dy);
    if (h > CGRectGetWidth(view.bounds) / 2.0) {
        answer = NO;
    }
    return  answer;
}

- (void)addRecord:(UITouch *)touche withEvent:(UIEvent *)event
{
    
    CGPoint  point = [touche locationInView:touche.view];
    
    NSDictionary  *record = @{ ((touche.view == self.tapperLeft) ? kLeftTargetRecordKey: kRightTargetRecordKey): touche.view,
                               kYTimeStampRecordKey : @(event.timestamp),
                               kXCoordinateRecordKey : @(point.x),
                               kYCoordinateRecordKey : @(point.y)
                            };
    [self.records addObject:record];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch  *touche = [touches anyObject];
    
    if (touche.view == self.tapperLeft) {
        CGPoint  location = [touche locationInView:self.tapperLeft];
        if ([self doesTargetContainPoint:location inView:self.tapperLeft] == YES) {
            self.tapsCounter = self.tapsCounter + 1;
            [self formatTotalTapsCounter];
            
            [self addRecord:touche withEvent:event];
        }
    } else if (touche.view == self.tapperRight) {
        CGPoint  location = [touche locationInView:self.tapperRight];
        if ([self doesTargetContainPoint:location inView:self.tapperRight] == YES) {
            self.tapsCounter = self.tapsCounter + 1;
            [self formatTotalTapsCounter];
            
            [self addRecord:touche withEvent:event];
        }
    }
}

#pragma  mark  -  Timer Action Method

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
        self.countingTaps = YES;
        [self setupDisplay];
        
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

- (void)tapsCountTimerDidFire:(NSTimer *)aTimer
{
    self.counter = self.counter + 1;
    if (self.counter < self.progressor.numberOfSteps) {
        [self.progressor setCompletedSteps:self.counter animation:YES];
    } else {
        [self.countdownTimer invalidate];
        self.countdownTimer = nil;
        self.countingTaps = NO;
        [self setupDisplay];
        
        self.recorder.records = self.records;
        NSError  *error = nil;
        BOOL  stoppedSuccessfully = [self.recorder stop:&error];
        
        if (stoppedSuccessfully == YES) {
            if (self.delegate != nil) {
                if ([self.delegate respondsToSelector:@selector(stepViewControllerDidFinish:navigationDirection:)] == YES) {
                    [self.delegate stepViewControllerDidFinish:self navigationDirection:RKStepViewControllerNavigationDirectionForward];
                }
            }
        } else {
            NSLog(@"Failed to Stop APHIntervalTappingRecorder and Save Results");
        }
    }
}

#pragma  mark  -  View Controller Methods

- (void)setupDisplay
{
    if (self.isCountingTaps == YES) {
        self.progressor.numberOfSteps = (NSUInteger)kTappingTestDuration * kStepsCountMultiplier;
        [self.progressor setCompletedSteps:0 animation:NO];
        self.progressor.hidden = NO;
        self.countdownView.hidden = YES;
        self.countTapsView.hidden = NO;
        self.tapperLeft.enabled   = YES;
        self.tapperRight.enabled  = YES;
    } else {
        self.progressor.hidden = YES;
        self.countdownView.hidden = NO;
        self.countTapsView.hidden = YES;
        self.tapperLeft.enabled   = NO;
        self.tapperRight.enabled  = NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    {
        CGFloat  topPosition = self.topLayoutGuide.length;
        CGRect  frame = CGRectMake(0.0, topPosition, self.view.frame.size.width, 5.0);
        APCStepProgressBar  *bar = [[APCStepProgressBar alloc] initWithFrame:frame style:APCStepProgressBarStyleDefault];
        [self.view addSubview:bar];
        self.progressor = bar;
    }
    
    [self setupDisplay];
    
    self.records = [NSMutableArray array];
    RKActiveStep  *step = (RKActiveStep *)self.step;
    APHIntervalTappingRecorderConfiguration  *configuration = step.recorderConfigurations[0];
    self.recorder = (APHIntervalTappingRecorder *)[configuration recorderForStep:self.step taskInstanceUUID:self.taskViewController.taskInstanceUUID];
    
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
