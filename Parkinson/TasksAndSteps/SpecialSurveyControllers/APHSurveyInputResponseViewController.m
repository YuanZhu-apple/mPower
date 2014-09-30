//
//  APHSurveyInputResponseViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 9/24/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHSurveyInputResponseViewController.h"

@interface APHSurveyInputResponseViewController ( )  <UITextFieldDelegate>

@property  (nonatomic, weak)  IBOutlet  UIProgressView  *progressor;

@property  (nonatomic, weak)  IBOutlet  UILabel       *purposeTitle;
@property  (nonatomic, weak)  IBOutlet  UILabel       *questionCaption;

@property  (nonatomic, weak)  IBOutlet  UITextField   *textInputField;

@end

@implementation APHSurveyInputResponseViewController

#pragma  mark  -  Text Field Delegate Methods

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
