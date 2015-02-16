//
//  APHProfileExtender.h
//  mPower
//
//  Copyright (c) 2015 Apple, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@import APCAppCore;


@interface APHProfileExtender : NSObject <APCProfileViewControllerDelegate>

@property (nonatomic, strong) APCProfileViewController *profileViewController;

@end
