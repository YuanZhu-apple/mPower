//
//  APHScoring.h
//  Parkinson's
//
//  Copyright (c) 2014 <INSTITUTION-NAME-TBD>. All rights reserved.
//

#import <Foundation/Foundation.h>

@import APCAppleCore;

typedef NS_ENUM(NSUInteger, APHScoreDataKinds)
{
    APHDataKindNone = 0,
    APHDataKindSystolicBloodPressure,
    APHDataKindTotalCholesterol,
    APHDataKindHDL,
    APHDataKindHeartRate,
    APHDataKindWalk
};

@interface APHScoring : NSEnumerator <APCLineGraphViewDataSource>

- (instancetype)initWithKind:(NSUInteger)kind numberOfDays:(NSUInteger)numberOfDays correlateWithKind:(NSUInteger)correlateKind;
- (NSNumber *)minimumDataPoint;
- (NSNumber *)maximumDataPoint;
- (NSNumber *)averageDataPoint;
- (id)nextObject;

@end
