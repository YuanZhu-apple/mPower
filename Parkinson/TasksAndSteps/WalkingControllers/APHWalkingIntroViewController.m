//
//  APHIntervalTappingIntorViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 10/03/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHWalkingIntroViewController.h"
#import "APHIntroductionViewController.h"

static  NSString  *kViewControllerTitle = @"Gait Test";

static  NSString  *kIntroHeadingCaption = @"Measures Gait & Balance";

@interface APHWalkingIntroViewController  ( )

@property  (nonatomic, strong)          APCIntroductionViewController  *instructionsController;

@property  (nonatomic, weak)  IBOutlet  UILabel  *introHeadingCaption;
@property  (nonatomic, weak)  IBOutlet  UIView   *instructionsContainer;
@property (weak, nonatomic) IBOutlet UIButton *getStartedButton;


@property  (nonatomic, strong)          NSArray  *instructionalParagraphs;

@property  (nonatomic, weak)  IBOutlet  UILabel  *tapGetStarted;

@end

@implementation APHWalkingIntroViewController

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
    
    NSArray  *introImageNames = @[ @"walking.instructions.01", @"walking.instructions.02", @"walking.instructions.03", @"walking.instructions.04", @"walking.instructions.05" ];
    
    NSArray  *paragraphs = @[
                             @"Once you tap Get Started, you will have ten seconds to put this device in your pocket.  A non-swinging bag or similar location will work as well.",
                             @"After the phone vibrates, walk 20 steps in a straight line.",
                             @"After 20 steps, there will be a second vibration.  Turn around and walk 20 steps back to your starting point.",
                             @"Once you return to the starting point, you will feel a third vibration.  Stand as still as possible for 30 seconds.",
                             @"After the test is complete, your results will be analyzed and the results will be returned when ready."
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
