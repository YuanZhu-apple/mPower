// 
//  APHPhonationMeteringView.m 
//  mPower 
// 
//  Copyright (c) 2014 Apple, Inc. All rights reserved. 
// 
 
#import "APHPhonationMeteringView.h"

static  CGFloat  kDisabledPowerLevel = -1.0;
static  CGFloat  kBoundsInsetAmount  =  1.0;

@interface APHPhonationMeteringView  ( )

@property  (nonatomic, assign)  CGFloat  innerRingDiameter;

@property  (nonatomic, assign)  CGRect  innerDiskRectangle;
@property  (nonatomic, assign)  CGRect  innerRingRectangle;
@property  (nonatomic, assign)  CGRect  middleRingRectangle;
@property  (nonatomic, assign)  CGRect  outerRingRectangle;

@property  (nonatomic, assign)  CGRect  insetsAdjustedBounds;

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
    
    UIEdgeInsets  insets = UIEdgeInsetsMake(kBoundsInsetAmount, kBoundsInsetAmount, kBoundsInsetAmount, kBoundsInsetAmount);
    self.insetsAdjustedBounds = UIEdgeInsetsInsetRect(self.bounds, insets);
    
    self.disabledStrokeColor = [UIColor grayColor];
    
    self.innerDiskColor       = [UIColor darkGrayColor];
    self.innerRingFillColor   = [UIColor whiteColor];
    self.middleRingColor      = [UIColor greenColor];
    self.outerRingColor       = [UIColor redColor];
    
    self.backgroundColor = [UIColor clearColor];
    
    CGFloat  innerDiskOffset    = 3.0 /  8.0;
    CGFloat  innerDiskDiameter  = 1.0 /  4.0;
    
    CGFloat  innerRingOffset    = 5.0 / 16.0;
    self.innerRingDiameter      = 3.0 /  8.0;
    
    CGFloat  middleRingOffset   = 1.0 / 16.0;
    CGFloat  middleRingDiameter = 7.0 /  8.0;
    
    self.innerDiskRectangle  = CGRectMake(CGRectGetWidth(self.insetsAdjustedBounds) * innerDiskOffset, CGRectGetWidth(self.insetsAdjustedBounds) * innerDiskOffset,
                                          CGRectGetWidth(self.insetsAdjustedBounds) * innerDiskDiameter, CGRectGetWidth(self.insetsAdjustedBounds) * innerDiskDiameter);
    
    self.innerRingRectangle  = CGRectMake(CGRectGetWidth(self.insetsAdjustedBounds) * innerRingOffset, CGRectGetWidth(self.insetsAdjustedBounds) * innerRingOffset,
                                          CGRectGetWidth(self.insetsAdjustedBounds) * self.innerRingDiameter, CGRectGetWidth(self.insetsAdjustedBounds) * self.innerRingDiameter);
    
    self.middleRingRectangle = CGRectMake(CGRectGetWidth(self.insetsAdjustedBounds) * middleRingOffset, CGRectGetWidth(self.insetsAdjustedBounds) * middleRingOffset,
                                          CGRectGetWidth(self.insetsAdjustedBounds) * middleRingDiameter, CGRectGetWidth(self.insetsAdjustedBounds) * middleRingDiameter);
    
    self.outerRingRectangle  = self.insetsAdjustedBounds;
    
    self.powerLevel = kDisabledPowerLevel;
}

    //
    //    draws four periods of a sine wave (actually some kind of Conic Section)
    //
- (void)drawInnerDiskInContext:(CGContextRef)context withBounds:(CGRect)bounds
{
    CGContextAddEllipseInRect(context, self.innerDiskRectangle);
    CGContextSetFillColorWithColor(context, self.innerDiskColor.CGColor);
    CGContextFillPath(context);
    
    CGContextSaveGState(context);
    
        //
        //    fine tuning magic numbers for translation and scale
        //
    CGContextTranslateCTM(context, CGRectGetMinX(self.innerDiskRectangle) + 3.0 * CGRectGetWidth(bounds) / 64.0,
                          CGRectGetMinY(self.innerDiskRectangle) + 1.5 * CGRectGetWidth(bounds) / 64.0);
    CGContextScaleCTM(context, 0.04375, 0.20);
    
    CGContextMoveToPoint(context, CGRectGetMinX(bounds), CGRectGetMidY(bounds));
        //
        //    period one
        //
    CGContextAddQuadCurveToPoint(context, 1.0 * CGRectGetWidth(bounds) / 4.0, -0.4375 * CGRectGetMaxY(bounds),
                                 2.0 * CGRectGetWidth(bounds) / 4.0, CGRectGetMidY(bounds));
    
    CGContextAddQuadCurveToPoint(context, 3.0 * CGRectGetWidth(bounds) / 4.0, 1.4375 * CGRectGetMaxY(bounds),
                                 4.0 * CGRectGetWidth(bounds) / 4.0, CGRectGetMidY(bounds));
        //
        //    period two
        //
    CGContextAddQuadCurveToPoint(context, 5.0 * CGRectGetWidth(bounds) / 4.0, -0.0625 * CGRectGetMaxY(bounds),
                                 6.0 * CGRectGetWidth(bounds) / 4.0, CGRectGetMidY(bounds));
    
    CGContextAddQuadCurveToPoint(context, 7.0 * CGRectGetWidth(bounds) / 4.0, 1.0625 * CGRectGetMaxY(bounds),
                                 8.0 * CGRectGetWidth(bounds) / 4.0, CGRectGetMidY(bounds));
        //
        //    period three
        //
    CGContextAddQuadCurveToPoint(context, 9.0 * CGRectGetWidth(bounds) / 4.0, -0.4375 * CGRectGetMaxY(bounds),
                                 10.0 * CGRectGetWidth(bounds) / 4.0, CGRectGetMidY(bounds));
    
    CGContextAddQuadCurveToPoint(context, 11.0 * CGRectGetWidth(bounds) / 4.0, 1.4375 * CGRectGetMaxY(bounds),
                                 12.0 * CGRectGetWidth(bounds) / 4.0, CGRectGetMidY(bounds));
        //
        //    period four
        //
    CGContextAddQuadCurveToPoint(context, 13.0 * CGRectGetWidth(bounds) / 4.0, -0.125 * CGRectGetMaxY(bounds),
                                 14.0 * CGRectGetWidth(bounds) / 4.0, CGRectGetMidY(bounds));
    
    CGContextAddQuadCurveToPoint(context, 15.0 * CGRectGetWidth(bounds) / 4.0, 1.125 * CGRectGetMaxY(bounds),
                                 16.0 * CGRectGetWidth(bounds) / 4.0, CGRectGetMidY(bounds));
    
    CGContextRestoreGState(context);
    CGContextSetStrokeColorWithColor(context, [[UIColor greenColor] CGColor]);
    
    CGContextStrokePath(context);

}

- (void)drawRect:(CGRect)rect
{
    CGRect  bounds = self.insetsAdjustedBounds;
    
    CGContextRef  context = UIGraphicsGetCurrentContext();
    
    CGFloat  clipRatio = self.innerRingDiameter + (self.powerLevel * (1.0 - self.innerRingDiameter));
    CGFloat  diameter = CGRectGetWidth(bounds) * clipRatio;
    
    if (self.powerLevel > 0.0) {
        CGRect  clipRectangle = CGRectMake((CGRectGetWidth(bounds) - diameter) / 2.0, (CGRectGetWidth(bounds) - diameter) / 2.0, diameter , diameter);
        CGContextAddEllipseInRect(context, clipRectangle);
        CGContextClip(context);
    }
    if (self.powerLevel > 0.0) {
        CGContextAddEllipseInRect(context, self.outerRingRectangle);
        CGContextSetFillColorWithColor(context, self.outerRingColor.CGColor);
        CGContextFillPath(context);
        
        CGContextAddEllipseInRect(context, self.middleRingRectangle);
        CGContextSetFillColorWithColor(context, self.middleRingColor.CGColor);
        CGContextFillPath(context);
    }
    
    if (self.powerLevel > 0.0) {
        CGContextAddEllipseInRect(context, self.innerRingRectangle);
        CGContextSetFillColorWithColor(context, self.innerRingFillColor.CGColor);
        CGContextFillPath(context);
    }
    [self drawInnerDiskInContext:context withBounds:bounds];
}

@end
