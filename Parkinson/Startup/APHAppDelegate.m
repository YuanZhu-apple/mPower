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
static NSString *const kStudyIdentifier = @"Parkinson's";
static NSString *const kAppPrefix       = @"parkinson";

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

- (NSArray*)quizSteps
{
    ORKInstructionStep* instruction = [[ORKInstructionStep alloc] initWithIdentifier:@"instruction"];
    instruction.title = @"Let's Test Your Understanding";
    instruction.text = @"We'll now ask you 5 simple questions about the study information you just read.\nPress Get Started when you're ready to start.";

    ORKTextChoiceAnswerFormat*  purposeChoice   = [[ORKTextChoiceAnswerFormat alloc] initWithStyle:ORKChoiceAnswerStyleSingleChoice
                                                                                       textChoices:@[NSLocalizedString(@"Understand the fluctuations of Parkinson’s disease symptoms", nil),
                                                                                                     NSLocalizedString(@"Treating Parkinson’s disease", nil)]];
    ORKQuestionStep*    question1 = [ORKQuestionStep questionStepWithIdentifier:@"purpose"
                                                                          title:NSLocalizedString(@"What is the purpose of this study?", nil)
                                                                         answer:purposeChoice];
    ORKQuestionStep*    question2 = [ORKQuestionStep questionStepWithIdentifier:@"deidentified"
                                                                          title:NSLocalizedString(@"My name will be stored with my Study data", nil)
                                                                         answer:[ORKBooleanAnswerFormat new]];
    ORKQuestionStep*    question3 = [ORKQuestionStep questionStepWithIdentifier:@"access"
                                                                          title:NSLocalizedString(@"Many researchers will be able to access my study data", nil)
                                                                         answer:[ORKBooleanAnswerFormat new]];
    ORKQuestionStep*    question4 = [ORKQuestionStep questionStepWithIdentifier:@"skipSurvey"
                                                                          title:NSLocalizedString(@"I will be able to skip any survey question", nil)
                                                                         answer:[ORKBooleanAnswerFormat new]];
    
    ORKQuestionStep*    question5 = [ORKQuestionStep questionStepWithIdentifier:@"stopParticipating"
                                                                          title:NSLocalizedString(@"I will be able to stop participating at any time", nil)
                                                                         answer:[ORKBooleanAnswerFormat new]];
    
    question1.optional = NO;
    question2.optional = NO;
    question3.optional = NO;
    question4.optional = NO;
    question5.optional = NO;
    
    return @[instruction, question1, question2, question3, question4, question5];
}

- (ORKTaskViewController*)consentViewController
{
    NSString*               docHtml   = nil;
    NSArray*                sections  = [super consentSectionsAndHtmlContent:&docHtml];
    ORKConsentDocument*     consent   = [[ORKConsentDocument alloc] init];
    ORKConsentSignature*    signature = [ORKConsentSignature signatureForPersonWithTitle:NSLocalizedString(@"Participant", nil)
                                                                        dateFormatString:nil
                                                                            identifier:@"participant"];
    
    consent.title                = NSLocalizedString(@"Consent", nil);
    consent.signaturePageTitle   = NSLocalizedString(@"Consent", nil);
    consent.signaturePageContent = NSLocalizedString(@"I agree  to participate in this research Study.", nil);
    consent.sections             = sections;
    consent.htmlReviewContent    = docHtml;
    
    [consent addSignature:signature];
    
    ORKVisualConsentStep*   step         = [[ORKVisualConsentStep alloc] initWithIdentifier:@"VisualStep" document:consent];
    ORKConsentReviewStep*   reviewStep   = nil;
    NSMutableArray*         consentSteps = [NSMutableArray arrayWithObject:step];
    
    [consentSteps addObjectsFromArray:[self quizSteps]];


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
