//
//  ConverterForPDScores.m
//  mPower
//
//  Copyright (c) 2014 Apple, Inc. All rights reserved.
//

#import "ConverterForPDScores.h"

NSString *const kTappingViewSizeKey       = @"TappingViewSize";
NSString *const kStartDateKey           = @"startDate";
NSString *const kEndDateKey             = @"endDate";

NSString *const kButtonRectLeftKey        = @"ButtonRectLeft";
NSString *const kButtonRectRightKey       = @"ButtonRectRight";
NSString *const kTapTimeStampKey      = @"TapTimeStamp";
NSString *const kTapCoordinateKey     = @"TapCoordinate";

NSString *const kTappedButtonNoneKey  = @"TappedButtonNone";
NSString *const kTappedButtonLeftKey  = @"TappedButtonLeft";
NSString *const kTappedButtonRightKey = @"TappedButtonRight";

NSString *const  kTappedButtonIdKey    = @"TappedButtonId";

NSString *const kQuestionTypeKey        = @"questionType";
NSString *const kQuestionTypeNameKey    = @"questionTypeName";
NSString *const kUserInfoKey            = @"userInfo";
NSString *const kIdentifierKey          = @"identifier";

NSString *const kTaskRunKey             = @"taskRun";
NSString *const kItemKey                = @"item";

static  NSString  *kTappingSamplesKey        = @"TappingSamples";

@implementation ConverterForPDScores

+ (NSArray*)convertTappings:(ORKTappingIntervalResult *)result
{
    NSMutableDictionary  *rawTappingResults = [NSMutableDictionary dictionary];
    
    NSString  *tappingViewSize = NSStringFromCGSize(result.stepViewSize);
    rawTappingResults[kTappingViewSizeKey] = tappingViewSize;
    
    rawTappingResults[kStartDateKey] = result.startDate;
    rawTappingResults[kEndDateKey]   = result.endDate;
    
    NSString  *leftButtonRect = NSStringFromCGRect(result.buttonRect1);
    rawTappingResults[kButtonRectLeftKey] = leftButtonRect;
    
    NSString  *rightButtonRect = NSStringFromCGRect(result.buttonRect2);
    rawTappingResults[kButtonRectRightKey] = rightButtonRect;
    
    NSArray  *samples = result.samples;
    NSMutableArray  *sampleResults = [NSMutableArray array];
    for (ORKTappingSample *sample  in  samples) {
        NSMutableDictionary  *aSampleDictionary = [NSMutableDictionary dictionary];
        
        aSampleDictionary[kTapTimeStampKey]     = @(sample.timestamp);
        
        aSampleDictionary[kTapCoordinateKey]   = NSStringFromCGPoint(sample.location);
        
        if (sample.buttonIdentifier == ORKTappingButtonIdentifierNone) {
            aSampleDictionary[kTappedButtonIdKey] = kTappedButtonNoneKey;
        } else if (sample.buttonIdentifier == ORKTappingButtonIdentifierLeft) {
            aSampleDictionary[kTappedButtonIdKey] = kTappedButtonLeftKey;
        } else if (sample.buttonIdentifier == ORKTappingButtonIdentifierRight) {
            aSampleDictionary[kTappedButtonIdKey] = kTappedButtonRightKey;
        }
        [sampleResults addObject:aSampleDictionary];
    }
    return sampleResults;
}

+ (NSArray*)convertPostureOrGain:(NSURL *)url {
    NSData *jsonData = [NSData dataWithContentsOfURL:url];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:NULL];
    NSArray *gaitItems = [json objectForKey:@"items"];
    return gaitItems;
}

@end
