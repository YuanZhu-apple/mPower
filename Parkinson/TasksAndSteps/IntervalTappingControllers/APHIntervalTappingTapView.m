//
//  APHIntervalTappingTapView.m
//  Parkinson
//
//  Created by Henry McGilton on 9/16/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHIntervalTappingTapView.h"

static  CGFloat  kPathLineWidth = 2.0;

static  NSString  *kCaption = nil;

static  NSString  *kFontName = @"Helvetica";
static  CGFloat    kPointSize = 20.0;

static  NSDictionary  *enabledAttributes  = nil;
static  NSDictionary  *disabledAttributes = nil;

@implementation APHIntervalTappingTapView

#pragma mark - Initialisation

+ (void)initialize
{
    if (kCaption == nil) {
        kCaption = NSLocalizedString(@"Tap", nil);
    }
    if (enabledAttributes == nil) {
        enabledAttributes = @{
                              NSFontAttributeName : [UIFont fontWithName:kFontName size:kPointSize],
                              NSForegroundColorAttributeName : [UIColor whiteColor]
                              };
    }
    if (disabledAttributes == nil) {
        disabledAttributes = @{
                              NSFontAttributeName : [UIFont fontWithName:kFontName size:kPointSize],
                              NSForegroundColorAttributeName : [UIColor grayColor]
                              };
    }
}

#pragma mark - Accessors

- (void)setEnabled:(BOOL)aEnabled
{
    if (_enabled != aEnabled) {
        _enabled = aEnabled;
        [self setNeedsDisplay];
    }
}

#pragma mark - Drawing

- (void)drawTapCaption
{
    CGSize  size = [kCaption sizeWithAttributes:enabledAttributes];
    CGFloat  x = (CGRectGetWidth(self.bounds) - size.width) / 2.0;
    CGFloat  y = (CGRectGetHeight(self.bounds) - size.height) / 2.0;
    CGPoint  drawPoint = CGPointMake(x, y);
    if (self.isEnabled == YES) {
        [kCaption drawAtPoint:drawPoint withAttributes:enabledAttributes];
    } else {
        [kCaption drawAtPoint:drawPoint withAttributes:disabledAttributes];
    }
}

- (void)drawRect:(CGRect)rect
{
    CGRect  bounds = self.bounds;
    CGFloat  kPathHalfLineWidth = kPathLineWidth / 2.0;
    
    if (self.isEnabled == YES) {
        UIBezierPath  *path = [UIBezierPath bezierPathWithOvalInRect:bounds];
        [[UIColor blueColor] set];
        [path fill];
    } else {
        UIEdgeInsets  insets = UIEdgeInsetsMake(kPathHalfLineWidth, kPathHalfLineWidth, kPathHalfLineWidth, kPathHalfLineWidth);
        bounds = UIEdgeInsetsInsetRect(bounds, insets);
        UIBezierPath  *path = [UIBezierPath bezierPathWithOvalInRect:bounds];
        path.lineWidth = kPathLineWidth;
        [[UIColor grayColor] set];
        [path stroke];
    }
    [self drawTapCaption];
}

@end
