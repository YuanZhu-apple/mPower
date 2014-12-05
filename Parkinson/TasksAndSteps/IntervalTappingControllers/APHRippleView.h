// 
//  APHRippleView.h 
//  mPower 
// 
//  Copyright (c) 2014 <INSTITUTION-NAME-TBD> All rights reserved. 
// 
 
#import <UIKit/UIKit.h>

@class  APHIntervalTappingTapView;
@class  APHRippleView;

@protocol  APHRippleViewDelegate <NSObject>
@required
- (void)rippleView:(APHRippleView *)rippleView touchesDidOccurAtPoints:(NSArray *)points;
@end


@interface APHRippleView : UIView

@property  (nonatomic, weak)    APHIntervalTappingTapView  *tapperLeft;
@property  (nonatomic, weak)    APHIntervalTappingTapView  *tapperRight;

@property  (nonatomic, strong)  UIColor                    *tintColor;

@property  (nonatomic, assign)  CGFloat                     minimumRadius;
@property  (nonatomic, assign)  CGFloat                     maximumRadius;

@property  (nonatomic, weak)    id <APHRippleViewDelegate>  delegate;

- (void)rippleAtPoint:(CGPoint)touchPoint;

@end
