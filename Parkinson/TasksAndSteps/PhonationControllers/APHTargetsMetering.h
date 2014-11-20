//
//  APHTargetsMetering.h
//  Parkinson
//
//  Created by Henry McGilton on 11/17/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  APCCircularProgressView;

@interface APHTargetsMetering : UIView

@property  (nonatomic, weak)  IBOutlet  APCCircularProgressView  *outerProgressor;
@property  (nonatomic, weak)  IBOutlet  APCCircularProgressView  *middleProgressor;
@property  (nonatomic, weak)  IBOutlet  APCCircularProgressView  *innerProgressor;

@end
