//
//  APHChangedMedsTaskViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 9/3/14.
//  Copyright (c) 2014 Henry McGilton. All rights reserved.
//

#import "APHChangedMedsTaskViewController.h"

@interface APHChangedMedsTaskViewController  ( )

@end

@implementation APHChangedMedsTaskViewController

#pragma  mark  -  Initialisation

+ (instancetype)customTaskViewController
{
    RKTask  *task = [self createTask];
    APHChangedMedsTaskViewController  *controller = [[APHChangedMedsTaskViewController alloc] initWithTask:task taskInstanceUUID:[NSUUID UUID]];
    controller.delegate = controller;
    return  controller;
}

+ (RKTask *)createTask
{
    return  nil;
}

@end
