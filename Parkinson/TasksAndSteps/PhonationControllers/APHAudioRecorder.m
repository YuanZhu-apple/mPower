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

@interface APHAudioRecorder ( )

@property  (nonatomic, assign)  BOOL  startRecorderMessageWasSent;
@property  (nonatomic, assign)  BOOL  stopRecorderMessageWasSent;

@end

@implementation APHAudioRecorder

- (void)start
{
//    NSLog(@"APHAudioRecorder start");
    if (self.startRecorderMessageWasSent == NO) {
        [super start];
        NSDictionary  *info = @{ APHAudioRecorderInstanceKey : self };
        
        NSNotification  *notification = [NSNotification notificationWithName:APHAudioRecorderDidStartKey
                                                       object:nil
                                                    userInfo:info];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        self.startRecorderMessageWasSent = YES;
    }
    
}

- (void)stop
{
//    NSLog(@"APHAudioRecorder stop");
    if (self.stopRecorderMessageWasSent == NO) {
        [super stop];
        self.stopRecorderMessageWasSent = YES;
    }
}

@end
