//
//  APHPhonationIntroViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 10/03/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHPhonationIntroViewController.h"
#import "APHIntroductionViewController.h"

static  NSString  *kViewControllerTitle = @"Sustained Phonation";

static  NSString  *kIntroHeadingCaption = @"Tests for Speech Difficulties";

@interface APHPhonationIntroViewController  ( )

@property  (nonatomic, strong)          APCIntroductionViewController  *instructionsController;

@property  (nonatomic, weak)  IBOutlet  UILabel  *introHeadingCaption;
@property  (nonatomic, weak)  IBOutlet  UIView   *instructionsContainer;
@property (weak, nonatomic) IBOutlet UIButton *getStartedButton;


@property  (nonatomic, strong)          NSArray   *instructionalParagraphs;

@property  (nonatomic, weak)  IBOutlet  UILabel   *tapGetStarted;

@end

@implementation APHPhonationIntroViewController

#pragma  mark  -  Initialisation

+ (void)initialize
{
    kIntroHeadingCaption = NSLocalizedString(kIntroHeadingCaption, nil);
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
    
    NSArray  *introImageNames = @[ @"phonation.instructions.01", @"phonation.instructions.02", @"phonation.instructions.03", @"phonation.instructions.04", @"phonation.instructions.05" ];
    
    NSArray  *paragraphs = @[
                             @"Once you tap Get Started, you will have five seconds until this test begins tracking your vocal patterns.",
                             @"Continue by saying “Aaah” into the microphone on your device for as long as you are able.",
                             @"As you speak, keep a continuous steady vocal volume so the outermost ring remains green.",
                             @"You will be prompted to adjust your vocal volume if it is too quiet or too loud.",
                             @"After the test is finished, your results will be analyzed and available on the dashboard.  You will be notified when analysis is ready."
                             ];
    
    self.introHeadingCaption.text = kIntroHeadingCaption;
    
    self.instructionsController = [[APHIntroductionViewController alloc] initWithNibName:nil bundle:nil];
    [self.instructionsContainer addSubview:self.instructionsController.view];
    [self.instructionsController setupWithInstructionalImages:introImageNames andParagraphs:paragraphs];
    [self.getStartedButton setBackgroundColor:[UIColor appPrimaryColor]];
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
