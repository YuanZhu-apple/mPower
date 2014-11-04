//
//  APHPhonationTaskViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 9/3/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHPhonationTaskViewController.h"
#import "APHPhonationIntroViewController.h"
#import "APHCommonTaskSummaryViewController.h"
#import <objc/message.h>
#import <AVFoundation/AVFoundation.h>

static NSString *MainStudyIdentifier = @"com.parkinsons.phonation";

static NSString * kPhonationStep101Key = @"Phonation_Step_101";
static NSString * kPhonationStep102Key = @"Phonation_Step_102";
static NSString * kPhonationStep103Key = @"Phonation_Step_103";
static NSString * kPhonationStep104Key = @"Phonation_Step_104";
static NSString * kPhonationStep105Key = @"Phonation_Step_105";

static  CGFloat  kAPCStepProgressBarHeight = 10.0;

@interface APHPhonationTaskViewController ()

@property (strong, nonatomic) RKDataArchive *taskArchive;

@property  (nonatomic, weak)  APCStepProgressBar  *progressor;

@end

@implementation APHPhonationTaskViewController

#pragma  mark  -  Initialisation

+ (RKTask *)createTask:(APCScheduledTask*) scheduledTask
{
    
    NSMutableArray *steps = [NSMutableArray array];
    
    {
        RKIntroductionStep *step = [[RKIntroductionStep alloc] initWithIdentifier:kPhonationStep101Key name:@"Introduction Step"];
        step.caption = @"Tests Speech Difficulties";
        step.explanation = @"";
        step.instruction = @"In the next screen you will be asked to say “Aaaahhh” for 10 seconds.";
        [steps addObject:step];
    }
    {
        RKActiveStep* step = [[RKActiveStep alloc] initWithIdentifier:kPhonationStep102Key name:@"active step"];
        step.text = @"Please say “Aaaahhh” for 10 seconds";
        step.countDown = 10.0;
        step.buzz = YES;
        step.vibration = YES;
        step.recorderConfigurations = @[[[RKAudioRecorderConfiguration alloc] initWithRecorderSettings:@{AVFormatIDKey : @(kAudioFormatAppleLossless),
                                                                                                         AVNumberOfChannelsKey : @(2),
                                                                                                         AVSampleRateKey: @(44100.0)
                                                                                                         }]];
        [steps addObject:step];
    }
    {
        RKActiveStep* step = [[RKActiveStep alloc] initWithIdentifier:kPhonationStep103Key name:@"active step"];
        step.caption = @"Great Job!";
        [steps addObject:step];
    }
    
    RKTask  *task = [[RKTask alloc] initWithName:@"Sustained Phonation" identifier:@"Phonation Task" steps:steps];
    
    return  task;
}

#pragma  mark  -  Task View Controller Delegate Methods

- (BOOL)taskViewController:(RKTaskViewController *)taskViewController shouldPresentStepViewController:(RKStepViewController *)stepViewController
{
    return  YES;
}

- (void)taskViewController:(RKTaskViewController *)taskViewController willPresentStepViewController:(RKStepViewController *)stepViewController
{
    stepViewController.cancelButton = nil;
    stepViewController.backButton = nil;
    stepViewController.continueButton = nil;
}

- (RKStepViewController *)taskViewController:(RKTaskViewController *)taskViewController viewControllerForStep:(RKStep *)step
{
    NSDictionary  *controllers = @{
                                   kPhonationStep101Key : [APHPhonationIntroViewController class],
                                   kPhonationStep103Key : [APHCommonTaskSummaryViewController class]
                                   };
    Class  aClass = [controllers objectForKey:step.identifier];
    APCStepViewController  *controller = [[aClass alloc] initWithNibName:nil bundle:nil];
    controller.resultCollector = self;
    controller.delegate = self;
    controller.title = @"Interval Tapping";
    controller.step = step;
    return  controller;
}

#pragma  mark  - View Controller methods

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
    self.progressor.progressTintColor = [UIColor appTertiaryColor1];
    [self.navigationBar addSubview:tempProgressor];
    self.progressor = tempProgressor;
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
    
    [taskViewController suspend];
    
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
