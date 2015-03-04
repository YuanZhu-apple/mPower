// 
//  APHIntervalTappingTaskViewController.m 
//  mPower 
// 
//  Copyright (c) 2014 Apple, Inc. All rights reserved. 
// 
 
#import "APHIntervalTappingTaskViewController.h"
#import "APHIntervalTappingRecorderDataKeys.h"
#import "PDScores.h"
#import "ConverterForPDScores.h"
#import <AVFoundation/AVFoundation.h>
#import "APHAppDelegate.h"

static NSString *const kMomentInDay                             = @"momentInDay";
static NSString *const kInstruction1                            = @"instruction1";
static NSString *const kMomentInDayFormat                       = @"momentInDayFormat";
static NSString *const kMomentInDayFormatTitle                  = @"We would like to understand how your performance on"
                                                                " this activity could be affected by the timing of your medication.";
static NSString *const kMomentInDayFormatItemText               = @"When are you performing this Activity?";
static NSString *const kMomentInDayFormatChoiceJustWokeUp       = @"Immediately before Parkinson medication";
static NSString *const kMomentInDayFormatChoiceTookMyMedicine   = @"Just after Parkinson medication (at your best)";
static NSString *const kMomentInDayFormatChoiceEvening          = @"Another time";
static NSString *const kMomentInDayFormatChoiceNone             = @"I don't take Parkinson medications";

static NSString *const kConclusionStep                          = @"conclusion";

static double kMinimumAmountOfTimeToShowSurvey = 20.0 * 60.0;

typedef  enum  _TappingStepOrdinals
{
    TappingStepOrdinalsIntroductionStep = 0,
    TappingStepOrdinalsTookMedicationsStep,
    TappingStepOrdinalsInstructionStep,
    TappingStepOrdinalsTappingStep,
    TappingStepOrdinalsConclusionStep,
}  TappingStepOrdinals;

static  NSString       *kTaskViewControllerTitle      = @"Tapping Activity";

static  NSString       *kIntervalTappingTitle         = @"Tapping Activity";

static  NSTimeInterval  kTappingStepCountdownInterval = 20.0;

static NSString        *kConclusionStepIdentifier     = @"conclusion";

@interface APHIntervalTappingTaskViewController  ( ) <NSObject>

@property  (nonatomic, assign)  TappingStepOrdinals  tappingStepOrdinal;

@property  (nonatomic, assign)  BOOL                 preferStatusBarShouldBeHidden;

@end

@implementation APHIntervalTappingTaskViewController

#pragma  mark  -  Task Creation Methods

+ (ORKOrderedTask *)createTask:(APCScheduledTask *) __unused scheduledTask
{
    ORKOrderedTask  *task = [ORKOrderedTask twoFingerTappingIntervalTaskWithIdentifier:kIntervalTappingTitle
                                                                intendedUseDescription:nil
                                                                              duration:kTappingStepCountdownInterval
                                                                                options:0];
    
    APHAppDelegate *appDelegate = (APHAppDelegate *) [UIApplication sharedApplication].delegate;
    NSDate *lastCompletionDate = appDelegate.dataSubstrate.currentUser.taskCompletion;
    NSTimeInterval numberOfSecondsSinceTaskCompletion = [[NSDate date] timeIntervalSinceDate: lastCompletionDate];
    
    if (numberOfSecondsSinceTaskCompletion > kMinimumAmountOfTimeToShowSurvey || lastCompletionDate == nil) {
        
        
        NSMutableArray *stepQuestions = [NSMutableArray array];
        
        
        ORKFormStep *step = [[ORKFormStep alloc] initWithIdentifier:kMomentInDay title:nil text:NSLocalizedString(kMomentInDayFormatTitle, nil)];
        
        step.optional = NO;
        
        
        {
            NSArray *choices = @[
                                 NSLocalizedString(kMomentInDayFormatChoiceJustWokeUp,
                                                   kMomentInDayFormatChoiceJustWokeUp),
                                 NSLocalizedString(kMomentInDayFormatChoiceTookMyMedicine,
                                                   kMomentInDayFormatChoiceTookMyMedicine),
                                 NSLocalizedString(kMomentInDayFormatChoiceEvening,
                                                   kMomentInDayFormatChoiceEvening),
                                 NSLocalizedString(kMomentInDayFormatChoiceNone,
                                                   kMomentInDayFormatChoiceNone)
                                 ];
            
            ORKAnswerFormat *format = [ORKTextChoiceAnswerFormat choiceAnswerFormatWithStyle:ORKChoiceAnswerStyleSingleChoice
                                                                                 textChoices:choices];
            
            ORKFormItem *item = [[ORKFormItem alloc] initWithIdentifier:kMomentInDayFormat
                                                                   text:NSLocalizedString(kMomentInDayFormatItemText, kMomentInDayFormatItemText)
                                                           answerFormat:format];
            [stepQuestions addObject:item];
        }
        
        [step setFormItems:stepQuestions];
        
        NSMutableArray *twoFingerSteps = [task.steps mutableCopy];
        
        [twoFingerSteps insertObject:step
                             atIndex:1];
        
        task = [[ORKOrderedTask alloc] initWithIdentifier:kIntervalTappingTitle
                                                                       steps:twoFingerSteps];
    }
    
    [[UIView appearance] setTintColor:[UIColor appPrimaryColor]];
    
    return  task;
}


#pragma  mark  -  Results For Dashboard

- (NSString *)createResultSummary
{
    ORKTaskResult  *taskResults = self.result;
    self.createResultSummaryBlock = ^(NSManagedObjectContext * context) {
        ORKTappingIntervalResult  *tapsterResults = nil;
        BOOL  found = NO;
        for (ORKStepResult  *stepResult  in  taskResults.results) {
            if (stepResult.results.count > 0) {
                for (id  object  in  stepResult.results) {
                    if ([object isKindOfClass:[ORKTappingIntervalResult class]] == YES) {
                        found = YES;
                        tapsterResults = object;
                        break;
                    }
                }
                if (found == YES) {
                    break;
                }
            }
        }
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF = 0"];
        NSArray *allSamples = [tapsterResults.samples valueForKey:@"buttonIdentifier"];
        NSArray *tapSamples = [allSamples filteredArrayUsingPredicate:predicate];
        
        NSArray * totalScore = [ConverterForPDScores convertTappings:tapsterResults];
        double scoreSummary = [PDScores scoreFromTappingTest:totalScore];
        
        scoreSummary = isnan(scoreSummary) ? 0 : scoreSummary;
        
        
        NSUInteger  numberOfSamples = 0;
        NSDictionary  *summary = nil;
        if (tapsterResults == nil) {
            summary = @{ kSummaryNumberOfRecordsKey : @(numberOfSamples), kScoreSummaryOfRecordsKey : @(scoreSummary)};
        } else {
            numberOfSamples = allSamples.count - tapSamples.count;
            summary = @{ kSummaryNumberOfRecordsKey : @(numberOfSamples), kScoreSummaryOfRecordsKey : @(scoreSummary)};
        }
        NSError  *error = nil;
        NSData  *data = [NSJSONSerialization dataWithJSONObject:summary options:0 error:&error];
        NSString  *contentString = nil;
        if (data == nil) {
            APCLogError2 (error);
        } else {
            contentString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
        
        if (contentString.length > 0)
        {
            [APCResult updateResultSummary:contentString forTaskResult:taskResults inContext:context];
        }
    };
    return nil;
}

#pragma  mark  -  Task View Controller Delegate Methods

- (void)taskViewController:(ORKTaskViewController *) __unused taskViewController stepViewControllerWillAppear:(ORKStepViewController *)stepViewController
{
    if (self.tappingStepOrdinal == TappingStepOrdinalsTappingStep) {
        self.preferStatusBarShouldBeHidden = YES;
        [[UIApplication sharedApplication] setStatusBarHidden: YES];
    }
    if ([stepViewController.step.identifier isEqualToString:kConclusionStep]) {
        self.preferStatusBarShouldBeHidden = NO;
        [[UIApplication sharedApplication] setStatusBarHidden: NO];
        [[UIView appearance] setTintColor:[UIColor appTertiaryColor1]];
    }
    
    if ([stepViewController.step.identifier isEqualToString:kInstruction1]) {
        UILabel *label = ((UILabel *)((UIView *)((UIView *)((UIView *) ((UIScrollView *)stepViewController.view.subviews[0]).subviews[0]).subviews[0]).subviews[0]).subviews[2]);
        label.text = NSLocalizedString(@"Rest your phone on a flat surface. Then use two fingers on the same hand to alternately tap the buttons that appear. Keep tapping for 20 seconds and time your taps to be as consistent as possible.\n\nTap Next to begin the test.", @"Instruction text for tapping activity in Parkinson");
    }
    self.tappingStepOrdinal = self.tappingStepOrdinal + 1;
}

- (void)taskViewController:(ORKTaskViewController *)taskViewController didFinishWithResult:(ORKTaskViewControllerResult)result error:(NSError *)error {
    
    if (result == ORKTaskViewControllerResultCompleted) {
        APHAppDelegate *appDelegate = (APHAppDelegate *) [UIApplication sharedApplication].delegate;
        appDelegate.dataSubstrate.currentUser.taskCompletion = [NSDate date];
    }
    
    [super taskViewController:taskViewController didFinishWithResult:result error:error];
}

#pragma  mark  -  View Controller Methods

- (BOOL)prefersStatusBarHidden
{
    return  self.preferStatusBarShouldBeHidden;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBar.topItem.title = NSLocalizedString(kTaskViewControllerTitle, nil);
    
    self.tappingStepOrdinal = TappingStepOrdinalsIntroductionStep;
    self.preferStatusBarShouldBeHidden = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

@end
