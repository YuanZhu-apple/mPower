//
//  APHIntervalTappingRecorder.h
//  Parkinson
//
//  Created by Henry McGilton on 9/26/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHIntervalTappingRecorder.h"

#import "APHIntervalTappingRecorderCustomView.h"
#import "APHIntervalTappingTapView.h"
#import "APHRippleView.h"


static  NSString  *kHealthApplicationNameKey     = @"HealthApplicationName";
static  NSString  *kHealthApplicationName        = @"Parkinson Health Application";
static  NSString  *kHealthApplicationTaskKey     = @"HealthApplicationTask";
static  NSString  *kIntervalTappingName          = @"ParkinsonIntervalTappingTask";

static  NSString  *kIntervalTappingRecordsKey    = @"ParkinsonIntervalTappingRecords";

static  NSString  *kContainerSizeTargetRecordKey = @"ContainerSize";
static  NSString  *kLeftTargetFrameRecordKey     = @"LeftTargetFrame";
static  NSString  *kRightTargetFrameRecordKey    = @"RightTargetFrame";

static  NSString  *kXCoordinateRecordKey         = @"XCoordinate";
static  NSString  *kYCoordinateRecordKey         = @"YCoordinate";
static  NSString  *kYTimeStampRecordKey          = @"TimeStamp";

static  CGFloat  kRipplerMinimumRadius           =   5.0;
static  CGFloat  kRipplerMaximumRadius           =  80.0;

@interface APHIntervalTappingRecorder ()

@property  (nonatomic, strong)  APHIntervalTappingRecorderCustomView  *outerTappingContainer;
@property  (nonatomic, strong)  RKActiveStepViewController            *stepperViewController;
@property  (nonatomic, weak)    APHRippleView                         *tappingTargetsContainer;

@property  (nonatomic, strong)  NSMutableDictionary                   *intervalTappingDictionary;
@property  (nonatomic, strong)  NSMutableArray                        *tappingRecords;
@property  (nonatomic, assign)  BOOL                                   dictionaryHeaderWasCreated;

@property  (nonatomic, assign)  NSUInteger                             tapsCounter;

@end

@implementation APHIntervalTappingRecorder

#pragma  mark  -  Tapping Methods

- (void)addRecord:(UITapGestureRecognizer *)recogniser
{
    CGPoint  point = [recogniser locationInView:recogniser.view];
    
    NSDictionary  *record = @{
                               kYTimeStampRecordKey  : @([[NSDate date] timeIntervalSinceReferenceDate]),
                               kXCoordinateRecordKey : @(point.x),
                               kYCoordinateRecordKey : @(point.y)
                            };
    [self.tappingRecords addObject:record];
}

- (void)setupdictionaryHeader
{
    APHIntervalTappingRecorderCustomView  *containerView = (APHIntervalTappingRecorderCustomView *)self.stepperViewController.customView;
    
    APHRippleView  *targetView = (APHRippleView *)containerView.tapTargetsContainer;
    
    [self.intervalTappingDictionary setObject:NSStringFromCGSize(targetView.frame.size)
                                       forKey:kContainerSizeTargetRecordKey];
    
    [self.intervalTappingDictionary setObject:NSStringFromCGRect(targetView.tapperLeft.frame)
                                       forKey:kLeftTargetFrameRecordKey];
    
    [self.intervalTappingDictionary setObject:NSStringFromCGRect(targetView.tapperRight.frame)
                                       forKey:kRightTargetFrameRecordKey];
    
    [self.intervalTappingDictionary setObject:self.tappingRecords
                                       forKey:kIntervalTappingRecordsKey];
}

- (void)targetWasTapped:(UITapGestureRecognizer *)recogniser
{
    if (self.dictionaryHeaderWasCreated == NO) {
        [self setupdictionaryHeader];
        self.dictionaryHeaderWasCreated = YES;
    }
    
    [self addRecord:recogniser];
    
    self.tapsCounter = self.tapsCounter + 1;
    self.outerTappingContainer.totalTapsCount.text = [NSString stringWithFormat:@"%lu", self.tapsCounter];
    if (self.tappingDelegate != nil) {
        [self.tappingDelegate recorder:self didRecordTap:@(self.tapsCounter)];
    }
    UIView  *tapView = recogniser.view;
    CGPoint  point = [recogniser locationInView:tapView];
    [self.tappingTargetsContainer rippleAtPoint:point];
}

#pragma  -  Recorder Tap Targets Setup

- (void)viewController:(UIViewController*)viewController willStartStepWithView:(UIView *)view
{
    [super viewController:viewController willStartStepWithView:view];
    
        //
        //    outerContainer is the view loaded from the Nib
        //
        //        outerContainer has two sub-views:
        //            top sub-view contains the 'Total Taps' label,
        //            and the Taps Count label
        //
        //            bottom sub-view is APHRippleView which contains the two tapping targets.
        //            APHRippleView tracks taps and provides fusion bomb feedback . . .
        //
    UINib  *nib = [UINib nibWithNibName:@"APHIntervalTappingRecorderCustomView" bundle:nil];
    APHIntervalTappingRecorderCustomView  *outerContainer = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
    self.outerTappingContainer = outerContainer;
    
    APHRippleView  *tapTargetsContainer = (APHRippleView *)outerContainer.tapTargetsContainer;
    
    tapTargetsContainer.tapperLeft = outerContainer.tapperLeft;
    tapTargetsContainer.tapperLeft.enabled = YES;
    
    tapTargetsContainer.tapperRight = outerContainer.tapperRight;
    tapTargetsContainer.tapperRight.enabled = YES;
    
    tapTargetsContainer.minimumRadius = kRipplerMinimumRadius;
    tapTargetsContainer.maximumRadius = kRipplerMaximumRadius;
    
    UITapGestureRecognizer  *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(targetWasTapped:)];
    [tapTargetsContainer addGestureRecognizer:tapRecognizer];

    [tapTargetsContainer addGestureRecognizer:tapRecognizer];
    
    self.tappingTargetsContainer = tapTargetsContainer;
    
    RKActiveStepViewController  *stepper = (RKActiveStepViewController *)viewController;
    
    [outerContainer setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSArray  *vc1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[c(==257.0)]" options:0 metrics:nil views:@{@"c":outerContainer}];
    [outerContainer addConstraints:vc1];

    NSArray  *vc2 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[c(==320.0)]" options:0 metrics:nil views:@{@"c":outerContainer}];
    [outerContainer addConstraints:vc2];
    
    stepper.customView = outerContainer;
    
    self.stepperViewController = stepper;
    
    self.tappingRecords            = [NSMutableArray array];
    self.intervalTappingDictionary = [NSMutableDictionary dictionary];
}

#pragma  -  Recorder Control Methods

- (BOOL)start:(NSError *__autoreleasing *)error
{
    BOOL  answer = [super start:error];

    if (answer == NO) {
        NSLog(@"Error %@", *error);
    }
    
    return  answer;
}

- (BOOL)stop:(NSError *__autoreleasing *)error
{
    BOOL  answer = [super stop:error];
    
    if (answer == NO) {
        NSLog(@"Error %@", *error);
    } else {
        if (self.tappingRecords != nil) {
            NSLog(@"%@", self.intervalTappingDictionary);
            
            id <RKRecorderDelegate> kludgedDelegate = self.delegate;
            
            if (kludgedDelegate != nil && [kludgedDelegate respondsToSelector:@selector(recorder:didCompleteWithResult:)]) {
                RKDataResult  *result = [[RKDataResult alloc] initWithStep:self.step];
                result.contentType = [self mimeType];
                NSError  *serializationError = nil;
                result.data = [NSJSONSerialization dataWithJSONObject:self.intervalTappingDictionary options:(NSJSONWritingOptions)0 error:&serializationError];
                
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
    return [[APHIntervalTappingRecorder alloc] initWithStep:step taskInstanceUUID:taskInstanceUUID];
}

+ (BOOL)supportsSecureCoding
{
    return NO;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    //DUMMY IMPLEMENTATION TO SUPPRESS WARNING
    return [super init];
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    //DUMMY IMPLEMENTATION TO SUPPRESS WARNING 
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

