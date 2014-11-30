//
//  APHEligibleViewController.m
//  Parkinson's
//
//  Copyright (c) 2014 <INSTITUTION-NAME-TBD>. All rights reserved.
//

#import "APHEligibleViewController.h"
#import "APHSignUpGeneralInfoViewController.h"

@interface APHEligibleViewController ()


@end

@implementation APHEligibleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Eligibility", @"");

}

- (void) startSignUp
{
    APHSignUpGeneralInfoViewController *signUpVC = [[UIStoryboard storyboardWithName:@"APHOnboarding" bundle:nil] instantiateViewControllerWithIdentifier:@"SignUpGeneralInfoVC"];
    [self.navigationController pushViewController:signUpVC animated:YES];
}

- (IBAction)startConsentTapped:(id)sender
{
#if DEVELOPMENT
    if (YES) {
#else
        if (((APCAppDelegate*)[UIApplication sharedApplication].delegate).dataSubstrate.parameters.hideConsent) {
#endif
        [self startSignUp];
    } else {
        [self showConsent];
    }
}

@end
