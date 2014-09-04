//
//  APHIntervalTappingTaskViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 9/3/14.
//  Copyright (c) 2014 Henry McGilton. All rights reserved.
//

#import "APHIntervalTappingTaskViewController.h"

@interface APHIntervalTappingTaskViewController  ( )

@end

@implementation APHIntervalTappingTaskViewController

#pragma  mark  -  Initialisation

+ (instancetype)customTaskViewController
{
    RKTask  *task = [self createTask];
    APHIntervalTappingTaskViewController  *controller = [[APHIntervalTappingTaskViewController alloc] initWithTask:task taskInstanceUUID:[NSUUID UUID]];
    controller.delegate = controller;
    return  controller;
}

+ (RKTask *)createTask
{
    return  nil;
}

@end
