// 
//  APHDashboardViewController.m 
//  mPower 
// 
//  Copyright (c) 2014 Apple, Inc. All rights reserved. 
// 
 
/* Controllers */
#import "APHDashboardViewController.h"
#import "APHDashboardEditViewController.h"
#import "APHIntervalTappingRecorderDataKeys.h"
#import "APHSpatialSpanMemoryGameViewController.h"
#import "APHWalkingTaskViewController.h"

static NSString * const kAPCBasicTableViewCellIdentifier       = @"APCBasicTableViewCell";
static NSString * const kAPCRightDetailTableViewCellIdentifier = @"APCRightDetailTableViewCell";

@interface APHDashboardViewController ()<UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) NSMutableArray *rowItemsOrder;

@property (nonatomic, strong) APCScoring *tapScoring;
@property (nonatomic, strong) APCScoring *gaitScoring;
@property (nonatomic, strong) APCScoring *stepScoring;
@property (nonatomic, strong) APCScoring *memoryScoring;
@property (nonatomic, strong) APCScoring *phonationScoring;

@end

@implementation APHDashboardViewController

#pragma mark - Init

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _rowItemsOrder = [NSMutableArray arrayWithArray:[defaults objectForKey:kAPCDashboardRowItemsOrder]];
        
        if (!_rowItemsOrder.count) {
            _rowItemsOrder = [[NSMutableArray alloc] initWithArray:@[
                                                                     @(kAPHDashboardItemTypeSteps),
                                                                     @(kAPHDashboardItemTypeIntervalTapping),
                                                                     @(kAPHDashboardItemTypeSpatialMemory),@(kAPHDashboardItemTypePhonation),@(kAPHDashboardItemTypeGait)
                                                                     ]];
            
            [defaults setObject:[NSArray arrayWithArray:_rowItemsOrder] forKey:kAPCDashboardRowItemsOrder];
            [defaults synchronize];
            
        }
        
        self.title = NSLocalizedString(@"Dashboard", @"Dashboard");
    }
    
    return self;
}

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self prepareScoringObjects];
    [self prepareData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.rowItemsOrder = [NSMutableArray arrayWithArray:[defaults objectForKey:kAPCDashboardRowItemsOrder]];
    
    [self prepareScoringObjects];
    [self prepareData];
}

- (void)updateVisibleRowsInTableView:(NSNotification *)notification
{
    [self prepareData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Data

- (void)prepareScoringObjects
{
    self.tapScoring = [[APCScoring alloc] initWithTask:@"APHIntervalTapping-7259AC18-D711-47A6-ADBD-6CFCECDED1DF"
                                          numberOfDays:-kNumberOfDaysToDisplay
                                              valueKey:kSummaryNumberOfRecordsKey
                                               dataKey:nil
                                               sortKey:nil
                                               groupBy:APHTimelineGroupDay];
    
    self.gaitScoring = [[APCScoring alloc] initWithTask:@"APHTimedWalking-80F09109-265A-49C6-9C5D-765E49AAF5D9"
                                           numberOfDays:-kNumberOfDaysToDisplay
                                               valueKey:kGaitScoreKey
                                                dataKey:nil
                                                sortKey:nil
                                                groupBy:APHTimelineGroupDay];
    
    self.memoryScoring = [[APCScoring alloc] initWithTask:@"APHSpatialSpanMemory-4A04F3D0-AC05-11E4-AB27-0800200C9A66"
                                           numberOfDays:-kNumberOfDaysToDisplay
                                               valueKey:kSpatialMemoryScoreSummaryKey
                                                dataKey:nil
                                                sortKey:nil
                                                groupBy:APHTimelineGroupDay];
    
    self.phonationScoring = [[APCScoring alloc] initWithTask:@"APHPhonation-C614A231-A7B7-4173-BDC8-098309354292"
                                             numberOfDays:-kNumberOfDaysToDisplay
                                                 valueKey:kScoreSummaryOfRecordsKey
                                                  dataKey:nil
                                                  sortKey:nil
                                                  groupBy:APHTimelineGroupDay];
    
    HKQuantityType *hkQuantity = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    self.stepScoring = [[APCScoring alloc] initWithHealthKitQuantityType:hkQuantity
                                                                    unit:[HKUnit countUnit]
                                                            numberOfDays:-kNumberOfDaysToDisplay];
}

- (void)prepareData
{
    [self.items removeAllObjects];
    
    {
        NSMutableArray *rowItems = [NSMutableArray new];
        
        NSUInteger allScheduledTasks = ((APCAppDelegate *)[UIApplication sharedApplication].delegate).dataSubstrate.countOfAllScheduledTasksForToday;
        NSUInteger completedScheduledTasks = ((APCAppDelegate *)[UIApplication sharedApplication].delegate).dataSubstrate.countOfCompletedScheduledTasksForToday;
        
        {
            APCTableViewDashboardProgressItem *item = [APCTableViewDashboardProgressItem new];
            item.identifier = kAPCDashboardProgressTableViewCellIdentifier;
            item.editable = NO;
            item.progress = (CGFloat)completedScheduledTasks/allScheduledTasks;
            item.caption = NSLocalizedString(@"Activity Completion", @"Activity Completion");
            
            item.info = NSLocalizedString(@"The activity completion indicates the percentage of activities for today you have completed. You can complete more by going to the Activities tab and tapping on any activity.", @"Dashboard tooltip item info text for Activity Completion in Parkinson");
            
            APCTableViewRow *row = [APCTableViewRow new];
            row.item = item;
            row.itemType = kAPCTableViewDashboardItemTypeProgress;
            [rowItems addObject:row];
        }
        
        for (NSNumber *typeNumber in self.rowItemsOrder) {
            
            APHDashboardItemType rowType = typeNumber.integerValue;
            
            switch (rowType) {
                case kAPHDashboardItemTypeIntervalTapping:
                {
                    APCTableViewDashboardGraphItem *item = [APCTableViewDashboardGraphItem new];
                    item.caption = NSLocalizedString(@"Tapping", @"");
                    item.graphData = self.tapScoring;
                    item.graphType = kAPCDashboardGraphTypeDiscrete;
                    
                    NSString  *detail = [NSString stringWithFormat:@"Average : %lu", (long)[[self.tapScoring averageDataPoint] integerValue]];
                    item.detailText = NSLocalizedString(detail, @"Average: {value} taps");
                    item.identifier =  kAPCDashboardGraphTableViewCellIdentifier;
                    item.editable = YES;
                    item.tintColor = [UIColor appTertiaryPurpleColor];
                
                    item.info = NSLocalizedString(@"This plot shows your finger-tapping speed each day as measured by the Tapping Activity. The length and position of each vertical bar represents the range in the number of taps you made in 20 seconds for a given day. Any differences in length or position over time reflect variations and trends in your tapping speed, which may reflect variations and trends in your symptoms.", @"Dashboard tooltip item info text for Tapping in Parkinson");
                    
                    APCTableViewRow *row = [APCTableViewRow new];
                    row.item = item;
                    row.itemType = rowType;
                    [rowItems addObject:row];

                }
                    break;
                case kAPHDashboardItemTypeGait:
                {
                    APCTableViewDashboardGraphItem *item = [APCTableViewDashboardGraphItem new];
                    item.caption = NSLocalizedString(@"Gait", @"");
                    item.graphData = self.gaitScoring;
                    item.graphType = kAPCDashboardGraphTypeDiscrete;
                    
                    NSString  *detail = [NSString stringWithFormat:@"Average : %lu", (long)[[self.gaitScoring averageDataPoint] integerValue]];
                    item.detailText = NSLocalizedString(detail, @"Average: {value} steps");
                    item.identifier = kAPCDashboardGraphTableViewCellIdentifier;
                    item.editable = YES;
                    item.tintColor = [UIColor appTertiaryYellowColor];
                    
                    item.info = NSLocalizedString(@"This plot combines several accelerometer-based measures for the Walking Activity. The length and position of each vertical bar represents the range of measures for a given day. Any differences in length or position over time reflect variations and trends in your Walking measure, which may reflect variations and trends in your symptoms.", @"Dashboard tooltip item info text for Gait in Parkinson");
                    
                    APCTableViewRow *row = [APCTableViewRow new];
                    row.item = item;
                    row.itemType = rowType;
                    [rowItems addObject:row];
                }
                    break;
                case kAPHDashboardItemTypeSpatialMemory:
                {
                    APCTableViewDashboardGraphItem *item = [APCTableViewDashboardGraphItem new];
                    item.caption = NSLocalizedString(@"Memory", @"");
                    item.graphData = self.memoryScoring;
                    item.graphType = kAPCDashboardGraphTypeDiscrete;
                    
                    NSString  *detail = [NSString stringWithFormat:@"Min: %0.0f  Max: %0.0f",
                                         [[self.memoryScoring minimumDataPoint] doubleValue], [[self.memoryScoring maximumDataPoint] doubleValue]];
                    item.detailText = NSLocalizedString(detail, @"");
                    item.identifier = kAPCDashboardGraphTableViewCellIdentifier;
                    item.editable = YES;
                    item.tintColor = [UIColor appTertiaryRedColor];
                    
                    item.info = NSLocalizedString(@"This plot shows the score you received each day for the Memory Game. Your score is computed from the longest sequence of items you successfully remembered. The length and position of each vertical bar represents the range of scores for a given day. Any differences in length or position over time reflect variations and trends in your score, which may reflect variations and trends in your symptoms.", @"Dashboard tooltip item info text for Memory in Parkinson");
                    
                    APCTableViewRow *row = [APCTableViewRow new];
                    row.item = item;
                    row.itemType = rowType;
                    [rowItems addObject:row];
                }
                    break;
                case kAPHDashboardItemTypePhonation:
                {
                    APCTableViewDashboardGraphItem *item = [APCTableViewDashboardGraphItem new];
                    item.caption = NSLocalizedString(@"Voice", @"");
                    item.graphData = self.phonationScoring;
                    item.graphType = kAPCDashboardGraphTypeDiscrete;
                    
                    NSString  *detail = [NSString stringWithFormat:@"Average : %lu", (long)[[self.phonationScoring averageDataPoint] integerValue]];
                    item.detailText = NSLocalizedString(detail, @"");
                    item.identifier = kAPCDashboardGraphTableViewCellIdentifier;
                    item.editable = YES;
                    item.tintColor = [UIColor appTertiaryBlueColor];
                    
                    item.info = NSLocalizedString(@"This plot combines several microphone-based measures as a single score for the Voice Activity. The length and position of each vertical bar represents the range of measures for a given day. Any differences in length or position over time reflect variations and trends in your Voice measure, which may reflect variations and trends in your symptoms.", @"Dashboard tooltip item info text for Voice in Parkinson");
                    
                    APCTableViewRow *row = [APCTableViewRow new];
                    row.item = item;
                    row.itemType = rowType;
                    [rowItems addObject:row];
                }
                    break;
                    
                case kAPHDashboardItemTypeSteps:
                {
                    APCTableViewDashboardGraphItem  *item = [APCTableViewDashboardGraphItem new];
                    item.caption = NSLocalizedString(@"Steps", @"Steps");
                    item.graphData = self.stepScoring;
                    NSString  *detail = [NSString stringWithFormat:@"Average : %lu", (long)[[self.stepScoring averageDataPoint] integerValue]];
                    item.detailText = NSLocalizedString(detail, @"Average: {value} steps");
                    item.identifier = kAPCDashboardGraphTableViewCellIdentifier;
                    item.editable = YES;
                    item.tintColor = [UIColor appTertiaryGreenColor];
                    
                    item.info = NSLocalizedString(@"This graph shows how many steps you took each day, according to you phone's motion sensors. Remember that for this number to be accurate, you should have the phone on you as frequently as possible.", @"Dashboard tooltip item info text for Steps in Parkinson");
                    
                    APCTableViewRow *row = [APCTableViewRow new];
                    row.item = item;
                    row.itemType = rowType;
                    [rowItems addObject:row];
                }
                    break;
                default:
                    break;
            }
            
        }
        
        APCTableViewSection *section = [APCTableViewSection new];
        section.rows = [NSArray arrayWithArray:rowItems];
        section.sectionTitle = NSLocalizedString(@"Recent Activity", @"");
        [self.items addObject:section];
    }
    
    [self.tableView reloadData];
}

@end
