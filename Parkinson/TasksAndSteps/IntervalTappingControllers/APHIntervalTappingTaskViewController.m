//
//  APHIntervalTappingTaskViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 9/3/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHIntervalTappingTaskViewController.h"
@import APCAppleCore;

#import "APHIntervalTappingIntroViewController.h"
#import "APHIntervalTappingStepsViewController.h"
#import "APHIntervalTappingResultsViewController.h"

#import "APHIntervalTappingRecorder.h"

static  NSString  *kIntervalTappingStep101 = @"IntervalTappingStep101";
static  NSString  *kIntervalTappingStep102 = @"IntervalTappingStep102";
static  NSString  *kIntervalTappingStep103 = @"IntervalTappingStep103";

static float tapInterval = 20.0;

@interface APHIntervalTappingTaskViewController  ( ) <NSObject, RKResultCollector>

@end

@implementation APHIntervalTappingTaskViewController

#pragma  mark  -  Initialisation

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.showsProgressInNavigationBar = NO;
    self.navigationItem.title = @"Interval Tapping";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationItem.title = @"Interval Tapping";
}

+ (RKTask *)createTask:(APCScheduledTask *)scheduledTask
{
    NSMutableArray *steps = [[NSMutableArray alloc] init];
    
    {
        RKIntroductionStep *step = [[RKIntroductionStep alloc] initWithIdentifier:kIntervalTappingStep101 name:@"Tap Intro"];
        step.caption = @"Tests Bradykinesia";
        step.explanation = @"";
        step.instruction = @"";
        [steps addObject:step];
    }
    
    {
        RKActiveStep* step = [[RKActiveStep alloc] initWithIdentifier:kIntervalTappingStep102 name:@"active step"];
        step.caption = @"Button Tap";
        step.text = @"";
        step.countDown = tapInterval;
        step.recorderConfigurations = @[[APHIntervalTappingRecorderConfiguration new]];
        [steps addObject:step];
    }
    
    {
        RKIntroductionStep* step = [[RKIntroductionStep alloc] initWithIdentifier:kIntervalTappingStep103 name:@"Tap Results"];
        step.caption = @"Button Tap";
        step.explanation = @"";
        step.instruction = @"";
        [steps addObject:step];
    }

    RKTask  *task = [[RKTask alloc] initWithName:@"Interval Touches" identifier:@"Tapping Task" steps:steps];
    
    return  task;
}

#pragma  mark  -  Navigation Bar Button Action Methods

- (void)cancelButtonTapped:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{ } ];
}

- (void)doneButtonTapped:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{ } ];
}

#pragma  mark  -  Task View Controller Delegate Methods

- (BOOL)taskViewController:(RKTaskViewController *)taskViewController shouldPresentStepViewController:(RKStepViewController *)stepViewController
{
    return  YES;
}

- (void)taskViewController:(RKTaskViewController *)taskViewController willPresentStepViewController:(RKStepViewController *)stepViewController
{
    stepViewController.cancelButton = nil;
    stepViewController.backButton = nil;
}

- (RKStepViewController *)taskViewController:(RKTaskViewController *)taskViewController viewControllerForStep:(RKStep *)step
{
    NSDictionary  *controllers = @{
                                   kIntervalTappingStep101 : [APHIntervalTappingIntroViewController   class],
                                   kIntervalTappingStep102 : [APHIntervalTappingStepsViewController   class],
                                   kIntervalTappingStep103 : [APHIntervalTappingResultsViewController class]
                                  };
    Class  aClass = [controllers objectForKey:step.identifier];
    APCStepViewController  *controller = [[aClass alloc] initWithNibName:nil bundle:nil];
    controller.resultCollector = self;
    controller.delegate = self;
    controller.title = @"Interval Tapping";
    controller.continueButtonOnToolbar = NO;
    controller.step = step;
    return  controller;
}

@end
