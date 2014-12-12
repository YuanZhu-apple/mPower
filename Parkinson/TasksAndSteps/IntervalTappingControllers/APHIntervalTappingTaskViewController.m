// 
//  APHIntervalTappingTaskViewController.m 
//  mPower 
// 
//  Copyright (c) 2014 Apple, Inc. All rights reserved. 
// 
 
#import "APHIntervalTappingTaskViewController.h"

#import "APHIntervalTappingRecorderCustomView.h"
#import "APHIntervalTappingRecorderDataKeys.h"
#import "APHIntervalTappingTapView.h"
#import "APHRippleView.h"

#import "APHIntervalTappingRecorder.h"

static NSString *MainStudyIdentifier = @"com.parkinsons.intervalTapping";

static  NSString  *kIntervalTappingStep101        = @"IntervalTappingStep101";

static  NSString  *kIntervalTappingStep102        = @"IntervalTappingStep102";
static  CGFloat    kGetReadyStepCountdownInterval = 5.0;

static  NSString  *kIntervalTappingStep103        = @"IntervalTappingStep103";
static  CGFloat    kTappingStepCountdownInterval  = 20.0;

static  NSString  *kIntervalTappingStep104        = @"IntervalTappingStep104";

static  NSString  *kTaskViewControllerTitle = @"Tapping";

@interface APHIntervalTappingTaskViewController  ( ) <NSObject>

@property  (nonatomic, strong)  APHRippleView  *tappingTargetsContainer;

@end

@implementation APHIntervalTappingTaskViewController

#pragma  mark  -  View Controller Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBar.topItem.title = NSLocalizedString(kTaskViewControllerTitle, nil);
    
    self.stepsToAutomaticallyAdvanceOnTimer = @[ kIntervalTappingStep102, kIntervalTappingStep103 ];
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
        RKSTInstructionStep  *step = [[RKSTInstructionStep alloc] initWithIdentifier:kIntervalTappingStep101];
        step.title = @"Tapping";
        step.text = @"";
        step.detailText = @"";
        [steps addObject:step];
    }
    
    {
        RKSTActiveStep  *step = [[RKSTActiveStep alloc] initWithIdentifier:kIntervalTappingStep102];
        step.title = NSLocalizedString(@"Tapping", @"");
        step.text = NSLocalizedString(@"Get Ready!", @"");
        step.countDownInterval = kGetReadyStepCountdownInterval;
        step.shouldStartTimerAutomatically = YES;
        step.shouldSpeakCountDown = YES;
        
        [steps addObject:step];
    }
    
    {
        RKSTActiveStep  *step = [[RKSTActiveStep alloc] initWithIdentifier:kIntervalTappingStep103];
        step.title = @"Button Tap";
        step.text = @"";
        step.countDownInterval = kTappingStepCountdownInterval;
        step.shouldStartTimerAutomatically = YES;
        step.recorderConfigurations = @[[APHIntervalTappingRecorderConfiguration new]];
        [steps addObject:step];
    }
    
    {
        RKSTInstructionStep  *step = [[RKSTInstructionStep alloc] initWithIdentifier:kIntervalTappingStep104];
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

/*********************************************************************************/
#pragma mark - Bar Button Action Methods
/*********************************************************************************/

- (void)cancelButtonWasTapped:(id)sender
{
    if ([self respondsToSelector:@selector(taskViewControllerDidCancel:)] == YES) {
        [self taskViewControllerDidCancel:self];
    }
}

#pragma  mark  -  Task View Controller Delegate Methods

- (void)taskViewController:(RKSTTaskViewController *)taskViewController stepViewControllerWillAppear:(RKSTStepViewController *)stepViewController
{
    if (kIntervalTappingStep102 == stepViewController.step.identifier) {
        stepViewController.continueButton = nil;
    } else if (kIntervalTappingStep104 == stepViewController.step.identifier) {
        stepViewController.continueButton = nil;
    }
    stepViewController.skipButton     = nil;
    stepViewController.continueButton = nil;
    
    if (([stepViewController.step.identifier isEqualToString:kIntervalTappingStep102] == YES) ||
        ([stepViewController.step.identifier isEqualToString:kIntervalTappingStep103] == YES)) {
        
        UIBarButtonItem  *cancellor = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonWasTapped:)];
        stepViewController.cancelButton = cancellor;
    }
    [super taskViewController:taskViewController stepViewControllerWillAppear:stepViewController];
}

- (RKSTStepViewController *)taskViewController:(RKSTTaskViewController *)taskViewController viewControllerForStep:(RKSTStep *)step
{
    APCStepViewController  *controller = nil;
    
    if ([step.identifier isEqualToString:kIntervalTappingStep101]) {
        controller = (APCInstructionStepViewController*) [[UIStoryboard storyboardWithName:@"APCInstructionStep" bundle:[NSBundle appleCoreBundle]] instantiateInitialViewController];
        APCInstructionStepViewController  *instController = (APCInstructionStepViewController*)controller;
        instController.imagesArray = @[ @"interval.instructions.01", @"interval.instructions.02", @"interval.instructions.03", @"interval.instructions.04" ];
        instController.headingsArray = @[ @"Tapping Task", @"Tapping Task", @"Tapping Task", @"Tapping Task" ];
        instController.messagesArray  = @[
                                          @"Please lay your phone on a flat surface when tapping for best results.",
                                          @"Once you tap “Get Started” below, you will have 5 seconds before the task begins.",
                                          @"Use 2 fingers on the same hand to alternately tap the left and right circles on the screen as quickly and as evenly as possible for 20 seconds.",
                                          @"After the intervals are finished, your results will be visible on the next screen."
                                          ];
        controller.delegate = self;
        controller.step = step;
    } else {
        NSDictionary  *controllers = @{
                                       kIntervalTappingStep104 : [APCSimpleTaskSummaryViewController    class]
                                      };
        Class  aClass = [controllers objectForKey:step.identifier];
        NSBundle  *bundle = nil;
        if ([step.identifier isEqualToString:kIntervalTappingStep104] == YES) {
            bundle = [NSBundle appleCoreBundle];
        }
        controller = [[aClass alloc] initWithNibName:nil bundle:bundle];
        controller.delegate = self;
        controller.title = @"Interval Tapping";
        controller.step = step;
    }
    return controller;
}

- (NSString *)createResultSummary
{
    RKSTResult  *aStepResult = [self.result resultForIdentifier:kIntervalTappingStep103];
    NSArray  *stepResults = nil;
    if ([aStepResult isKindOfClass:[RKSTStepResult class]] == YES) {
        stepResults = [(RKSTStepResult *)aStepResult results];
    }
    NSString  *contentString = @"";
    if (stepResults != nil) {
        RKSTResult  *aDataResult = [stepResults firstObject];
        if ([aDataResult isKindOfClass:[RKSTDataResult class]] == YES) {
            NSData  *data = [(RKSTDataResult *)aDataResult data];
            
            NSError  *error = nil;
            NSDictionary  *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSArray  *records = [dictionary objectForKey:kIntervalTappingRecordsKey];
            
            NSDictionary  *summary = @{ kSummaryNumberOfRecordsKey : @([records count]) };
            NSError  *serializationError = nil;
            NSData  *summaryData = [NSJSONSerialization dataWithJSONObject:summary options:0 error:&serializationError];
            
            contentString = [[NSString alloc] initWithData:summaryData encoding:NSUTF8StringEncoding];
        }
    }
    return contentString;
}

/*********************************************************************************/
#pragma  mark  - TaskViewController delegates
/*********************************************************************************/

- (void)taskViewControllerDidComplete:(RKSTTaskViewController *)taskViewController
{
    [super taskViewControllerDidComplete:taskViewController];
}

@end
