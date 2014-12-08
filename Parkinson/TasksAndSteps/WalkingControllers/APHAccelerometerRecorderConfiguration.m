// 
//  APHAccelerometerRecorderConfiguration.m 
//  mPower 
// 
//  Copyright (c) 2014 Apple, Inc. All rights reserved. 
// 
 
#import "APHAccelerometerRecorderConfiguration.h"
#import "APHAccelerometerRecorder.h"

@implementation APHAccelerometerRecorderConfiguration

- (NSURL *)makeOutputDirectory
{
    NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *path = [[paths lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", [[NSUUID UUID] UUIDString]]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path] == NO) {
        NSError  *fileError = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&fileError];
        if (fileError != nil) {
        }
    }
    NSURL  *pathUrl = nil;
    if (path != nil) {
        pathUrl = [NSURL fileURLWithPath:path];
    }
    return  pathUrl;
}

- (RKSTRecorder *)recorderForStep:(RKSTStep *)step outputDirectory:(NSURL *)outputDirectory
{
    if (outputDirectory == nil) {
        outputDirectory = [self makeOutputDirectory];
    }
    self.recorder = [[APHAccelerometerRecorder alloc] initWithFrequency:self.frequency step:step outputDirectory:outputDirectory];

    return  self.recorder;
}

@end
