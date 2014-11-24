//
//  APHAudioRecorderConfiguration.m
//  Parkinson
//
//  Created by Henry McGilton on 11/21/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHAudioRecorderConfiguration.h"
#import "APHAudioRecorder.h"

@implementation APHAudioRecorderConfiguration

- (RKSTRecorder*)recorderForStep:(RKSTStep*)step outputDirectory:(NSURL *)outputDirectory
{
    self.recorder = [[APHAudioRecorder alloc] initWithRecorderSettings:self.recorderSettings step:nil outputDirectory:outputDirectory];
    
    return  self.recorder;
}

@end
