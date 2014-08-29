//
//  RKStep+Description.m
//  Parkinson
//
//  Created by Henry McGilton on 8/20/14.
//  Copyright (c) 2014 Henry McGilton. All rights reserved.
//

#import "RKStep+Description.h"

@implementation RKStep (Description)

- (BOOL)description
{
    NSMutableString  *desc = [NSMutableString string];
    if (self.identifier != nil) {
        [desc appendWithFormat:@""];
    }
    return  desc;
}

@end
//  identifier;
//  @property (nonatomic, copy, readonly) NSString *name
