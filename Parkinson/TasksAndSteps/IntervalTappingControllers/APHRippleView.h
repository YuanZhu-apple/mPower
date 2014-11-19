//
//  APHRippleView.h
//  Parkinson
//
//  Created by Ramsundar Shandilya on 11/12/14.
//  Copyright (c) 2014 Ramsundar Shandilya. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  APHIntervalTappingTapView;

@interface APHRippleView : UIView

@property  (nonatomic, weak)    APHIntervalTappingTapView  *tapperLeft;
@property  (nonatomic, weak)    APHIntervalTappingTapView  *tapperRight;

@property  (nonatomic, strong)  UIColor                    *tintColor;

@property  (nonatomic, assign)  CGFloat                     minimumRadius;
@property  (nonatomic, assign)  CGFloat                     maximumRadius;

- (void)rippleAtPoint:(CGPoint)touchPoint;

@end
