// 
//  APHWalkingTaskViewController.m 
//  mPower 
// 
//  Copyright (c) 2014 Apple, Inc. All rights reserved. 
// 
 
#import "APHWalkingTaskViewController.h"
#import <HealthKit/HealthKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ConverterForPDScores.h"
#import "PDScores.h"
#import "APHAppDelegate.h"

typedef  enum  _WalkingStepOrdinals
{
    WalkingStepOrdinalsInstructionStep = 0,
    WalkingStepOrdinalsCountdownStep,
    WalkingStepOrdinalsWalkOutStep,
    WalkingStepOrdinalsWalkBackStep,
    WalkingStepOrdinalsStandStillStep,
    WalkingStepOrdinalsConclusionStep,
}  WalkingStepOrdinals;

static NSString *const kMomentInDay                             = @"momentInDay";
static NSString *const kMomentInDayFormat                       = @"momentInDayFormat";
static NSString *const kMomentInDayFormatItemText               = @"When are you performing this Activity?";
static NSString *const kMomentInDayFormatChoiceJustWokeUp       = @"Immediately before Parkinson medication";
static NSString *const kMomentInDayFormatChoiceTookMyMedicine   = @"Just after Parkinson medication (at your best)";
static NSString *const kMomentInDayFormatChoiceEvening          = @"Another time";
static NSString *const kMomentInDayFormatChoiceNone             = @"I don't take Parkinson medications";

static double kMinimumAmountOfTimeToShowSurvey = 20.0 * 60.0;

static  NSString       *kWalkingActivityTitle     = @"Walking Activity";

static  NSUInteger      kNumberOfStepsPerLeg      = 20;
static  NSTimeInterval  kStandStillDuration       = 30.0;

static  NSString       *kConclusionStepIdentifier = @"conclusion";

NSString  *kScoreForwardGainRecordsKey = @"ScoreForwardGainRecords";
NSString  *kScoreBackwardGainRecordsKey = @"ScoreBackwardGainRecords";
NSString  *kScorePostureRecordsKey = @"ScorePostureRecords";
NSString * const kGaitScoreKey = @"GaitScoreKey";

@interface APHWalkingTaskViewController  ( )

@property  (nonatomic, assign)  WalkingStepOrdinals  walkingStepOrdinal;

@property  (nonatomic, strong)  NSDate              *startCollectionDate;
@property  (nonatomic, strong)  NSDate              *endCollectionDate;

@property  (nonatomic, assign)  NSInteger  __block   collectedNumberOfSteps;

@end

@implementation APHWalkingTaskViewController

#pragma  mark  -  Initialisation

+ (ORKOrderedTask *)createTask:(APCScheduledTask *) __unused scheduledTask
{
    ORKOrderedTask  *task = [ORKOrderedTask shortWalkTaskWithIdentifier:kWalkingActivityTitle
                                                 intendedUseDescription:nil
                                                    numberOfStepsPerLeg:kNumberOfStepsPerLeg
                                                           restDuration:kStandStillDuration
                                                                options:ORKPredefinedTaskOptionNone];
    
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
        
        task = [[ORKOrderedTask alloc] initWithIdentifier:kWalkingActivityTitle
                                                    steps:twoFingerSteps];
    }
    
    return  task;
}

#pragma  mark  -  Create Dashboard Summary Results

- (NSString *)createResultSummary
{
    ORKTaskResult  *taskResults = self.result;
    self.createResultSummaryBlock = ^(NSManagedObjectContext * context) {
        BOOL  found = NO;
        NSURL * urlGaitForward = nil;
        NSURL * urlGaitBackward = nil;
        NSURL * urlPosture = nil;
        for (ORKStepResult  *stepResult  in  taskResults.results) {
            if (stepResult.results.count > 0) {
                for (id  object  in  stepResult.results) {
                    if ([object isKindOfClass:[ORKFileResult class]] == YES) {
                        ORKFileResult * fileResult = object;
                        if ([fileResult.fileURL.absoluteString.lastPathComponent hasPrefix: @"accel_walking.outbound"]) {
                            urlGaitForward = fileResult.fileURL;
                        } else if ([fileResult.fileURL.absoluteString.lastPathComponent hasPrefix: @"accel_walking.return"]) {
                            urlGaitBackward = fileResult.fileURL;
                        } else if ([fileResult.fileURL.absoluteString.lastPathComponent hasPrefix: @"accel_walking.rest"]) {
                            urlPosture = fileResult.fileURL;
                        }
                        found = YES;
                        fileResult = object;
                    }
                }
            }
        }
        
        NSArray * forwardSteps = [ConverterForPDScores convertPostureOrGain:urlGaitForward];
        NSArray * backwardSteps = [ConverterForPDScores convertPostureOrGain:urlGaitBackward];
        NSArray * posture = [ConverterForPDScores convertPostureOrGain:urlPosture];
        
        double forwardScores = [PDScores scoreFromGaitTest: forwardSteps];
        double backwardScores = [PDScores scoreFromGaitTest: backwardSteps];
        double postureScores = [PDScores scoreFromPostureTest: posture];
        
        forwardScores = isnan(forwardScores) ? 0 : forwardScores;
        backwardScores = isnan(backwardScores) ? 0 : backwardScores;
        postureScores = isnan(postureScores) ? 0 : postureScores;
        
        double avgScores = (forwardScores + backwardScores + postureScores) / 3;
        
        NSDictionary  *summary = @{
                                   kGaitScoreKey: @(avgScores),
                                   kScoreForwardGainRecordsKey: @(forwardScores),
                                   kScoreBackwardGainRecordsKey: @(backwardScores),
                                   kScorePostureRecordsKey: @(postureScores)
                                  };
        
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
    return  nil;
}

#pragma  mark  -  Task View Controller Delegate Methods

- (void)taskViewController:(ORKTaskViewController *) __unused taskViewController stepViewControllerWillAppear:(ORKStepViewController *)stepViewController
{
    if ([stepViewController.step.identifier isEqualToString:kConclusionStepIdentifier]) {
        [[UIView appearance] setTintColor:[UIColor appTertiaryColor1]];
    }
    
    if (self.walkingStepOrdinal == WalkingStepOrdinalsWalkOutStep) {
        self.startCollectionDate = [NSDate date];
    }
    if (self.walkingStepOrdinal == WalkingStepOrdinalsStandStillStep) {
        self.endCollectionDate = [NSDate date];
        
        NSTimeZone  *timezone = [NSTimeZone localTimeZone];
        
        NSDate  *adjustedStartDate = [self.startCollectionDate dateByAddingTimeInterval:timezone.secondsFromGMT];
        NSDate  *adjustedEndDate   = [self.endCollectionDate   dateByAddingTimeInterval:timezone.secondsFromGMT];

        HKQuantityType  *stepCountType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
        NSPredicate  *predicate = [HKQuery predicateForSamplesWithStartDate:adjustedStartDate endDate:adjustedEndDate options:HKQueryOptionNone];

        HKStatisticsQuery  *query = [[HKStatisticsQuery alloc] initWithQuantityType:stepCountType
                                                            quantitySamplePredicate:predicate
                                                                            options:HKStatisticsOptionCumulativeSum
                                                                  completionHandler:^(HKStatisticsQuery * __unused query, HKStatistics *result, NSError *error) {
                                                                      if (result != nil) {
                                                                          self.collectedNumberOfSteps = [result.sumQuantity doubleValueForUnit:[HKUnit countUnit]];
                                                                      } else {
                                                                          APCLogError2 (error);
                                                                      }
                                                                  }];
        HKHealthStore  *healthStore = [HKHealthStore new];
        [healthStore executeQuery:query];
    }
    if (self.walkingStepOrdinal == WalkingStepOrdinalsConclusionStep) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        AVSpeechUtterance  *talk = [AVSpeechUtterance
                                    speechUtteranceWithString:NSLocalizedString(@"You have completed the activity.", @"You have completed the activity.")];
        AVSpeechSynthesizer  *synthesiser = [[AVSpeechSynthesizer alloc] init];
        talk.rate = 0.1;
        [synthesiser speakUtterance:talk];
    }
    self.walkingStepOrdinal = self.walkingStepOrdinal + 1;
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

#pragma  mark  -  View Controller Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.walkingStepOrdinal = WalkingStepOrdinalsInstructionStep;
    
    self.navigationBar.topItem.title = NSLocalizedString(kWalkingActivityTitle, nil);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

@end
