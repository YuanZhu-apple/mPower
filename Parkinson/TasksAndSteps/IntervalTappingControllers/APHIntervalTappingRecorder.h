// 
//  APHIntervalTappingRecorder.h 
//  mPower 
// 
//  Copyright (c) 2014 Apple, Inc. All rights reserved. 
// 
 
#import <ResearchKit/ResearchKit_Private.h>

@class  APHIntervalTappingRecorder;

@protocol  APHIntervalTappingRecorderDelegate <NSObject>

@required

- (void)recorder:(APHIntervalTappingRecorder *)recorder didRecordTap:(NSNumber *)tapCount;

@end

@interface APHIntervalTappingRecorder : RKSTRecorder

@property  (nonatomic, weak)  id <APHIntervalTappingRecorderDelegate>  tappingDelegate;

@end

@interface APHIntervalTappingRecorderConfiguration : RKSTRecorderConfiguration 

@end
