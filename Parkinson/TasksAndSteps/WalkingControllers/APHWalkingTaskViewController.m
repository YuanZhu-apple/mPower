//
//  APHWalkingTaskViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 9/3/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHWalkingTaskViewController.h"

#import "APHWalkingIntroViewController.h"
#import "APHWalkingStepsViewController.h"
#import "APHCommonTaskSummaryViewController.h"

#import <objc/message.h>

static NSString *MainStudyIdentifier = @"com.parkinsons.walkingTask";

static  NSString       *kWalkingStep101Key               = @"Walking Step 101";

static  NSString       *kGetReadyStep                    = @"Get Ready";
static  NSTimeInterval  kGetReadyCountDownInterval       = 5.0;

static  NSString       *kWalkingStep102Key               = @"Walking Step 102";
static  NSTimeInterval  kWalkingStep102CountDownInterval = 30.0;

static  NSString       *kWalkingStep103Key               = @"Walking Step 103";
static  NSTimeInterval  kWalkingStep103CountDownInterval = 30.0;

static  NSString       *kWalkingStep104Key               = @"Walking Step 104";
static  NSTimeInterval  kWalkingStep104CountDownInterval = 30.0;

static  NSString       *kWalkingStep105Key               = @"Walking Step 105";

static  NSString  *kTaskViewControllerTitle = @"Timed Walking";

@interface APHWalkingTaskViewController  ( )
{
    NSInteger _count;
}

@property (strong, nonatomic) RKSTDataArchive *taskArchive;

@end

@implementation APHWalkingTaskViewController

#pragma  mark  -  Initialisation

+ (RKSTOrderedTask *)createTask: (APCScheduledTask*) scheduledTask
{
    NSMutableArray  *steps = [NSMutableArray array];
    
    {
        RKSTActiveStep* step = [[RKSTActiveStep alloc] initWithIdentifier:kWalkingStep101Key];
        step.title = NSLocalizedString(@"Measures Gait and Balance", @"");
        step.text = NSLocalizedString(@"You have 10 seconds to put this device in your pocket."
        @"After the phone vibrates, follow the instructions to begin.", @"");
        step.shouldPlaySoundOnStart = YES;
        step.shouldVibrateOnStart = YES;
        [steps addObject:step];
    }
    
    {
        //Introduction to fitness test
        RKSTActiveStep* step = [[RKSTActiveStep alloc] initWithIdentifier:kGetReadyStep];
        step.title = NSLocalizedString(@"Timed Walking", @"");
        step.text = NSLocalizedString(@"Get Ready!", @"");
        step.countDownInterval = kGetReadyCountDownInterval;
        step.shouldStartTimerAutomatically = YES;
        step.shouldUseNextAsSkipButton = NO;
        step.shouldPlaySoundOnStart = YES;
        step.shouldSpeakCountDown = YES;
        
        [steps addObject:step];
    }
    
    {
        RKSTActiveStep* step = [[RKSTActiveStep alloc] initWithIdentifier:kWalkingStep102Key];
        step.title = NSLocalizedString(@"Walk out 20 Steps", @"");
        step.text = NSLocalizedString(@"Now please walk out 20 steps.", @"");
        step.spokenInstruction = step.text;
        step.shouldPlaySoundOnStart = YES;
        step.shouldVibrateOnStart = YES;
        step.countDownInterval = kWalkingStep102CountDownInterval;
        step.shouldStartTimerAutomatically = YES;
        step.recorderConfigurations = @[ [[RKSTAccelerometerRecorderConfiguration alloc] initWithFrequency:100.0]];
        [steps addObject:step];
    }
    {
        RKSTActiveStep* step = [[RKSTActiveStep alloc] initWithIdentifier:kWalkingStep103Key];
        step.title = NSLocalizedString(@"Turn around and walk back", @"");
        step.text = NSLocalizedString(@"Now please turn 180 degrees, and walk back to your starting point.", @"");
        step.spokenInstruction = step.text;
        step.shouldPlaySoundOnStart = YES;
        step.shouldVibrateOnStart = YES;
        step.countDownInterval = kWalkingStep103CountDownInterval;
        step.shouldStartTimerAutomatically = YES;
        step.recorderConfigurations = @[ [[RKSTAccelerometerRecorderConfiguration alloc] initWithFrequency:100.0]];
        [steps addObject:step];
    }
    {
        RKSTActiveStep* step = [[RKSTActiveStep alloc] initWithIdentifier:kWalkingStep104Key];
        step.title = NSLocalizedString(@"Standing Still", @"");
        step.text = NSLocalizedString(@"Now please stand still for 30 seconds.", @"");
        step.spokenInstruction = step.text;
        step.shouldPlaySoundOnStart = YES;
        step.shouldVibrateOnStart = YES;
        step.countDownInterval = kWalkingStep104CountDownInterval;
        step.shouldStartTimerAutomatically = YES;
        step.recorderConfigurations = @[ [[RKSTAccelerometerRecorderConfiguration alloc] initWithFrequency:100.0]];
        [steps addObject:step];
    }
    {
        RKSTActiveStep* step = [[RKSTActiveStep alloc] initWithIdentifier:kWalkingStep105Key];
        step.title = NSLocalizedString(@"Great Job!", @"");
        step.text = NSLocalizedString(@"Your gait symptoms seem to appear mild."
                    @"Insert easy to understand meaning of this interpretation here.", @"");
        step.shouldPlaySoundOnStart = YES;
        step.shouldVibrateOnStart = YES;

        [steps addObject:step];
    }
    
    RKSTOrderedTask  *task = [[RKSTOrderedTask alloc] initWithIdentifier:@"Timed Walking Task" steps:steps];
    
    return  task;
}

- (instancetype)initWithTask:(id<RKSTTask>)task taskRunUUID:(NSUUID *)taskRunUUID
{
    self = [super initWithTask:task taskRunUUID:taskRunUUID];
    if (self) {
        _count = 0;
    }
    return self;
}

#pragma  mark  -  Task View Controller Delegate Methods
- (BOOL)taskViewController:(RKSTTaskViewController *)taskViewController shouldShowMoreInfoOnStep:(RKSTStep *)step
{
    return  NO;
}

- (BOOL)taskViewController:(RKSTTaskViewController *)taskViewController shouldPresentStep:(RKSTStep*)step
{
    return  YES;
}

- (void)taskViewController:(RKSTTaskViewController *)taskViewController willPresentStepViewController:(RKSTStepViewController *)stepViewController
{
    if (kWalkingStep101Key == stepViewController.step.identifier) {
        stepViewController.continueButton = nil;
        stepViewController.skipButton = nil;
    } else if (kWalkingStep102Key == stepViewController.step.identifier) {
        stepViewController.continueButton = nil;
    } else if (kWalkingStep103Key == stepViewController.step.identifier) {
        stepViewController.continueButton = nil;
    } else if (kWalkingStep104Key == stepViewController.step.identifier) {
        stepViewController.continueButton = nil;
    } else if (kWalkingStep105Key == stepViewController.step.identifier) {
                stepViewController.continueButton = [[UIBarButtonItem alloc] initWithTitle:@"Well done!" style:stepViewController.continueButton.style target:stepViewController.continueButton.target action:stepViewController.continueButton.action];
    }
}

- (void)taskViewController:(RKSTTaskViewController *)taskViewController didReceiveLearnMoreEventFromStepViewController:(RKSTStepViewController *)stepViewController
{
}

- (RKSTStepViewController *)taskViewController:(RKSTTaskViewController *)taskViewController viewControllerForStep:(RKSTStep *)step
{

    NSDictionary  *stepsToControllersMap = @{
                                             kWalkingStep101Key : @[ [APHWalkingIntroViewController class], @(0) ],
                                             kGetReadyStep      : @[ [APCStepViewController class],   @(0) ],
                                             kWalkingStep102Key : @[ [APCStepViewController class],   @(0) ],
                                             kWalkingStep103Key : @[ [APCStepViewController class],   @(0) ],
                                             kWalkingStep104Key : @[ [APCStepViewController class],   @(0) ],
                                             kWalkingStep105Key : @[ [APHCommonTaskSummaryViewController class], @(0) ],
                                           };
    
    RKSTStepViewController  *controller = nil;
    
    NSArray  *descriptor = stepsToControllersMap[step.identifier];
    
    if (descriptor != nil) {
        Class  classToCreate = descriptor[0];
        NSUInteger  phase = [descriptor[1] unsignedIntegerValue];
        controller = [[classToCreate alloc] initWithStep:step];
        if ([controller respondsToSelector:@selector(setWalkingPhase:)] == YES) {
            ((APHWalkingStepsViewController *)controller).walkingPhase = (WalkingStepsPhase)phase;
        }
        controller.delegate = self;
    }
    return  controller;
}

#pragma  mark  -  View Controller Methods    kWalkingStep102Key

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationBar.topItem.title = NSLocalizedString(kTaskViewControllerTitle, nil);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/*********************************************************************************/
#pragma  mark  - TaskViewController delegates
/*********************************************************************************/

- (void)taskViewControllerDidFail: (RKSTTaskViewController *)taskViewController withError:(NSError*)error{
    
    [self.taskArchive resetContent];
    self.taskArchive = nil;
    
}

/*********************************************************************************/
#pragma mark - StepViewController Delegate Methods
/*********************************************************************************/

- (void)stepViewControllerWillAppear:(RKSTStepViewController *)viewController
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
