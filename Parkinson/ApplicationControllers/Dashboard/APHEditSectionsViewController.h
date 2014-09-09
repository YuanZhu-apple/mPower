//
//  APHEditSectionsViewController.h
//  Parkinson
//
//  Created by Ramsundar Shandilya on 9/8/14.
//  Copyright (c) 2014 Henry McGilton. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const DashboardSectionsOrder = @"DashboardSectionsOrderKey";

typedef NS_ENUM(NSUInteger, APHDashboardSection) {
    APHDashboardSectionStudyOverView = 0,
    APHDashboardSectionActivity,
    APHDashboardSectionBloodCount,
    APHDashboardSectionMedications,
    APHDashboardSectionInsights,
    APHDashboardSectionAlerts
};

@interface APHEditSectionsViewController : UIViewController

@end
