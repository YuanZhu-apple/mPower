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

typedef  enum  _WalkingStepOrdinals
{
    WalkingStepOrdinalsInstructionStep = 0,
    WalkingStepOrdinalsCountdownStep,
    WalkingStepOrdinalsWalkOutStep,
    WalkingStepOrdinalsWalkBackStep,
    WalkingStepOrdinalsStandStillStep,
    WalkingStepOrdinalsConclusionStep,
}  WalkingStepOrdinals;

static  NSString       *kWalkingActivityTitle     = @"Walking Activity";

static  NSUInteger      kNumberOfStepsPerLeg      = 20;
static  NSTimeInterval  kStandStillDuration       = 30.0;

static  NSString       *kConclusionStepIdentifier = @"conclusion";

NSString  *kScoreForwardGainRecordsKey = @"ScoreForwardGainRecords";
NSString  *kScoreBackwardGainRecordsKey = @"ScoreBackwardGainRecords";
NSString  *kScorePostureRecordsKey = @"ScorePostureRecords";

@interface APHWalkingTaskViewController  ( )

@property  (nonatomic, assign)  WalkingStepOrdinals  walkingStepOrdinal;

@property  (nonatomic, strong)  NSDate              *startCollectionDate;
@property  (nonatomic, strong)  NSDate              *endCollectionDate;

@property  (nonatomic, assign)  NSInteger  __block   collectedNumberOfSteps;

@end

@implementation APHWalkingTaskViewController

#pragma  mark  -  Initialisation

+ (ORKOrderedTask *)createTask:(APCScheduledTask *)scheduledTask
{
    ORKOrderedTask  *task = [ORKOrderedTask shortWalkTaskWithIdentifier:kWalkingActivityTitle
                                                 intendedUseDescription:nil
                                                    numberOfStepsPerLeg:kNumberOfStepsPerLeg
                                                           restDuration:kStandStillDuration
                                                                options:ORKPredefinedTaskOptionNone];
    return  task;
}

#pragma  mark  -  Create Dashboard Summary Results

- (NSString *)createResultSummary
{
    ORKTaskResult  *taskResults = self.result;
    ORKFileResult  *fileResult = nil;
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
    
    NSDictionary  *summary = @{  @"value" : @(self.collectedNumberOfSteps), kScoreForwardGainRecordsKey: @(forwardScores), kScoreBackwardGainRecordsKey: @(backwardScores), kScorePostureRecordsKey: @(postureScores) };
    
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

#pragma  mark  -  Task View Controller Delegate Methods

- (void)taskViewController:(ORKTaskViewController *)taskViewController stepViewControllerWillAppear:(ORKStepViewController *)stepViewController
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
                                                                  completionHandler:^(HKStatisticsQuery *query, HKStatistics *result, NSError *error) {
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
