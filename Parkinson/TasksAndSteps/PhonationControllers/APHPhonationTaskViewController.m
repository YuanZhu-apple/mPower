// 
//  APHPhonationTaskViewController.m 
//  mPower 
// 
//  Copyright (c) 2014 Apple, Inc. All rights reserved. 
// 
 
#import "APHPhonationTaskViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <APCAppCore/APCAppCore.h>
#import "PDScores.h"
#import "APHIntervalTappingRecorderDataKeys.h"
#import "APHAppDelegate.h"

static NSString *const kMomentInDay                             = @"momentInDay";
static NSString *const kMomentInDayFormat                       = @"momentInDayFormat";
static NSString *const kMomentInDayFormatItemText               = @"When are you performing this Activity?";
static NSString *const kMomentInDayFormatChoiceJustWokeUp       = @"Immediately before Parkinson medication";
static NSString *const kMomentInDayFormatChoiceTookMyMedicine   = @"Just after Parkinson medication (at your best)";
static NSString *const kMomentInDayFormatChoiceEvening          = @"Another time";
static NSString *const kMomentInDayFormatChoiceNone             = @"I don't take Parkinson medications";

static double kMinimumAmountOfTimeToShowSurvey = 20.0 * 60.0;


typedef  enum  _PhonationStepOrdinals
{
    PhonationStepOrdinalsIntroductionStep = 0,
    PhonationStepOrdinalsInstructionStep,
    PhonationStepOrdinalsCountdownStep,
    PhonationStepOrdinalsVoiceRecordingStep,
    PhonationStepOrdinalsConclusionStep,
}  PhonationStepOrdinals;

static  NSString       *kTaskViewControllerTitle   = @"Voice Activity";

static  NSTimeInterval  kGetSoundingAaahhhInterval = 10.0;

static  NSString       *kConclusionStepIdentifier  = @"conclusion";

@interface APHPhonationTaskViewController ( )  <ORKTaskViewControllerDelegate>

@property  (nonatomic, assign)  PhonationStepOrdinals  voiceRecordingStepOrdinal;

@end

@implementation APHPhonationTaskViewController

#pragma  mark  -  Initialisation

+ (ORKOrderedTask *)createTask:(APCScheduledTask *)scheduledTask
{
    NSDictionary  *audioSettings = @{ AVFormatIDKey         : @(kAudioFormatAppleLossless),
                                      AVNumberOfChannelsKey : @(1),
                                      AVSampleRateKey       : @(44100.0)
                                    };
    
      ORKOrderedTask  *task = [ORKOrderedTask audioTaskWithIdentifier:kTaskViewControllerTitle
                                               intendedUseDescription:nil
                                                    speechInstruction:nil
                                               shortSpeechInstruction:nil
                                                             duration:kGetSoundingAaahhhInterval
                                                    recordingSettings:audioSettings
                                                              options:0];
    
    [[UIView appearance] setTintColor:[UIColor appPrimaryColor]];
    
    APHAppDelegate *appDelegate = (APHAppDelegate *) [UIApplication sharedApplication].delegate;
    NSDate *lastCompletionDate = appDelegate.dataSubstrate.currentUser.taskCompletion;
    NSTimeInterval numberOfSecondsSinceTaskCompletion = [[NSDate date] timeIntervalSinceDate: lastCompletionDate];
    
    if (numberOfSecondsSinceTaskCompletion > kMinimumAmountOfTimeToShowSurvey || lastCompletionDate == nil) {
        
        
        NSMutableArray *stepQuestions = [NSMutableArray array];
        
        
        ORKFormStep *step = [[ORKFormStep alloc] initWithIdentifier:kMomentInDay title:nil text:NSLocalizedString(nil, nil)];
        
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
        
        task = [[ORKOrderedTask alloc] initWithIdentifier:kTaskViewControllerTitle
                                                    steps:twoFingerSteps];
    }

    
    return  task;
}

#pragma  mark  -  Task View Controller Delegate Methods

- (void)taskViewController:(ORKTaskViewController *)taskViewController stepViewControllerWillAppear:(ORKStepViewController *)stepViewController
{
    if (self.voiceRecordingStepOrdinal == PhonationStepOrdinalsVoiceRecordingStep) {
        [[UIView appearance] setTintColor:[UIColor appTertiaryBlueColor]];
    }
    if (self.voiceRecordingStepOrdinal == PhonationStepOrdinalsConclusionStep) {
        [[UIView appearance] setTintColor:[UIColor appTertiaryColor1]];
    }
    self.voiceRecordingStepOrdinal = self.voiceRecordingStepOrdinal + 1;
}

- (void) taskViewController: (ORKTaskViewController *) taskViewController
        didFinishWithResult: (ORKTaskViewControllerResult) result
                      error: (NSError *) error
{
    [[UIView appearance] setTintColor: [UIColor appPrimaryColor]];

    if (result == ORKTaskViewControllerResultFailed && error != nil)
    {
        APCLogError2 (error);
    } else if (result == ORKTaskViewControllerResultCompleted) {
        APHAppDelegate *appDelegate = (APHAppDelegate *) [UIApplication sharedApplication].delegate;
        appDelegate.dataSubstrate.currentUser.taskCompletion = [NSDate date];
    }

    [super taskViewController: taskViewController
          didFinishWithResult: result
                        error: error];
}

#pragma  mark  -  Results For Dashboard

- (NSString *)createResultSummary
{
    ORKTaskResult  *taskResults = self.result;
    ORKFileResult  *fileResult = nil;
    BOOL  found = NO;
    for (ORKStepResult  *stepResult  in  taskResults.results) {
        if (stepResult.results.count > 0) {
            for (id  object  in  stepResult.results) {
                if ([object isKindOfClass:[ORKFileResult class]] == YES) {
                    found = YES;
                    fileResult = object;
                    break;
                }
            }
            if (found == YES) {
                break;
            }
        }
    }
    
    double scoreSummary = [PDScores scoreFromPhonationTest: fileResult.fileURL];
    scoreSummary = isnan(scoreSummary) ? 0 : scoreSummary;
    
    NSDictionary  *summary = @{kScoreSummaryOfRecordsKey : @(scoreSummary)};
    
    NSError  *error = nil;
    NSData  *data = [NSJSONSerialization dataWithJSONObject:summary options:0 error:&error];
    NSString  *contentString = nil;
    if (data == nil) {
        APCLogError2 (error);
    } else {
        contentString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return  contentString;
}

#pragma  mark  - View Controller methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBar.topItem.title = NSLocalizedString(kTaskViewControllerTitle, nil);
    
    self.voiceRecordingStepOrdinal = PhonationStepOrdinalsIntroductionStep;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

@end
