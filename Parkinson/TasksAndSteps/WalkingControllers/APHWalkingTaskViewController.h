// 
//  APHWalkingTaskViewController.h 
//  mPower 
// 
//  Copyright (c) 2014 Apple, Inc. All rights reserved.
// 
 

#import <APCAppCore/APCAppCore.h>
#import <Foundation/Foundation.h>
#import <ResearchKit/ResearchKit.h>

extern NSString * const kGaitScoreKey;

@interface APHWalkingTaskViewController : APCBaseTaskViewController
- (NSDictionary *) computeTotalDistanceForDashboardItem:(NSURL *)fileURL;
@end
