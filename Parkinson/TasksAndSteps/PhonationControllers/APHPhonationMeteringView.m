//
//  APHPhonationMeteringView.m
//  Parkinson
//
//  Created by Henry McGilton on 11/22/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHPhonationMeteringView.h"

static  CGFloat  kDisabledPowerLevel = -1.0;

@interface APHPhonationMeteringView  ( )

@property  (nonatomic, assign)  CGRect  innerDiskRectangle;
@property  (nonatomic, assign)  CGRect  innerRingRectangle;
@property  (nonatomic, assign)  CGRect  middleRingRectangle;
@property  (nonatomic, assign)  CGRect  outerRingRectangle;

@end

@implementation APHPhonationMeteringView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self setupDefaults];
    }
    return  self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        [self setupDefaults];
    }
    return  self;
}

- (BOOL)isOpaque
{
    return  YES;
}

- (void)setupDefaults
{
    self.disabledStrokeColor = [UIColor grayColor];
    
    self.innerDiskColor       = [UIColor lightGrayColor];
    self.innerRingFillColor   = [UIColor whiteColor];
    self.middleRingColor      = [UIColor greenColor];
    self.outerRingColor       = [UIColor redColor];
    
    self.backgroundColor = [UIColor clearColor];
    
    CGFloat  innerDiskOffset    = 3.0 /  8.0;
    CGFloat  innerDiskDiameter  = 1.0 /  4.0;
    
    CGFloat  innerRingOffset    = 5.0 / 16.0;
    CGFloat  innerRingDiameter  = 3.0 /  8.0;
    
    CGFloat  middleRingOffset   = 1.0 /  8.0;
    CGFloat  middleRingDiameter = 3.0 /  4.0;
    
    self.innerDiskRectangle  = CGRectMake(CGRectGetWidth(self.bounds) * innerDiskOffset, CGRectGetWidth(self.bounds) * innerDiskOffset,
                                          CGRectGetWidth(self.bounds) * innerDiskDiameter, CGRectGetWidth(self.bounds) * innerDiskDiameter);
    
    self.innerRingRectangle  = CGRectMake(CGRectGetWidth(self.bounds) * innerRingOffset, CGRectGetWidth(self.bounds) * innerRingOffset,
                                          CGRectGetWidth(self.bounds) * innerRingDiameter, CGRectGetWidth(self.bounds) * innerRingDiameter);
    
    self.middleRingRectangle = CGRectMake(CGRectGetWidth(self.bounds) * middleRingOffset, CGRectGetWidth(self.bounds) * middleRingOffset,
                                          CGRectGetWidth(self.bounds) * middleRingDiameter, CGRectGetWidth(self.bounds) * middleRingDiameter);
    
    self.outerRingRectangle  = self.bounds;
    
    self.powerLevel = kDisabledPowerLevel;
}

- (void)drawRect:(CGRect)rect
{
    CGRect  bounds = self.bounds;
    
    CGContextRef  context = UIGraphicsGetCurrentContext();
    
    CGFloat  clipRatio = 0.5 + (self.powerLevel * 0.5);
    CGFloat  diameter = CGRectGetWidth(bounds) * clipRatio;
    
    if (self.powerLevel >= 0.0) {
        CGRect  clipRectangle = CGRectMake((CGRectGetWidth(bounds) - diameter) / 2.0, (CGRectGetWidth(bounds) - diameter) / 2.0, diameter , diameter);
        CGContextAddEllipseInRect(context, clipRectangle);
        CGContextClip(context);
    }
    if (self.powerLevel >= 0.0) {
        CGContextAddEllipseInRect(context, self.outerRingRectangle);
        CGContextSetFillColorWithColor(context, self.outerRingColor.CGColor);
        CGContextFillPath(context);
        
        CGContextAddEllipseInRect(context, self.middleRingRectangle);
        CGContextSetFillColorWithColor(context, self.middleRingColor.CGColor);
        CGContextFillPath(context);
    } else {
        CGContextAddEllipseInRect(context, self.outerRingRectangle);
        CGContextSetStrokeColorWithColor(context, self.disabledStrokeColor.CGColor);
        CGContextStrokePath(context);

        CGContextAddEllipseInRect(context, self.middleRingRectangle);
        CGContextSetFillColorWithColor(context, self.disabledStrokeColor.CGColor);
        CGContextStrokePath(context);
    }
    
    CGContextAddEllipseInRect(context, self.innerRingRectangle);
    CGContextSetFillColorWithColor(context, self.innerRingFillColor.CGColor);
    CGContextFillPath(context);
    
    if (self.powerLevel < 0.0) {
        CGContextAddEllipseInRect(context, self.innerRingRectangle);
        CGContextSetFillColorWithColor(context, self.disabledStrokeColor.CGColor);
        CGContextStrokePath(context);
    }
    
    CGContextAddEllipseInRect(context, self.innerDiskRectangle);
    CGContextSetFillColorWithColor(context, self.innerDiskColor.CGColor);
    CGContextFillPath(context);
}

@end
