//
//  SignUpGeneralInfoViewController.m
//  OnBoarding
//
//  Created by Karthik Keyan on 9/2/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APCProfile.h"
#import "APHUserInfoCell.h"
#import "UIView+Category.h"
#import "APCTableViewItem.h"
#import "NSString+Category.h"
#import "NSBundle+Category.h"
#import "APCHealthKitProxy.h"
#import "APCStepProgressBar.h"
#import "APCUserInfoConstants.h"
#import "UIAlertView+Category.h"
#import "UITableView+Appearance.h"
#import "APHSignUpGeneralInfoViewController.h"
#import "APHSignUpMedicalInfoViewController.h"


@interface APHSignUpGeneralInfoViewController ()

@property (nonatomic, strong) APCHealthKitProxy *healthKitProxy;

@end

@implementation APHSignUpGeneralInfoViewController


#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.profile = [APCProfile new];
        self.itemsOrder = [NSMutableArray new];
        
        [self prepareFields];
    }
    return self;
}

- (void) prepareFields {
    NSMutableArray *items = [NSMutableArray new];
    NSMutableArray *itemsOrder = [NSMutableArray new];
    
    {
        APCTableViewTextFieldItem *field = [APCTableViewTextFieldItem new];
        field.style = UITableViewCellStyleValue1;
        field.caption = NSLocalizedString(@"Username", @"");
        field.placeholder = NSLocalizedString(@"Add Username", @"");
        field.value = self.profile.userName;
        field.keyboardType = UIKeyboardTypeDefault;
        field.regularExpression = kAPCGeneralInfoItemUserNameRegEx;
        field.identifier = NSStringFromClass([APCTableViewTextFieldItem class]);
        
        [items addObject:field];
        [itemsOrder addObject:@(APCSignUpUserInfoItemUserName)];
    }
    
    {
        APCTableViewTextFieldItem *field = [APCTableViewTextFieldItem new];
        field.style = UITableViewCellStyleValue1;
        field.caption = NSLocalizedString(@"Password", @"");
        field.placeholder = NSLocalizedString(@"Add Password", @"");
        field.value = self.profile.password;
        field.secure = YES;
        field.keyboardType = UIKeyboardTypeDefault;
        field.identifier = NSStringFromClass([APCTableViewTextFieldItem class]);
        
        [items addObject:field];
        
        [itemsOrder addObject:@(APCSignUpUserInfoItemPassword)];
    }
    
    {
        APCTableViewTextFieldItem *field = [APCTableViewTextFieldItem new];
        field.style = UITableViewCellStyleValue1;
        field.caption = NSLocalizedString(@"Email", @"");
        field.placeholder = NSLocalizedString(@"Add Email Address", @"");
        field.value = self.profile.email;
        field.keyboardType = UIKeyboardTypeEmailAddress;
        field.identifier = NSStringFromClass([APCTableViewTextFieldItem class]);
        
        [items addObject:field];
        
        [itemsOrder addObject:@(APCSignUpUserInfoItemEmail)];
    }
    
    {
        APCTableViewDatePickerItem *field = [APCTableViewDatePickerItem new];
        field.style = UITableViewCellStyleValue1;
        field.selectionStyle = UITableViewCellSelectionStyleGray;
        field.caption = NSLocalizedString(@"Birthdate", @"");
        field.placeholder = NSLocalizedString(@"MMMM DD, YYYY", @"");
        field.date = self.profile.dateOfBirth;
        field.identifier = NSStringFromClass([APCTableViewDatePickerItem class]);
        
        [items addObject:field];
        
        [itemsOrder addObject:@(APCSignUpUserInfoItemDateOfBirth)];
    }
    
    {
        APCTableViewSegmentItem *field = [APCTableViewSegmentItem new];
        field.style = UITableViewCellStyleValue1;
        field.segments = [APCProfile sexTypesInStringValue];
        field.selectedIndex = [APCProfile stringIndexFromSexType:self.profile.gender];
        field.identifier = NSStringFromClass([APCTableViewSegmentItem class]);
        
        [items addObject:field];
        
        [itemsOrder addObject:@(APCSignUpUserInfoItemGender)];
    }
    
    
    self.items = items;
    self.itemsOrder = itemsOrder;
}


#pragma mark - View Life Cycle

- (void) viewDidLoad {
    [super viewDidLoad];
    
    [self addNavigationItems];
    [self addHeaderView];
    [self addFooterView];
    [self setupProgressBar];
    [self loadHealthKitValues];
}


#pragma mark - UI Methods

- (void) addNavigationItems {
    self.title = NSLocalizedString(@"General Information", @"");
    
    UIBarButtonItem *nextBarButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Next", @"") style:UIBarButtonItemStylePlain target:self action:@selector(validateContent)];
    self.navigationItem.rightBarButtonItem = nextBarButton;
}

- (void) setupProgressBar {
    self.stepProgressBar.rightLabel.text = NSLocalizedString(@"Mandatory", @"");
}

- (void) addHeaderView {
    [super addHeaderView];
    
    [self.profileImageButton setImage:[UIImage imageNamed:@"img_user_placeholder"] forState:UIControlStateNormal];
}

- (void) addFooterView {
    UILabel *label = [UILabel new];
    label.frame = CGRectMake(0, 0, self.tableView.width, 44);
    label.font = [UITableView footerFont];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UITableView footerTextColor];
    label.text = NSLocalizedString(@"All fields on this screen are required.", @"");
    self.tableView.tableFooterView = label;
}


#pragma mark - Public Methods

- (Class) cellClass {
    return [APHUserInfoCell class];
}


#pragma mark - Private Methods

- (void) loadHealthKitValues {
    typeof(self) __weak weakSelf = self;
    [self.healthKitProxy authenticate:^(BOOL granted, NSError *error) {
        if (granted) {
            [weakSelf loadBiologicalInfo];
            [weakSelf loadHeight];
            [weakSelf loadWidth];
        }
    }];
}

- (void) loadHeight {
    typeof(self) __weak weakSelf = self;
    [self.healthKitProxy latestHeight:^(HKQuantity *quantity, NSError *error) {
        if (!error) {
            weakSelf.profile.height = [NSString stringWithFormat:@"%f", [quantity doubleValueForUnit:[HKUnit unitFromLengthFormatterUnit:NSLengthFormatterUnitInch]]];
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void) loadWidth {
    typeof(self) __weak weakSelf = self;
    
    [self.healthKitProxy latestHeight:^(HKQuantity *quantity, NSError *error) {
        if (!error) {
            weakSelf.profile.weight = @([quantity doubleValueForUnit:[HKUnit unitFromMassFormatterUnit:NSMassFormatterUnitKilogram]]);
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void) loadBiologicalInfo {
    [self.healthKitProxy fillBiologicalInfo:self.profile];
    [self.tableView reloadData];
}

- (BOOL) isContentValid:(NSString **)errorMessage {
    BOOL isContentValid = [super isContentValid:errorMessage];
    
    // If super returned false then we dont need to check any content further unnecessary,
    // because if any one of the content is invalid then we are immediatly returing false
    if (isContentValid) {
        for (int i = 0; i < self.itemsOrder.count; i++) {
            NSNumber *order = self.itemsOrder[i];
            
            APCTableViewItem *item = self.items[i];
            
            switch (order.integerValue) {
                case APCSignUpUserInfoItemUserName:
                    isContentValid = [[(APCTableViewTextFieldItem *)item value] isValidForRegex:kAPCGeneralInfoItemUserNameRegEx];
                    *errorMessage = NSLocalizedString(@"Please give a valid Username", @"");
                    break;
                    
                case APCSignUpUserInfoItemPassword:
                    if ([[(APCTableViewTextFieldItem *)item value] length] == 0) {
                        *errorMessage = NSLocalizedString(@"Please give a valid Password", @"");
                        isContentValid = NO;
                    }
                    else if ([[(APCTableViewTextFieldItem *)item value] length] < 6) {
                        *errorMessage = NSLocalizedString(@"Password should be at least 6 characters", @"");
                        isContentValid = NO;
                    }
                    break;
                    
                case APCSignUpUserInfoItemEmail:
                    isContentValid = [[(APCTableViewTextFieldItem *)item value] isValidForRegex:kAPCGeneralInfoItemEmailRegEx];
                    *errorMessage = NSLocalizedString(@"Please give a valid Email", @"");
                    break;
                    
                case APCSignUpUserInfoItemDateOfBirth:
                    isContentValid = ([(APCTableViewDatePickerItem *)item date] != nil);
                    *errorMessage = NSLocalizedString(@"Please give your Date of Birth", @"");
                    break;
                    
                default:
#warning ASSERT_MESSAGE Require
                    NSAssert(order.integerValue <= APCSignUpUserInfoItemWakeUpTime, @"ASSER_MESSAGE");
                    break;
            }
            
            // If any of the content is not valid the break the for loop
            // We doing this 'break' here because we cannot break a for loop inside switch-statements (switch already have break statement)
            if (!isContentValid) {
                break;
            }
        }
    }
    
    return isContentValid;
}

- (void) loadProfileValuesInModel {
    for (int i = 0; i < self.itemsOrder.count; i++) {
        NSNumber *order = self.itemsOrder[i];
        
        APCTableViewItem *item = self.items[i];
        
        switch (order.integerValue) {
            case APCSignUpUserInfoItemUserName:
                self.profile.userName = [(APCTableViewTextFieldItem *)item value];
                break;
                
            case APCSignUpUserInfoItemPassword:
                self.profile.password = [(APCTableViewTextFieldItem *)item value];
                break;
                
            case APCSignUpUserInfoItemEmail:
                self.profile.email = [(APCTableViewTextFieldItem *)item value];
                break;
                
            case APCSignUpUserInfoItemDateOfBirth:
                self.profile.dateOfBirth = [(APCTableViewDatePickerItem *)item date];
                break;
                
            case APCSignUpUserInfoItemGender:
                self.profile.gender = [APCProfile sexTypeFromStringValue:[APCProfile sexTypesInStringValue][[(APCTableViewSegmentItem *)item selectedIndex]]];
                break;
                
            default:
#warning ASSERT_MESSAGE Require
                NSAssert(NO, @"ASSER_MESSAGE");
                break;
        }
    }
}

- (void) validateContent {
    [self.tableView endEditing:YES];
    
    NSString *message;
    if ([self isContentValid:&message]) {
        [self loadProfileValuesInModel];
        [self next];
    }
    else {
        [UIAlertView showSimpleAlertWithTitle:NSLocalizedString(@"General Information", @"") message:message];
    }
}

- (void) next {
    APHSignUpMedicalInfoViewController *medicalInfoViewController = [APHSignUpMedicalInfoViewController new];
    medicalInfoViewController.profile = self.profile;
    
    [self.navigationController pushViewController:medicalInfoViewController animated:YES];
}

@end
