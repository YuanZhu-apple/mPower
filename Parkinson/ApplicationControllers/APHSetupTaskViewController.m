//
//  APHSetupTaskViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 9/3/14.
//  Copyright (c) 2014 Henry McGilton. All rights reserved.
//

#import "APHSetupTaskViewController.h"

#import "APHStepDictionaryKeys.h"

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

+ (RKTask *)createTask
{
    return  nil;
}

@end