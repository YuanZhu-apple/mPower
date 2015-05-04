// 
//  APHAppDelegate.m 
//  mPower 
// 
// Copyright (c) 2015, Sage Bionetworks. All rights reserved. 
// 
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
// 
// 1.  Redistributions of source code must retain the above copyright notice, this
// list of conditions and the following disclaimer.
// 
// 2.  Redistributions in binary form must reproduce the above copyright notice, 
// this list of conditions and the following disclaimer in the documentation and/or 
// other materials provided with the distribution. 
// 
// 3.  Neither the name of the copyright holder(s) nor the names of any contributors 
// may be used to endorse or promote products derived from this software without 
// specific prior written permission. No license is granted to the trademarks of 
// the copyright holders even if such marks are included in this software. 
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE 
// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL 
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 
// 
 
@import APCAppCore;
#import "APHAppDelegate.h"
#import "APHProfileExtender.h"
#import "APHAppDelegate+APHMigration.h"

static NSString *const kWalkingActivitySurveyIdentifier             = @"4-APHTimedWalking-80F09109-265A-49C6-9C5D-765E49AAF5D9";
static NSString *const kVoiceActivitySurveyIdentifier               = @"3-APHPhonation-C614A231-A7B7-4173-BDC8-098309354292";
static NSString *const kTappingActivitySurveyIdentifier             = @"2-APHIntervalTapping-7259AC18-D711-47A6-ADBD-6CFCECDED1DF";
static NSString *const kMemoryActivitySurveyIdentifier              = @"7-APHSpatialSpanMemory-4A04F3D0-AC05-11E4-AB27-0800200C9A66";
static NSString *const kPDSurveyIdentifier                          = @"6-PDQ8-20EF83D2-E461-4C20-9024-F43FCAAAF4C8";
static NSString *const kWeeklySurveyIdentifier                      = @"5-MDSUPDRS-20EF82D1-E461-4C20-9024-F43FCAAAF4C8";
static NSString *const kMyThoughtsSurveyIdentifier                  = @"8-MyThoughts-12ffde40-1551-4b48-aae2-8fef38d61b61";

/*********************************************************************************/
#pragma mark - Initializations Options
/*********************************************************************************/
static NSString *const kStudyIdentifier             = @"Parkinson's";
static NSString *const kAppPrefix                   = @"parkinson";
static NSString* const  kConsentPropertiesFileName  = @"APHConsentSection";

static NSString *const kVideoShownKey = @"VideoShown";


static NSString *const kJsonScheduleStringKey           = @"scheduleString";
static NSString *const kJsonTasksKey                    = @"tasks";
static NSString *const kJsonScheduleTaskIDKey           = @"taskID";
static NSString *const kJsonSchedulesKey                = @"schedules";


static NSString *const kPDQ8TaskIdentifier              = @"6-PDQ8-20EF83D2-E461-4C20-9024-F43FCAAAF4C8";
static NSInteger const kPDQ8TaskOffset                  = 2;
static NSString *const kMDSUPDRS                        = @"5-MDSUPDRS-20EF82D1-E461-4C20-9024-F43FCAAAF4C8";
static NSInteger const kMDSUPDRSOffset                  = 1;
static NSInteger const kMonthOfDayObject                = 2;

@interface APHAppDelegate ()
@property (nonatomic, strong) APHProfileExtender* profileExtender;
@property  (nonatomic, assign)  NSInteger environment;
@end

@implementation APHAppDelegate

- (BOOL)application:(UIApplication*) __unused application willFinishLaunchingWithOptions:(NSDictionary*) __unused launchOptions
{
    [super application:application willFinishLaunchingWithOptions:launchOptions];
    
    [self enableBackgroundDeliveryForHealthKitTypes];
    
    return YES;
}

- (void)enableBackgroundDeliveryForHealthKitTypes
{
    NSArray* dataTypesWithReadPermission = self.initializationOptions[kHKReadPermissionsKey];
    
    if (dataTypesWithReadPermission)
    {
        for (id dataType in dataTypesWithReadPermission)
        {
            HKObjectType*   sampleType  = nil;
            
            if ([dataType isKindOfClass:[NSDictionary class]])
            {
                NSDictionary* categoryType = (NSDictionary*) dataType;
                
                //Distinguish
                if (categoryType[kHKWorkoutTypeKey])
                {
                    sampleType = [HKObjectType workoutType];
                }
                else if (categoryType[kHKCategoryTypeKey])
                {
                    sampleType = [HKObjectType categoryTypeForIdentifier:categoryType[kHKCategoryTypeKey]];
                }
            }
            else
            {
                sampleType = [HKObjectType quantityTypeForIdentifier:dataType];
            }
            
            if (sampleType)
            {
                [self.dataSubstrate.healthStore enableBackgroundDeliveryForType:sampleType
                                                                      frequency:HKUpdateFrequencyImmediate
                                                                 withCompletion:^(BOOL success, NSError *error)
                 {
                     if (!success)
                     {
                         if (error)
                         {
                             APCLogError2(error);
                         }
                     }
                     else
                     {
                         APCLogDebug(@"Enabling background delivery for healthkit");
                     }
                 }];
            }
        }
    }
}

- (void) setUpInitializationOptions
{
    NSDictionary *permissionsDescriptions = @{
                                              @(kSignUpPermissionsTypeLocation) : NSLocalizedString(@"Using your GPS enables the app to accurately determine distances travelled. Your actual location will never be shared.", @""),
                                              @(kSignUpPermissionsTypeCoremotion) : NSLocalizedString(@"Using the motion co-processor allows the app to determine your activity, helping the study better understand how activity level may influence disease.", @""),
                                              @(kSignUpPermissionsTypeMicrophone) : NSLocalizedString(@"Access to microphone is required for your Voice Recording Activity.", @""),
                                              @(kSignUpPermissionsTypeLocalNotifications) : NSLocalizedString(@"Allowing notifications enables the app to show you reminders.", @""),
                                              @(kSignUpPermissionsTypeHealthKit) : NSLocalizedString(@"On the next screen, you will be prompted to grant mPower access to read and write some of your general and health information, such as height, weight and steps taken so you don't have to enter it again.", @""),
                                                  };
    
    NSMutableDictionary * dictionary = [super defaultInitializationOptions];
#ifdef DEBUG
    self.environment = SBBEnvironmentStaging;
#else
    self.environment = SBBEnvironmentProd;
#endif
    
    dictionary = [self updateOptionsFor5OrOlder:dictionary];
    [dictionary addEntriesFromDictionary:@{
                                           kStudyIdentifierKey                  : kStudyIdentifier,
                                           kAppPrefixKey                        : kAppPrefix,
                                           kBridgeEnvironmentKey                : @(self.environment),
                                           kHKReadPermissionsKey                : @[
                                                   HKQuantityTypeIdentifierBodyMass,
                                                   HKQuantityTypeIdentifierHeight,
                                                   HKQuantityTypeIdentifierStepCount
                                                   ],
                                           kHKWritePermissionsKey                : @[
                                                   ],
                                           kAppServicesListRequiredKey           : @[
                                                   @(kSignUpPermissionsTypeLocation),
                                                   @(kSignUpPermissionsTypeCoremotion),
                                                   @(kSignUpPermissionsTypeMicrophone),
                                                   @(kSignUpPermissionsTypeLocalNotifications)
                                                   ],
                                           kAppServicesDescriptionsKey : permissionsDescriptions,
                                           kAppProfileElementsListKey            : @[
                                                   @(kAPCUserInfoItemTypeEmail),
                                                   @(kAPCUserInfoItemTypeDateOfBirth),
                                                   @(kAPCUserInfoItemTypeBiologicalSex),
                                                   @(kAPCUserInfoItemTypeHeight),
                                                   @(kAPCUserInfoItemTypeWeight),
                                                   @(kAPCUserInfoItemTypeWakeUpTime),
                                                   @(kAPCUserInfoItemTypeSleepTime),
                                                   ],
                                           kShareMessageKey : NSLocalizedString(@"Please take a look at Parkinson mPower, a research study app about Parkinson Disease.  Download it for iPhone at http://apple.co/1FO7Bsi", nil)
                                           }];
    
    self.initializationOptions = dictionary;
    
    self.profileExtender = [[APHProfileExtender alloc] init];
}

-(void)setUpTasksReminder{
    
    APCTaskReminder *walkingActivityReminder = [[APCTaskReminder alloc]initWithTaskID:kWalkingActivitySurveyIdentifier reminderBody:NSLocalizedString(@"Walking Activity", nil)];
    APCTaskReminder *voiceActivityReminder = [[APCTaskReminder alloc]initWithTaskID:kVoiceActivitySurveyIdentifier reminderBody:NSLocalizedString(@"Voice Activity", nil)];
    APCTaskReminder *tappingActivityReminder = [[APCTaskReminder alloc]initWithTaskID:kTappingActivitySurveyIdentifier reminderBody:NSLocalizedString(@"Tapping Activity", nil)];
    APCTaskReminder *memoryActivityReminder = [[APCTaskReminder alloc]initWithTaskID:kMemoryActivitySurveyIdentifier reminderBody:NSLocalizedString(@"Memory Activity", nil)];
    APCTaskReminder *pdSurveyReminder = [[APCTaskReminder alloc]initWithTaskID:kPDSurveyIdentifier reminderBody:NSLocalizedString(@"PD Survey", nil)];
    APCTaskReminder *weeklySurveyReminder = [[APCTaskReminder alloc]initWithTaskID:kWeeklySurveyIdentifier reminderBody:NSLocalizedString(@"Weekly Survey", nil)];
    APCTaskReminder *myThoughtsSurveyReminder = [[APCTaskReminder alloc]initWithTaskID:kMyThoughtsSurveyIdentifier reminderBody:NSLocalizedString(@"My Thoughts", nil)];

    [self.tasksReminder.reminders removeAllObjects];
    [self.tasksReminder manageTaskReminder:walkingActivityReminder];
    [self.tasksReminder manageTaskReminder:voiceActivityReminder];
    [self.tasksReminder manageTaskReminder:tappingActivityReminder];
    [self.tasksReminder manageTaskReminder:memoryActivityReminder];
    [self.tasksReminder manageTaskReminder:pdSurveyReminder];
    [self.tasksReminder manageTaskReminder:weeklySurveyReminder];
    [self.tasksReminder manageTaskReminder:myThoughtsSurveyReminder];
    
    if ([self doesPersisteStoreExist] == NO)
    {
        APCLogEvent(@"This app is being launched for the first time. Turn all reminders on");
        for (APCTaskReminder *reminder in self.tasksReminder.reminders) {
            [[NSUserDefaults standardUserDefaults]setObject:reminder.reminderBody forKey:reminder.reminderIdentifier];
        }
        
        if ([[UIApplication sharedApplication] currentUserNotificationSettings].types != UIUserNotificationTypeNone){
            [self.tasksReminder setReminderOn:@YES];
        }
        
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
}

- (void)performMigrationAfterDataSubstrateFrom:(NSInteger) __unused previousVersion currentVersion:(NSInteger) __unused currentVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *majorVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *minorVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSError *migrationError = nil;
    
    if (self.doesPersisteStoreExist == NO)
    {
        APCLogEvent(@"This application is being launched for the first time. We know this because there is no persistent store.");
    }
    else if ([[defaults objectForKey:@"previousVersion"] isEqual: @3])
    {
        APCLogEvent(@"The entire data model version %d", kTheEntireDataModelOfTheApp);
        if (![self performMigrationFromThreeToFourWithError:&migrationError])
        {
            APCLogEvent(@"Migration from version %@ to %@ has failed.", [defaults objectForKey:@"previousVersion"], @(kTheEntireDataModelOfTheApp));
        }
    }
    
    [defaults setObject:majorVersion forKey:@"shortVersionString"];
    [defaults setObject:minorVersion forKey:@"version"];
    
    if (!migrationError)
    {
        [defaults setObject:@(currentVersion) forKey:@"previousVersion"];
    }
    
}

- (void) setUpAppAppearance
{
    [APCAppearanceInfo setAppearanceDictionary:@{
                                                 kPrimaryAppColorKey : [UIColor colorWithRed:255 / 255.0f green:0.0 blue:56 / 255.0f alpha:1.000],
                                                 @"2-APHIntervalTapping-7259AC18-D711-47A6-ADBD-6CFCECDED1DF" : [UIColor appTertiaryPurpleColor],
                                                 @"7-APHSpatialSpanMemory-4A04F3D0-AC05-11E4-AB27-0800200C9A66" : [UIColor appTertiaryRedColor],
                                                 @"3-APHPhonation-C614A231-A7B7-4173-BDC8-098309354292" : [UIColor appTertiaryBlueColor],
                                                 @"4-APHTimedWalking-80F09109-265A-49C6-9C5D-765E49AAF5D9" : [UIColor appTertiaryYellowColor],
                                                 @"1-EnrollmentSurvey-20EF83D2-E461-4C20-9024-F43FCAAAF4C3": [UIColor lightGrayColor],
                                                 @"6-PDQ8-20EF83D2-E461-4C20-9024-F43FCAAAF4C8": [UIColor lightGrayColor],
                                                 @"5-MDSUPDRS-20EF82D1-E461-4C20-9024-F43FCAAAF4C8": [UIColor lightGrayColor],
                                                 @"8-MyThoughts-12ffde40-1551-4b48-aae2-8fef38d61b61": [UIColor lightGrayColor],
                                                 @"9-Feedback-394348ce-ca4f-4abe-b97e-fedbfd7ffb8e": [UIColor lightGrayColor],
                                                 @"a-APHMedicationTracker-20EF8ED2-E461-4C20-9024-F43FCAAAF4C3": [UIColor colorWithRed:0.933
                                                                                                                               green:0.267
                                                                                                                                blue:0.380
                                                                                                                               alpha:1.000]
                                                 }];
    [[UINavigationBar appearance] setTintColor:[UIColor appPrimaryColor]];
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSForegroundColorAttributeName : [UIColor appSecondaryColor2],
                                                            NSFontAttributeName : [UIFont appNavBarTitleFont]
                                                            }];
    [[UIView appearance] setTintColor:[UIColor appPrimaryColor]];
    self.dataSubstrate.parameters.hideExampleConsent = YES;
}

- (id <APCProfileViewControllerDelegate>) profileExtenderDelegate {
    
    return self.profileExtender;
}

- (void) showOnBoarding
{
    [super showOnBoarding];
    
    [self showStudyOverview];
}

- (void) showStudyOverview
{
    APCStudyOverviewViewController *studyController = [[UIStoryboard storyboardWithName:@"APCOnboarding" bundle:[NSBundle appleCoreBundle]] instantiateViewControllerWithIdentifier:@"StudyOverviewVC"];
    [self setUpRootViewController:studyController];
}

- (BOOL) isVideoShown
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kVideoShownKey];
}

- (NSMutableDictionary *) updateOptionsFor5OrOlder:(NSMutableDictionary *)initializationOptions {
    if (![APCDeviceHardware isiPhone5SOrNewer]) {
        [initializationOptions setValue:@"APHTasksAndSchedules_NoM7" forKey:kTasksAndSchedulesJSONFileNameKey];
    }
    return initializationOptions;
}

- (NSArray *)allSetTextBlocks
{
    NSArray *allSetBlockOfText = nil;
    
    NSString *activitiesAdditionalText = NSLocalizedString(@"Please perform the activites each day when you are at your lowest before you take your Parkinson medications, after your medications take effect, and then a third time during the day.", nil);
    allSetBlockOfText = @[@{kAllSetActivitiesTextAdditional: activitiesAdditionalText}];
    
    return allSetBlockOfText;
}

/*********************************************************************************/
#pragma mark - Datasubstrate Delegate Methods
/*********************************************************************************/
- (void) setUpCollectors
{
    if (self.dataSubstrate.currentUser.userConsented)
    {
        if (!self.passiveDataCollector)
        {
            self.passiveDataCollector = [[APCPassiveDataCollector alloc] init];
        }
        
        [self configureDisplacementTracker];
        [self configureObserverQueries];
        [self configureMotionActivityObserver];
    }
}

- (void)configureMotionActivityObserver
{
    NSString*(^CoreMotionDataSerializer)(id) = ^NSString *(id dataSample)
    {
        CMMotionActivity* motionActivitySample  = (CMMotionActivity*)dataSample;
        NSString* motionActivity                = [CMMotionActivity activityTypeName:motionActivitySample];
        NSNumber* motionConfidence              = @(motionActivitySample.confidence);
        NSString* stringToWrite                 = [NSString stringWithFormat:@"%@,%@,%@\n",
                                                   motionActivitySample.startDate.toStringInISO8601Format,
                                                   motionActivity,
                                                   motionConfidence];
        
        return stringToWrite;
    };
    
    NSDate* (^LaunchDate)() = ^
    {
        APCUser*    user        = ((APCAppDelegate *)[UIApplication sharedApplication].delegate).dataSubstrate.currentUser;
        NSDate*     consentDate = nil;
        
        if (user.consentSignatureDate)
        {
            consentDate = user.consentSignatureDate;
        }
        else
        {
            NSFileManager*  fileManager = [NSFileManager defaultManager];
            NSString*       filePath    = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"db.sqlite"];
            
            if ([fileManager fileExistsAtPath:filePath])
            {
                NSError*        error       = nil;
                NSDictionary*   attributes  = [fileManager attributesOfItemAtPath:filePath error:&error];
                
                if (error)
                {
                    APCLogError2(error);
                    
                    consentDate = [[NSDate date] startOfDay];
                }
                else
                {
                    consentDate = [attributes fileCreationDate];
                }
            }
        }
        
        return consentDate;
    };
    
    APCCoreMotionBackgroundDataCollector *motionCollector = [[APCCoreMotionBackgroundDataCollector alloc] initWithIdentifier:@"motionActivityCollector"
                                                                                                              dateAnchorName:@"APCCoreMotionCollectorAnchorName"
                                                                                                            launchDateAnchor:LaunchDate];
    
    NSArray*            motionColumnNames   = @[@"startTime",@"activityType",@"confidence"];
    APCPassiveDataSink* receiver            = [[APCPassiveDataSink alloc] initWithIdentifier:@"motionActivityCollector"
                                                                                 columnNames:motionColumnNames
                                                                          operationQueueName:@"APCCoreMotion Activity Collector"
                                                                            andDataProcessor:CoreMotionDataSerializer];
    
    [motionCollector setReceiver:receiver];
    [motionCollector setDelegate:receiver];
    [motionCollector start];
    [self.passiveDataCollector addDataSink:motionCollector];
}

- (void)configureDisplacementTracker
{
    APCDisplacementTrackingCollector*           locationCollector   = [[APCDisplacementTrackingCollector alloc]
                                                                       initWithIdentifier:@"locationCollector"
                                                                       deferredUpdatesTimeout:60.0 * 60.0];
    NSArray*                                    locationColumns     = @[@"timestamp",
                                                                        @"distanceFromPreviousLocation",
                                                                        @"distanceUnit",
                                                                        @"direction",
                                                                        @"directionUnit",
                                                                        @"speed",
                                                                        @"speedUnit",
                                                                        @"floor",
                                                                        @"altitude",
                                                                        @"altitudeUnit",
                                                                        @"horizontalAccuracy",
                                                                        @"horizontalAccuracyUnit",
                                                                        @"verticalAccuracy",
                                                                        @"verticalAccuracyUnit"];
    APCPassiveDisplacementTrackingDataUploader* displacementSinker  = [[APCPassiveDisplacementTrackingDataUploader alloc]
                                                                       initWithIdentifier:@"locationTracker"
                                                                       columnNames:locationColumns
                                                                       operationQueueName:@"APCDisplacement Tracker Sink"
                                                                       andDataProcessor:nil];
    [locationCollector setReceiver:displacementSinker];
    [locationCollector setDelegate:displacementSinker];
    [locationCollector start];
    [self.passiveDataCollector addDataSink:locationCollector];
}

- (void)configureObserverQueries
{
    NSDate* (^LaunchDate)() = ^
    {
        APCUser*    user        = ((APCAppDelegate *)[UIApplication sharedApplication].delegate).dataSubstrate.currentUser;
        NSDate*     consentDate = nil;
        
        if (user.consentSignatureDate)
        {
            consentDate = user.consentSignatureDate;
        }
        else
        {
            NSFileManager*  fileManager = [NSFileManager defaultManager];
            NSString*       filePath    = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"db.sqlite"];
            
            if ([fileManager fileExistsAtPath:filePath])
            {
                NSError*        error       = nil;
                NSDictionary*   attributes  = [fileManager attributesOfItemAtPath:filePath error:&error];
                
                if (error)
                {
                    APCLogError2(error);
                    
                    consentDate = [[NSDate date] startOfDay];
                }
                else
                {
                    consentDate = [attributes fileCreationDate];
                }
            }
        }
        
        return consentDate;
    };
    
    NSString*(^QuantityDataSerializer)(id) = ^NSString*(id dataSample)
    {
        HKQuantitySample*   qtySample           = (HKQuantitySample *)dataSample;
        NSString*           startDateTimeStamp  = [qtySample.startDate toStringInISO8601Format];
        NSString*           endDateTimeStamp    = [qtySample.endDate toStringInISO8601Format];
        NSString*           healthKitType       = qtySample.quantityType.identifier;
        NSString*           quantityValueRep    = [NSString stringWithFormat:@"%@", qtySample.quantity];
        NSArray*            valueSplit          = [quantityValueRep componentsSeparatedByString:@" "];
        NSString*           quantityValue       = [valueSplit objectAtIndex:0];
        NSString*           quantityUnit        = @"";
        
        for (int i = 1; i < (int)[valueSplit count]; i++)
        {
            quantityUnit = [quantityUnit stringByAppendingString:valueSplit[i]];
        }
        
        NSString*           sourceIdentifier    = qtySample.source.bundleIdentifier;
        NSString*           quantitySource      = qtySample.source.name;
        
        if (quantitySource == nil)
        {
            quantitySource = @"not available";
        }
        else if ([[[UIDevice currentDevice] name] isEqualToString:quantitySource])
        {
            if ([APCDeviceHardware platformString])
            {
                quantitySource = [APCDeviceHardware platformString];
            }
            else
            {
                //  This shouldn't get called.
                quantitySource = @"iPhone";
            }
        }
        
        NSString *stringToWrite = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@\n",
                                   startDateTimeStamp,
                                   endDateTimeStamp,
                                   healthKitType,
                                   quantityValue,
                                   quantityUnit,
                                   quantitySource,
                                   sourceIdentifier];
        
        return stringToWrite;
    };
    
    NSString*(^WorkoutDataSerializer)(id) = ^(id dataSample)
    {
        HKWorkout*  sample                      = (HKWorkout*)dataSample;
        NSString*   startDateTimeStamp          = [sample.startDate toStringInISO8601Format];
        NSString*   endDateTimeStamp            = [sample.endDate toStringInISO8601Format];
        NSString*   healthKitType               = sample.sampleType.identifier;
        NSString*   activityType                = [HKWorkout workoutActivityTypeStringRepresentation:(int)sample.workoutActivityType];
        double      energyConsumedValue         = [sample.totalEnergyBurned doubleValueForUnit:[HKUnit kilocalorieUnit]];
        NSString*   energyConsumed              = [NSString stringWithFormat:@"%f", energyConsumedValue];
        NSString*   energyUnit                  = [HKUnit kilocalorieUnit].description;
        double      totalDistanceConsumedValue  = [sample.totalDistance doubleValueForUnit:[HKUnit meterUnit]];
        NSString*   totalDistance               = [NSString stringWithFormat:@"%f", totalDistanceConsumedValue];
        NSString*   distanceUnit                = [HKUnit meterUnit].description;
        NSString*   sourceIdentifier            = sample.source.bundleIdentifier;
        NSString*   quantitySource              = sample.source.name;
        
        if (quantitySource == nil)
        {
            quantitySource = @"not available";
        }
        else if ([[[UIDevice currentDevice] name] isEqualToString:quantitySource])
        {
            if ([APCDeviceHardware platformString])
            {
                quantitySource = [APCDeviceHardware platformString];
            }
            else
            {
                //  This shouldn't get called.
                quantitySource = @"iPhone";
            }
        }
        
        NSError*    error                       = nil;
        NSString*   metaData                    = [NSDictionary convertDictionary:sample.metadata ToStringWithReturningError:&error];
        NSString*   metaDataStringified         = [NSString stringWithFormat:@"\"%@\"", metaData];
        NSString*   stringToWrite               = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@\n",
                                                   startDateTimeStamp,
                                                   endDateTimeStamp,
                                                   healthKitType,
                                                   activityType,
                                                   totalDistance,
                                                   distanceUnit,
                                                   energyConsumed,
                                                   energyUnit,
                                                   quantitySource,
                                                   sourceIdentifier,
                                                   metaDataStringified];
        
        return stringToWrite;
    };
    
    NSString*(^CategoryDataSerializer)(id) = ^NSString*(id dataSample)
    {
        HKCategorySample*   catSample       = (HKCategorySample *)dataSample;
        NSString*           stringToWrite   = nil;
        
        if (catSample.categoryType.identifier == HKCategoryTypeIdentifierSleepAnalysis)
        {
            NSString*           startDateTime   = [catSample.startDate toStringInISO8601Format];
            NSString*           healthKitType   = catSample.sampleType.identifier;
            NSString*           categoryValue   = nil;
            
            if (catSample.value == HKCategoryValueSleepAnalysisAsleep)
            {
                categoryValue = @"HKCategoryValueSleepAnalysisAsleep";
            }
            else
            {
                categoryValue = @"HKCategoryValueSleepAnalysisInBed";
            }
            
            NSString*           quantityUnit        = [[HKUnit secondUnit] unitString];
            NSString*           sourceIdentifier    = catSample.source.bundleIdentifier;
            NSString*           quantitySource      = catSample.source.name;
            
            if (quantitySource == nil)
            {
                quantitySource = @"not available";
            }
            else if ([[[UIDevice currentDevice] name] isEqualToString:quantitySource])
            {
                if ([APCDeviceHardware platformString])
                {
                    quantitySource = [APCDeviceHardware platformString];
                }
                else
                {
                    //  This shouldn't get called.
                    quantitySource = @"iPhone";
                }
                
            }
            
            // Get the difference in seconds between the start and end date for the sample
            NSDateComponents* secondsSpentInBedOrAsleep = [[NSCalendar currentCalendar] components:NSCalendarUnitSecond
                                                                                          fromDate:catSample.startDate
                                                                                            toDate:catSample.endDate
                                                                                           options:NSCalendarWrapComponents];
            NSString*           quantityValue   = [NSString stringWithFormat:@"%ld", (long)secondsSpentInBedOrAsleep.second];
            
            stringToWrite = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@\n",
                             startDateTime,
                             healthKitType,
                             categoryValue,
                             quantityValue,
                             quantityUnit,
                             sourceIdentifier,
                             quantitySource];
        }
        
        return stringToWrite;
    };
    
    NSArray* dataTypesWithReadPermission = self.initializationOptions[kHKReadPermissionsKey];
    
    if (!self.passiveDataCollector)
    {
        self.passiveDataCollector = [[APCPassiveDataCollector alloc] init];
    }
    
    // Just a note here that we are using n collectors to 1 data sink for quantity sample type data.
    NSArray*                    quantityColumnNames = @[@"startTime,endTime,type,value,unit,source,sourceIdentifier"];
    APCPassiveDataSink*         quantityreceiver    = [[APCPassiveDataSink alloc] initWithIdentifier:@"HealthKitDataCollector"
                                                                                         columnNames:quantityColumnNames
                                                                                  operationQueueName:@"APCHealthKitQuantity Activity Collector"
                                                                                    andDataProcessor:QuantityDataSerializer];
    
    NSArray*                    workoutColumnNames  = @[@"startTime,endTime,type,workoutType,total distance,unit,energy consumed,unit,source,sourceIdentifier,metadata"];
    APCPassiveDataSink*         workoutReceiver     = [[APCPassiveDataSink alloc] initWithIdentifier:@"HealthKitWorkoutCollector"
                                                                                         columnNames:workoutColumnNames
                                                                                  operationQueueName:@"APCHealthKitWorkout Activity Collector"
                                                                                    andDataProcessor:WorkoutDataSerializer];
    NSArray*                    categoryColumnNames = @[@"startTime,type,category value,value,unit,source,sourceIdentifier"];
    APCPassiveDataSink*         sleepReceiver       = [[APCPassiveDataSink alloc] initWithIdentifier:@"HealthKitSleepCollector"
                                                                                         columnNames:categoryColumnNames
                                                                                  operationQueueName:@"APCHealthKitSleep Activity Collector"
                                                                                    andDataProcessor:CategoryDataSerializer];
    
    if (dataTypesWithReadPermission)
    {
        for (id dataType in dataTypesWithReadPermission)
        {
            HKSampleType* sampleType = nil;
            
            if ([dataType isKindOfClass:[NSDictionary class]])
            {
                NSDictionary* categoryType = (NSDictionary *) dataType;
                
                //Distinguish
                if (categoryType[kHKWorkoutTypeKey])
                {
                    sampleType = [HKObjectType workoutType];
                }
                else if (categoryType[kHKCategoryTypeKey])
                {
                    sampleType = [HKObjectType categoryTypeForIdentifier:categoryType[kHKCategoryTypeKey]];
                }
            }
            else
            {
                sampleType = [HKObjectType quantityTypeForIdentifier:dataType];
            }
            
            if (sampleType)
            {
                // This is really important to remember that we are creating as many user defaults as there are healthkit permissions here.
                NSString*                               uniqueAnchorDateName    = [NSString stringWithFormat:@"APCHealthKit%@AnchorDate", dataType];
                APCHealthKitBackgroundDataCollector*    collector               = [[APCHealthKitBackgroundDataCollector alloc] initWithIdentifier:sampleType.identifier
                                                                                                                                       sampleType:sampleType anchorName:uniqueAnchorDateName
                                                                                                                                 launchDateAnchor:LaunchDate];
                
                //If the HKObjectType is a HKWorkoutType then set a different receiver/data sink.
                if ([sampleType isKindOfClass:[HKWorkoutType class]])
                {
                    [collector setReceiver:workoutReceiver];
                    [collector setDelegate:workoutReceiver];
                }
                else if ([sampleType isKindOfClass:[HKCategoryType class]])
                {
                    [collector setReceiver:sleepReceiver];
                    [collector setDelegate:sleepReceiver];
                }
                else
                {
                    [collector setReceiver:quantityreceiver];
                    [collector setDelegate:quantityreceiver];
                }
                
                [collector start];
                [self.passiveDataCollector addDataSink:collector];
            }
        }
    }
}

/*********************************************************************************/
#pragma mark - APCOnboardingDelegate Methods
/*********************************************************************************/

- (APCScene *)inclusionCriteriaSceneForOnboarding:(APCOnboarding *) __unused onboarding
{
    APCScene *scene = [APCScene new];
    scene.name = @"APHInclusionCriteriaViewController";
    scene.storyboardName = @"APHOnboarding";
    scene.bundle = [NSBundle mainBundle];
    
    return scene;
}


/*********************************************************************************/
#pragma mark - Consent
/*********************************************************************************/

- (ORKTaskViewController *)consentViewController
{
    APCConsentTask*         task = [[APCConsentTask alloc] initWithIdentifier:@"Consent"
                                                           propertiesFileName:kConsentPropertiesFileName];
    ORKTaskViewController*  consentVC = [[ORKTaskViewController alloc] initWithTask:task
                                                                        taskRunUUID:[NSUUID UUID]];
    
    return consentVC;
}

- (NSDictionary *) tasksAndSchedulesWillBeLoaded {
    
    NSString                    *resource = [[NSBundle mainBundle] pathForResource:self.initializationOptions[kTasksAndSchedulesJSONFileNameKey]
                                                                            ofType:@"json"];
    
    NSData                      *jsonData = [NSData dataWithContentsOfFile:resource];
    NSError                     *error;
    NSDictionary                *dictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                              options:NSJSONReadingMutableContainers
                                                                                error:&error];
    if (dictionary == nil) {
        APCLogError2 (error);
    }
    
    NSArray                     *schedules = [dictionary objectForKey:kJsonSchedulesKey];
    NSMutableDictionary         *newDictionary = [dictionary mutableCopy];
    NSMutableArray              *newSchedulesArray = [NSMutableArray new];
    
    for (NSDictionary *schedule in schedules) {
        
        NSString *taskIdentifier = [schedule objectForKey:kJsonScheduleTaskIDKey];
        
        if ( [taskIdentifier isEqualToString: kPDQ8TaskIdentifier] || [taskIdentifier isEqualToString: kMDSUPDRS])
        {
            NSDate              *date = [NSDate date];
            NSDateComponents    *dateComponent = [[NSDateComponents alloc] init];
            

            
            NSDate              *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponent
                                                                                         toDate:date
                                                                                        options:0];
            
            NSCalendar          *cal = [NSCalendar currentCalendar];
            
            NSDateComponents    *components = [cal components:(NSCalendarUnitDay | NSCalendarUnitMonth)
                                                     fromDate:newDate];
            
            if ( [taskIdentifier isEqualToString: kPDQ8TaskIdentifier])
            {
                [components setDay:kPDQ8TaskOffset];
                
                newDate = [[NSCalendar currentCalendar] dateByAddingComponents:components
                                                                        toDate:[NSDate date]
                                                                       options:0];
                
                components = [cal components:(NSCalendarUnitDay | NSCalendarUnitMonth)
                                    fromDate:newDate];
            } else if ([taskIdentifier isEqualToString: kMDSUPDRS]) {
                [components setDay:kMDSUPDRSOffset];
                
                newDate = [[NSCalendar currentCalendar] dateByAddingComponents:components
                                                                        toDate:[NSDate date]
                                                                       options:0];
                
                components = [cal components:(NSCalendarUnitDay | NSCalendarUnitMonth)
                                    fromDate:newDate];
            }
            
            NSString            *scheduleString = [schedule objectForKey:kJsonScheduleStringKey];
            NSMutableArray      *scheduleObjects = [[scheduleString componentsSeparatedByString:@" "] mutableCopy];
            
            
            [scheduleObjects replaceObjectAtIndex:kMonthOfDayObject withObject:@([components day])];

            
            NSString            *newScheduleString = [scheduleObjects componentsJoinedByString:@" "];
            
            [schedule setValue:newScheduleString
                        forKey:kJsonScheduleStringKey];
            
            [newSchedulesArray addObject:schedule];
        }
        else {
            [newSchedulesArray addObject:schedule];
        }
    }
    
    [newDictionary setValue:[dictionary objectForKey:kJsonTasksKey]
                     forKey:kJsonTasksKey];
    
    [newDictionary setValue:newSchedulesArray
                     forKey:kJsonSchedulesKey];
    
    return newDictionary;
}


@end
