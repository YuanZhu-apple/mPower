//
//  YMLStepViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 8/22/14.
//  Copyright (c) 2014 Henry McGilton. All rights reserved.
//

#import "YMLStepViewController.h"

@interface YMLStepViewController ()

@end

@implementation YMLStepViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem  *item = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:nil action:NULL];
    [self.navigationItem setLeftBarButtonItem:item];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
