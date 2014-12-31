// 
//  APHAudioRecorderConfiguration.m 
//  mPower 
// 
//  Copyright (c) 2014 Apple, Inc. All rights reserved. 
// 
 
#import "APHAudioRecorderConfiguration.h"
#import "APHAudioRecorder.h"

#import <APCAppCore/APCAppCore.h>

@implementation APHAudioRecorderConfiguration

- (RKSTRecorder*)recorderForStep:(RKSTStep*)step outputDirectory:(NSURL *)outputDirectory
{
    self.recorder = [[APHAudioRecorder alloc] initWithRecorderSettings:self.recorderSettings step:step outputDirectory:outputDirectory];
    return  self.recorder;
}

@end
