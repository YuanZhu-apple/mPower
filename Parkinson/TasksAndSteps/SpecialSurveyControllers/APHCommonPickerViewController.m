//
//  APHCommonPickerViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 9/25/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHCommonPickerViewController.h"

@interface APHCommonPickerViewController  ( )  <UIPickerViewDataSource, UIPickerViewDelegate>

@property  (nonatomic, weak)  IBOutlet  UIPickerView     *pickerel;
@property  (nonatomic, weak)  IBOutlet  UIBarButtonItem  *cancelButton;
@property  (nonatomic, weak)  IBOutlet  UIBarButtonItem  *doneButton;

@end

@implementation APHCommonPickerViewController

#pragma  mark  -  Tool Bar Action Methods

- (IBAction)cancelButtonTapped:(UIBarButtonItem *)sender
{
}

- (IBAction)doneButtonTapped:(UIBarButtonItem *)sender
{
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

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return  @"";
}

#pragma  mark  -  Picker View Delegate Methods

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
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
