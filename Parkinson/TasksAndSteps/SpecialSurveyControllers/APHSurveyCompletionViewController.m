//
//  APHSurveyCompletionViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 9/24/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHSurveyCompletionViewController.h"
@import APCAppleCore;


@interface APHSurveyCompletionViewController ()

@property  (nonatomic, weak)  IBOutlet  APCCircularProgressView  *progressor;
@property  (nonatomic, weak)  IBOutlet  APCConfirmationView      *confirmer;

@end

@implementation APHSurveyCompletionViewController

#pragma  mark  -  View Controller Methods

- (void)doneButtonTapped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(stepViewControllerDidFinish:navigationDirection:)] == YES) {
        [self.delegate stepViewControllerDidFinish:self navigationDirection:RKStepViewControllerNavigationDirectionForward];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.progressor.progress = 0.25;
    self.confirmer.completed = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.backBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped:)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationItem.backBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
