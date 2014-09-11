//
//  APHPhonationTaskViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 9/3/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHPhonationTaskViewController.h"
#import "APHStepDictionaryKeys.h"
#import <objc/message.h>
#import <AVFoundation/AVFoundation.h>

static NSString * kPhonationStep101Key = @"Phonation_Step_101";
static NSString * kPhonationStep102Key = @"Phonation_Step_102";
static NSString * kPhonationStep103Key = @"Phonation_Step_103";
static NSString * kPhonationStep104Key = @"Phonation_Step_104";
static NSString * kPhonationStep105Key = @"Phonation_Step_105";

@implementation APHPhonationTaskViewController

#pragma  mark  -  Initialisation

+ (instancetype)customTaskViewController
{
    RKTask  *task = [self createTask];
    APHPhonationTaskViewController  *controller = [[APHPhonationTaskViewController alloc] initWithTask:task taskInstanceUUID:[NSUUID UUID]];
    controller.taskDelegate = controller;
    return  controller;
}

+ (RKTask *)createTask
{
    
    NSMutableArray *steps = [NSMutableArray array];
    
    {
        RKIntroductionStep *step = [[RKIntroductionStep alloc] initWithIdentifier:kPhonationStep101Key name:@"Introduction Step"];
        step.caption = @"Tests Speech Difficulties";
        step.explanation = @"";
        step.instruction = @"In the next screen you will be asked to say \"Aaaahhh\" for 10 seconds.";
        [steps addObject:step];
    }
    {
        RKActiveStep* step = [[RKActiveStep alloc] initWithIdentifier:kPhonationStep102Key name:@"active step"];
        step.text = @"Please say \"Aaaahhh\" for 10 seconds";
        step.countDown = 10.0;
        step.buzz = YES;
        step.vibration = YES;
        step.recorderConfigurations = @[[[RKAudioRecorderConfiguration alloc] initWithRecorderSettings:@{AVFormatIDKey : @(kAudioFormatAppleLossless),
                                                                                                         AVNumberOfChannelsKey : @(2),
                                                                                                         AVSampleRateKey: @(44100.0)
                                                                                                         }]];
        [steps addObject:step];
    }
    {
        RKActiveStep* step = [[RKActiveStep alloc] initWithIdentifier:kPhonationStep103Key name:@"active step"];
        step.caption = @"Great Job!";
        step.countDown = 5.0;
        [steps addObject:step];
    }
    
    RKTask  *task = [[RKTask alloc] initWithName:@"Sustained Phonation" identifier:@"Phonation Task" steps:steps];
    
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
