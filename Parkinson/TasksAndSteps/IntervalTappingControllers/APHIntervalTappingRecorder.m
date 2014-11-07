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

#import "APHCustomIntervalTappingTargetView.h"
#import "APHIntervalTappingFeedbackView.h"


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

static  CGFloat    kFeedbackViewSide             = 60.0;

@interface APHIntervalTappingRecorder ()

@property  (nonatomic, strong)  RKActiveStepViewController      *stepperViewController;
@property  (nonatomic, weak)    APHIntervalTappingFeedbackView  *feedbackView;

@property  (nonatomic, strong)  NSMutableDictionary  *intervalTappingDictionary;
@property  (nonatomic, strong)  NSMutableArray       *tappingRecords;
@property  (nonatomic, assign)  BOOL                  dictionaryHeaderWasCreated;

@property  (nonatomic, assign)  NSUInteger            tapsCounter;

@end

@implementation APHIntervalTappingRecorder

#pragma  mark  -  Tapping Methods

//- (BOOL)doesTargetContainPoint:(CGPoint)point inView:(UIView *)view
//{
//    BOOL  answer = YES;
//    
//    CGFloat  dx = point.x - CGRectGetMidX(view.bounds);
//    CGFloat  dy = point.y - CGRectGetMidY(view.bounds);
//    CGFloat  h = hypot(dx, dy);
//    if (h > CGRectGetWidth(view.bounds) / 2.0) {
//        answer = NO;
//    }
//    return  answer;
//}

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
    APHCustomIntervalTappingTargetView  *targetView = (APHCustomIntervalTappingTargetView *)self.stepperViewController.customView;
    
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
    if (self.tappingDelegate != nil) {
        [self.tappingDelegate recorder:self didRecordTap:@(self.tapsCounter)];
    }
    UIView  *tapView = recogniser.view;
    CGPoint  point = [recogniser locationInView:tapView];
    
    CGRect  feedbackerFrame = CGRectMake(0.0, 0.0, kFeedbackViewSide, kFeedbackViewSide);
    APHIntervalTappingFeedbackView  *feedbacker = [[APHIntervalTappingFeedbackView alloc] initWithFrame:feedbackerFrame];
    [tapView addSubview:feedbacker];
    [tapView bringSubviewToFront:feedbacker];
    feedbacker.center = point;
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseOut
                     animations: ^{
                         feedbacker.alpha = 0.0;
                     } completion: ^(BOOL finished) {
                         [feedbacker removeFromSuperview];
                     }];
}

#pragma  -  Recorder Tap Targets Setup

- (void)viewController:(UIViewController*)viewController willStartStepWithView:(UIView *)view
{

    [super viewController:viewController willStartStepWithView:view];
    
    UINib  *nib = [UINib nibWithNibName:@"APHCustomIntervalTappingTargetView" bundle:nil];
    APHCustomIntervalTappingTargetView  *tapperContainer = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(targetWasTapped:)];
    [tapperContainer addGestureRecognizer:tapRecognizer];
    
    [tapperContainer.layer setBorderColor:[UIColor grayColor].CGColor];
    [tapperContainer.layer setBorderWidth:1.0];
    [tapperContainer.layer setCornerRadius:4.0];
    
    [tapperContainer setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[c(>=160)]" options:0 metrics:nil views:@{@"c":tapperContainer}];
    
    for (NSLayoutConstraint *constraint in verticalConstraints) {
        constraint.priority = UILayoutPriorityFittingSizeLevel;
    }
    [tapperContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[c(>=280)]" options:0 metrics:nil views:@{@"c":tapperContainer}]];
    
    [tapperContainer addConstraints:verticalConstraints];
    [tapperContainer layoutIfNeeded];
    
    [(RKActiveStepViewController *)viewController setCustomView:tapperContainer];
    RKActiveStepViewController  *stepper = (RKActiveStepViewController *)viewController;
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
//            NSLog(@"%@", self.intervalTappingDictionary);
            
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

