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
//    RKSTResult  *aStepResult = [self.result resultForIdentifier:kIntervalTappingStep103];
//    NSArray  *stepResults = nil;
//    if ([aStepResult isKindOfClass:[RKSTStepResult class]] == YES) {
//        stepResults = [(RKSTStepResult *)aStepResult results];
//    }
//    NSString  *contentString = @"";
//    if (stepResults != nil) {
//        RKSTResult  *aDataResult = [stepResults lastObject];
//        if ([aDataResult isKindOfClass:[APCDataResult class]] == YES) {
//            NSData  *data = [(APCDataResult *)aDataResult data];
//            
//            NSError  *error = nil;
//            NSDictionary  *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
//            NSArray  *records = [dictionary objectForKey:kIntervalTappingRecordsKey];
//            
//            NSDictionary  *summary = @{ kSummaryNumberOfRecordsKey : @([records count]) };
//            NSError  *serializationError = nil;
//            NSData  *summaryData = [NSJSONSerialization dataWithJSONObject:summary options:0 error:&serializationError];
//            
//            contentString = [[NSString alloc] initWithData:summaryData encoding:NSUTF8StringEncoding];
//        }
//    }
    return @"";
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
