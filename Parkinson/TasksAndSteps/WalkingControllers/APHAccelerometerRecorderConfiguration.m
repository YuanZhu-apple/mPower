// 
//  APHAccelerometerRecorderConfiguration.m 
//  mPower 
// 
//  Copyright (c) 2014 Apple, Inc. All rights reserved. 
// 
 
#import "APHAccelerometerRecorderConfiguration.h"
#import "APHAccelerometerRecorder.h"

#import <APCAppCore/APCAppCore.h>

@implementation APHAccelerometerRecorderConfiguration

- (RKSTRecorder *)recorderForStep:(RKSTStep *)step outputDirectory:(NSURL *)outputDirectory
{
    self.recorder = [[APHAccelerometerRecorder alloc] initWithFrequency:self.frequency step:step outputDirectory:outputDirectory];
    APCLogDebug(@"APHAccelerometerRecorderConfiguration recorderForStep called, recorder = %@", self.recorder);
    return  self.recorder;
}

@end
