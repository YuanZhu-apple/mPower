// 
//  APHIntervalTappingTaskViewController.m 
//  mPower 
// 
//  Copyright (c) 2014 Apple, Inc. All rights reserved. 
// 
 
#import "APHIntervalTappingTaskViewController.h"
#import "APHIntervalTappingRecorderDataKeys.h"

#import <AVFoundation/AVFoundation.h>

static  NSString       *kIntervalTappingTitle         = @"Finger Tapping Activity";
static  NSString       *kIntendedUseDescription       = @"Play The Finger Drums";
static  NSTimeInterval  kTappingStepCountdownInterval = 20.0;

@interface APHIntervalTappingTaskViewController  ( ) <NSObject>

@end

@implementation APHIntervalTappingTaskViewController

#pragma  mark  -  Task Creation Methods

+ (RKSTOrderedTask *)createTask:(APCScheduledTask *)scheduledTask
{
    RKSTOrderedTask  *task = [RKSTOrderedTask twoFingerTappingIntervalTaskWithIdentifier:kIntervalTappingTitle
                                                                  intendedUseDescription:kIntendedUseDescription
                                                                                duration:kTappingStepCountdownInterval
                                                                                 options:0];
    return  task;
}

#pragma  mark  -  Results For Dashboard

- (NSString *)createResultSummary
{
    RKSTTaskResult  *taskResults = self.result;
    RKSTTappingIntervalResult  *tapsterResults = nil;
    for (RKSTStepResult *stepResult  in  taskResults.results) {
        if (stepResult.results.count > 0) {
            if ([[stepResult.results firstObject] isKindOfClass:[RKSTTappingIntervalResult class]] == YES) {
                tapsterResults = [stepResult.results firstObject];
                break;
            }
        }
    }
    NSUInteger  numberOfSamples = 0;
    NSDictionary  *summary = nil;
    if (tapsterResults == nil) {
        summary = @{ kSummaryNumberOfRecordsKey : @(numberOfSamples) };
    } else {
        numberOfSamples = [tapsterResults.samples count];
        summary = @{ kSummaryNumberOfRecordsKey : @(numberOfSamples) };
    }
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

#pragma  mark  -  View Controller Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

@end
