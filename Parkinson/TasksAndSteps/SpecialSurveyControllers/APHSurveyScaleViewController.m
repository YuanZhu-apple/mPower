//
//  APHSurveyScaleViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 9/23/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHSurveyScaleViewController.h"

@interface APHSurveyScaleViewController ()

@property  (nonatomic, weak)  IBOutlet  UIProgressView  *progressor;

@property  (nonatomic, weak)  IBOutlet  UILabel         *purposeTitle;
@property  (nonatomic, weak)  IBOutlet  UITextView      *purposeExplanation;

@property  (nonatomic, weak)  IBOutlet  UISlider        *scaleMeasure;
@property  (nonatomic, weak)  IBOutlet  UILabel         *chooseResponseCaption;
@property  (nonatomic, weak)  IBOutlet  UILabel         *displayResponseCaption;
@property  (nonatomic, weak)  IBOutlet  UILabel         *mildCaption;
@property  (nonatomic, weak)  IBOutlet  UILabel         *severeCaption;
@property  (nonatomic, weak)  IBOutlet  UILabel         *discussion;

@end

@implementation APHSurveyScaleViewController

#pragma  mark  -  Slider Action Methods

- (IBAction)scaleMeasureDidChangeValue:(UISlider *)sender
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
