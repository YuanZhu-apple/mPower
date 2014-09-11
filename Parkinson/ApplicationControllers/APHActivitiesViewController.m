//
//  APHActivitiesViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 8/20/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

/* ViewControllers */
#import "APHActivitiesViewController.h"
#import "APHWalkingOverviewViewController.h"
#import "APHWalkingStepsViewController.h"
#import "APHWalkingResultsViewController.h"
#import "APHWalkingTaskViewController.h"
#import "APHPhonationTaskViewController.h"
#import "APHSleepQualityTaskViewController.h"
#import "APHChangedMedsTaskViewController.h"
#import "APHIntervalTappingTaskViewController.h"
#import "APHTracingObjectsTaskViewController.h"

/* Views */
#import "APHActivitiesTableViewCell.h"

/* Model */
#import "APCScheduledTask.h"

/* Other Classes */
#import "NSString+CustomMethods.h"
#import "NSManagedObject+APCHelper.h"
#import "APHStepDictionaryKeys.h"
#import "UIColor+Parkinson.h"
#import "APHParkinsonAppDelegate.h"
#import <ResearchKit/ResearchKit.h>

static  NSInteger  kNumberOfSectionsInTableView = 1;

static  NSString   *kTableCellReuseIdentifier = @"ActivitiesTableViewCell";
static  NSString   *kViewControllerTitle      = @"Activities";

@interface APHActivitiesViewController () <RKTaskViewControllerDelegate, RKStepViewControllerDelegate>

@property  (nonatomic, strong)            NSArray                *rowTitles;
@property  (nonatomic, strong)            NSArray                *rowSubTitles;

@property  (nonatomic, strong)            NSIndexPath            *selectedIndexPath;
@property (nonatomic, strong) NSMutableArray *scheduledTasksArray;
@end

@implementation APHActivitiesViewController

#pragma mark - Init

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        _scheduledTasksArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Activities";

    [self.tableView registerNib:[UINib nibWithNibName:@"APHActivitiesTableViewCell" bundle:nil] forCellReuseIdentifier:kTableCellReuseIdentifier];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.selectedIndexPath != nil) {
        [self.tableView deselectRowAtIndexPath:self.selectedIndexPath animated:YES];
        self.selectedIndexPath = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  kNumberOfSectionsInTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.scheduledTasksArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    APHActivitiesTableViewCell  *cell = (APHActivitiesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kTableCellReuseIdentifier];
    
    APCScheduledTask *scheduledTask = self.scheduledTasksArray[indexPath.row];
    
    cell.titleLabel.text = scheduledTask.task.taskType;
    
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

#pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  70.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 30)];
    [headerView.contentView setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1.0]];
    
    switch (section) {
        case 0:
            headerView.textLabel.text = @"Today";
            break;
        
        default://TODO: Assert
            break;
    }
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray  *controllerClasses = @[
                                    [APHWalkingTaskViewController         class],
                                    [APHPhonationTaskViewController       class],
                                    [APHSleepQualityTaskViewController    class],
                                    [APHChangedMedsTaskViewController     class],
                                    [APHIntervalTappingTaskViewController class],
                                    [APHTracingObjectsTaskViewController  class]
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

- (IBAction)updateActivities:(id)sender
{
    NSFetchRequest * request = [APCScheduledTask request];
//    request.predicate = [NSPredicate predicateWithFormat:@"dueOn == %@",[NSDate date]];
    NSError * error;
    NSManagedObjectContext *context = ((APHParkinsonAppDelegate *)[UIApplication sharedApplication].delegate).dataSubstrate.mainContext;
    
    NSArray *scheduledTasks = [context executeFetchRequest:request error:&error];
    self.scheduledTasksArray = [NSMutableArray arrayWithArray:scheduledTasks];
    
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

@end
