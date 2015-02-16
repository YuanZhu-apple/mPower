// 
//  APHWalkingTaskViewController.m 
//  mPower 
// 
//  Copyright (c) 2014 Apple, Inc. All rights reserved. 
// 
 
#import "APHWalkingTaskViewController.h"
#import <HealthKit/HealthKit.h>
#import <AVFoundation/AVFoundation.h>

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
    NSDictionary  *summary = @{  @"value" : @(self.collectedNumberOfSteps) };
    
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

- (void)taskViewControllerDidComplete:(ORKTaskViewController *)taskViewController
{
    [[UIView appearance] setTintColor:[UIColor appPrimaryColor]];
    
    [super taskViewControllerDidComplete:taskViewController];
    
}

- (void)taskViewControllerDidCancel:(ORKTaskViewController *)taskViewController
{
    [[UIView appearance] setTintColor:[UIColor appPrimaryColor]];
    
    [super taskViewControllerDidCancel:taskViewController];
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
