// 
//  APHAccelerometerRecorder.m 
//  mPower 
// 
//  Copyright (c) 2014 Apple, Inc. All rights reserved. 
// 
 
#import "APHAccelerometerRecorder.h"

@interface APHAccelerometerRecorder ( )

@property  (nonatomic, assign)  BOOL  startRecorderMessageWasSent;
@property  (nonatomic, assign)  BOOL  stopRecorderMessageWasSent;

@end

@implementation APHAccelerometerRecorder

- (void)start
{
    if (self.startRecorderMessageWasSent == NO) {
        [super start];
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
