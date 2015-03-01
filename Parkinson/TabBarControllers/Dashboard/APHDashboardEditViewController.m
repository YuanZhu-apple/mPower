// 
//  APHDashboardEditViewController.m 
//  mPower 
// 
//  Copyright (c) 2014 Apple, Inc. All rights reserved. 
// 
 
#import "APHDashboardEditViewController.h"

@implementation APHDashboardEditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareData];
}

- (void)prepareData
{
    [self.items removeAllObjects];
    
    {
        for (NSNumber *typeNumber in self.rowItemsOrder) {
            
            APHDashboardItemType rowType = typeNumber.integerValue;
            
            switch (rowType) {
                case kAPHDashboardItemTypeIntervalTapping:
                {
                    APCTableViewDashboardItem *item = [APCTableViewDashboardItem new];
                    item.caption = NSLocalizedString(@"Tapping", @"");
                    item.taskId = @"APHIntervalTapping-7259AC18-D711-47A6-ADBD-6CFCECDED1DF";
                    item.tintColor = [UIColor colorForTaskId:item.taskId];
                    
                    [self.items addObject:item];
                    
                }
                    break;
                case kAPHDashboardItemTypeGait:{
                    
                    APCTableViewDashboardItem *item = [APCTableViewDashboardItem new];
                    item.caption = NSLocalizedString(@"Gait", @"");
                    item.taskId = @"APHTimedWalking-80F09109-265A-49C6-9C5D-765E49AAF5D9";
                    item.tintColor = [UIColor colorForTaskId:item.taskId];
                    
                    [self.items addObject:item];
                }
                    break;
                case kAPHDashboardItemTypeSpatialMemory:{
                    
                    APCTableViewDashboardItem *item = [APCTableViewDashboardItem new];
                    item.caption = NSLocalizedString(@"Memory", @"");
                    item.taskId = @"APHSpatialSpanMemory-4A04F3D0-AC05-11E4-AB27-0800200C9A66";
                    item.tintColor = [UIColor colorForTaskId:item.taskId];
                    
                    [self.items addObject:item];
                }
                    break;
                case kAPHDashboardItemTypePhonation:{
                    
                    APCTableViewDashboardItem *item = [APCTableViewDashboardItem new];
                    item.caption = NSLocalizedString(@"Voice", @"");
                    item.taskId = @"APHPhonation-C614A231-A7B7-4173-BDC8-098309354292";
                    item.tintColor = [UIColor colorForTaskId:item.taskId];
                    
                    [self.items addObject:item];
                }
                    break;
                case kAPHDashboardItemTypeSteps:{
                    
                    APCTableViewDashboardItem *item = [APCTableViewDashboardItem new];
                    item.caption = NSLocalizedString(@"Steps", @"");
                    item.tintColor = [UIColor appTertiaryGreenColor];
                    
                    [self.items addObject:item];
                }
                    break;
                default:
                    break;
            }
        }
        
    }
}

@end
