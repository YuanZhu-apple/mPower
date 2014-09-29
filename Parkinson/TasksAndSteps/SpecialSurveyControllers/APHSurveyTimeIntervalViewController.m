//
//  APHSurveyTimeIntervalViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 9/24/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHSurveyTimeIntervalViewController.h"

@interface APHSurveyTimeIntervalViewController  ( )

@property  (nonatomic, weak)  IBOutlet  UIProgressView  *progressor;

@property  (nonatomic, weak)  IBOutlet  UILabel       *purposeTitle;
@property  (nonatomic, weak)  IBOutlet  UILabel       *questionCaption;

@property  (nonatomic, weak)  IBOutlet  UILabel       *selectDateCaption;

@property  (nonatomic, weak)  IBOutlet  UIDatePicker  *dateSelector;

@end

@implementation APHSurveyTimeIntervalViewController

#pragma  mark  -  Date Picker Action Methods

- (IBAction)datePickerSelectedDate:(UIDatePicker *)sender
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
