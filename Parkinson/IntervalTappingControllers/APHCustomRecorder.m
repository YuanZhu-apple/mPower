//
//  APHCustomRecorder.h
//  Parkinson
//
//  Created by Justin Warmkessel on 8/27/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHCustomRecorder.h"

@interface APHCustomRecorder ()

@property (nonatomic, strong) UIView* containerView;
@property (nonatomic, strong) UIButton* tapTestButton;
@property (nonatomic, strong) NSTimer* timer;
@property (nonatomic, strong) NSMutableArray* records;

@end

@implementation APHCustomRecorder

- (void)viewController:(UIViewController*)viewController willStartStepWithView:(UIView*)view{
    [super viewController:viewController willStartStepWithView:view];
    self.containerView = view;

}

- (instancetype)initWithStep:(RKStep *)step taskInstanceUUID:(NSUUID *)taskInstanceUUID {
    self = [super initWithStep:step taskInstanceUUID:taskInstanceUUID];
    
    if (self) {
        _records = [NSMutableArray new];
    }
    
    return self;
}

- (BOOL)start:(NSError *__autoreleasing *)error{
    BOOL ret = [super start:error];
    
    if (!ret) {
        
        NSLog(@"Error %@", *error);
        
    } else {
    
        NSAssert(self.containerView != nil, @"No container view attached.");
        
        if (self.tapTestButton) {
            [self.tapTestButton removeFromSuperview];
        }
        
        self.tapTestButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.tapTestButton setTitle:@"Tap here" forState:UIControlStateNormal];
        self.tapTestButton.frame = CGRectInset(self.containerView.bounds, 10, 10);
        self.tapTestButton.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleHeight;
        self.tapTestButton.backgroundColor = [UIColor blueColor];
        [self.containerView addSubview:self.tapTestButton];
        
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer:)];
        [self.tapTestButton setUserInteractionEnabled:YES];
        [self.tapTestButton addGestureRecognizer:tapGesture];
    }
    
    return ret;
}


// Tap GestureRecognizer function
- (void)tapGestureRecognizer:(UIGestureRecognizer *)recognizer {
    CGPoint tappedPoint = [recognizer locationInView:self.tapTestButton];
    CGFloat xCoordinate = tappedPoint.x;
    CGFloat yCoordinate = tappedPoint.y;
    
    NSDictionary* dictionary = @{@"event": @"userTouchDown",
                                 @"x" : @(xCoordinate),
                                 @"y" : @(yCoordinate),
                                 @"time": @([[NSDate date] timeIntervalSinceReferenceDate])};
    
    [_records addObject:dictionary];
    
}


- (BOOL)stop:(NSError *__autoreleasing *)error{
    BOOL ret = [super stop:error];
    
    if (!ret) {
        
        NSLog(@"Error %@", *error);
        
    } else {
        
        [self.timer invalidate];
        [self.tapTestButton removeFromSuperview];
        self.tapTestButton = nil;
        
        if (self.records) {
            
            NSLog(@"%@", self.records);
            
            id<RKRecorderDelegate> localDelegate = self.delegate;
            if (localDelegate && [localDelegate respondsToSelector:@selector(recorder:didCompleteWithResult:)]) {
                RKDataResult* result = [[RKDataResult alloc] initWithStep:self.step];
                result.contentType = [self mimeType];
                NSError* serializationError;
                result.data = [NSJSONSerialization dataWithJSONObject:self.records options:(NSJSONWritingOptions)0 error:&serializationError];
                
                if (serializationError) {
                    if (error) {
                        *error = serializationError;
                        NSLog(@"Error %@", *error);
                    }
                    ret = NO;
                } else {
                    result.filename = self.fileName;
                    [localDelegate recorder:self didCompleteWithResult:result];
                    self.records = nil;
                }
            }
        }else{
            if (error) {
                *error = [NSError errorWithDomain:RKErrorDomain
                                             code:RKErrorObjectNotFound
                                         userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"Records object is nil.", nil)}];

                NSLog(@"Error %@", *error);
            }
            ret = NO;
        }
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

