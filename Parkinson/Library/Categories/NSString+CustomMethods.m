//
//  NSString+CustomMethods.m
//  Parkinson
//
//  Created by Henry McGilton on 8/20/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "NSString+CustomMethods.h"

@implementation NSString (CustomMethods)

- (BOOL)hasContent
{
    BOOL  answer = NO;
    if (self.length > 0) {
        answer = YES;
    }
    return  answer;
}

@end
