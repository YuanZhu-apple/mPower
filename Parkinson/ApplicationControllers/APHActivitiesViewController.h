//
//  APHActivitiesViewController.h
//  Parkinson
//
//  Created by Henry McGilton on 8/20/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APHActivitiesViewController : UITableViewController

//
//    Property Declaration for Category (Split Implementation) Files
//
@property  (nonatomic, strong)  NSArray       *stepsConfigurations;
@property  (nonatomic, strong)  NSDictionary  *keysToPropertiesMap;

@end

