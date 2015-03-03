// 
//  APHAppDelegate.m 
//  mPower 
// 
//  Copyright (c) 2014 Apple, Inc. All rights reserved. 
// 
 
@import APCAppCore;
#import "APHAppDelegate.h"
#import "APHProfileExtender.h"

/*********************************************************************************/
#pragma mark - Initializations Options
/*********************************************************************************/
static NSString *const kStudyIdentifier             = @"Parkinson's";
static NSString *const kAppPrefix                   = @"parkinson";
static NSString* const  kConsentPropertiesFileName  = @"APHConsentSection";

static NSString *const kVideoShownKey = @"VideoShown";

@interface APHAppDelegate ()
@property (nonatomic, strong) APHProfileExtender* profileExtender;

@end

@implementation APHAppDelegate

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
    dictionary = [self updateOptionsFor5OrOlder:dictionary];
    [dictionary addEntriesFromDictionary:@{
                                           kStudyIdentifierKey                  : kStudyIdentifier,
                                           kAppPrefixKey                        : kAppPrefix,
                                           kBridgeEnvironmentKey                : @(SBBEnvironmentProd),
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
                                           kAnalyticsOnOffKey  : @(YES),
                                           kAnalyticsFlurryAPIKeyKey : @"4T6KKBMDSYFVX95PNNWT"
                                           }];
    
    self.initializationOptions = dictionary;
    
    self.profileExtender = [[APHProfileExtender alloc] init];
}

- (void) setUpAppAppearance
{
    [APCAppearanceInfo setAppearanceDictionary:@{
                                                 kPrimaryAppColorKey : [UIColor colorWithRed:255 / 255.0f green:0.0 blue:56 / 255.0f alpha:1.000],
                                                 @"APHIntervalTapping-7259AC18-D711-47A6-ADBD-6CFCECDED1DF" : [UIColor appTertiaryPurpleColor],
                                                 @"APHSpatialSpanMemory-4A04F3D0-AC05-11E4-AB27-0800200C9A66" : [UIColor appTertiaryRedColor],
                                                 @"APHPhonation-C614A231-A7B7-4173-BDC8-098309354292" : [UIColor appTertiaryBlueColor],
                                                 @"APHTimedWalking-80F09109-265A-49C6-9C5D-765E49AAF5D9" : [UIColor appTertiaryYellowColor],
                                                 @"EnrollmentSurvey-20EF83D2-E461-4C20-9024-F43FCAAAF4C3": [UIColor lightGrayColor],
                                                 @"PDQ8-20EF83D2-E461-4C20-9024-F43FCAAAF4C8": [UIColor lightGrayColor],
                                                 @"MDSUPDRS-20EF82D1-E461-4C20-9024-F43FCAAAF4C8": [UIColor lightGrayColor],
                                                 @"MyThoughts-12ffde40-1551-4b48-aae2-8fef38d61b61": [UIColor lightGrayColor],
                                                 @"Feedback-394348ce-ca4f-4abe-b97e-fedbfd7ffb8e": [UIColor lightGrayColor],
                                                 @"APHMedicationTracker-20EF8ED2-E461-4C20-9024-F43FCAAAF4C3": [UIColor colorWithRed:0.933
                                                                                                                               green:0.267
                                                                                                                                blue:0.380
                                                                                                                               alpha:1.000]
                                                 }];
    [[UINavigationBar appearance] setTintColor:[UIColor appPrimaryColor]];
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSForegroundColorAttributeName : [UIColor appSecondaryColor2],
                                                            NSFontAttributeName : [UIFont appMediumFontWithSize:17.0f]
                                                            }];
    [[UIView appearance] setTintColor:[UIColor appPrimaryColor]];
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

/*********************************************************************************/
#pragma mark - Datasubstrate Delegate Methods
/*********************************************************************************/
- (void) setUpCollectors
{
    //
    // Set up location tracker
    //
    APCCoreLocationTracker * locationTracker = [[APCCoreLocationTracker alloc] initWithIdentifier: @"locationTracker"
                                                                           deferredUpdatesTimeout: 60.0 * 60.0
                                                                            andHomeLocationStatus: APCPassiveLocationTrackingHomeLocationUnavailable];
    [self.passiveDataCollector addTracker: locationTracker];
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

@end
