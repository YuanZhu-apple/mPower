//
//  APHIntervalTappingRecorder.h
//  Parkinson
//
//  Created by Henry McGilton on 9/26/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHIntervalTappingRecorder.h"

@interface APHIntervalTappingRecorder ()

@property  (nonatomic, weak)    UIView          *containerView;
//@property  (nonatomic, strong)  NSMutableArray  *records;

@end

@implementation APHIntervalTappingRecorder

- (void)viewController:(UIViewController*)viewController willStartStepWithView:(UIView *)view
{
    NSLog(@"viewController willStartStepWithView called");
    [super viewController:viewController willStartStepWithView:view];
    self.containerView = view;
}

- (BOOL)start:(NSError *__autoreleasing *)error
{
    BOOL  answer = [super start:error];

    if (answer == NO) {
        NSLog(@"Error %@", *error);
    } else {
//        NSAssert(self.containerView != nil, @"No container view attached.");
    }
    return  answer;
}

- (BOOL)stop:(NSError *__autoreleasing *)error
{
    BOOL  answer = [super stop:error];
    
    if (answer == NO) {
        NSLog(@"Error %@", *error);
    } else {
        if (self.records != nil) {
//            NSLog(@"%@", self.records);
            
            id <RKRecorderDelegate> kludgedDelegate = self.delegate;
            
            if (kludgedDelegate != nil && [kludgedDelegate respondsToSelector:@selector(recorder:didCompleteWithResult:)]) {
                RKDataResult  *result = [[RKDataResult alloc] initWithStep:self.step];
                result.contentType = [self mimeType];
                NSError  *serializationError = nil;
                result.data = [NSJSONSerialization dataWithJSONObject:self.records options:(NSJSONWritingOptions)0 error:&serializationError];
                
                if (serializationError != nil) {
                    if (error != nil) {
                        *error = serializationError;
                        NSLog(@"Error %@", *error);
                    }
                    answer = NO;
                } else {
                    result.filename = self.fileName;
                    [kludgedDelegate recorder:self didCompleteWithResult:result];
//                    self.records = nil;
                }
            }
        } else {
            if (error != nil) {
                *error = [NSError errorWithDomain:RKErrorDomain
                                             code:RKErrorObjectNotFound
                                         userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"Records object is nil.", nil)}];

                NSLog(@"Error %@", *error);
            }
            answer = NO;
        }
    }
    return  answer;
}

- (NSString*)dataType
{
    return @"tapTheButton";
}

- (NSString*)mimeType
{
    return @"application/json";
}

- (NSString*)fileName
{
    return @"tapTheButton.json";
}

@end

@implementation APHIntervalTappingRecorderConfiguration

- (RKRecorder *)recorderForStep:(RKStep *)step taskInstanceUUID:(NSUUID *)taskInstanceUUID
{
    NSLog(@"APHIntervalTappingRecorderConfiguration recorderForStep called");
    return [[APHIntervalTappingRecorder alloc] initWithStep:step taskInstanceUUID:taskInstanceUUID];
}

#pragma mark - RKSerialization

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [self init];
    if (self) {
    }
    return self;
}

- (NSDictionary *)dictionaryValue
{
    NSMutableDictionary  *dictionary = [NSMutableDictionary new];
    
    dictionary[@"_class"] = NSStringFromClass([self class]);
    
    return  dictionary;
}

@end

