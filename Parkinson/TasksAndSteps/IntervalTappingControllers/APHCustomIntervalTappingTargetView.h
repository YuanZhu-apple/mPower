//
//  APHCustomIntervalTappingTargetView
//  Parkinson
//
//  Created by Justin Warmkessel on 10/16/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class APHIntervalTappingTapView;

@interface APHCustomIntervalTappingTargetView : UIView

@property (weak, nonatomic) IBOutlet APHIntervalTappingTapView *tapperLeft;
@property (weak, nonatomic) IBOutlet APHIntervalTappingTapView *tapperRight;

@end
