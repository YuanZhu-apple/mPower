//
//  PurpleRecorder.m
//  StudyDemo
//
//  Copyright (c) 2014 Apple. All rights reserved.
//

#import "APHCustomRecorder.h"

@interface APHCustomRecorder ()

@property (nonatomic, strong) UIView* containerView;
@property (nonatomic, strong) UIButton* button;
@property (nonatomic, strong) NSTimer* timer;
@property (nonatomic, strong) NSMutableArray* records;

@end

@implementation APHCustomRecorder

- (void)viewController:(UIViewController*)viewController willStartStepWithView:(UIView*)view{
    [super viewController:viewController willStartStepWithView:view];
    self.containerView = view;

}


- (BOOL)start:(NSError *__autoreleasing *)error{
    BOOL ret = [super start:error];
    
    NSAssert(self.containerView != nil, @"No container view attached.");
    
    if (_button) {
        [_button removeFromSuperview];
    }
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button setTitle:@"Tap here" forState:UIControlStateNormal];
    _button.frame = CGRectInset(_containerView.bounds, 10, 10);
    _button.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleHeight;
    _button.backgroundColor = [UIColor blueColor];
    [_containerView addSubview:_button];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer:)];
    [_button setUserInteractionEnabled:YES];
    [_button addGestureRecognizer:tapGesture];
    
    
    _records = [NSMutableArray array];
    
    return ret;
}

// Tap GestureRecognizer function
- (void)tapGestureRecognizer:(UIGestureRecognizer *)recognizer {
    CGPoint tappedPoint = [recognizer locationInView:_button];
    CGFloat xCoordinate = tappedPoint.x;
    CGFloat yCoordinate = tappedPoint.y;
    
    NSString *xStr = [NSString stringWithFormat:@"%f", xCoordinate];
    NSString *yStr = [NSString stringWithFormat:@"%f", yCoordinate];
    
    NSDictionary* dictionary = @{@"event": @"userTouchDown",
                                 @"x" : xStr,
                                 @"y" : yStr,
                                 @"time": @([[NSDate date] timeIntervalSinceReferenceDate])};
    
    [_records addObject:dictionary];
    
}

- (IBAction)timerFired:(id)sender{
    _button.hidden = !_button.hidden;
    
    NSDictionary* dictionary = @{@"event": _button.hidden? @"buttonHide": @"buttonShow",
                                 @"time": @([[NSDate date] timeIntervalSinceReferenceDate])};
    
    [_records addObject:dictionary];
    
}

- (BOOL)stop:(NSError *__autoreleasing *)error{
    BOOL ret = [super stop:error];
    
    [self.timer invalidate];
    [_button removeFromSuperview];
    _button = nil;
    
    if (self.records) {
        
        NSLog(@"%@", self.records);
        
        id<RKRecorderDelegate> localDelegate = self.delegate;
        if (localDelegate && [localDelegate respondsToSelector:@selector(recorder:didCompleteWithResult:)]) {
            RKDataResult* result = [[RKDataResult alloc] initWithStep:self.step];
            result.contentType = [self mimeType];
            NSError* err;
            result.data = [NSJSONSerialization dataWithJSONObject:self.records options:(NSJSONWritingOptions)0 error:&err];
            
            if (err) {
                if (error) {
                    *error = err;
                }
                return NO;
            }
            
            result.filename = self.fileName;
            [localDelegate recorder:self didCompleteWithResult:result];
            self.records = nil;
        }
    }else{
        if (error) {
            *error = [NSError errorWithDomain:RKErrorDomain
                                         code:RKErrorObjectNotFound
                                     userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"Records object is nil.", nil)}];
        }
        ret = NO;
    }
    
    
    return ret;
}

- (NSString*)dataType{
    return @"tapTheButton";
}

- (NSString*)mimeType{
    return @"application/json";
}

- (NSString*)fileName{
    return @"tapTheButton.json";
}

@end

@implementation CustomRecorderConfiguration

- (RKRecorder*)recorderForStep:(RKStep*)step taskInstanceUUID:(NSUUID*)taskInstanceUUID{
    return [[APHCustomRecorder alloc] initWithStep:step taskInstanceUUID:taskInstanceUUID];
}

#pragma mark - RKSerialization

- (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    
    self = [self init];
    if (self) {
        
    }
    return self;
}

- (NSDictionary*)dictionaryValue{
    
    NSMutableDictionary* dict = [NSMutableDictionary new];
    
    dict[@"_class"] = NSStringFromClass([self class]);
    
    return dict;
}

@end

