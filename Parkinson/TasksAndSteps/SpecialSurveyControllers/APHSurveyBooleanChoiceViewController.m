//
//  APHSurveyBooleanChoiceViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 9/24/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHSurveyBooleanChoiceViewController.h"

@interface APHSurveyBooleanChoiceViewController ()

@property  (nonatomic, weak)  IBOutlet  UIProgressView  *progressor;

@property  (nonatomic, weak)  IBOutlet  UILabel       *purposeTitle;
@property  (nonatomic, weak)  IBOutlet  UILabel       *questionCaption;

@property  (nonatomic, weak)  IBOutlet  UIButton      *negativeButton;
@property  (nonatomic, weak)  IBOutlet  UIButton      *positiveButton;

@end

@implementation APHSurveyBooleanChoiceViewController

#pragma  mark  -  Button Configuration Methods

- (void)deselectAllButtons
{
    self.negativeButton.selected = NO;
    self.positiveButton.selected = NO;
}

- (void)deselectOtherButtons:(UIButton *)sender
{
}

#pragma  mark  -  Button Action Methods

- (IBAction)choiceButtonWasTapped:(UIButton *)sender
{
    if (sender.isSelected == YES) {
        sender.selected = NO;
    } else {
        sender.selected = YES;
        if (sender == self.negativeButton) {
            self.positiveButton.selected = NO;
        } else {
            self.negativeButton.selected = NO;
        }
    }
}

#pragma  mark  -  View Controller Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    [self deselectAllButtons];
}


@end
