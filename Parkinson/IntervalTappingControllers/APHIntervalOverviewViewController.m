//
//  APHIntervalOverviewViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 8/21/14.
//  Copyright (c) 2014 Henry McGilton. All rights reserved.
//

#import "APHIntervalOverviewViewController.h"

@interface APHIntervalOverviewViewController ()

@property  (nonatomic, weak)  IBOutlet  UIProgressView  *progessor;
@property  (nonatomic, weak)  IBOutlet  UILabel         *tapster;

@end

@implementation APHIntervalOverviewViewController

#pragma  mark  -  Action Methods

- (IBAction)informationButtonTapped:(id)sender
{
}

#pragma  mark  -  View Controller Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CALayer  *layer = self.tapster.layer;
    layer.borderWidth = 1.0;
    layer.borderColor = [[UIColor lightGrayColor] CGColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
