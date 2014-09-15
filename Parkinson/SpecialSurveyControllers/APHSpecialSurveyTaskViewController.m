//
//  APHSpecialSurveyTaskViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 9/15/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHSpecialSurveyTaskViewController.h"

@interface APHSpecialSurveyTaskViewController ()

@end

@implementation APHSpecialSurveyTaskViewController

#pragma  mark  -  View Controller Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma  mark  -  Task View Controller Delegate Methods

- (BOOL)taskViewController:(RKTaskViewController *)taskViewController shouldShowMoreInfoOnStep:(RKStep *)step
{
    return  NO;
}

- (BOOL)taskViewController:(RKTaskViewController *)taskViewController shouldPresentStep:(RKStep*)step
{
    return  YES;
}

- (void)taskViewController:(RKTaskViewController *)taskViewController willPresentStepViewController:(RKStepViewController *)stepViewController
{
    //    stepViewController.continueButtonOnToolbar = NO;
}

- (void)taskViewController:(RKTaskViewController *)taskViewController didReceiveLearnMoreEventFromStepViewController:(RKStepViewController *)stepViewController
{
}


@end
