//
//  APHSetupTaskViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 9/3/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHSetupTaskViewController.h"

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

+ (instancetype)customTaskViewController
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

+ (RKTask *)createTask
{
    return  nil;
}

@end