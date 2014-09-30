//
//  APHIntervalTappingRecorder.h
//  Parkinson
//
//  Created by Henry McGilton on 9/26/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import <ResearchKit/ResearchKit.h>

@interface APHIntervalTappingRecorder : RKRecorder

@property  (nonatomic, strong)  NSMutableArray  *records;

@end

@interface APHIntervalTappingRecorderConfiguration : NSObject <RKRecorderConfiguration>

@end