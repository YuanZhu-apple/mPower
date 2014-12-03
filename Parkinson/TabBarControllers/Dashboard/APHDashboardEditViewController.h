//
//  APHDashboardEditViewController.h
//  Parkinson's
//
//  Copyright (c) 2014 <INSTITUTION-NAME-TBD>. All rights reserved.
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
