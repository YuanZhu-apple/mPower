//
//  APHRippleView.m
//  Parkinson
//
//  Created by Ramsundar Shandilya on 11/12/14.
//  Copyright (c) 2014 Ramsundar Shandilya. All rights reserved.
//

#import "APHRippleView.h"

@import APCAppleCore;

@interface APHRippleView ()

@property  (nonatomic, assign)  CGFloat               animationDuration;

@property  (nonatomic, strong)  NSMutableDictionary  *layersQueue;

@property  (nonatomic, assign)  NSUInteger            count;

@end

@implementation APHRippleView

@synthesize tintColor = _tintColor;

- (instancetype)init
{
    if (self = [super init]) {
        [self sharedInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self sharedInit];
    }
    return self;
}

#pragma mark - Setup

- (void)sharedInit
{
    self.backgroundColor = [UIColor clearColor];
    self.layersQueue = [NSMutableDictionary new];
    
    _minimumRadius = 20.0f;
    _maximumRadius = MAX(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    
    _animationDuration = 0.2;
    
    _tintColor = [UIColor appTertiaryPurpleColor];
    
    _count = 0;
}

- (CAShapeLayer *)rippleLayer
{
    CAShapeLayer *rippleLayer = [CAShapeLayer layer];
    rippleLayer.frame = CGRectMake(0, 0, self.maximumRadius, self.maximumRadius);
    rippleLayer.path = [UIBezierPath bezierPathWithOvalInRect:rippleLayer.bounds].CGPath;
    rippleLayer.fillColor = _tintColor.CGColor;
    rippleLayer.opacity = 0.9;
    rippleLayer.transform = CATransform3DMakeScale(0.3, 0.3, 0.3);
    
    return rippleLayer;
} 

#pragma mark - Touches

- (void)rippleAtPoint:(CGPoint)touchPoint
{
    CAShapeLayer *rippleLayer = [self rippleLayer];
    [self.layer addSublayer:rippleLayer];
    
    rippleLayer.position = touchPoint;
    [self animateRipple:rippleLayer];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSArray  *touchesArray = [touches allObjects];
    NSMutableArray  *points = [NSMutableArray arrayWithCapacity:[touchesArray count]];
    for (UITouch *touche in touchesArray) {
        CGPoint touchPoint = [touche locationInView:self];
        
        CAShapeLayer  *rippleLayer = [self rippleLayer];
        [self.layer addSublayer:rippleLayer];
        
        rippleLayer.position = touchPoint;
        [self animateRipple:rippleLayer];
        NSValue  *value = [NSValue valueWithCGPoint:touchPoint];
        [points addObject:value];
    }
    if (self.delegate != nil) {
        [self.delegate rippleView:self touchesDidOccurAtPoints:points];
    }
}

#pragma mark - Animation

- (void)animateRipple:(CALayer *)rippleLayer
{
    CABasicAnimation *growAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    growAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    growAnimation.duration = 0.2;
    growAnimation.removedOnCompletion = NO;
    growAnimation.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation.toValue = @(0);
    fadeAnimation.beginTime = 0.2;
    fadeAnimation.duration = 0.3;
    fadeAnimation.removedOnCompletion = NO;
    fadeAnimation.fillMode = kCAFillModeForwards;

    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.duration = 0.5;
    groupAnimation.removedOnCompletion = NO;
    groupAnimation.fillMode = kCAFillModeForwards;
    groupAnimation.delegate = self;
    groupAnimation.animations = @[growAnimation, fadeAnimation];
    
    self.count++;
    
    NSString *keyName = [NSString stringWithFormat:@"ripple_%lu", (unsigned long)self.count];
    [self.layersQueue setObject:rippleLayer forKey:keyName];
    
    [groupAnimation setValue:keyName forKeyPath:@"RippleAnimation"];
    [rippleLayer addAnimation:groupAnimation forKey:@"RippleAnimation"];
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSString *keyName = [anim valueForKey:@"RippleAnimation"];
    
    CALayer *rippleLayer = (CALayer *)self.layersQueue[keyName];
    if (rippleLayer) {
        [rippleLayer removeFromSuperlayer];
        [self.layersQueue removeObjectForKey:keyName];
    }
}

@end
