//
//  APHIntervalTappingIntorViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 9/16/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHIntervalTappingIntroViewController.h"

#import "APHIntroductionViewController.h"

static  NSString  *kViewControllerTitle = @"Interval Tapping";

static  NSString  *kIntroHeadingCaption = @"Tests for Bradykinesia";

@interface APHIntervalTappingIntroViewController  ( )

@property  (nonatomic, strong)          APCIntroductionViewController  *instructionsController;

@property  (nonatomic, weak)  IBOutlet  UILabel  *introHeadingCaption;
@property  (nonatomic, weak)  IBOutlet  UIView   *instructionsContainer;
@property (weak, nonatomic) IBOutlet UIButton *getStartedButton;

@property  (nonatomic, strong)          NSArray  *instructionalParagraphs;

@property  (nonatomic, weak)  IBOutlet  UILabel  *tapGetStarted;

@end

@implementation APHIntervalTappingIntroViewController

#pragma  mark  -  Initialisation

+ (void)initialize
{
    kIntroHeadingCaption = NSLocalizedString(@"Tests Bradykinesia", nil);
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
    
    NSArray  *introImageNames = @[ @"interval.instructions.01", @"interval.instructions.02", @"interval.instructions.03", @"interval.instructions.04" ];
    
    NSArray  *paragraphs = @[
                             @"For this task, please lay your phone on a flat surface to produce the most accurate results.",
                             @"Once you tap “Get Started”, you will have five seconds before the first interval set appears.",
                             @"Next, use two fingers on the same hand to alternately tap the buttons for 20 seconds.  Time your taps to be as consistent as possible.",
                             @"After the intervals are finished, your results will be visible on the next screen."
                             ];
    
    self.introHeadingCaption.text = kIntroHeadingCaption;
    
    self.instructionsController = [[APHIntroductionViewController alloc] initWithNibName:nil bundle:nil];
    [self.instructionsContainer addSubview:self.instructionsController.view];
    [self.instructionsController setupWithInstructionalImages:introImageNames andParagraphs:paragraphs];
    [self.getStartedButton setBackgroundImage:[UIImage imageWithColor:[UIColor appPrimaryColor]] forState:UIControlStateNormal];
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
