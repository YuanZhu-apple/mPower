//
//  APHIntervalTappingTargetContainer.h
//  Parkinson
//
//  Created by Henry McGilton on 9/30/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  APHIntervalTappingTapView;

@interface APHIntervalTappingTargetContainer : UIView

@property  (nonatomic, weak)  APHIntervalTappingTapView  *tapperLeft;
@property  (nonatomic, weak)  APHIntervalTappingTapView  *tapperRight;

@end
