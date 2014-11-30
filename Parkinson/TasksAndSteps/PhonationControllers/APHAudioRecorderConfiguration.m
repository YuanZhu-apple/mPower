//
//  APHAudioRecorderConfiguration.m
//  Parkinson's
//
//  Copyright (c) 2014 <INSTITUTION-NAME-TBD>. All rights reserved.
//

#import "APHAudioRecorderConfiguration.h"
#import "APHAudioRecorder.h"

@implementation APHAudioRecorderConfiguration

- (NSURL *)makeOutputDirectory
{
    NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *path = [[paths lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", [[NSUUID UUID] UUIDString]]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path] == NO) {
        NSError  *fileError = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&fileError];
        if (fileError != nil) {
//          NSLog(@"APHAudioRecorderConfiguration directory creation error = %@", fileError);
        }
    }
    NSURL  *pathUrl = nil;
    if (path != nil) {
        pathUrl = [NSURL fileURLWithPath:path];
    }
    return  pathUrl;
}

- (RKSTRecorder*)recorderForStep:(RKSTStep*)step outputDirectory:(NSURL *)outputDirectory
{
    if (outputDirectory == nil) {
        outputDirectory = [self makeOutputDirectory];
    }
    
    self.recorder = [[APHAudioRecorder alloc] initWithRecorderSettings:self.recorderSettings step:step outputDirectory:outputDirectory];
    
    return  self.recorder;
}

@end
