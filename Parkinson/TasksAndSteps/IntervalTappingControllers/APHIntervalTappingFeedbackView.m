//
//  APHIntervalTappingFeedbackView.m
//  Parkinson
//
//  Created by Henry McGilton on 11/5/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHIntervalTappingFeedbackView.h"

@interface APHIntervalTappingFeedbackView  ( )

@property  (nonatomic, assign)  CGGradientRef  gradient;

@end

@implementation APHIntervalTappingFeedbackView

- (void)createGradient
{
    CGColorSpaceRef  colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGFloat  lite[4] = { 0.9375, 0.9375, 1.0, 0.75 };    //    light color
    CGFloat  dark[4] = { 0.5000, 0.5000, 1.0, 1.00 };    //    dark color
    
    CGFloat  locations[] = { 1.0, 0.0 };
    
    CGColorRef  startColorRef  = CGColorCreate(colorSpace, lite);
    CGColorRef  endColorRef    = CGColorCreate(colorSpace, dark);
    
    NSArray  *colors = @[(__bridge_transfer NSObject *)startColorRef, (__bridge_transfer NSObject *)endColorRef];
    self.gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, locations);
    CFRelease(colorSpace);
}

- (BOOL)isOpaque
{
    return  NO;
}

- (void)drawRect:(CGRect)rect
{
    [self createGradient];
    
    CGContextRef  context = UIGraphicsGetCurrentContext();
    CGRect  bounds = self.bounds;
    CGContextDrawRadialGradient(context, self.gradient, CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds)), 0.0,
                                CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds)), CGRectGetWidth(bounds) / 2.0, 0);
}

- (void)dealloc
{
    if (_gradient != NULL) {
        CGGradientRelease(_gradient);
    }
}

@end
