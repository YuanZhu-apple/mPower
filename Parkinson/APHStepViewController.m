//
//  APHStepViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 8/22/14.
//  Copyright (c) 2014 Henry McGilton. All rights reserved.
//

#import "APHStepViewController.h"

@interface APHStepViewController ()

@end

@implementation APHStepViewController

#pragma  mark  -  Action Methods

- (void)goBackToPreviousStep:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma  mark  -  View Controller Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem  *item = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(goBackToPreviousStep:)];
    [self.navigationItem setLeftBarButtonItem:item];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
