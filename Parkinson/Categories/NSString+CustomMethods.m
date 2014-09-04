//
//  NSString+CustomMethods.m
//  Parkinson
//
//  Created by Henry McGilton on 8/20/14.
//  Copyright (c) 2014 Henry McGilton. All rights reserved.
//

#import "NSString+CustomMethods.h"

@implementation NSString (CustomMethods)

- (BOOL)hasContent
{
    BOOL  answer = YES;
    if (self.length == 0) {
        answer = NO;
    }
    return  answer;
}

@end
