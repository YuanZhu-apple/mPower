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
                                               valueKey:@"value"
                                                dataKey:nil
                                                sortKey:nil
                                                groupBy:APHTimelineGroupDay];
    
    self.memoryScoring = [[APCScoring alloc] initWithTask:@"APHSpatialSpanMemory-4A04F3D0-AC05-11E4-AB27-0800200C9A66"
                                           numberOfDays:-kNumberOfDaysToDisplay
                                               valueKey:@"value"
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
            
#warning Replace Placeholder Values - APPLE-1576
            item.info = NSLocalizedString(@"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", @"");
            
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
                    
                    #warning Replace Placeholder Values - APPLE-1576
                    item.info = NSLocalizedString(@"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", @"");
                    
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
                    
                    #warning Replace Placeholder Values - APPLE-1576
                    item.info = NSLocalizedString(@"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", @"");
                    
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
                    
                    NSString  *detail = [NSString stringWithFormat:@"Average : %lu", (long)[[self.memoryScoring averageDataPoint] integerValue]];
                    item.detailText = NSLocalizedString(detail, @"");
                    item.identifier = kAPCDashboardGraphTableViewCellIdentifier;
                    item.editable = YES;
                    item.tintColor = [UIColor appTertiaryRedColor];
                    
#warning Replace Placeholder Values - APPLE-1576
                    item.info = NSLocalizedString(@"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", @"");
                    
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
                    
#warning Replace Placeholder Values - APPLE-1576
                    item.info = NSLocalizedString(@"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", @"");
                    
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
                    
                    #warning Replace Placeholder Values - APPLE-1576
                    item.info = NSLocalizedString(@"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", @"");
                    
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
