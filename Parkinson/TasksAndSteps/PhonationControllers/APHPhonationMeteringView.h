// 
//  APHPhonationMeteringView.h 
//  mPower 
// 
//  Copyright (c) 2014 <INSTITUTION-NAME-TBD> All rights reserved. 
// 
 
#import <UIKit/UIKit.h>

@interface APHPhonationMeteringView : UIView

@property  (nonatomic, strong)  UIColor  *innerDiskColor;
@property  (nonatomic, strong)  UIColor  *innerRingFillColor;
@property  (nonatomic, strong)  UIColor  *disabledStrokeColor;
@property  (nonatomic, strong)  UIColor  *middleRingColor;
@property  (nonatomic, strong)  UIColor  *outerRingColor;

@property  (nonatomic, assign)  CGFloat  powerLevel;

@end
