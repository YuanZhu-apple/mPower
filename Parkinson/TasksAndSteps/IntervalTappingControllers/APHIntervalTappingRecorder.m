// 
//  APHIntervalTappingRecorder.m 
//  mPower 
// 
//  Copyright (c) 2014 Apple, Inc. All rights reserved. 
// 
 
#import "APHIntervalTappingRecorder.h"

#import "APHIntervalTappingRecorderCustomView.h"
#import "APHIntervalTappingRecorderDataKeys.h"
#import "APHIntervalTappingTapView.h"
#import "APHRippleView.h"

static  CGFloat  kRipplerMinimumRadius           =   5.0;
static  CGFloat  kRipplerMaximumRadius           =  80.0;

@interface APHIntervalTappingRecorder () <APHRippleViewDelegate>

@property  (nonatomic, strong)  APHIntervalTappingRecorderCustomView  *outerTappingContainer;
@property  (nonatomic, strong)  RKSTActiveStepViewController          *stepperViewController;
@property  (nonatomic, weak)    APHRippleView                         *tappingTargetsContainer;

@property  (nonatomic, strong)  NSMutableDictionary                   *intervalTappingDictionary;
@property  (nonatomic, strong)  NSMutableArray                        *tappingRecords;
@property  (nonatomic, assign)  BOOL                                   dictionaryHeaderWasCreated;

@property  (nonatomic, assign)  NSUInteger                             tapsCounter;

@property  (nonatomic, assign)  BOOL                                   stopMethodWasCalled;

@end

@implementation APHIntervalTappingRecorder

#pragma  mark  -  Tapping Methods

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

- (void)addRecord:(CGPoint)point
{
    NSDictionary  *record = @{
                              kTimeStampRecordKey  : @([[NSDate date] timeIntervalSinceReferenceDate]),
                              kXCoordinateRecordKey : @(point.x),
                              kYCoordinateRecordKey : @(point.y)
                              };
    [self.tappingRecords addObject:record];
}

- (void)rippleView:(APHRippleView *)rippleView touchesDidOccurAtPoints:(NSArray *)points
{
    if (self.dictionaryHeaderWasCreated == NO) {
        [self setupdictionaryHeader];
        self.dictionaryHeaderWasCreated = YES;
    }
    for (NSValue *value in points) {
        CGPoint  point = [value CGPointValue];
        [self addRecord:point];
        self.tapsCounter = self.tapsCounter + 1;
        self.outerTappingContainer.totalTapsCount.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.tapsCounter];
    }
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
    
    tapTargetsContainer.delegate = self;
    
    tapTargetsContainer.tapperLeft = outerContainer.tapperLeft;
    tapTargetsContainer.tapperLeft.enabled = YES;
    
    tapTargetsContainer.tapperRight = outerContainer.tapperRight;
    tapTargetsContainer.tapperRight.enabled = YES;
    
    tapTargetsContainer.minimumRadius = kRipplerMinimumRadius;
    tapTargetsContainer.maximumRadius = kRipplerMaximumRadius;
    
    self.tappingTargetsContainer = tapTargetsContainer;
    
    RKSTActiveStepViewController  *stepper = (RKSTActiveStepViewController *)viewController;
    
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

//- (void)start
//{
//    [super start];
//}

- (void)stop
{
    if (self.stopMethodWasCalled == NO) {
        if (self.tappingRecords != nil) {
            id <RKSTRecorderDelegate> substituteDelegate = self.delegate;
            
            if (substituteDelegate != nil && [substituteDelegate respondsToSelector:@selector(recorder:didCompleteWithResult:)]) {
                RKSTDataResult  *result = [[RKSTDataResult alloc] initWithIdentifier:self.step.identifier];
                result.contentType = [self mimeType];
                
                NSError  *serializationError = nil;
                result.data = [NSJSONSerialization dataWithJSONObject:self.intervalTappingDictionary options:(NSJSONWritingOptions)0 error:&serializationError];
                
                if (serializationError != nil) {
                    if (substituteDelegate != nil && [substituteDelegate respondsToSelector:@selector(recorder:didFailWithError:)]) {
                        [substituteDelegate recorder:self didFailWithError:serializationError];
                    }
                } else {
                    result.filename = self.fileName;
                    [substituteDelegate recorder:self didCompleteWithResult:result];
                }
            }
        }
        self.stopMethodWasCalled = YES;
        [super stop];
    }
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

- (RKSTRecorder *)recorderForStep:(RKSTStep *)step outputDirectory:(NSURL *)outputDirectory
{
    return [[APHIntervalTappingRecorder alloc] initWithStep:step outputDirectory:outputDirectory];
}

@end

