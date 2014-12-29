// 
//  APHAccelerometerRecorderConfiguration.m 
//  mPower 
// 
//  Copyright (c) 2014 Apple, Inc. All rights reserved. 
// 
 
#import "APHAccelerometerRecorderConfiguration.h"
#import "APHAccelerometerRecorder.h"

@implementation APHAccelerometerRecorderConfiguration

- (RKSTRecorder *)recorderForStep:(RKSTStep *)step outputDirectory:(NSURL *)outputDirectory
{
    self.recorder = [[APHAccelerometerRecorder alloc] initWithFrequency:self.frequency step:step outputDirectory:outputDirectory];
    return  self.recorder;
}

@end
