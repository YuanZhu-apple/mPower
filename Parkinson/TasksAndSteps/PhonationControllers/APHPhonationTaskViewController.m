// 
//  APHPhonationTaskViewController.m 
//  mPower 
// 
//  Copyright (c) 2014 Apple, Inc. All rights reserved. 
// 
 
#import "APHPhonationTaskViewController.h"

#import <objc/message.h>
#import <AVFoundation/AVFoundation.h>
#import "APHAudioRecorderConfiguration.h"
#import "APHAudioRecorder.h"
#import "APHPhonationMeteringView.h"

#import <ResearchKit/ResearchKit_Private.h>

static  NSString       *MainStudyIdentifier        = @"com.parkinsons.phonation";

static  NSString       *kPhonationStep101Key       = @"Phonation_Step_101";

static  NSString       *kGetReadyStep              = @"Get Ready";
static  NSTimeInterval  kGetReadyCountDownInterval =  5.0;

static  NSString       *kPhonationStep102Key       = @"Phonation_Step_102";
static  NSTimeInterval  kGetSoundingAaahhhInterval = 10.0;

static  NSString       *kPhonationStep103Key       = @"Phonation_Step_103";

static  NSString       *kTaskViewControllerTitle   = @"Voice";

static  CGFloat         kPhoneFiveScreenWidth                    = 320.0;
static  CGFloat         kPhoneSixScreenWidth                     = 375.0;

static  CGFloat         kMeteringDisplayWidthPlusInsetsForPhone5 = 162.0;
static  CGFloat         kMeteringDisplayWidthPlusInsetsForPhone6 = 182.0;

static  CGFloat         kMeteringDisplayOffetFromBottomForPhone5 =   5.0;
static  CGFloat         kMeteringDisplayOffetFromBottomForPhone6 =  24.0;

static  NSTimeInterval  kMeteringTimeInterval      =   0.01;

@interface APHPhonationTaskViewController ( )  <RKSTTaskViewControllerDelegate>

    //
    //    metering-related stuff
    //
@property  (nonatomic, weak)    APHPhonationMeteringView        *meteringDisplay;
@property  (nonatomic, assign)  CGFloat                         meteringDisplayWidthPlusInsets;
@property  (nonatomic, assign)  CGFloat                         meteringDisplayOffsetFromBottom;

@property  (nonatomic, strong)  NSTimer                         *meteringTimer;

@property  (nonatomic, strong)  APHAudioRecorderConfiguration   *audioConfiguration;
@property  (nonatomic, strong)  RKSTAudioRecorder               *ourAudioRecorder;
@property  (nonatomic, strong)  AVAudioRecorder                 *audioRecorder;

@end

@implementation APHPhonationTaskViewController

#pragma  mark  -  Initialisation

+ (RKSTOrderedTask *)createTask:(APCScheduledTask*) scheduledTask
{
    
    NSMutableArray *steps = [NSMutableArray array];
    
    {
        RKSTInstructionStep  *step = [[RKSTInstructionStep alloc] initWithIdentifier:kPhonationStep101Key];
        step.title = @"Tests Speech Difficulties";
        step.text = @"";
        step.detailText = @"In the next screen you will be asked to say “Aaaahhh” for 10 seconds.";
        [steps addObject:step];
    }
    
    {
        //Introduction to fitness test
        RKSTActiveStep  *step = [[RKSTActiveStep alloc] initWithIdentifier:kGetReadyStep];
        step.title = NSLocalizedString(@"Voice", @"");
        step.text = NSLocalizedString(@"Get Ready!", @"");
        step.countDownInterval = kGetReadyCountDownInterval;
        step.shouldStartTimerAutomatically = YES;
        step.shouldUseNextAsSkipButton = NO;
        step.shouldPlaySoundOnStart = YES;
        step.shouldSpeakCountDown = YES;
        
        [steps addObject:step];
    }
    
    {
        RKSTActiveStep  *step = [[RKSTActiveStep alloc] initWithIdentifier:kPhonationStep102Key];
        step.text = @"Please say “Aaaahhh” for 10 seconds";
        step.countDownInterval = kGetSoundingAaahhhInterval;
        step.shouldStartTimerAutomatically = YES;
        step.shouldPlaySoundOnStart = YES;
        step.shouldVibrateOnStart = YES;
        step.recorderConfigurations = @[[[APHAudioRecorderConfiguration alloc] initWithRecorderSettings:@{ AVFormatIDKey : @(kAudioFormatAppleLossless),
                                                                                                            AVNumberOfChannelsKey : @(1),
                                                                                                            AVSampleRateKey: @(44100.0)
                                                                                                            }]];
        [steps addObject:step];
    }
    
    {
        RKSTInstructionStep  *step = [[RKSTInstructionStep alloc] initWithIdentifier:kPhonationStep103Key];
        step.title = @"Great Job!";
        [steps addObject:step];
    }
    
    RKSTOrderedTask  *task = [[RKSTOrderedTask alloc] initWithIdentifier:@"Phonation Activity" steps:steps];
    
    return  task;
}

#pragma  mark  -  Task View Controller Delegate Methods

- (void)taskViewController:(RKSTTaskViewController *)taskViewController stepViewControllerWillAppear:(RKSTStepViewController *)stepViewController
{
    stepViewController.cancelButton = nil;
    stepViewController.backButton = nil;
    stepViewController.continueButton = nil;
    stepViewController.skipButton     = nil;
    
    if (([stepViewController.step.identifier isEqualToString:kPhonationStep101Key] == YES) ||
        ([stepViewController.step.identifier isEqualToString:kGetReadyStep] == YES) ||
        ([stepViewController.step.identifier isEqualToString:kPhonationStep102Key] == YES)) {
        
        UIBarButtonItem  *cancellor = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonWasTapped:)];
        stepViewController.cancelButton = cancellor;
    }
    
    if ([stepViewController.step.identifier isEqualToString:kPhonationStep102Key] == YES) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRecorderDidStart:) name:APHAudioRecorderDidStartKey object:nil];
        RKSTActiveStep  *activeStep = (RKSTActiveStep *)stepViewController.step;
        self.audioConfiguration = [activeStep.recorderConfigurations firstObject];
        
        [self addMeteringStuff:(APCStepViewController *)stepViewController];
    }
    if ([stepViewController.step.identifier isEqualToString:kPhonationStep103Key] == YES) {
        [self.meteringTimer invalidate];
        self.meteringTimer      = nil;
        [self.audioRecorder stop];
        self.audioConfiguration = nil;
        self.ourAudioRecorder   = nil;
        self.audioRecorder      = nil;
        
        NSError  *error = nil;
        BOOL  success = [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
        if (success == NO) {
            APCLogError2(error);
        }
    }
    [super taskViewController:taskViewController stepViewControllerWillAppear:stepViewController];
}

- (RKSTStepViewController *)taskViewController:(RKSTTaskViewController *)taskViewController viewControllerForStep:(RKSTStep *)step
{
    APCStepViewController  *controller = nil;
    
    if ([step.identifier isEqualToString:kPhonationStep101Key]) {
        controller = (APCInstructionStepViewController*) [[UIStoryboard storyboardWithName:@"APCInstructionStep" bundle:[NSBundle appleCoreBundle]] instantiateInitialViewController];
        APCInstructionStepViewController  *instController = (APCInstructionStepViewController*)controller;
        
        instController.imagesArray = @[ @"phonation.instructions.01", @"phonation.instructions.02", @"phonation.instructions.03", @"phonation.instructions.04", @"phonation.instructions.05" ];
        instController.headingsArray = @[ @"Voice Activity", @"Voice Activity", @"Voice Activity", @"Voice Activity", @"Voice Activity" ];
        instController.messagesArray  = @[
                                          @"Once you tap Get Started, you will have five seconds until this test begins tracking your vocal patterns.",
                                          @"When prompted, say “Aaah” into your phone's microphone for as long as you are comfortably able to.",
                                          @"Try to maintain a steady volume so that the outermost ring remains green.",
                                          @"If you are too quiet or too loud, you will be prompted to raise or lower your voice.",
                                          @"After the test is finished, your results will be analyzed and available on the dashboard.  You will be notified when analysis is ready."
                                          ];
        controller.delegate = self;
        controller.step = step;
    } else {
        NSDictionary  *controllers = @{
                                       kPhonationStep103Key : [APCSimpleTaskSummaryViewController class]
                                       };
        Class  aClass = [controllers objectForKey:step.identifier];
        NSBundle  *bundle = nil;
        if ([step.identifier isEqualToString:kPhonationStep103Key] == YES) {
            bundle = [NSBundle appleCoreBundle];
        }
        controller = [[aClass alloc] initWithNibName:nil bundle:bundle];
        controller.delegate = self;
        controller.title = NSLocalizedString(@"Voice", @"");
        controller.step = step;
    }
    return  controller;
}

#pragma  mark  - View Controller methods

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    CGRect  bounds = [[[UIScreen mainScreen] fixedCoordinateSpace] bounds];
    if (CGRectGetWidth(bounds) >= kPhoneSixScreenWidth) {
        self.meteringDisplayWidthPlusInsets = kMeteringDisplayWidthPlusInsetsForPhone6;
        self.meteringDisplayOffsetFromBottom = kMeteringDisplayOffetFromBottomForPhone6;
    } else if (CGRectGetWidth(bounds) >= kPhoneFiveScreenWidth) {
        self.meteringDisplayWidthPlusInsets = kMeteringDisplayWidthPlusInsetsForPhone5;
        self.meteringDisplayOffsetFromBottom = kMeteringDisplayOffetFromBottomForPhone5;
    } else {
        self.meteringDisplayWidthPlusInsets = kMeteringDisplayWidthPlusInsetsForPhone5;
        self.meteringDisplayOffsetFromBottom = kMeteringDisplayOffetFromBottomForPhone5;
    }

    self.navigationBar.topItem.title = NSLocalizedString(kTaskViewControllerTitle, nil);
    
    self.stepsToAutomaticallyAdvanceOnTimer = @[ kGetReadyStep, kPhonationStep102Key ];
    
    NSError  *error = nil;
    BOOL  success = [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    if (success == NO) {
        APCLogError2(error);
    }
}

/*********************************************************************************/
#pragma mark - Audio Recorder Notification Method
/*********************************************************************************/

- (void)audioRecorderDidStart:(NSNotification *)notification
{
    NSDictionary  *info = [notification userInfo];
    self.ourAudioRecorder = [info objectForKey:APHAudioRecorderInstanceKey];
    self.audioRecorder = self.ourAudioRecorder.audioRecorder;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:APHAudioRecorderDidStartKey object:nil];
    
    self.audioRecorder.meteringEnabled = YES;
    [self setupTimer];
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
#pragma mark - Metering Logic (if you stretch the term 'logic') . . .
/*********************************************************************************/

- (void)addMeteringStuff:(APCStepViewController *)viewController
{
    APHPhonationMeteringView  *meterologist = [[APHPhonationMeteringView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.meteringDisplayWidthPlusInsets, self.meteringDisplayWidthPlusInsets)];
    self.meteringDisplay = meterologist;

    NSString  *verticalConstraint = [NSString stringWithFormat:@"V:[c(==%.0f)]", self.meteringDisplayWidthPlusInsets];
    NSArray  *vc1 = [NSLayoutConstraint constraintsWithVisualFormat:verticalConstraint options:0 metrics:nil views:@{@"c":meterologist}];
    [meterologist addConstraints:vc1];

    NSString  *horizontalConstraint = [NSString stringWithFormat:@"H:[c(==%.0f)]", self.meteringDisplayWidthPlusInsets];
    NSArray  *vc2 = [NSLayoutConstraint constraintsWithVisualFormat:horizontalConstraint options:0 metrics:nil views:@{@"c":meterologist}];
    [meterologist addConstraints:vc2];
    
    [viewController.view addSubview:meterologist];
    [meterologist setTranslatesAutoresizingMaskIntoConstraints: NO];
    
    NSArray  *constraints = @[
                              [NSLayoutConstraint constraintWithItem:viewController.view
                                                           attribute:NSLayoutAttributeBottom
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:meterologist
                                                           attribute:NSLayoutAttributeBottom
                                                          multiplier:1.0
                                                            constant:self.meteringDisplayOffsetFromBottom],
                              [NSLayoutConstraint constraintWithItem:viewController.view
                                                           attribute:NSLayoutAttributeCenterX
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:meterologist
                                                           attribute:NSLayoutAttributeCenterX
                                                          multiplier:1.0
                                                            constant:0.0]
                              ];
    
    [viewController.view addConstraints:constraints];
    [viewController.view bringSubviewToFront:meterologist];
}

- (void)setupTimer
{
    self.meteringTimer = [NSTimer scheduledTimerWithTimeInterval:kMeteringTimeInterval
                                                          target:self
                                                        selector:@selector(meteringTimerDidFire:)
                                                        userInfo:nil
                                                         repeats:YES];
}

    //
    //    range of magic numbers collected from audio meter
    //
static  float  kMinimumPowerOffsetFromBase = 20.0;
static  float  kMaximumPowerOffsetFromFull =  5.0;

- (void)meteringTimerDidFire:(NSTimer *)timer
{
    [self.audioRecorder updateMeters];
    
    float  power = [self.audioRecorder averagePowerForChannel:0];
    power = power + kMinimumPowerOffsetFromBase;
    
    float  inputRange = (kMinimumPowerOffsetFromBase - kMaximumPowerOffsetFromFull);
    
    if (power < 0.0) {
        power = 0.0;
    }
    if (power > inputRange) {
        power = inputRange;
    }
    float  mappedPower = power / inputRange;
    self.meteringDisplay.powerLevel = mappedPower;
    [self.meteringDisplay setNeedsDisplay];
}

@end
