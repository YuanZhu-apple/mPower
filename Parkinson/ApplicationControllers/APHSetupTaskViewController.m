//
//  APHSetupTaskViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 9/3/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHSetupTaskViewController.h"
#import "APCAppleCore.h"
#import "APHParkinsonAppDelegate.h"
#import <objc/message.h>

static  NSDictionary  *keysToPropertiesMap = nil;

@implementation APHSetupTaskViewController

#pragma  mark  -  Class Initialisation

+ (void)initialize
{
    if (keysToPropertiesMap == nil) {
        keysToPropertiesMap = @{
                         APHActiveCountDownKey              : APHActiveCountDownPropKey,
                         APHActiveBuzzKey                   : APHActiveBuzzPropKey,
                         APHActiveVibrationKey              : APHActiveVibrationPropKey,
                         APHActiveTextKey                   : APHActiveTextPropKey,
                         APHActiveVoicePromptKey            : APHActiveVoicePromptPropKey,
                         APHActiveRecorderConfigurationsKey : APHActiveRecorderConfigurationsPropKey,
                         
                         APHConsentConsentPdfFileKey        : APHConsentConsentPdfFilePropKey,
                         
                         APHIntroductionTitleTextKey        : APHIntroductionTitleTextPropKey,
                         APHIntroductionDescriptionTextKey  : APHIntroductionDescriptionTextPropKey,
                         
                         APHMediaRequestKey                 : APHMediaRequestPropKey,
                         APHMediaMediaTypeKey               : APHMediaMediaTypePropKey,
                         APHMediaAllowsEditingKey           : APHMediaAllowsEditingPropKey,
                         
                         APHQuestionOptionalKey             : APHQuestionOptionalPropKey,
                         APHQuestionQuestionKey             : APHQuestionQuestionPropKey,
                         APHQuestionPromptKey               : APHQuestionPromptPropKey,
                         APHQuestionAnswerFormatKey         : APHQuestionAnswerFormatPropKey,
                    };
    }
}


#pragma  mark  -  Instance Initialisation

+ (NSDictionary *)keysToPropertiesMap
{
    return  keysToPropertiesMap;
}

+ (instancetype)customTaskViewController: (APCScheduledTask*) scheduledTask
{
    return  nil;
}

+ (RKTask *)mapConfigurationsToTask:(NSArray *)configurations
{
    NSMutableArray  *steps = [[NSMutableArray alloc] initWithCapacity:[configurations count]];
    
    for (NSDictionary  *dictionary  in  configurations) {
        NSString  *className = dictionary[APHStepStepTypeKey];
        Class  class = NSClassFromString(className);
        RKStep  *step = [[class alloc] initWithIdentifier:dictionary[APHStepIdentiferKey] name:dictionary[APHStepNameKey]];
        
//        NSDictionary  *keysToPropertiesMap = [super keysToPropertiesMap];
        for (NSString  *key  in  keysToPropertiesMap) {
            id  object = [dictionary objectForKey: key];
            if (object != nil) {
                NSString  *propertyName = [self.keysToPropertiesMap objectForKey:key];
                [step setValue:object forKey:propertyName];
            }
        }
        [steps addObject:step];
    }
    RKTask  *task = [[RKTask alloc] initWithName:@"Measures Gait and Balance" identifier:@"Walking Task" steps:steps];
    return  task;
}

+ (RKTask *)createTask: (APCScheduledTask*) scheduledTask
{
    return  nil;
}

/*********************************************************************************/
#pragma mark - RKTaskDelegate
/*********************************************************************************/
//Universal Did Produce Result
- (void)taskViewController:(RKTaskViewController *)taskViewController didProduceResult:(RKResult *)result
{
    APCResult * apcResult = [APCResult storeRKResult:result inContext:((APHParkinsonAppDelegate *)[UIApplication sharedApplication].delegate).dataSubstrate.mainContext];
    apcResult.scheduledTask = self.scheduledTask;
    NSError * saveError;
    [apcResult saveToPersistentStore:&saveError];
    [saveError handle];
    NSLog(@"RKResult: %@ APCResult: %@", result,apcResult);

    
    if ([result isKindOfClass:[RKFileResult class]]) {
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
}

- (NSString *)filePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[paths lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", [NSUUID UUID].UUIDString]];
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