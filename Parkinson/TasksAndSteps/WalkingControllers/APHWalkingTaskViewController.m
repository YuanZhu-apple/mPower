//
//  APHWalkingTaskViewController.m
//  Parkinson's
//
//  Copyright (c) 2014 <INSTITUTION-NAME-TBD>. All rights reserved.
//

#import "APHWalkingTaskViewController.h"

#import "APHWalkingStepsViewController.h"

#import <objc/message.h>

static NSString *MainStudyIdentifier = @"com.parkinsons.walkingTask";

static  NSString       *kWalkingStep101Key               = @"Walking Step 101";

static  NSString       *kGetReadyStep                    = @"Get Ready";
static  NSTimeInterval  kGetReadyCountDownInterval       = 10.0;

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

@property  (strong, nonatomic)  RKSTDataArchive    *taskArchive;

@property  (assign, nonatomic)  UIApplicationState  applicationState;

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

- (void)dealloc
{
    NSNotificationCenter  *centre = [NSNotificationCenter defaultCenter];
    [centre removeObserver:self];
    [centre removeObserver:self];
}

#pragma  mark  -  Task View Controller Delegate Methods

- (BOOL)taskViewController:(RKSTTaskViewController *)taskViewController shouldShowMoreInfoOnStep:(RKSTStep *)step
{
    return  NO;
}

- (BOOL)taskViewController:(RKSTTaskViewController *)taskViewController shouldPresentStep:(RKSTStep *)step
{
    return  YES;
}

- (void)taskViewController:(RKSTTaskViewController *)taskViewController stepViewControllerWillAppear:(RKSTStepViewController *)stepViewController
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
    }

    self.applicationState = [[UIApplication sharedApplication] applicationState];
    
    stepViewController.skipButton     = nil;
    stepViewController.continueButton = nil;
    
    if (([stepViewController.step.identifier isEqualToString:kGetReadyStep] == YES) ||
        ([stepViewController.step.identifier isEqualToString:kWalkingStep102Key] == YES) ||
        ([stepViewController.step.identifier isEqualToString:kWalkingStep103Key] == YES) ||
        ([stepViewController.step.identifier isEqualToString:kWalkingStep104Key] == YES)) {
        
        UIBarButtonItem  *cancellor = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonWasTapped:)];
        stepViewController.cancelButton = cancellor;
    }
    if (self.applicationState != UIApplicationStateActive) {
        NSLog(@"APHWalkingTaskViewController stepViewControllerWillAppear sending LocalNotification");
        NSString  *speech = stepViewController.step.text;
        
        UILocalNotification  *localNotification = [UILocalNotification new];
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.userInfo = @{ @"stuff": @"other stuff" };
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    }
    [super taskViewController:taskViewController stepViewControllerWillAppear:stepViewController];
}

- (void)taskViewController:(RKSTTaskViewController *)taskViewController didReceiveLearnMoreEventFromStepViewController:(RKSTStepViewController *)stepViewController
{
}

- (RKSTStepViewController *)taskViewController:(RKSTTaskViewController *)taskViewController viewControllerForStep:(RKSTStep *)step
{
    APCStepViewController  *controller = nil;
    
    if ([step.identifier isEqualToString:kWalkingStep101Key]) {
        controller = (APCInstructionStepViewController*) [[UIStoryboard storyboardWithName:@"APCInstructionStep" bundle:[NSBundle appleCoreBundle]] instantiateInitialViewController];
        APCInstructionStepViewController  *instController = (APCInstructionStepViewController*)controller;
        
        instController.imagesArray = @[ @"walking.instructions.01", @"walking.instructions.02", @"walking.instructions.03", @"walking.instructions.04", @"walking.instructions.05" ];
        instController.headingsArray = @[ @"Gait Test", @"Gait Test", @"Gait Test", @"Gait Test", @"Gait Test" ];
        instController.messagesArray  = @[
                                          @"Once you tap Get Started, you will have ten seconds to put this device in your pocket.  A non-swinging bag or similar location will work as well.",
                                          @"After the phone vibrates, walk 20 steps in a straight line.",
                                          @"After 20 steps, there will be a second vibration.  Turn around and walk 20 steps back to your starting point.",
                                          @"Once you return to the starting point, you will feel a third vibration.  Stand as still as possible for 30 seconds.",
                                          @"After the test is complete, your results will be analyzed and the results will be returned when ready."
                                          ];
        controller.delegate = self;
        controller.step = step;
    } else {
        NSDictionary  *stepsToControllersMap = @{
                                                 kWalkingStep105Key : [APCSimpleTaskSummaryViewController class]
                                               };
        
        Class  aClass = stepsToControllersMap[step.identifier];
        NSBundle  *bundle = nil;
        if ([step.identifier isEqualToString:kWalkingStep105Key] == YES) {
            bundle = [NSBundle appleCoreBundle];
        }
        controller = [[aClass alloc] initWithNibName:nil bundle:bundle];
        controller.delegate = self;
        controller.title = kTaskViewControllerTitle;
        controller.step = step;
    }
    return  controller;
}

#pragma  mark  -  UIApplication Notification Methods

- (void)applicationWillResignActive:(NSNotification *)notification
{
    NSLog(@"APHWalkingTaskViewController applicationWillResignActive");
}

- (void)applicationDidEnterBackground:(NSNotification *)notification
{
    NSLog(@"APHWalkingTaskViewController applicationDidEnterBackground");
}

#pragma  mark  -  View Controller Methods

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationBar.topItem.title = NSLocalizedString(kTaskViewControllerTitle, nil);
    
    self.stepsToAutomaticallyAdvanceOnTimer = @[ kGetReadyStep, kWalkingStep102Key, kWalkingStep103Key, kWalkingStep104Key ];
    
    NSNotificationCenter  *centre = [NSNotificationCenter defaultCenter];
    
    [centre addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [centre addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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

/*********************************************************************************/
#pragma  mark  - TaskViewController delegates
/*********************************************************************************/

- (void)taskViewControllerDidFail: (RKSTTaskViewController *)taskViewController withError:(NSError*)error
{
    [self.taskArchive resetContent];
    self.taskArchive = nil;
}

@end
