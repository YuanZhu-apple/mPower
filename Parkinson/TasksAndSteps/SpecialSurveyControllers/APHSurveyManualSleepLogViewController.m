//
//  APHSurveyManualSleepLogViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 9/25/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHSurveyManualSleepLogViewController.h"

@interface APHSurveyManualSleepLogViewController ()

@property  (nonatomic, weak)  IBOutlet  UIProgressView  *progressor;

@property  (nonatomic, weak)  IBOutlet  UILabel         *purposeTitle;
@property  (nonatomic, weak)  IBOutlet  UITextView      *purposeExplanation;

@end

@implementation APHSurveyManualSleepLogViewController

#pragma  mark  -  Gesture Recogniser Action Methods

- (IBAction)hoursTapperWasTapped:(UITapGestureRecognizer *)sender
{
}

- (IBAction)wakingsTapperWasTapped:(UITapGestureRecognizer *)sender
{
}

#pragma  mark  -  View Controller Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
