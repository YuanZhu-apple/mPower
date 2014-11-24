//
//  APHAudioRecorder.m
//  Parkinson
//
//  Created by Henry McGilton on 11/22/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHAudioRecorder.h"

NSString  *APHAudioRecorderDidStartKey = @"APHAudioRecorderDidStart";
NSString  *APHAudioRecorderInstanceKey = @"APHAudioRecorderInstance";

@implementation APHAudioRecorder

- (void)start
{
    NSLog(@"APHAudioRecorder start");
    [super start];
    
    NSDictionary  *info = @{ APHAudioRecorderInstanceKey : self };
    
    NSNotification  *notification = [NSNotification notificationWithName:APHAudioRecorderDidStartKey
                                                   object:nil
                                                userInfo:info];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}

- (void)stop
{
    NSLog(@"APHAudioRecorder stop");
    [super stop];
}

@end
