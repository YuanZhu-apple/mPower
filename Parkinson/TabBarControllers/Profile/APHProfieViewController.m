//
//  APHProfieViewController.m
//  Parkinson
//
//  Created by Ramsundar Shandilya on 10/10/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHProfieViewController.h"

@interface APHProfieViewController ()

@end

@implementation APHProfieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self prepareFields];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareFields
{
    self.items = [NSMutableArray new];
    self.itemTypeOrder = [NSMutableArray new];
    
    {
        APCTableViewItem *field = [APCTableViewItem new];
        field.caption = NSLocalizedString(@"Email", @"");
        field.identifier = kAPCDefaultTableViewCellIdentifier;
        field.editable = NO;
        field.textAlignnment = NSTextAlignmentRight;
        field.detailText = self.user.email;
        [self.items addObject:field];
        [self.itemTypeOrder addObject:@(APCSignUpUserInfoItemEmail)];
    }
    
    {
        APCTableViewItem *field = [APCTableViewItem new];
        field.caption = NSLocalizedString(@"Birthdate", @"");
        field.identifier = kAPCDefaultTableViewCellIdentifier;
        field.editable = NO;
        field.textAlignnment = NSTextAlignmentRight;
        field.detailText = [self.user.birthDate toStringWithFormat:NSDateDefaultDateFormat];
        [self.items addObject:field];
        [self.itemTypeOrder addObject:@(APCSignUpUserInfoItemDateOfBirth)];
    }
    
    {
        APCTableViewItem *field = [APCTableViewItem new];
        field.caption = NSLocalizedString(@"Biological Sex", @"");
        field.identifier = kAPCDefaultTableViewCellIdentifier;
        field.editable = NO;
        field.textAlignnment = NSTextAlignmentRight;
        field.detailText = [APCUser stringValueFromSexType:self.user.biologicalSex];
        [self.items addObject:field];
        [self.itemTypeOrder addObject:@(APCSignUpUserInfoItemGender)];
    }
    
    {
        APCTableViewCustomPickerItem *field = [APCTableViewCustomPickerItem new];
        field.caption = NSLocalizedString(@"Medical Conditions", @"");
        field.pickerData = @[[APCUser medicalConditions]];
        field.textAlignnment = NSTextAlignmentRight;
        field.identifier = kAPCDefaultTableViewCellIdentifier;
        
        if (self.user.medications) {
            field.selectedRowIndices = @[ @([field.pickerData[0] indexOfObject:self.user.medicalConditions]) ];
        }
        else {
            field.selectedRowIndices = @[ @(0) ];
        }
        
        [self.items addObject:field];
        [self.itemTypeOrder addObject:@(APCSignUpUserInfoItemMedicalCondition)];
    }
    
    {
        APCTableViewCustomPickerItem *field = [APCTableViewCustomPickerItem new];
        field.caption = NSLocalizedString(@"Medication", @"");
        field.pickerData = @[[APCUser medications]];
        field.textAlignnment = NSTextAlignmentRight;
        field.identifier = kAPCDefaultTableViewCellIdentifier;
        
        if (self.user.medications) {
            field.selectedRowIndices = @[ @([field.pickerData[0] indexOfObject:self.user.medications]) ];
        }
        else {
            field.selectedRowIndices = @[ @(0) ];
        }
        
        [self.items addObject:field];
        [self.itemTypeOrder addObject:@(APCSignUpUserInfoItemMedication)];
    }
    
    {
        APCTableViewCustomPickerItem *field = [APCTableViewCustomPickerItem new];
        field.caption = NSLocalizedString(@"Height", @"");
        field.pickerData = [APCUser heights];
        field.textAlignnment = NSTextAlignmentRight;
        field.identifier = kAPCDefaultTableViewCellIdentifier;
        
        if (self.user.height) {
            double heightInInches = [APCUser heightInInches:self.user.height];
            NSString *feet = [NSString stringWithFormat:@"%d'", (int)heightInInches/12];
            NSString *inches = [NSString stringWithFormat:@"%d''", (int)heightInInches%12];
            
            field.selectedRowIndices = @[ @([field.pickerData[0] indexOfObject:feet]), @([field.pickerData[1] indexOfObject:inches]) ];
        }
        else {
            field.selectedRowIndices = @[ @(2), @(5) ];
        }
        
        [self.items addObject:field];
        [self.itemTypeOrder addObject:@(APCSignUpUserInfoItemHeight)];
    }
    
    {
        APCTableViewTextFieldItem *field = [APCTableViewTextFieldItem new];
        field.caption = NSLocalizedString(@"Weight", @"");
        field.placeholder = NSLocalizedString(@"lb", @"");
        field.regularExpression = kAPCMedicalInfoItemWeightRegEx;
        field.value = [NSString stringWithFormat:@"%.1f", [APCUser weightInPounds:self.user.weight]];
        field.keyboardType = UIKeyboardTypeDecimalPad;
        field.textAlignnment = NSTextAlignmentRight;
        field.identifier = kAPCTextFieldTableViewCellIdentifier;
        
        [self.items addObject:field];
        [self.itemTypeOrder addObject:@(APCSignUpUserInfoItemWeight)];
    }
    
    {
        APCTableViewDatePickerItem *field = [APCTableViewDatePickerItem new];
        field.selectionStyle = UITableViewCellSelectionStyleGray;
        field.style = UITableViewCellStyleValue1;
        field.caption = NSLocalizedString(@"What time do you wake up?", @"");
        field.placeholder = NSLocalizedString(@"7:00 AM", @"");
        field.identifier = kAPCDefaultTableViewCellIdentifier;
        field.datePickerMode = UIDatePickerModeTime;
        field.dateFormat = kAPCMedicalInfoItemSleepTimeFormat;
        field.textAlignnment = NSTextAlignmentRight;
        field.detailDiscloserStyle = YES;
        
        if (self.user.sleepTime) {
            field.date = self.user.sleepTime;
            field.detailText = [field.date toStringWithFormat:kAPCMedicalInfoItemSleepTimeFormat];
        }
        
        [self.items addObject:field];
        [self.itemTypeOrder addObject:@(APCSignUpUserInfoItemWakeUpTime)];
    }
    
    {
        APCTableViewDatePickerItem *field = [APCTableViewDatePickerItem new];
        field.selectionStyle = UITableViewCellSelectionStyleGray;
        field.style = UITableViewCellStyleValue1;
        field.caption = NSLocalizedString(@"What time do you go to sleep?", @"");
        field.placeholder = NSLocalizedString(@"9:30 PM", @"");
        field.identifier = kAPCDefaultTableViewCellIdentifier;
        field.datePickerMode = UIDatePickerModeTime;
        field.dateFormat = kAPCMedicalInfoItemSleepTimeFormat;
        field.textAlignnment = NSTextAlignmentRight;
        field.detailDiscloserStyle = YES;
        
        if (self.user.wakeUpTime) {
            field.date = self.user.wakeUpTime;
            field.detailText = [field.date toStringWithFormat:kAPCMedicalInfoItemSleepTimeFormat];
        }
        
        [self.items addObject:field];
        [self.itemTypeOrder addObject:@(APCSignUpUserInfoItemSleepTime)];
    }
    
}



@end
