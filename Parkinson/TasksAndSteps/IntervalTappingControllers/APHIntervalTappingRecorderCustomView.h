//
//  APHIntervalTappingRecorderCustomView
//  Parkinson's
//
//  Copyright (c) 2014 <INSTITUTION-NAME-TBD>. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  APHIntervalTappingTapView;
@class  APHRippleView;

@interface APHIntervalTappingRecorderCustomView : UIView

@property  (nonatomic, weak)  IBOutlet  APHRippleView              *tapTargetsContainer;

@property  (nonatomic, weak)  IBOutlet  APHIntervalTappingTapView  *tapperLeft;
@property  (nonatomic, weak)  IBOutlet  APHIntervalTappingTapView  *tapperRight;

@property  (nonatomic, weak)  IBOutlet  UILabel                    *totalTapsCount;

@end
