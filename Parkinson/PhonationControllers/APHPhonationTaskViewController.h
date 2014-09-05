//
//  APHPhonationTaskViewController.h
//  Parkinson
//
//  Created by Henry McGilton on 9/3/14.
//  Copyright (c) 2014 Henry McGilton. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ResearchKit/ResearchKit.h>

#import "APHSetupTaskViewController.h"

static  const  NSString  *kPhonationStep101Key = @"Phonation_Step_101";
static  const  NSString  *kPhonationStep102Key = @"Phonation_Step_102";
static  const  NSString  *kPhonationStep103Key = @"Phonation_Step_103";
static  const  NSString  *kPhonationStep104Key = @"Phonation_Step_104";
static  const  NSString  *kPhonationStep105Key = @"Phonation_Step_105";

@interface APHPhonationTaskViewController : APHSetupTaskViewController

+ (instancetype)customTaskViewController;

@end
