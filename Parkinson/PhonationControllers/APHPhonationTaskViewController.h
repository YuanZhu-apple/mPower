//
//  APHPhonationTaskViewController.h
//  Parkinson
//
//  Created by Henry McGilton on 9/3/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ResearchKit/ResearchKit.h>

#import "APHSetupTaskViewController.h"

@interface APHPhonationTaskViewController : APHSetupTaskViewController

+ (instancetype)customTaskViewController: (APCScheduledTask*) scheduledTask;

@end
