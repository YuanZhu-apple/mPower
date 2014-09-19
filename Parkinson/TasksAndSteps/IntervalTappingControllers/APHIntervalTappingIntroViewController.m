//
//  APHIntervalTappingIntorViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 9/16/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHIntervalTappingIntroViewController.h"

static  NSString  *kViewControllerTitle = @"Interval Tapping";

static  NSString  *kIntroHeadingCaption = @"Tests Bradykinesia";
static  NSString  *kInstructionalParagraph = @"Once you tap get started, you will have 5 seconds before the first interval set appears.";
static  NSString  *kTapGetStarted = @"Tap “Get Started” to Begin";

@interface APHIntervalTappingIntroViewController ()

@property  (nonatomic, weak)  IBOutlet  UIImageView  *instructionalImages;

@property  (nonatomic, weak)  IBOutlet  UILabel  *introHeadingCaption;
@property  (nonatomic, weak)  IBOutlet  UILabel  *instructionalParagraph;
@property  (nonatomic, weak)  IBOutlet  UILabel  *tapGetStarted;

@end

@implementation APHIntervalTappingIntroViewController

#pragma  mark  -  Initialisation

+ (void)initialize
{
    kIntroHeadingCaption = NSLocalizedString(@"Tests Bradykinesia", nil);
    kInstructionalParagraph = NSLocalizedString(@"Once you tap “Get Started”, you will have 5 seconds before the first interval set appears.", nil);
    kIntroHeadingCaption = NSLocalizedString(@"Tap “Get Started” to Begin", nil);
}

#pragma  mark  -  Button Action Methods

- (IBAction)getStartedWasTapped:(id)sender
{
    if (self.delegate != nil) {
        if ([self.delegate respondsToSelector:@selector(stepViewControllerDidFinish:navigationDirection:)] == YES) {
            [self.delegate stepViewControllerDidFinish:self navigationDirection:RKStepViewControllerNavigationDirectionForward];
        }
    }
}

#pragma  mark  -  View Controller Methods

- (void)cancelButtonTapped:(id)sender
{
    if (self.delegate != nil) {
        if ([self.delegate respondsToSelector:@selector(stepViewControllerDidCancel:)] == YES) {
            [self.delegate stepViewControllerDidCancel:self];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = kViewControllerTitle;
    
    self.introHeadingCaption.text = kIntroHeadingCaption;
    self.instructionalParagraph.text = kInstructionalParagraph;
    self.tapGetStarted.text = kIntroHeadingCaption;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = kViewControllerTitle;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped:)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.title = kViewControllerTitle;
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
