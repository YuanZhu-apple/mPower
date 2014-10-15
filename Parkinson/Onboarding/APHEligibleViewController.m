//
//  APHEligibleViewController.m
//  Parkinson
//
//  Created by Dhanush Balachandran on 10/15/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHEligibleViewController.h"

@interface APHEligibleViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UIButton *consentButton;


@end

@implementation APHEligibleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Eligibility", @"");
    
    [self setUpAppearance];
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"<", @"") style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backBarButton;
    
    [self.consentButton addTarget:self action:@selector(showConsent) forControlEvents:UIControlEventTouchUpInside];

}


- (void) setUpAppearance
{
    self.label1.font = [UIFont appMediumFontWithSize:17];
    self.label1.textColor = [UIColor appSecondaryColor1];
    
    self.label2.font = [UIFont appLightFontWithSize:17];
    self.label2.textColor = [UIColor appSecondaryColor1];
    
    [self.consentButton setBackgroundImage:[UIImage imageWithColor:[UIColor appPrimaryColor]] forState:UIControlStateNormal];
    [self.consentButton setTitleColor:[UIColor appSecondaryColor4] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) back
{
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

- (void) startSignUp
{
    
}

@end
