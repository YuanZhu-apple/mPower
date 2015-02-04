//
//  APHSpatialSpanMemoryGameViewController.m
//  mPower
//
//  Copyright (c) 2014–2015 Apple, Inc. All rights reserved.
//

#import "APHSpatialSpanMemoryGameViewController.h"

static  NSString       *kTaskViewControllerTitle      = @"Memory Activity";

static  NSString       *kMemorySpanTitle              = @"Tapping Activity";

static  NSString       *kConclusionStepIdentifier     = @"conclusion";

static  NSInteger       kInitialSpan                  =  3;
static  NSInteger       kMinimumSpan                  =  2;
static  NSInteger       kMaximumSpan                  =  15;
static  NSTimeInterval  kPlaySpeed                    = 1.0;
static  NSInteger       kMaximumTests                 = 5;
static  NSInteger       kMaxConsecutiveFailures       =  3;
static  NSString       *kCustomTargetPluralName       = nil;
static  BOOL            kRequiresReversal             = NO;

@interface APHSpatialSpanMemoryGameViewController ()

@end

@implementation APHSpatialSpanMemoryGameViewController

#pragma  mark  -  Task Creation Methods

+ (RKSTOrderedTask *)createTask:(APCScheduledTask *)scheduledTask
{
        RKSTOrderedTask  *task = [RKSTOrderedTask spatialSpanMemoryTaskWithIdentifier:kMemorySpanTitle
            intendedUseDescription:nil
            initialSpan:kInitialSpan
            minimumSpan:kMinimumSpan
            maximumSpan:kMaximumSpan
            playSpeed:kPlaySpeed
            maxTests:kMaximumTests
            maxConsecutiveFailures:kMaxConsecutiveFailures
            customTargetImage:nil
            customTargetPluralName:kCustomTargetPluralName
            requireReversal:kRequiresReversal
            options:RKPredefinedTaskOptionNone];
    
    [[UIView appearance] setTintColor:[UIColor appPrimaryColor]];
    
    return  task;
}

#pragma  mark  -  Task View Controller Delegate Methods

- (void)taskViewController:(RKSTTaskViewController *)taskViewController stepViewControllerWillAppear:(RKSTStepViewController *)stepViewController {
    
    if ([stepViewController.step.identifier isEqualToString:kConclusionStepIdentifier]) {
        [[UIView appearance] setTintColor:[UIColor appTertiaryColor1]];
    }
}

- (void)taskViewControllerDidComplete:(RKSTTaskViewController *)taskViewController
{
    [[UIView appearance] setTintColor:[UIColor appPrimaryColor]];
    
    [super taskViewControllerDidComplete:taskViewController];
    
}

- (void)taskViewControllerDidCancel:(RKSTTaskViewController *)taskViewController
{
    [[UIView appearance] setTintColor:[UIColor appPrimaryColor]];
    
    [super taskViewControllerDidCancel:taskViewController];
}

#pragma  mark  -  View Controller Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBar.topItem.title = NSLocalizedString(kTaskViewControllerTitle, nil);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
