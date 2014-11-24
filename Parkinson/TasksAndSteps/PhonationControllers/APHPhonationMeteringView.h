//
//  APHPhonationMeteringView.h
//  Parkinson
//
//  Created by Henry McGilton on 11/22/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APHPhonationMeteringView : UIView

@property  (nonatomic, strong)  UIColor  *innerDiskColor;
@property  (nonatomic, strong)  UIColor  *innerRingColor;
@property  (nonatomic, strong)  UIColor  *middleRingColor;
@property  (nonatomic, strong)  UIColor  *outerRingColor;

@property  (nonatomic, assign)  CGFloat  powerLevel;

@end
