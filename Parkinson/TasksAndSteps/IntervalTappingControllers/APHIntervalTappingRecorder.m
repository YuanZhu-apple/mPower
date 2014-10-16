//
//  APHIntervalTappingRecorder.h
//  Parkinson
//
//  Created by Henry McGilton on 9/26/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHIntervalTappingRecorder.h"
#import "APHIntervalTappingTargetContainer.h"
#import "APHIntervalTappingTapView.h"

static  NSString  *kWhichTargetRecordKey = @"WhichTarget";
static          NSString  *kLeftTargetRecordKey  = @"LeftTarget";
static          NSString  *kRightTargetRecordKey = @"RightTarget";
static  NSString  *kXCoordinateRecordKey = @"XCoordinate";
static  NSString  *kYCoordinateRecordKey = @"YCoordinate";
static  NSString  *kYTimeStampRecordKey  = @"TimeStamp";

@interface APHIntervalTappingRecorder ()

@property  (nonatomic, weak)    APHIntervalTappingTargetContainer  *container;
@property  (nonatomic, strong)  NSMutableArray                     *records;

@property  (nonatomic, assign)  NSUInteger                          tapsCounter;

@end

@implementation APHIntervalTappingRecorder

#pragma  mark  -  Tapping Methods

- (BOOL)doesTargetContainPoint:(CGPoint)point inView:(UIView *)view
{
    BOOL  answer = YES;
    
    CGFloat  dx = point.x - CGRectGetMidX(view.bounds);
    CGFloat  dy = point.y - CGRectGetMidY(view.bounds);
    CGFloat  h = hypot(dx, dy);
    if (h > CGRectGetWidth(view.bounds) / 2.0) {
        answer = NO;
    }
    return  answer;
}

- (void)addRecord:(UITapGestureRecognizer *)recogniser
{
    
    CGPoint  point = [recogniser locationInView:recogniser.view];
    
    NSDictionary  *record = @{ kWhichTargetRecordKey : recogniser.view == self.container.tapperLeft ? kLeftTargetRecordKey: kRightTargetRecordKey,
                               kYTimeStampRecordKey  : @([[NSDate date] timeIntervalSinceReferenceDate]),
                               kXCoordinateRecordKey : @(point.x),
                               kYCoordinateRecordKey : @(point.y)
                            };
    [self.records addObject:record];
}

- (void)targetWasTapped:(UITapGestureRecognizer *)recogniser
{
    BOOL  didRecordTouch = NO;
    
    if (recogniser.view == self.container.tapperLeft) {
        CGPoint  location = [recogniser locationInView:self.container.tapperLeft];
        if ([self doesTargetContainPoint:location inView:self.container.tapperLeft] == YES) {
            didRecordTouch = YES;
        }
    } else if (recogniser.view == self.container.tapperRight) {
        CGPoint  location = [recogniser locationInView:self.container.tapperRight];
        if ([self doesTargetContainPoint:location inView:self.container.tapperRight] == YES) {
            didRecordTouch = YES;
        }
    }
    if (didRecordTouch == YES) {
        [self addRecord:recogniser];
        self.tapsCounter = self.tapsCounter + 1;
        if (self.tappingDelegate != nil) {
            [self.tappingDelegate recorder:self didRecordTap:@(self.tapsCounter)];
        }
    }
}

#pragma  -  Recorder Tap Targets Setup 

- (void)viewController:(UIViewController*)viewController willStartStepWithView:(UIView *)view
{
    NSLog(@"viewController willStartStepWithView called");
    [super viewController:viewController willStartStepWithView:view];
    self.container = (APHIntervalTappingTargetContainer *)view;
    
    APHIntervalTappingTargetContainer *tapperContainer = [[APHIntervalTappingTargetContainer alloc] initWithFrame:CGRectMake(0.0, 0.0, 280.0, 160.0)];
    
    APHIntervalTappingTapView *tapperLeft = [[APHIntervalTappingTapView alloc] initWithFrame:CGRectMake(20.0, 20.0, 100.0, 100.0)];
    APHIntervalTappingTapView *tapperRight = [[APHIntervalTappingTapView alloc] initWithFrame:CGRectMake(182.0, 20.0, 100.0, 100.0)];
    
    [tapperContainer addSubview:tapperLeft];
    [tapperContainer addSubview:tapperRight];

    tapperContainer.tapperLeft = tapperLeft;
    tapperContainer.tapperRight = tapperRight;
    
    self.container = (APHIntervalTappingTargetContainer *)tapperContainer;
    
    [tapperContainer setBackgroundColor:[UIColor redColor]];
    UITapGestureRecognizer  *tapsterLeft = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(targetWasTapped:)];
    [self.container.tapperLeft addGestureRecognizer:tapsterLeft];
    
    UITapGestureRecognizer  *tapsterRight = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(targetWasTapped:)];
    [self.container.tapperRight addGestureRecognizer:tapsterRight];
    
    [tapperContainer setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[c(>=160)]" options:0 metrics:nil views:@{@"c":tapperContainer}];
    
    for (NSLayoutConstraint *constraint in verticalConstraints) {
        constraint.priority = UILayoutPriorityFittingSizeLevel;
    }
    
    [tapperContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[c(>=280)]" options:0 metrics:nil views:@{@"c":tapperContainer}]];
    
    [tapperContainer addConstraints:verticalConstraints];
    
    [(RKActiveStepViewController *)viewController setCustomView:tapperContainer];
    
    
    
    
    
    
    self.records = [NSMutableArray array];
}

#pragma  -  Recorder Control Methods

- (BOOL)start:(NSError *__autoreleasing *)error
{
    BOOL  answer = [super start:error];

    if (answer == NO) {
        NSLog(@"Error %@", *error);
    } else {
        NSAssert(self.container != nil, @"No container view attached.");
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

#pragma  -  Recorder Configuration and Initialisation

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

