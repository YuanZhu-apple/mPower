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
                                     APHIntroductionTitleTextKey : @"Introduction To Phonation",
                                     APHIntroductionDescriptionTextKey : @"In the next screen you will be asked to say \"Aaaahhh\" for 20 seconds.",
                                     },
                                 @{
                                     APHStepStepTypeKey  : APHActiveStepType,
                                     APHStepIdentiferKey : kPhonationStep102Key,
                                     APHStepNameKey : @"active step",
                                     APHActiveTextKey : @"Please say Aaaahhh for 20 seconds",
                                     APHActiveCountDownKey : @(20.0),
                                     APHActiveBuzzKey : @(YES),
                                     APHActiveVibrationKey : @(YES),
                                     APHActiveVoicePromptKey : APHActiveTextKey,
                                     APHActiveRecorderConfigurationsKey : @[[RKAudioRecorderConfiguration configuration]],
                                     }
                                 ];
    
    NSMutableArray  *steps = [[NSMutableArray alloc] initWithCapacity:[configurations count]];
    
    for (NSDictionary  *dictionary  in  configurations) {
        NSString  *className = dictionary[APHStepStepTypeKey];
        Class  class = NSClassFromString(className);
        RKStep  *step = [[class alloc] initWithIdentifier:dictionary[APHStepIdentiferKey] name:dictionary[APHStepNameKey]];
        
        NSDictionary  *keysToPropertiesMap = [super keysToPropertiesMap];
        for (NSString  *key  in  keysToPropertiesMap) {
            id  object = [dictionary objectForKey: key];
            if (object != nil) {
                NSString  *propertyName = [self.keysToPropertiesMap objectForKey:key];
                [step setValue:object forKey:propertyName];
            }
        }
        [steps addObject:step];
    }
    RKTask  *task = [[RKTask alloc] initWithName:@"Measures Phonation" identifier:@"Phonation Task" steps:steps];
    
    return  task;
}

-(void)taskViewControllerDidComplete:(RKTaskViewController *)taskViewController
{
    [taskViewController suspend];
}

- (void)taskViewControllerDidCancel:(RKTaskViewController *)taskViewController
{
    [taskViewController suspend];
}

-(void)taskViewController:(RKTaskViewController *)taskViewController didProduceResult:(RKResult *)result
{
    NSLog(@"%@", [self descriptionForObject:result]);
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
    [taskViewController dismissViewControllerAnimated:YES completion:NULL];
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
