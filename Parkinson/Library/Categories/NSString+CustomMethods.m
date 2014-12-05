// 
//  NSString+CustomMethods.m 
//  mPower 
// 
//  Copyright (c) 2014 <INSTITUTION-NAME-TBD> All rights reserved. 
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
