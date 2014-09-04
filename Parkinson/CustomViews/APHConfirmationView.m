//
//  APHConfirmationView.m
//  Parkinson
//
//  Created by Henry McGilton on 8/20/14.
//  Copyright (c) 2014 Henry McGilton. All rights reserved.
//

#import "APHConfirmationView.h"

static  const  CGFloat  insetForBorder = 0.5;

@implementation APHConfirmationView

- (void)drawRect:(CGRect)rect
{
    CGRect  bounds = self.bounds;
    
    self.backgroundColor = [UIColor clearColor];
    
    UIEdgeInsets  insets = UIEdgeInsetsMake(insetForBorder, insetForBorder, insetForBorder, insetForBorder);
    bounds = UIEdgeInsetsInsetRect(bounds, insets);
    
    UIBezierPath  *path = [UIBezierPath bezierPathWithOvalInRect:bounds];
    
    if (self.isCompleted == YES) {
        [[UIColor greenColor] set];
        [path fill];
        [path stroke];
    } else {
        [[UIColor grayColor] set];
        [path stroke];
    }
}

@end
