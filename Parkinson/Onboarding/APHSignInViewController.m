//
//  APHSignInViewController.m
//  Parkinson
//
//  Created by Karthik Keyan on 9/15/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "UIAlertView+Category.h"
#import "APCSageNetworkManager.h"
#import "UITableView+Appearance.h"
#import "APHParkinsonAppDelegate.h"
#import "APHSignInViewController.h"
#import "APCSpinnerViewController.h"

@interface APHSignInViewController ()

@end

@implementation APHSignInViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.userHandleTextField.font = [UITableView textFieldFont];
    self.userHandleTextField.textColor = [UITableView textFieldTextColor];
    
    self.passwordTextField.font = [UITableView textFieldFont];
    self.passwordTextField.textColor = [UITableView textFieldTextColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) isContentValid:(NSString **)errorMessage {
    BOOL isContentValid = YES;
    
    if (self.userHandleTextField.text.length == 0) {
        *errorMessage = NSLocalizedString(@"Please enter your user name or email", @"");
        isContentValid = NO;
    }
    else if (self.passwordTextField.text.length == 0) {
        *errorMessage = NSLocalizedString(@"Please enter your password", @"");
        isContentValid = NO;
    }
    
    return isContentValid;
}

- (void) signIn {
    NSString *errorMessage;
    if ([self isContentValid:&errorMessage]) {
        APCSpinnerViewController *spinnerController = [[APCSpinnerViewController alloc] init];
        [self presentViewController:spinnerController animated:YES completion:nil];
        
        typeof(self) __weak weakSelf = self;
        
        APCSageNetworkManager *networkManager = (APCSageNetworkManager *)[(APHParkinsonAppDelegate *)[[UIApplication sharedApplication] delegate] networkManager];
        [networkManager signIn:self.userHandleTextField.text password:self.passwordTextField.text success:^(NSURLSessionDataTask *task, id responseObject) {
            [spinnerController dismissViewControllerAnimated:YES completion:nil];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [spinnerController dismissViewControllerAnimated:YES completion:nil];
        }];
    }
    else {
        [UIAlertView showSimpleAlertWithTitle:NSLocalizedString(@"Sign In", @"") message:errorMessage];
    }
}

@end
