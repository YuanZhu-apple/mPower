//
//  APHIntervalTappingFeedbackView.m
//  Parkinson
//
//  Created by Henry McGilton on 11/5/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHIntervalTappingFeedbackView.h"

static  CGGradientRef  target = NULL;

@interface APHIntervalTappingFeedbackView  ( )

@end

@implementation APHIntervalTappingFeedbackView

+ (void)initialize
{
    if (target == NULL) {
        CGColorSpaceRef  colorSpace = CGColorSpaceCreateDeviceRGB();
        CGFloat  lite[4] = { 0.9375, 0.9375, 1.0, 0.75 };    //    light color
        CGFloat  dark[4] = { 0.5000, 0.5000, 1.0, 1.00 };    //    dark color
        
        CGFloat  locations[] = { 1.0, 0.0 };
        CGColorRef  startColorRef  = CGColorCreate(colorSpace, lite);
        CGColorRef  endColorRef    = CGColorCreate(colorSpace, dark);
        
        NSArray  *colors = @[(__bridge NSObject *)startColorRef, (__bridge NSObject *)endColorRef];
        CGGradientRef  aGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, locations);
        target = aGradient;
    }
}

- (BOOL)isOpaque
{
    return  NO;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef  context = UIGraphicsGetCurrentContext();
    CGRect  bounds = self.bounds;
    CGContextDrawRadialGradient(context, target, CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds)), 0.0,
                                CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds)), CGRectGetWidth(bounds) / 2.0, 0);
}

- (void)dealloc
{
    if (target != NULL) {
        CGGradientRelease(target);
    }
}

@end
