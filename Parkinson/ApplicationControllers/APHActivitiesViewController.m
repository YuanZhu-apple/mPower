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
#import "UIColor+Parkinson.h"
#import "APHParkinsonAppDelegate.h"
#import <ResearchKit/ResearchKit.h>

@interface APCGroupedScheduledTask : NSObject

@property (strong, nonatomic) NSMutableArray *scheduledTasks;
@property (strong, nonatomic) NSString *taskType;
@property (strong, nonatomic) NSString *taskTitle;
@property (strong, nonatomic) NSString *taskClassName;
@property (nonatomic, readonly) NSUInteger completedTasksCount;
@property (nonatomic, readonly, getter=isComplete) BOOL complete;

@end

/* ************************************** */



static NSString *kTableCellReuseIdentifier = @"ActivitiesTableViewCell";

static CGFloat kTableViewRowHeight = 70;
static CGFloat kTableViewSectionHeaderHeight = 30;
static NSInteger kNumberOfSectionsInTableView = 1;

@interface APHActivitiesViewController () <RKTaskViewControllerDelegate, RKStepViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray *scheduledTasksArray;

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
    
    self.navigationItem.title = NSLocalizedString(@"Activities", @"Activities");

    [self.tableView registerNib:[UINib nibWithNibName:@"APHActivitiesTableViewCell" bundle:nil] forCellReuseIdentifier:kTableCellReuseIdentifier];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadData];
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
    
    id task = self.scheduledTasksArray[indexPath.row];
    
    if ([task isKindOfClass:[APCGroupedScheduledTask class]]) {
        
        cell.type = kActivitiesTableViewCellTypeSubtitle;
        
        APCGroupedScheduledTask *groupedScheduledTask = (APCGroupedScheduledTask *)task;
        
        cell.titleLabel.text = groupedScheduledTask.taskTitle;
        
        NSUInteger tasksCount = groupedScheduledTask.scheduledTasks.count;
        NSUInteger completedTasksCount = groupedScheduledTask.completedTasksCount;
        
        cell.subTitleLabel.text = [NSString stringWithFormat:@"%lu/%lu %@", (unsigned long)completedTasksCount, (unsigned long)tasksCount, NSLocalizedString(@"Tasks Completed", nil)];
        
        cell.completed = groupedScheduledTask.complete;
        
    } else if ([task isKindOfClass:[APCScheduledTask class]]){
        
        cell.type = kActivitiesTableViewCellTypeDefault;
        
        APCScheduledTask *scheduledTask = (APCScheduledTask *)task;
        
        cell.titleLabel.text = scheduledTask.task.taskTitle;
        cell.completed = scheduledTask.completed.boolValue;
        
    } else{
        //Handle all cases in ifElse statements. May handle NSAssert here.
    }
    
    return  cell;
}

#pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  kTableViewRowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kTableViewSectionHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), kTableViewSectionHeaderHeight)];
    [headerView.contentView setBackgroundColor:[UIColor parkinsonLightGrayColor]];
    
    switch (section) {
        case 0:
            headerView.textLabel.text = NSLocalizedString(@"Today", @"Today");
            break;
        
        default:{
            NSAssert(0, @"Invalid Section");
        }
            break;
    }
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id task = self.scheduledTasksArray[indexPath.row];
    NSString *taskType;
    
    if ([task isKindOfClass:[APCGroupedScheduledTask class]]) {
        
        APCGroupedScheduledTask *groupedScheduledTask = (APCGroupedScheduledTask *)task;
        taskType = groupedScheduledTask.taskType;
        
        NSString *taskClass = groupedScheduledTask.taskClassName;
        
        Class  class = [NSClassFromString(taskClass) class];
        
        if (class != [NSNull class]) {

            
            NSDate *currentDate = [NSDate date];
            NSInteger taskIndex = -1;
            
            for (int i =0; i<groupedScheduledTask.scheduledTasks.count; i++) {
                APCScheduledTask *scheduledTask = groupedScheduledTask.scheduledTasks[i];
                
                if ([currentDate compare:scheduledTask.dueOn] == NSOrderedAscending) {
                    taskIndex = i;
                    break;
                }else {
                    NSLog(@"The dueOn date for this task is older than the current time. Ignore this task.");
                }
            }
            
            if (taskIndex != -1) {
                APHSetupTaskViewController *controller = [class customTaskViewController:groupedScheduledTask.scheduledTasks[taskIndex]];
                [self presentViewController:controller animated:YES completion:nil];
            } else {
                //TODO: The user has tapped on an old task for the day (dueOn date is earlier than current time). May present alert.
            }
        }
        
    } else {
        APCScheduledTask *scheduledTask = (APCScheduledTask *)task;
        taskType = scheduledTask.task.taskType;
        
        NSString *taskClass = scheduledTask.task.taskClassName;
        
        Class  class = [NSClassFromString(taskClass) class];
        
        if (class != [NSNull class]) {
            APHSetupTaskViewController *controller = [class customTaskViewController:scheduledTask];
            [self presentViewController:controller animated:YES completion:nil];
        }
    }
}

#pragma mark - Update methods

- (IBAction)updateActivities:(id)sender
{
    [self reloadData];
    [self.refreshControl endRefreshing];
}

- (void)reloadData
{
    [self.scheduledTasksArray removeAllObjects];
    
    NSSortDescriptor *dateSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"dueOn" ascending:YES];
    NSArray *unsortedScheduledTasks = [((APHParkinsonAppDelegate *)[UIApplication sharedApplication].delegate).dataSubstrate  scheduledTasksForPredicate:nil sortDescriptors:@[dateSortDescriptor]];
    
    [self groupSimilarTasks:unsortedScheduledTasks];
    
    [self.tableView reloadData];
}

#pragma mark - Sort and Group Task

- (void)groupSimilarTasks:(NSArray *)unsortedScheduledTasks
{
    NSMutableArray *taskTypesArray = [[NSMutableArray alloc] init];
    
    /* Get the list of task Ids to group */
    
    for (APCScheduledTask *scheduledTask in unsortedScheduledTasks) {
        NSString *taskId = scheduledTask.task.uid;
        
        if (![taskTypesArray containsObject:taskId]) {
            [taskTypesArray addObject:taskId];
        }
    }
    
    /* group tasks by task Id */
    for (NSString *taskId in taskTypesArray) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"task.uid == %@", taskId];
        
        NSArray *filteredTasksArray = [unsortedScheduledTasks filteredArrayUsingPredicate:predicate];
        
        if (filteredTasksArray.count > 1) {
            APCScheduledTask *scheduledTask = filteredTasksArray.firstObject;
            APCGroupedScheduledTask *groupedTask = [[APCGroupedScheduledTask alloc] init];
            groupedTask.scheduledTasks = [NSMutableArray arrayWithArray:filteredTasksArray];
            groupedTask.taskType = scheduledTask.task.taskType;
            groupedTask.taskTitle = scheduledTask.task.taskTitle;
            groupedTask.taskClassName = scheduledTask.task.taskClassName;
            
            [self.scheduledTasksArray addObject:groupedTask];
        } else{
            
            [self.scheduledTasksArray addObject:filteredTasksArray.firstObject];
        }
    }
}

@end

/*
 --------------------------------------------------
 APCGroupedSCheduledTask
 --------------------------------------------------
 */

@implementation APCGroupedScheduledTask

- (instancetype)init
{
    if (self = [super init]) {
        _scheduledTasks = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"Task Title : %@\nTask Type : %@\nTasks : %@", self.taskTitle, self.taskType, self.scheduledTasks];
}

- (NSUInteger)completedTasksCount
{
    NSUInteger count = 0;
    
    for (APCScheduledTask *scheduledTask in self.scheduledTasks) {
        if (scheduledTask.completed.boolValue) {
            count++;
        }
    }
    
    return count;
}

- (BOOL)isComplete
{
    return ([self completedTasksCount]/self.scheduledTasks.count);
}

@end
