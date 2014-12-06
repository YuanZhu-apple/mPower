// 
//  APHDashboardEditViewController.h 
//  mPower 
// 
//  Copyright (c) 2014 Apple, Inc. All rights reserved. 
// 
 
@import APCAppCore;

typedef NS_ENUM(APCTableViewItemType, APHDashboardItemType) {
    kAPHDashboardItemTypeIntervalTapping,
    kAPHDashboardItemTypeGait,
    kAPHDashboardItemTypeSteps,
    kAPHDashboardItemTypeAlerts,
    kAPHDashboardItemTypeInsights,
};

@interface APHDashboardEditViewController : APCDashboardEditViewController

@end
