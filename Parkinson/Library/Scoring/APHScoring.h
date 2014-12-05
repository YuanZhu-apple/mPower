// 
//  APHScoring.h 
//  mPower 
// 
//  Copyright (c) 2014 <INSTITUTION-NAME-TBD> All rights reserved. 
// 
 
#import <Foundation/Foundation.h>

@import APCAppCore;

@interface APHScoring : NSEnumerator <APCLineGraphViewDataSource>

- (instancetype)initWithHealthKitQuantityType:(HKQuantityType *)quantityType
                                 numberOfDays:(NSUInteger)numberOfDays;

- (instancetype)initWithTask:(NSString *)taskId
                numberOfDays:(NSUInteger)numberOfDays
                    valueKey:(NSString *)valueKey
                     dataKey:(NSString *)dataKey;

- (NSNumber *)minimumDataPoint;
- (NSNumber *)maximumDataPoint;
- (NSNumber *)averageDataPoint;
- (id)nextObject;

@end
