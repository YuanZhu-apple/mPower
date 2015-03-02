// 
//  APHDashboardEditViewController.h 
//  mPower 
// 
//  Copyright (c) 2014 Apple, Inc. All rights reserved. 
// 
 
@import APCAppCore;

typedef NS_ENUM(APCTableViewItemType, APHDashboardItemType) {
    kAPHDashboardItemTypeIntervalTapping,
    kAPHDashboardItemTypeSpatialMemory,
    kAPHDashboardItemTypeGait,
    kAPHDashboardItemTypePhonation,
    kAPHDashboardItemTypeSteps,
    kAPHDashboardItemTypeAlerts,
    kAPHDashboardItemTypeInsights,
};

@interface APHDashboardEditViewController : APCDashboardEditViewController

@end
