//
//  APHSignInViewController.m
//  Parkinson's
//
//  Copyright (c) 2014 <INSTITUTION-NAME-TBD>. All rights reserved.
//

#import "APHSignInViewController.h"

@interface APHSignInViewController ()

@end

@implementation APHSignInViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)forgotPassword
{
    APCForgotPasswordViewController *forgotPasswordViewController = [[UIStoryboard storyboardWithName:@"APHOnboarding" bundle:nil] instantiateViewControllerWithIdentifier:@"ForgotPasswordVC"];
    [self.navigationController pushViewController:forgotPasswordViewController animated:YES];
    
}

@end
