//
//  APHPhonationTaskViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 9/3/14.
//  Copyright (c) 2014 Henry McGilton. All rights reserved.
//

#import "APHPhonationTaskViewController.h"
#import "APHStepDictionaryKeys.h"
#import <objc/message.h>

@implementation APHPhonationTaskViewController

#pragma  mark  -  Initialisation

+ (instancetype)customTaskViewController
{
    RKTask  *task = [self createTask];
    APHPhonationTaskViewController  *controller = [[APHPhonationTaskViewController alloc] initWithTask:task taskInstanceUUID:[NSUUID UUID]];
    controller.delegate = controller;
    return  controller;
}

+ (RKTask *)createTask
{
    NSArray  *configurations = @[
                                 @{
                                     APHStepStepTypeKey  : APHIntroductionStepType,
                                     APHStepIdentiferKey : kPhonationStep101Key,
                                     APHStepNameKey : @"Intro step",
                                     APHIntroductionTitleTextKey : @"Tests Speech Difficulties",
                                     APHIntroductionDescriptionTextKey : @"In the next screen you will be asked to say \"Aaaahhh\" for 10 seconds.",
                                     },
                                 @{
                                     APHStepStepTypeKey  : APHActiveStepType,
                                     APHStepIdentiferKey : kPhonationStep102Key,
                                     APHStepNameKey : @"active step",
                                     APHActiveTextKey : @"Please say \"Aaaahhh\" for 10 seconds",
                                     APHActiveCountDownKey : @(10.0),
                                     APHActiveBuzzKey : @(YES),
                                     APHActiveVibrationKey : @(YES),
                                     APHActiveRecorderConfigurationsKey : @[[RKAudioRecorderConfiguration configuration]],
                                     },
                                 @{
                                     APHStepStepTypeKey  : APHActiveStepType,
                                     APHStepIdentiferKey : kPhonationStep103Key,
                                     APHIntroductionTitleTextKey: @"Great Job!",
                                     APHActiveCountDownKey : @(5.0),
                                     }
                                 ];
    
    RKTask  *task = [self mapConfigurationsToTask:configurations];
    
    return  task;
}

- (void)taskViewControllerDidComplete: (RKTaskViewController *)taskViewController
{
    [taskViewController suspend];
    [taskViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)taskViewControllerDidCancel:(RKTaskViewController *)taskViewController
{
    [taskViewController suspend];
    [taskViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)taskViewController:(RKTaskViewController *)taskViewController willPresentStepViewController:(RKStepViewController *)stepViewController
{
//    if (![stepViewController.step isKindOfClass:[RKIntroductionStep class]]) {
//            stepViewController.continueButtonOnToolbar = NO;
//    }

}

-(void)taskViewController:(RKTaskViewController *)taskViewController didProduceResult:(RKResult *)result
{
    NSError * error;
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self filePath]]) {
        [[NSFileManager defaultManager] removeItemAtPath:[self filePath] error:&error];
        if (error) {
            NSLog(@"%@",[self descriptionForObject:error]);
        }
    }
    [[NSFileManager defaultManager] moveItemAtPath:[(RKFileResult*)result fileUrl].path toPath:[self filePath] error:&error];
    if (error) {
        NSLog(@"%@",[self descriptionForObject:error]);
    }
}

- (NSString *)filePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[paths lastObject] stringByAppendingPathComponent:@"file.m4a"];
}

/*********************************************************************************/
#pragma mark - Misc
/*********************************************************************************/
-(NSString *)descriptionForObject:(id)objct
{
    unsigned int varCount;
    NSMutableString *descriptionString = [[NSMutableString alloc]init];
    
    
    objc_property_t *vars = class_copyPropertyList(object_getClass(objct), &varCount);
    
    for (int i = 0; i < varCount; i++)
    {
        objc_property_t var = vars[i];
                const char* name = property_getName (var);
        
        NSString *keyValueString = [NSString stringWithFormat:@"\n%@ = %@",[NSString stringWithUTF8String:name],[objct valueForKey:[NSString stringWithUTF8String:name]]];
        [descriptionString appendString:keyValueString];
    }
    
    free(vars);
    return descriptionString;
}

@end
