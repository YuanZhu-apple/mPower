//
//  APHSurveySingleChoiceViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 9/23/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHSurveySingleChoiceViewController.h"

@interface APHSurveySingleChoiceViewController  ( )  <UIPickerViewDataSource, UIPickerViewDelegate>

@property  (nonatomic, weak)  IBOutlet  UIProgressView  *progressor;

@property  (nonatomic, weak)  IBOutlet  UILabel       *purposeTitle;
@property  (nonatomic, weak)  IBOutlet  UILabel       *chooseAnswerCaptions;

@property  (nonatomic, weak)  IBOutlet  UIView        *optionsContainer;
@property  (nonatomic, weak)      IBOutlet  UIButton       *optionOneChoice;
@property  (nonatomic, weak)      IBOutlet  UIButton       *optionTwoChoice;
@property  (nonatomic, weak)      IBOutlet  UIButton       *optionThreeChoice;
@property  (nonatomic, strong)              NSArray        *optionChoices;

@property  (nonatomic, weak)  IBOutlet  UIPickerView  *picker;

@end

@implementation APHSurveySingleChoiceViewController

#pragma  mark  -  Button Configuration Methods

- (void)deselectAllButtons
{
    for (UIButton *button  in  self.optionChoices) {
        button.selected = NO;
    }
}

- (void)deselectOtherButtons:(UIButton *)sender
{
    for (UIButton *button  in  self.optionChoices) {
        if (button != sender) {
            button.selected = NO;
        }
    }
}

#pragma  mark  -  Button Action Methods

- (IBAction)choiceButtonWasTapped:(UIButton *)sender
{
    if (sender.isSelected == YES) {
        sender.selected = NO;
    } else {
        sender.selected = YES;
        [self deselectOtherButtons:sender];
    }
}

#pragma  mark  -  Picker View Data Source Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return  1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return  1;
}

#pragma  mark  -  Picker View Delegate Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return  @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
}

#pragma  mark  -  View Controller Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.optionChoices = @[ _optionOneChoice, _optionTwoChoice, _optionThreeChoice ];
    
    [self deselectAllButtons];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
