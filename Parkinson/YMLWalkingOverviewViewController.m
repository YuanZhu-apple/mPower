//
//  YMLWalkingOverviewViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 8/20/14.
//  Copyright (c) 2014 Henry McGilton. All rights reserved.
//

#import "YMLWalkingOverviewViewController.h"
#import "YMLWalkingStepsViewController.h"

@interface YMLWalkingOverviewViewController ()

@end

@implementation YMLWalkingOverviewViewController

#pragma  mark  -  Action Methods

- (IBAction)goToNextStep:(id)sender
{
    YMLWalkingStepsViewController  *controller = [[YMLWalkingStepsViewController alloc] initWithNibName:nil bundle:nil];
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
