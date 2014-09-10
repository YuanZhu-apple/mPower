//
//  APHActivitiesViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 8/20/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHActivitiesViewController.h"

#import "APHWalkingOverviewViewController.h"

#import "APHWalkingStepsViewController.h"
#import "APHWalkingResultsViewController.h"

#import "APHWalkingTaskViewController.h"

#import "APHPhonationTaskViewController.h"
#import "APHIntervalTappingTaskViewController.h"

#import "APHActivitiesTableViewCell.h"
#import "NSString+CustomMethods.h"
#import "APHStepDictionaryKeys.h"

#import <ResearchKit/ResearchKit.h>

static  NSInteger  kNumberOfSectionsInTableView = 1;

static  NSString   *kTableCellReuseIdentifier = @"ActivitiesTableViewCell";
static  NSString   *kViewControllerTitle      = @"Activities";

@interface APHActivitiesViewController () <RKTaskViewControllerDelegate, RKStepViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *activitiesTableView;

@property  (nonatomic, strong)            NSArray                *rowTitles;
@property  (nonatomic, strong)            NSArray                *rowSubTitles;

@property  (nonatomic, strong)            NSIndexPath            *selectedIndexPath;

@end

@implementation APHActivitiesViewController

#pragma mark - Init

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    
    return self;
}

#pragma mark - Lifecycle

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
    
    UINib  *tableCellNib = [UINib nibWithNibName:@"APHActivitiesTableViewCell" bundle:[NSBundle mainBundle]];
    [self.activitiesTableView registerNib:tableCellNib forCellReuseIdentifier:kTableCellReuseIdentifier];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.selectedIndexPath != nil) {
        [self.activitiesTableView deselectRowAtIndexPath:self.selectedIndexPath animated:YES];
        self.selectedIndexPath = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


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
    
    cell.titleLabel.text = self.rowTitles[indexPath.row];
    
    if ([self.rowSubTitles[indexPath.row] hasContent] == YES) {
        cell.type = APHActivitiesTableViewCellTypeSubtitle;
        cell.subTitleLabel.text = self.rowSubTitles[indexPath.row];
    } else {
        cell.type = APHActivitiesTableViewCellTypeDefault;
    }
    
    if (indexPath.row == 4) {
        cell.completed = YES;
    }
    
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  70.0;
}

#pragma  mark  -  Table View Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray  *controllerClasses = @[
                                    [APHWalkingTaskViewController      class],
                                    [APHPhonationTaskViewController    class],
                                    [APHIntervalTappingTaskViewController     class],
                                ];
    if (indexPath.row < [controllerClasses count]) {
        Class  class = controllerClasses[indexPath.row];
        if (class != [NSNull class]) {
            RKTaskViewController  *controller = [class customTaskViewController];
            
            [self presentViewController:controller animated:YES completion:^{
                NSLog(@"task Presented");
            }];
        }
    }
}

#pragma  mark  -  View Controller Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Activities";
    
    self.rowTitles = @[
                       @"Timed Walking",
                       @"Sustained Phonation",
                       @"Interval Tapping",
                       ];
    
    self.rowSubTitles = @[
                       @"",
                       @"",
                       @"",
                       ];
    
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
