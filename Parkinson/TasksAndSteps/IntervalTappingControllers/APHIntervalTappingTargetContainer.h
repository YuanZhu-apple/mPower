// 
//  APHIntervalTappingTargetContainer.h 
//  mPower 
// 
//  Copyright (c) 2014 <INSTITUTION-NAME-TBD> All rights reserved. 
// 
 
#import <UIKit/UIKit.h>

@class  APHIntervalTappingTapView;

@interface APHIntervalTappingTargetContainer : UIView

@property  (nonatomic, weak)  APHIntervalTappingTapView  *tapperLeft;
@property  (nonatomic, weak)  APHIntervalTappingTapView  *tapperRight;

@end
