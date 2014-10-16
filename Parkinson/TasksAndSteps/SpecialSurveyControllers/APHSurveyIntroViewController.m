//
//  APHSurveyIntroViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 9/23/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHSurveyIntroViewController.h"

@interface APHSurveyIntroViewController ()

@property  (nonatomic, weak)  IBOutlet  UIProgressView  *progressor;

@property  (nonatomic, weak)  IBOutlet  UILabel         *purposeTitle;
@property  (nonatomic, weak)  IBOutlet  UITextView      *purposeExplanation;

@property  (nonatomic, weak)  IBOutlet  UILabel         *durationTitle;
@property  (nonatomic, weak)  IBOutlet  UITextView      *durationExplanation;

@property  (nonatomic, weak)  IBOutlet  UIButton        *getStarted;

@end

@implementation APHSurveyIntroViewController

#pragma  mark  -  Button Action Methods

- (IBAction)getStartedWasTapped:(UIButton *)sender
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
