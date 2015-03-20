//
//  ConverterForPDScores.h
//  mPower
//
//  Copyright (c) 2015 Apple, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@import APCAppCore;

@interface ConverterForPDScores : NSObject

+ (NSArray*)convertTappings:(ORKTappingIntervalResult *)result;
+ (NSArray*)convertPostureOrGain:(NSURL *)url;

@end
