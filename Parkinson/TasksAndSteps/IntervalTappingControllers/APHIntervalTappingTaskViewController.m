//
//  APHIntervalTappingTaskViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 9/3/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHIntervalTappingTaskViewController.h"

#import "APHIntervalTappingIntroViewController.h"
#import "APHIntervalTappingStepsViewController.h"
#import "APHCommonTaskSummaryViewController.h"

#import "APHIntervalTappingRecorder.h"

static NSString *MainStudyIdentifier = @"com.parkinsons.intervalTapping";

static  NSString  *kIntervalTappingStep101 = @"IntervalTappingStep101";
static  NSString  *kIntervalTappingStep102 = @"IntervalTappingStep102";
static  NSString  *kIntervalTappingStep103 = @"IntervalTappingStep103";

static  NSString  *kTaskViewControllerTitle = @"Interval Tapping";

static float tapInterval = 20.0;

@interface APHIntervalTappingTaskViewController  ( ) <NSObject>

@property (strong, nonatomic) RKSTDataArchive *taskArchive;

@end

@implementation APHIntervalTappingTaskViewController

#pragma  mark  -  View Controller Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBar.topItem.title = NSLocalizedString(kTaskViewControllerTitle, nil);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

#pragma  mark  -  Task Creation Methods

+ (RKSTOrderedTask *)createTask:(APCScheduledTask *)scheduledTask
{
    NSMutableArray *steps = [[NSMutableArray alloc] init];
    
    {
        RKSTInstructionStep *step = [[RKSTInstructionStep alloc] initWithIdentifier:kIntervalTappingStep101];
        step.title = @"Tests Bradykinesia";
        step.text = @"";
        step.detailText = @"";
        [steps addObject:step];
    }
    
    {
        RKSTActiveStep* step = [[RKSTActiveStep alloc] initWithIdentifier:kIntervalTappingStep102];
        step.title = @"Button Tap";
        step.text = @"";
        step.countDownInterval = tapInterval;
        step.recorderConfigurations = @[[APHIntervalTappingRecorderConfiguration new]];
        [steps addObject:step];
    }
    
    {
        RKSTInstructionStep* step = [[RKSTInstructionStep alloc] initWithIdentifier:kIntervalTappingStep103];
        step.title = @"You're finished.";
        step.text = @"";
        step.detailText = @"";
        [steps addObject:step];
    }

    RKSTOrderedTask  *task = [[RKSTOrderedTask alloc] initWithIdentifier:@"Tapping Task" steps:steps];
    
    return  task;
}

#pragma  mark  -  Navigation Bar Button Action Methods

- (void)cancelButtonTapped:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{ } ];
}

- (void)doneButtonTapped:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{ } ];
}

#pragma  mark  -  Task View Controller Delegate Methods

- (BOOL)taskViewController:(RKSTTaskViewController *)taskViewController shouldPresentStepViewController:(RKSTStepViewController *)stepViewController
{
    return  YES;
}

- (void)taskViewController:(RKSTTaskViewController *)taskViewController willPresentStepViewController:(RKSTStepViewController *)stepViewController
{
    if (kIntervalTappingStep102 == stepViewController.step.identifier)
    {
        stepViewController.continueButton = nil;
    } else if (kIntervalTappingStep103 == stepViewController.step.identifier)
    {
        stepViewController.continueButton = [[UIBarButtonItem alloc] initWithTitle:@"Well done!" style:stepViewController.continueButton.style target:stepViewController.continueButton.target action:stepViewController.continueButton.action];
        stepViewController.continueButton = nil;
    }
}

- (RKSTStepViewController *)taskViewController:(RKSTTaskViewController *)taskViewController viewControllerForStep:(RKSTStep *)step
{
    NSDictionary  *controllers = @{
                                   kIntervalTappingStep101 : [APHIntervalTappingIntroViewController   class],
                                   kIntervalTappingStep103 : [APHCommonTaskSummaryViewController class]
                                  };
    
    Class  aClass = [controllers objectForKey:step.identifier];
    APCStepViewController  *controller = [[aClass alloc] initWithNibName:nil bundle:nil];
    controller.delegate = self;
    controller.title = @"Interval Tapping";
    controller.step = step;
    
    return controller;
}



/*********************************************************************************/
#pragma  mark  - TaskViewController delegates
/*********************************************************************************/

- (void)taskViewControllerDidFail: (RKSTTaskViewController *)taskViewController withError:(NSError*)error{
    NSLog(@"taskViewControllerDidFail %@", error);

    [self.taskArchive resetContent];
    self.taskArchive = nil;
    
}

/*********************************************************************************/
#pragma mark - StepViewController Delegate Methods
/*********************************************************************************/

- (void)stepViewControllerWillBePresented:(RKSTStepViewController *)viewController
{
    viewController.skipButton = nil;
    viewController.continueButton = nil;
}

- (void)stepViewControllerDidFinish:(RKSTStepViewController *)stepViewController navigationDirection:(RKSTStepViewControllerNavigationDirection)direction
{
    [super stepViewControllerDidFinish:stepViewController navigationDirection:direction];
    
    stepViewController.continueButton = nil;
}

@end
