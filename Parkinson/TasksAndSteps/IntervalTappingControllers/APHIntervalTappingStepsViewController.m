//
//  APHIntervalTappingStepsViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 9/16/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHIntervalTappingStepsViewController.h"
#import "APHIntervalTappingTapView.h"

static  NSUInteger      kInitialCountDownValue =  5;
static  NSTimeInterval  kTappingTestDuration   = 20.0;
//static  NSTimeInterval  kTappingTestDuration   =  5.0;
static  NSTimeInterval  kCountDownInterval     =  1.0;

@interface APHIntervalTappingStepsViewController ()

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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch  *touche = [touches anyObject];
    
    if (touche.view == self.tapperLeft) {
        CGPoint  location = [touche locationInView:self.tapperLeft];
        if ([self doesTargetContainPoint:location inView:self.tapperLeft] == YES) {
            self.tapsCounter = self.tapsCounter + 1;
            [self formatTotalTapsCounter];
        }
    } else if (touche.view == self.tapperRight) {
        CGPoint  location = [touche locationInView:self.tapperRight];
        if ([self doesTargetContainPoint:location inView:self.tapperRight] == YES) {
            self.tapsCounter = self.tapsCounter + 1;
            [self formatTotalTapsCounter];
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
        self.countingTaps = YES;
        [self setupDisplay];
        self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:kTappingTestDuration target:self selector:@selector(tapsCountTimerDidFire:) userInfo:nil repeats:NO];
    }
}

- (void)tapsCountTimerDidFire:(NSTimer *)aTimer
{
    self.countingTaps = NO;
    [self setupDisplay];

    if (self.delegate != nil) {
        if (self.resultCollector) {
            [self.resultCollector didProduceResult:[[RKResult alloc] initWithStep:self.step] forStep:self.step];
        }
        if ([self.delegate respondsToSelector:@selector(stepViewControllerDidFinish:navigationDirection:)] == YES) {
            [self.delegate stepViewControllerDidFinish:self navigationDirection:RKStepViewControllerNavigationDirectionForward];
        }
    }
}

#pragma  mark  -  View Controller Methods

- (void)setupDisplay
{
    if (self.isCountingTaps ==YES) {
        self.countdownView.hidden = YES;
        self.countTapsView.hidden = NO;
        self.tapperLeft.enabled   = YES;
        self.tapperRight.enabled  = YES;
    } else {
        self.countdownView.hidden = NO;
        self.countTapsView.hidden = YES;
        self.tapperLeft.enabled   = NO;
        self.tapperRight.enabled  = NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupDisplay];
    
    self.counter = kInitialCountDownValue;
    [self formatCountDownCounter];
    self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:kCountDownInterval target:self selector:@selector(countdownTimerDidFire:) userInfo:nil repeats:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.backBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationItem.backBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
