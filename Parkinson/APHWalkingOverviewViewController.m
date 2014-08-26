//
//  APHWalkingOverviewViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 8/20/14.
//  Copyright (c) 2014 Henry McGilton. All rights reserved.
//

#import "APHWalkingOverviewViewController.h"
#import "APHWalkingStepsViewController.h"

@interface APHWalkingOverviewViewController ()

@end

@implementation APHWalkingOverviewViewController

#pragma  mark  -  Action Methods

- (IBAction)goToNextStep:(id)sender
{
    APHWalkingStepsViewController  *controller = [[APHWalkingStepsViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
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
