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

@property (nonatomic, strong) APCScoring *distanceScore;
@property (nonatomic, strong) APCScoring *heartRateScore;

@property (nonatomic, strong) APCPresentAnimator *presentAnimator;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

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
                                                                     @(kAPHDashboardItemTypeIntervalTapping),
                                                                     @(kAPHDashboardItemTypeGait),
                                                                     @(kAPHDashboardItemTypeSteps)
                                                                     ]];
            
            [defaults setObject:[NSArray arrayWithArray:_rowItemsOrder] forKey:kAPCDashboardRowItemsOrder];
            [defaults synchronize];
            
        }
        
        self.title = NSLocalizedString(@"Dashboard", @"Dashboard");
        
        _presentAnimator = [APCPresentAnimator new];
        _dateFormatter = [NSDateFormatter new];
    }
    
    return self;
}

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self prepareData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.rowItemsOrder = [NSMutableArray arrayWithArray:[defaults objectForKey:kAPCDashboardRowItemsOrder]];
    
    [self prepareData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Data

- (void)prepareData
{
    [self.items removeAllObjects];
    
    {
        NSMutableArray *rowItems = [NSMutableArray new];
        
        NSUInteger allScheduledTasks = ((APCAppDelegate *)[UIApplication sharedApplication].delegate).dataSubstrate.countOfAllScheduledTasksForToday;
        NSUInteger completedScheduledTasks = ((APCAppDelegate *)[UIApplication sharedApplication].delegate).dataSubstrate.countOfCompletedScheduledTasksForToday;
        
        {
            APCTableViewItem *item = [APCTableViewItem new];
            item.caption = NSLocalizedString(@"Activities", @"");
            item.identifier = kAPCRightDetailTableViewCellIdentifier;
            item.editable = NO;
            item.textAlignnment = NSTextAlignmentRight;
            
            
            item.detailText = [NSString stringWithFormat:@"%lu/%lu", (unsigned long)completedScheduledTasks, (unsigned long)allScheduledTasks];
            
            APCTableViewRow *row = [APCTableViewRow new];
            row.item = item;
            row.itemType = kAPCTableViewDashboardItemTypeProgress;
            [rowItems addObject:row];
        }
        
        {
            APCTableViewDashboardProgressItem *item = [APCTableViewDashboardProgressItem new];
            item.identifier = kAPCDashboardProgressTableViewCellIdentifier;
            item.editable = NO;
            item.progress = (CGFloat)completedScheduledTasks/allScheduledTasks;
            
            APCTableViewRow *row = [APCTableViewRow new];
            row.item = item;
            row.itemType = kAPCTableViewDashboardItemTypeProgress;
            [rowItems addObject:row];
        }
        
        
        APCTableViewSection *section = [APCTableViewSection new];
        NSDate *dateToday = [NSDate date];
        
        self.dateFormatter.dateFormat = @"MMMM d";
        
        section.sectionTitle = [NSString stringWithFormat:@"%@, %@", NSLocalizedString(@"Today", @""), [self.dateFormatter stringFromDate:dateToday]];
        section.rows = [NSArray arrayWithArray:rowItems];
        [self.items addObject:section];
    }

    {
        NSMutableArray *rowItems = [NSMutableArray new];
        
        for (NSNumber *typeNumber in self.rowItemsOrder) {
            
            APHDashboardItemType rowType = typeNumber.integerValue;
            
            switch (rowType) {
                case kAPHDashboardItemTypeIntervalTapping:
                {
                    APCScoring  *scoring = [[APCScoring alloc] initWithTask:@"APHIntervalTapping-7259AC18-D711-47A6-ADBD-6CFCECDED1DF"
                                                              numberOfDays:-5
                                                            valueKey:kSummaryNumberOfRecordsKey
                                            dataKey:nil];
                    
                    APCTableViewDashboardGraphItem *item = [APCTableViewDashboardGraphItem new];
                    item.caption = NSLocalizedString(@"Tapping", @"");
                    item.graphData = scoring;
                    item.identifier = kAPCDashboardGraphTableViewCellIdentifier;
                    item.editable = YES;
                    item.tintColor = [UIColor appTertiaryPurpleColor];
                    
                    APCTableViewRow *row = [APCTableViewRow new];
                    row.item = item;
                    row.itemType = rowType;
                    [rowItems addObject:row];

                }
                    break;
                case kAPHDashboardItemTypeGait:
                {
                    APCScoring  *scoring = [[APCScoring alloc] initWithTask:@"APHTimedWalking-80F09109-265A-49C6-9C5D-765E49AAF5D9"
                                                               numberOfDays:-5
                                                                   valueKey:@"value"
                                            dataKey:nil];
                    
                    APCTableViewDashboardGraphItem *item = [APCTableViewDashboardGraphItem new];
                    item.caption = NSLocalizedString(@"Gait", @"");
                    item.graphData = scoring;
                    item.identifier = kAPCDashboardGraphTableViewCellIdentifier;
                    item.editable = YES;
                    item.tintColor = [UIColor appTertiaryYellowColor];
                    
                    APCTableViewRow *row = [APCTableViewRow new];
                    row.item = item;
                    row.itemType = rowType;
                    [rowItems addObject:row];
                }
                    break;
                    
                case kAPHDashboardItemTypeSteps:
                {
                    HKQuantityType  *hkStepCount = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
                    APCScoring  *scoring = [[APCScoring alloc] initWithHealthKitQuantityType:hkStepCount unit:[HKUnit countUnit] numberOfDays:-5];
                    
                    APCTableViewDashboardGraphItem  *item = [APCTableViewDashboardGraphItem new];
                    item.caption = NSLocalizedString(@"Steps", @"Steps");
                    item.graphData = scoring;
                    NSString  *detail = [NSString stringWithFormat:@"Average : %lu", (long)[[scoring averageDataPoint] integerValue]];
                    item.detailText = NSLocalizedString(detail, @"Average: {value} steps");
                    item.identifier = kAPCDashboardGraphTableViewCellIdentifier;
                    item.editable = YES;
                    item.tintColor = [UIColor appTertiaryGreenColor];
                    
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
        section.sectionTitle = NSLocalizedString(@"Past 5 Days", @"");
        [self.items addObject:section];
    }
    
    [self.tableView reloadData];
}

#pragma mark - APCDashboardGraphTableViewCellDelegate methods

- (void)dashboardGraphViewCellDidTapExpandForCell:(APCDashboardLineGraphTableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    APCTableViewDashboardGraphItem *graphItem = (APCTableViewDashboardGraphItem *)[self itemForIndexPath:indexPath];
    
    CGRect initialFrame = [cell convertRect:cell.bounds toView:self.view.window];
    self.presentAnimator.initialFrame = initialFrame;

    APCLineGraphViewController *graphViewController = [[UIStoryboard storyboardWithName:@"APHDashboard" bundle:nil] instantiateViewControllerWithIdentifier:@"GraphVC"];
    graphViewController.graphItem = graphItem;
//    graphViewController.transitioningDelegate = self;
//    graphViewController.modalPresentationStyle = UIModalPresentationCustom;
    [self.navigationController presentViewController:graphViewController animated:YES completion:nil];
}

#pragma mark - UIViewControllerTransitioningDelegate methods

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    self.presentAnimator.presenting = YES;
    return self.presentAnimator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    
    self.presentAnimator.presenting = NO;
    return self.presentAnimator;
}

@end
