//
//  APHWalkingResultsViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 8/20/14.
//  Copyright (c) 2014 Henry McGilton. All rights reserved.
//

#import "APHWalkingResultsViewController.h"

@interface APHWalkingResultsViewController ()

@end

@implementation APHWalkingResultsViewController

#pragma  mark  -  Action Methods

- (IBAction)goBackToOverview:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma  mark  -  View Controller Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self.taskViewController;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
