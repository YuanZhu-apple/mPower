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

static  NSString  *kWalkingStep101Key = @"Walking Step 101";
static  NSString  *kgetReadyStep = @"Get Ready";
static  NSString  *kWalkingStep102Key = @"Walking Step 102";
static  NSString  *kWalkingStep103Key = @"Walking Step 103";
static  NSString  *kWalkingStep104Key = @"Walking Step 104";
static  NSString  *kWalkingStep105Key = @"Walking Step 105";

static  NSString  *kTaskViewControllerTitle = @"Timed Walking";

static NSInteger kCountDownTimer = 10;

static  CGFloat  kAPCStepProgressBarHeight = 8.0;

@interface APHWalkingTaskViewController  ( )
{
    NSInteger _count;
}

@property (strong, nonatomic) RKDataArchive *taskArchive;

@property  (nonatomic, weak)  APCStepProgressBar  *progressor;

@end

@implementation APHWalkingTaskViewController

#pragma  mark  -  Initialisation

+ (RKTask *)createTask: (APCScheduledTask*) scheduledTask
{
    NSMutableArray  *steps = [NSMutableArray array];
    
    {
        RKActiveStep* step = [[RKActiveStep alloc] initWithIdentifier:kWalkingStep101Key name:@"active step"];
        step.caption = NSLocalizedString(@"Measures Gait and Balance", @"");
        step.text = NSLocalizedString(@"You have 10 seconds to put this device in your pocket."
        @"After the phone vibrates, follow the instructions to begin.", @"");
        step.buzz = YES;
        step.vibration = YES;
        [steps addObject:step];
    }
    
    {
        //Introduction to fitness test
        RKActiveStep* step = [[RKActiveStep alloc] initWithIdentifier:kgetReadyStep name:@"active step"];
        step.caption = NSLocalizedString(@"Timed Walking", @"");
        step.text = NSLocalizedString(@"Get Ready!", @"");
        step.countDown = kCountDownTimer;
        step.useNextForSkip = NO;
        step.buzz = YES;
        step.speakCountDown = YES;
        
        [steps addObject:step];
    }
    
    {
        RKActiveStep* step = [[RKActiveStep alloc] initWithIdentifier:kWalkingStep102Key name:@"active step"];
        step.caption = NSLocalizedString(@"Walk out 20 Steps", @"");
        step.text = NSLocalizedString(@"Now please walk out 20 steps.", @"");
        step.voicePrompt = step.text;
        step.buzz = YES;
        step.vibration = YES;
        step.countDown = 30.0;
        step.recorderConfigurations = @[ [[RKAccelerometerRecorderConfiguration alloc] initWithFrequency:100.0]];
        [steps addObject:step];
    }
    {
        RKActiveStep* step = [[RKActiveStep alloc] initWithIdentifier:kWalkingStep103Key name:@"active step"];
        step.caption = NSLocalizedString(@"Turn around and walk back", @"");
        step.text = NSLocalizedString(@"Now please turn 180 degrees, and walk back to your starting point.", @"");
        step.voicePrompt = step.text;
        step.buzz = YES;
        step.vibration = YES;
        step.countDown = 30.0;
        step.recorderConfigurations = @[ [[RKAccelerometerRecorderConfiguration alloc] initWithFrequency:100.0]];
        [steps addObject:step];
    }
    {
        RKActiveStep* step = [[RKActiveStep alloc] initWithIdentifier:kWalkingStep104Key name:@"active step"];
        step.caption = NSLocalizedString(@"Standing Still", @"");
        step.text = NSLocalizedString(@"Now please stand still for 30 seconds.", @"");
        step.voicePrompt = step.text;
        step.buzz = YES;
        step.vibration = YES;
        step.countDown = 30.0;
        step.recorderConfigurations = @[ [[RKAccelerometerRecorderConfiguration alloc] initWithFrequency:100.0]];
        [steps addObject:step];
    }
    {
        RKActiveStep* step = [[RKActiveStep alloc] initWithIdentifier:kWalkingStep105Key name:@"active step"];
        step.caption = NSLocalizedString(@"Great Job!", @"");
        step.text = NSLocalizedString(@"Your gait symptoms seem to appear mild."
                    @"Insert easy to understand meaning of this interpretation here.", @"");
        step.buzz = YES;
        step.vibration = YES;

        [steps addObject:step];
    }
    
    RKTask  *task = [[RKTask alloc] initWithName:@"Timed Walking Task" identifier:@"Timed Walking Task" steps:steps];
    
    return  task;
}

- (instancetype)initWithTask:(id<RKLogicalTask>)task taskInstanceUUID:(NSUUID *)taskInstanceUUID
{
    self = [super initWithTask:task taskInstanceUUID:taskInstanceUUID];
    if (self) {
        _count = 0;
    }
    return self;
}

#pragma  mark  -  Task View Controller Delegate Methods
- (BOOL)taskViewController:(RKTaskViewController *)taskViewController shouldShowMoreInfoOnStep:(RKStep *)step
{
    return  NO;
}

- (BOOL)taskViewController:(RKTaskViewController *)taskViewController shouldPresentStep:(RKStep*)step
{
    return  YES;
}

- (void)taskViewController:(RKTaskViewController *)taskViewController willPresentStepViewController:(RKStepViewController *)stepViewController
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

- (void)taskViewController:(RKTaskViewController *)taskViewController didReceiveLearnMoreEventFromStepViewController:(RKStepViewController *)stepViewController
{
}

- (RKStepViewController *)taskViewController:(RKTaskViewController *)taskViewController viewControllerForStep:(RKStep *)step
{

    NSDictionary  *stepsToControllersMap = @{
                                             kWalkingStep101Key : @[ [APHWalkingIntroViewController class], @(0) ],
                                             kWalkingStep105Key : @[ [APHCommonTaskSummaryViewController  class], @(0) ],
                                           };
    
    RKStepViewController  *controller = nil;
    
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

#pragma  mark  -  View Controller Methods

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self beginTask];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect  navigationBarFrame = self.navigationBar.frame;
    CGRect  progressorFrame = CGRectMake(0.0, CGRectGetHeight(navigationBarFrame) - kAPCStepProgressBarHeight, CGRectGetWidth(navigationBarFrame), kAPCStepProgressBarHeight);
    
    APCStepProgressBar  *tempProgressor = [[APCStepProgressBar alloc] initWithFrame:progressorFrame style:APCStepProgressBarStyleOnlyProgressView];
    
    RKTask  *task = self.task;
    NSArray  *steps = task.steps;
    tempProgressor.numberOfSteps = [steps count];
    [tempProgressor setCompletedSteps: 1 animation:NO];
    tempProgressor.progressTintColor = [UIColor appTertiaryColor1];
    [self.navigationBar addSubview:tempProgressor];
    self.progressor = tempProgressor;
    
    self.showsProgressInNavigationBar = NO;
    self.navigationBar.topItem.title = NSLocalizedString(kTaskViewControllerTitle, nil);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/*********************************************************************************/
#pragma  mark  - Private methods
/*********************************************************************************/

- (void)beginTask
{
    if (self.taskArchive)
    {
        [self.taskArchive resetContent];
    }
    
    self.taskArchive = [[RKDataArchive alloc] initWithItemIdentifier:[RKItemIdentifier itemIdentifierForTask:self.task] studyIdentifier:MainStudyIdentifier taskInstanceUUID:self.taskInstanceUUID extraMetadata:nil fileProtection:RKFileProtectionCompleteUnlessOpen];
    
}

/*********************************************************************************/
#pragma mark - Helpers
/*********************************************************************************/

-(void)sendResult:(RKResult*)result
{
    // In a real application, consider adding to the archive on a concurrent queue.
    NSError *err = nil;
    if (![result addToArchive:self.taskArchive error:&err])
    {
        // Error adding the result to the archive; archive may be invalid. Tell
        // the user there's been a problem and stop the task.
        NSLog(@"Error adding %@ to archive: %@", result, err);
    }
}


/*********************************************************************************/
#pragma  mark  - TaskViewController delegates
/*********************************************************************************/
- (void)taskViewController:(RKTaskViewController *)taskViewController didProduceResult:(RKResult *)result {
    
    NSLog(@"didProduceResult = %@", result);
    
    if ([result isKindOfClass:[RKSurveyResult class]]) {
        RKSurveyResult* sresult = (RKSurveyResult*)result;
        
        for (RKQuestionResult* qr in sresult.surveyResults) {
            NSLog(@"%@ = [%@] %@ ", [[qr itemIdentifier] stringValue], [qr.answer class], qr.answer);
        }
    }
    
    
    [self sendResult:result];
    
    [super taskViewController:taskViewController didProduceResult:result];
}

- (void)taskViewControllerDidFail: (RKTaskViewController *)taskViewController withError:(NSError*)error{
    
    [self.taskArchive resetContent];
    self.taskArchive = nil;
    
}

- (void)taskViewControllerDidCancel:(RKTaskViewController *)taskViewController{
    
    [taskViewController suspend];
    
    [self.taskArchive resetContent];
    self.taskArchive = nil;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)taskViewControllerDidComplete: (RKTaskViewController *)taskViewController{
    
//    NSFetchRequest * request = [APCResult request];
//    request.predicate = [NSPredicate predicateWithFormat:@"scheduledTask == %@ AND rkTaskInstanceUUID == %@", self.scheduledTask, self.taskInstanceUUID.UUIDString];
//    
//    APCAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//    NSArray * results = [appDelegate.dataSubstrate.mainContext executeFetchRequest:request error:NULL];
//    
//    RKStep * dummyStep = [[RKStep alloc] initWithIdentifier:@"Dummy" name:@"name"];
//    RKDataResult * result = [[RKDataResult alloc] initWithStep:dummyStep];
//    result.filename = @"walkingTask.json";
//    result.contentType = @"application/json";
//    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
//    [results enumerateObjectsUsingBlock:^(APCDataResult * result, NSUInteger idx, BOOL *stop) {
//        dictionary[result.rkItemIdentifier] = [NSJSONSerialization JSONObjectWithData:result.data options:0 error:NULL];
//    }];
//    
    
//    NSMutableDictionary *wrapperDictionary = [NSMutableDictionary dictionary];
//    wrapperDictionary[@"fitnessTest"] = dictionary;
//    
//    NSLog(@"Dictionary: %@", wrapperDictionary);
//    
//    result.data = [NSJSONSerialization dataWithJSONObject:wrapperDictionary options:(NSJSONWritingOptions)0 error:NULL];
//    [result addToArchive:self.taskArchive error:NULL];

    
    NSError *err = nil;
    NSURL *archiveFileURL = [self.taskArchive archiveURLWithError:&err];
    if (archiveFileURL)
    {
        NSURL *documents = [NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]];
        NSURL *outputUrl = [documents URLByAppendingPathComponent:[archiveFileURL lastPathComponent]];
        
        // This is where you would queue the archive for upload. In this demo, we move it
        // to the documents directory, where you could copy it off using iTunes, for instance.
        [[NSFileManager defaultManager] moveItemAtURL:archiveFileURL toURL:outputUrl error:nil];
        
        NSLog(@"outputUrl= %@", outputUrl);
        
        // When done, clean up:
        self.taskArchive = nil;
        if (archiveFileURL)
        {
            [[NSFileManager defaultManager] removeItemAtURL:archiveFileURL error:nil];
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [super taskViewControllerDidComplete:taskViewController];
}

/*********************************************************************************/
#pragma mark - StepViewController Delegate Methods
/*********************************************************************************/

- (void)stepViewControllerWillBePresented:(RKStepViewController *)viewController
{
    viewController.skipButton = nil;
    viewController.continueButton = nil;
}

- (void)stepViewControllerDidFinish:(RKStepViewController *)stepViewController navigationDirection:(RKStepViewControllerNavigationDirection)direction
{
    [super stepViewControllerDidFinish:stepViewController navigationDirection:direction];
    
    stepViewController.continueButton = nil;
    
    NSInteger  completedSteps = self.progressor.completedSteps;
    if (direction == RKStepViewControllerNavigationDirectionForward) {
        completedSteps = completedSteps + 1;
    } else {
        completedSteps = completedSteps - 1;
    }
    [self.progressor setCompletedSteps:completedSteps animation:YES];
}

@end
