// 
//  APHAppDelegate.m 
//  mPower 
// 
//  Copyright (c) 2014 Apple, Inc. All rights reserved. 
// 
 
@import APCAppCore;
#import "APHAppDelegate.h"

/*********************************************************************************/
#pragma mark - Initializations Options
/*********************************************************************************/
static NSString *const kStudyIdentifier = @"Parkinson's";
static NSString *const kAppPrefix       = @"parkinson";

static NSString *const kVideoShownKey = @"VideoShown";

@interface APHAppDelegate ()

@end

@implementation APHAppDelegate

- (void) setUpInitializationOptions
{
    NSMutableDictionary * dictionary = [super defaultInitializationOptions];
    [dictionary addEntriesFromDictionary:@{
                                           kStudyIdentifierKey                  : kStudyIdentifier,
                                           kAppPrefixKey                        : kAppPrefix,
                                           kBridgeEnvironmentKey                : @(SBBEnvironmentStaging),
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
}

- (void) setUpAppAppearance
{
    [APCAppearanceInfo setAppearanceDictionary:@{
                                                 kPrimaryAppColorKey : [UIColor colorWithRed:255 / 255.0f green:0.0 blue:56 / 255.0f alpha:1.000]
                                                 }];
    [[UINavigationBar appearance] setTintColor:[UIColor appPrimaryColor]];
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSForegroundColorAttributeName : [UIColor appSecondaryColor2],
                                                            NSFontAttributeName : [UIFont appMediumFontWithSize:17.0f]
                                                            }];
    [[UIView appearance] setTintColor:[UIColor appPrimaryColor]];
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

- (APCScene *)inclusionCriteriaSceneForOnboarding:(APCOnboarding *)onboarding
{
    APCScene *scene = [APCScene new];
    scene.name = @"APHInclusionCriteriaViewController";
    scene.storyboardName = @"APHOnboarding";
    scene.bundle = [NSBundle mainBundle];
    
    return scene;
}

/* Commenting out as we no longer need Home Location
- (APCScene *)customInfoSceneForOnboarding:(APCOnboarding *)onboarding
{
    APCScene *scene = [APCScene new];
    scene.name = @"APCHomeLocationViewController";
    scene.storyboardName = @"APCHomeLocation";
    scene.bundle = [NSBundle appleCoreBundle];
    
    return scene;
}
*/
 
/*********************************************************************************/
#pragma mark - Consent
/*********************************************************************************/

- (ORKTaskViewController*)consentViewController
{
    NSArray*                sections  = [super consentSections];
    ORKConsentDocument*     consent   = [[ORKConsentDocument alloc] init];
    ORKConsentSignature*    signature = [ORKConsentSignature signatureForPersonWithTitle:NSLocalizedString(@"Participant", nil)
                                                                        dateFormatString:nil
                                                                            identifier:@"participant"];
    
    consent.title                = NSLocalizedString(@"Consent", nil);
    consent.signaturePageTitle   = NSLocalizedString(@"Consent", nil);
    consent.signaturePageContent = NSLocalizedString(@"I agree  to participate in this research Study.", nil);
    consent.sections             = sections;
    
    [consent addSignature:signature];
    
    ORKVisualConsentStep*   step         = [[ORKVisualConsentStep alloc] initWithIdentifier:@"VisualStep" document:consent];
    ORKConsentReviewStep*   reviewStep   = nil;
    NSMutableArray*         consentSteps = [NSMutableArray arrayWithObject:step];

#warning Reconsider if the the `signedIn` feature for consent is needed.
    if (self.dataSubstrate.currentUser.isSignedIn == NO)
    {
        reviewStep                  = [[ORKConsentReviewStep alloc] initWithIdentifier:@"reviewStep" signature:signature inDocument:consent];
        reviewStep.reasonForConsent = NSLocalizedString(@"By agreeing you are consenting to take part in this research study.", nil);
        [consentSteps addObject: reviewStep];
    }
    
    ORKOrderedTask*         task      = [[ORKOrderedTask alloc] initWithIdentifier:@"consent" steps:consentSteps];
    ORKTaskViewController*  consentVC = [[ORKTaskViewController alloc] initWithTask:task taskRunUUID:[NSUUID UUID]];
    
    return consentVC;
}

@end
