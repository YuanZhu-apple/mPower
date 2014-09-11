//
//  APHSetupTaskViewController.h
//  Parkinson
//
//  Created by Henry McGilton on 9/3/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ResearchKit/ResearchKit.h>

#import "APHStepDictionaryKeys.h"

@interface APHSetupTaskViewController : RKTaskViewController <RKTaskViewControllerDelegate, RKStepViewControllerDelegate, RKResultCollector>

@property  (nonatomic, strong)  RKTask  *task;

+ (instancetype)customTaskViewController;

+ (NSDictionary *)keysToPropertiesMap;

+ (RKTask *)mapConfigurationsToTask:(NSArray *)configurations;

@end
