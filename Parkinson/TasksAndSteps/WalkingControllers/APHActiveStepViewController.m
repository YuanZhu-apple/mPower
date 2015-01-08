//
//  APHActiveStepViewController.m
//  Parkinson
//
//  Created by Dhanush Balachandran on 1/8/15.
//  Copyright (c) 2015 Apple, Inc. All rights reserved.
//

#import "APHActiveStepViewController.h"
@import APCAppCore;

@interface APHActiveStepViewController ()

@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic) NSInteger timeCount;

@end

@implementation APHActiveStepViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    APCLogViewControllerAppeared();
    APCLogDebug(@"%@ Step Appeared", self.step);
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                      target:self
                                                    selector:@selector(targetMethod:)
                                                    userInfo:nil
                                                     repeats:YES];
}

- (void) targetMethod: (NSTimer*) timer
{
    self.timeCount++;
    APCLogDebug(@"I am alive for %@ secs : IS FINISHED : %@", @(self.timeCount), @(self.isFinished));
    if (self.isFinished) {
        [self.delegate stepViewControllerDidFinish:self navigationDirection:RKSTStepViewControllerNavigationDirectionForward];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.timer invalidate];
}

@end
