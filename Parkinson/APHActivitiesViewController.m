//
//  APHActivitiesViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 8/20/14.
//  Copyright (c) 2014 Henry McGilton. All rights reserved.
//

#import "APHActivitiesViewController.h"

#import "APHWalkingOverviewViewController.h"
#import "APHActivitiesViewControllerWalking.h"

#import "APHWalkingStepsViewController.h"
#import "APHWalkingResultsViewController.h"

#import "APHPhonationOverviewViewController.h"
#import "APHSleepQualityOverviewViewController.h"
#import "APHChangedMedsOverviewViewController.h"
#import "APHIntervalOverviewViewController.h"
#import "APHTracingOverviewViewController.h"

#import "APHActivitiesTableViewCell.h"
#import "NSString+CustomMethods.h"
#import "APHStepDictionaryKeys.h"

#import <ResearchKit/ResearchKit.h>

static  NSInteger  kNumberOfSectionsInTableView = 1;

static  NSString   *kTableCellReuseIdentifier = @"ActivitiesTableViewCell";
static  NSString   *kViewControllerTitle      = @"Activities";

@interface APHActivitiesViewController () <UITableViewDataSource, UITableViewDelegate, RKTaskViewControllerDelegate, RKStepViewControllerDelegate>

@property  (nonatomic, strong)  IBOutlet  UITableView            *tabulator;

@property  (nonatomic, strong)            NSArray                *rowTitles;
@property  (nonatomic, strong)            NSArray                *rowSubTitles;

@property  (nonatomic, strong)            NSIndexPath            *selectedIndexPath;

@end

@implementation APHActivitiesViewController

#pragma  mark  -  Table View Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  kNumberOfSectionsInTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [self.rowTitles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    APHActivitiesTableViewCell  *cell = (APHActivitiesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kTableCellReuseIdentifier];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.title.text = self.rowTitles[indexPath.row];
    if ([self.rowTitles[indexPath.row] hasContent] == YES) {
        cell.subTitle.text = self.rowSubTitles[indexPath.row];
    }
    if (indexPath.row == 4) {
        cell.completed = YES;
    }
    
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  44.0;
}

#pragma  mark  -  Table View Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;
    
    NSArray  *controllerClasses = @[
                                    [APHWalkingOverviewViewController      class],
                                    [APHPhonationOverviewViewController    class],
                                    [APHSleepQualityOverviewViewController class],
                                    [APHChangedMedsOverviewViewController  class],
                                    [APHIntervalOverviewViewController     class],
                                    [APHTracingOverviewViewController      class]
                                ];
    if (indexPath.row < [controllerClasses count]) {
        if (indexPath.row == 0) {
            [self createWalkingTask];
        }
//        Class  class = controllerClasses[indexPath.row];
//        if (class != [NSNull class]) {
//            UIViewController  *controller = [[class alloc] initWithNibName:nil bundle:nil];
//            [self.navigationController pushViewController:controller animated:YES];
//        }
    }
}

#pragma  mark  -  Task View Controller Delegate Methods

- (void)taskViewControllerDidComplete: (RKTaskViewController *)taskViewController
{
    NSLog(@"taskViewControllerDidComplete");
}

- (void)taskViewController: (RKTaskViewController *)taskViewController didFailWithError:(NSError*)error
{
    NSLog(@"taskViewController didFailWithError = %@", error);
}

- (void)taskViewControllerDidCancel:(RKTaskViewController *)taskViewController
{
    NSLog(@"taskViewController taskViewControllerDidCancel");
}

- (BOOL)taskViewController:(RKTaskViewController *)taskViewController shouldShowMoreInfoOnStep:(RKStep *)step
{
    NSLog(@"taskViewController shouldShowMoreInfoOnStep");
    return  YES;
}

- (RKStepViewController *)taskViewController:(RKTaskViewController *)taskViewController viewControllerForStep:(RKStep *)step
{
    NSLog(@"taskViewController viewControllerForStep = %@", step);
    
    RKStepViewController  *controller = nil;
    
    if ([step.identifier isEqualToString:@"Walking 101"] == YES) {
        controller = [[APHWalkingOverviewViewController alloc] initWithStep:step];
    } else if ([step.identifier isEqualToString:@"Walking 102"] == YES) {
        controller = [[APHWalkingStepsViewController alloc] initWithStep:step];
        ((APHWalkingStepsViewController *)controller).walkingPhase = WalkingStepsPhaseWalkSomeDistance;
    } else if ([step.identifier isEqualToString:@"Walking 103"] == YES) {
        controller = [[APHWalkingStepsViewController alloc] initWithStep:step];
        ((APHWalkingStepsViewController *)controller).walkingPhase = WalkingStepsPhaseWalkBackToBase;
    } else if ([step.identifier isEqualToString:@"Walking 104"] == YES) {
        controller = [[APHWalkingStepsViewController alloc] initWithStep:step];
        ((APHWalkingStepsViewController *)controller).walkingPhase = WalkingStepsPhaseStandStill;
    } else if ([step.identifier isEqualToString:@"Walking 105"] == YES) {
        controller = [[APHWalkingResultsViewController alloc] initWithStep:step];
    }
    controller.delegate = self;
    return  controller;
}

- (BOOL)taskViewController:(RKTaskViewController *)taskViewController shouldPresentStep:(RKStep*)step
{
//     NSLog(@"taskViewController shouldPresentStep = %@", step);
    return  YES;
}

- (void)taskViewController:(RKTaskViewController *)taskViewController
        willPresentStepViewController:(RKStepViewController *)stepViewController
{
    NSLog(@"taskViewController willPresentStepViewController = %@", stepViewController.step.identifier);
//    if ([stepViewController.step.identifier isEqualToString:@"Walking 101"] == YES) {
//        NSLog(@"taskViewController willPresentStepViewController = %@", stepViewController.step.identifier);
//    } else if ([stepViewController.step.identifier isEqualToString:@"Walking 102"] == YES) {
//        NSLog(@"taskViewController willPresentStepViewController = %@", stepViewController.step.identifier);
//    }
}

- (void)taskViewController:(RKTaskViewController *)taskViewController didReceiveLearnMoreEventFromStepViewController:(RKStepViewController *)stepViewController
{
    NSLog(@"taskViewController didReceiveLearnMoreEventFromStepViewController");
}

#pragma  mark  -  Step View Controller Delegate Methods

//- (void)stepViewControllerWillBePresented:(RKStepViewController *)viewController
//{
//    NSLog(@"stepViewControllerWillBePresented");
//}
//
//- (void)stepViewControllerDidFinish:(RKStepViewController *)stepViewController navigationDirection:(RKStepViewControllerNavigationDirection)direction
//{
//    NSLog(@"stepViewControllerDidFinish");
//}
//
//- (void)stepViewControllerDidFail:(RKStepViewController *)stepViewController withError:(NSError*)error
//{
//    NSLog(@"stepViewControllerDidFail");
//}
//
//- (void)stepViewControllerDidCancel:(RKStepViewController *)stepViewController
//{
//    NSLog(@"stepViewControllerDidCancel");
//}

#pragma  mark  -  View Controller Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Activities";
    
    self.rowTitles = @[
                       @"Timed Walking",
                       @"Sustained Phonation",
                       @"Did you sleep well last night?",
                       @"Have you recently changed medications?",
                       @"Interval Tapping",
                       @"Tracing Objects"
                       ];
    
    self.rowSubTitles = @[
                       @"Afternoon and Evening Remaining",
                       @"Evening Remaining",
                       @"",
                       @"",
                       @"Morning, Evening and Night Completed",
                       @"Completed"
                       ];
    
    self.keysToPropertiesMap = @{
                               APHActiveCountDownKey              : APHActiveCountDownPropKey,
                               APHActiveBuzzKey                   : APHActiveBuzzPropKey,
                               APHActiveVibrationKey              : APHActiveVibrationPropKey,
                               APHActiveTextKey                   : APHActiveTextPropKey,
                               APHActiveVoicePromptKey            : APHActiveVoicePromptPropKey,
                               APHActiveRecorderConfigurationsKey : APHActiveRecorderConfigurationsPropKey,
                               
                               APHConsentConsentPdfFileKey        : APHConsentConsentPdfFilePropKey,
                               
                               APHIntroductionTitleTextKey        : APHIntroductionTitleTextPropKey,
                               APHIntroductionDescriptionTextKey  : APHIntroductionDescriptionTextPropKey,
                               
                               APHMediaRequestKey                 : APHMediaRequestPropKey,
                               APHMediaMediaTypeKey               : APHMediaMediaTypePropKey,
                               APHMediaAllowsEditingKey           : APHMediaAllowsEditingPropKey,
                               
                               APHQuestionOptionalKey             : APHQuestionOptionalPropKey,
                               APHQuestionQuestionKey             : APHQuestionQuestionPropKey,
                               APHQuestionPromptKey               : APHQuestionPromptPropKey,
                               APHQuestionAnswerFormatKey         : APHQuestionAnswerFormatPropKey,
                               
                               };
    
    UINib  *tableCellNib = [UINib nibWithNibName:@"APHActivitiesTableViewCell" bundle:[NSBundle mainBundle]];
    [self.tabulator registerNib:tableCellNib forCellReuseIdentifier:kTableCellReuseIdentifier ];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.selectedIndexPath != nil) {
        [self.tabulator deselectRowAtIndexPath:self.selectedIndexPath animated:YES];
        self.selectedIndexPath = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
