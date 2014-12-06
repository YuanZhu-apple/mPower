// 
//  APHAudioRecorder.m 
//  mPower 
// 
//  Copyright (c) 2014 <INSTITUTION-NAME-TBD> All rights reserved. 
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
    if (self.stopRecorderMessageWasSent == NO) {
        [super stop];
        self.stopRecorderMessageWasSent = YES;
    }
}

@end
