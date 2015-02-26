//
//  APHSpatialSpanMemoryGameViewController.m
//  mPower
//
//  Copyright (c) 2014–2015 Apple, Inc. All rights reserved.
//

#import "APHSpatialSpanMemoryGameViewController.h"

static  NSString       *kTaskViewControllerTitle      = @"Memory Activity";

static  NSString       *kMemorySpanTitle              = @"Memory Activity";

static  NSString       *kConclusionStepIdentifier     = @"conclusion";

NSString * const kSpatialMemoryScoreSummaryKey = @"spatialMemoryScoreSummaryKey";

static  NSInteger       kInitialSpan                  =  3;
static  NSInteger       kMinimumSpan                  =  2;
static  NSInteger       kMaximumSpan                  =  15;
static  NSTimeInterval  kPlaySpeed                    = 1.0;
static  NSInteger       kMaximumTests                 = 5;
static  NSInteger       kMaxConsecutiveFailures       =  3;
static  NSString       *kCustomTargetPluralName       = nil;
static  BOOL            kRequiresReversal             = NO;

@interface APHSpatialSpanMemoryGameViewController ()

@end

@implementation APHSpatialSpanMemoryGameViewController

#pragma  mark  -  Task Creation Methods

+ (ORKOrderedTask *)createTask:(APCScheduledTask *)scheduledTask
{
        ORKOrderedTask  *task = [ORKOrderedTask spatialSpanMemoryTaskWithIdentifier:kMemorySpanTitle
            intendedUseDescription:nil
            initialSpan:kInitialSpan
            minimumSpan:kMinimumSpan
            maximumSpan:kMaximumSpan
            playSpeed:kPlaySpeed
            maxTests:kMaximumTests
            maxConsecutiveFailures:kMaxConsecutiveFailures
            customTargetImage:nil
            customTargetPluralName:kCustomTargetPluralName
            requireReversal:kRequiresReversal
            options:ORKPredefinedTaskOptionNone];
    
    [[UIView appearance] setTintColor:[UIColor appPrimaryColor]];
    
    return  task;
}

#pragma  mark  -  Task View Controller Delegate Methods

- (void)taskViewController:(ORKTaskViewController *)taskViewController stepViewControllerWillAppear:(ORKStepViewController *)stepViewController
{
    
    if ([stepViewController.step.identifier isEqualToString:kConclusionStepIdentifier]) {
        [[UIView appearance] setTintColor:[UIColor appTertiaryColor1]];
    }
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

#pragma mark - Results for Dashboard

- (NSString *)createResultSummary
{
    ORKTaskResult  *taskResults = self.result;
    self.createResultSummaryBlock = ^(NSManagedObjectContext * context) {
        ORKSpatialSpanMemoryResult  *memoryResults = nil;
        BOOL  found = NO;
        for (ORKStepResult  *stepResult  in  taskResults.results) {
            if (stepResult.results.count > 0) {
                for (id  object  in  stepResult.results) {
                    if ([object isKindOfClass:[ORKSpatialSpanMemoryResult class]] == YES) {
                        found = YES;
                        memoryResults = object;
                        break;
                    }
                }
                if (found == YES) {
                    break;
                }
            }
        }
        
        // Create the summary dictionary
        NSDictionary *summary = @{kSpatialMemoryScoreSummaryKey: @(memoryResults.score)};
        
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

#pragma  mark  -  View Controller Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBar.topItem.title = NSLocalizedString(kTaskViewControllerTitle, nil);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
