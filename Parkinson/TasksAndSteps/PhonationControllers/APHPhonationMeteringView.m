//
//  APHPhonationMeteringView.m
//  Parkinson
//
//  Created by Henry McGilton on 11/22/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHPhonationMeteringView.h"

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
    self.innerDiskColor  = [UIColor lightGrayColor];
    self.innerRingColor  = [UIColor whiteColor];
    self.middleRingColor = [UIColor greenColor];
    self.outerRingColor  = [UIColor redColor];
    
    self.backgroundColor = [UIColor clearColor];
    
    self.innerDiskRectangle  = CGRectMake(CGRectGetWidth(self.bounds) * 3.0 / 8.0, CGRectGetWidth(self.bounds) * 3.0 / 8.0,
                                          CGRectGetWidth(self.bounds) * 1.0 / 4.0, CGRectGetWidth(self.bounds) * 1.0 / 4.0);
    
    self.innerRingRectangle  = CGRectMake(CGRectGetWidth(self.bounds) * 1.0 / 4.0, CGRectGetWidth(self.bounds) * 1.0 / 4.0,
                                          CGRectGetWidth(self.bounds) * 1.0 / 2.0, CGRectGetWidth(self.bounds) * 1.0 / 2.0);
    
    self.middleRingRectangle = CGRectMake(CGRectGetWidth(self.bounds) * 1.0 / 8.0, CGRectGetWidth(self.bounds) * 1.0 / 8.0,
                                          CGRectGetWidth(self.bounds) * 3.0 / 4.0, CGRectGetWidth(self.bounds) * 3.0 / 4.0);
    
    self.outerRingRectangle  = self.bounds;
    
    self.powerLevel = 0.0;
}

- (void)drawRect:(CGRect)rect
{
    CGRect  bounds = self.bounds;
    
    CGContextRef  context = UIGraphicsGetCurrentContext();
    
    CGFloat  clipRatio = 0.5 + (self.powerLevel * 0.5);
    CGFloat  diameter = CGRectGetWidth(bounds) * clipRatio;
    
    CGRect  clipRectangle = CGRectMake((CGRectGetWidth(bounds) - diameter) / 2.0, (CGRectGetWidth(bounds) - diameter) / 2.0, diameter , diameter);
    CGContextAddEllipseInRect(context, clipRectangle);
    CGContextClip(context);
    
    CGContextAddEllipseInRect(context, self.outerRingRectangle);
    CGContextSetFillColorWithColor(context, self.outerRingColor.CGColor);
    CGContextFillPath(context);
    
    CGContextAddEllipseInRect(context, self.middleRingRectangle);
    CGContextSetFillColorWithColor(context, self.middleRingColor.CGColor);
    CGContextFillPath(context);
    
    CGContextAddEllipseInRect(context, self.innerRingRectangle);
    CGContextSetFillColorWithColor(context, self.innerRingColor.CGColor);
    CGContextFillPath(context);
    
    CGContextAddEllipseInRect(context, self.innerDiskRectangle);
    CGContextSetFillColorWithColor(context, self.innerDiskColor.CGColor);
    CGContextFillPath(context);
}

@end
