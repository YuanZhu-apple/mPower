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
#import "APCHealthKitProxy.h"
#import "APCStepProgressBar.h"
#import "UITableView+Appearance.h"
#import "APHSignUpGeneralInfoViewController.h"
#import "APHSignUpMedicalInfoViewController.h"


// Regular Expressions
static NSString * const kAPCUserInfoFieldUserNameRegEx          = @"[A-Za-z0-9_.]+";
static NSString * const kAPCUserInfoFieldEmailRegEx             = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";


@interface APHSignUpGeneralInfoViewController ()

@property (nonatomic, strong) APCHealthKitProxy *healthKitProxy;

@property (nonatomic, readwrite) NSMutableArray *itemsOrder;

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
    
    {
        APCTableViewTextFieldItem *field = [APCTableViewTextFieldItem new];
        field.style = UITableViewCellStyleValue1;
        field.caption = NSLocalizedString(@"Username", @"");
        field.placeholder = NSLocalizedString(@"Add Username", @"");
        field.value = nil;
        field.keyboardType = UIKeyboardTypeDefault;
        field.regularExpression = kAPCUserInfoFieldUserNameRegEx;
        field.identifier = NSStringFromClass([APCTableViewTextFieldItem class]);
        
        [items addObject:field];
        [self.itemsOrder addObject:@(APCSignUpUserInfoItemUserName)];
    }
    
    {
        APCTableViewTextFieldItem *field = [APCTableViewTextFieldItem new];
        field.style = UITableViewCellStyleValue1;
        field.caption = NSLocalizedString(@"Password", @"");
        field.placeholder = NSLocalizedString(@"Add Password", @"");
        field.value = nil;
        field.secure = YES;
        field.keyboardType = UIKeyboardTypeDefault;
        field.identifier = NSStringFromClass([APCTableViewTextFieldItem class]);
        
        [items addObject:field];
        
        [self.itemsOrder addObject:@(APCSignUpUserInfoItemPassword)];
    }
    
    {
        APCTableViewTextFieldItem *field = [APCTableViewTextFieldItem new];
        field.style = UITableViewCellStyleValue1;
        field.caption = NSLocalizedString(@"Email", @"");
        field.placeholder = NSLocalizedString(@"Add Email Address", @"");
        field.value = nil;
        field.keyboardType = UIKeyboardTypeEmailAddress;
        field.identifier = NSStringFromClass([APCTableViewTextFieldItem class]);
        
        [items addObject:field];
        
        [self.itemsOrder addObject:@(APCSignUpUserInfoItemEmail)];
    }
    
    {
        APCTableViewDatePickerItem *field = [APCTableViewDatePickerItem new];
        field.style = UITableViewCellStyleValue1;
        field.caption = NSLocalizedString(@"Birthdate", @"");
        field.placeholder = NSLocalizedString(@"MMMM DD, YYYY", @"");
        field.date = nil;
        field.identifier = NSStringFromClass([APCTableViewDatePickerItem class]);
        
        [items addObject:field];
        
        [self.itemsOrder addObject:@(APCSignUpUserInfoItemDateOfBirth)];
    }
    
    {
        APCTableViewSegmentItem *field = [APCTableViewSegmentItem new];
        field.style = UITableViewCellStyleValue1;
        field.segments = @[ NSLocalizedString(@"Male", @""), NSLocalizedString(@"Female", @""), NSLocalizedString(@"Other", @"") ];
        field.selectedIndex = 0;
        field.identifier = NSStringFromClass([APCTableViewSegmentItem class]);
        
        [items addObject:field];
        
        [self.itemsOrder addObject:@(APCSignUpUserInfoItemGender)];
    }
    
    self.items = items;
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
    UIView *headerView = [[UINib nibWithNibName:@"APCUserInfoTableHeaderView" bundle:nil] instantiateWithOwner:self options:nil][0];
    self.tableView.tableHeaderView = headerView;
    
    CGRect frame = self.headerTextFieldSeparatorView.frame;
    frame.size.height = 1;
    
    self.headerTextFieldSeparatorView.clipsToBounds = YES;
    self.headerTextFieldSeparatorView.frame = frame;
    self.headerTextFieldSeparatorView.backgroundColor = self.tableView.separatorColor;
    
    self.profileImageButton.layer.cornerRadius = self.profileImageButton.frame.size.width/2;
    
    self.firstNameTextField.font = [UITableView textFieldFont];
    self.firstNameTextField.textColor = [UITableView textFieldTextColor];
    
    self.lastNameTextField.font = [UITableView textFieldFont];
    self.lastNameTextField.textColor = [UITableView textFieldTextColor];
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
    return YES;
}

- (void) validateContent {
    NSString *message;
    if ([self isContentValid:&message]) {
        [self next];
    }
}

- (void) next {
    APHSignUpMedicalInfoViewController *medicalInfoViewController = [APHSignUpMedicalInfoViewController new];
    medicalInfoViewController.profile = self.profile;
    
    [self.navigationController pushViewController:medicalInfoViewController animated:YES];
}

@end
