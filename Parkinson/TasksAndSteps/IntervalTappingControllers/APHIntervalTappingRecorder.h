//
//  APHIntervalTappingRecorder.h
//  Parkinson's
//
//  Copyright (c) 2014 <INSTITUTION-NAME-TBD>. All rights reserved.
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
