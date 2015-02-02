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
                                                   @(kSignUpPermissionsTypeMicrophone)
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
                                           kAppServicesListRequiredKey : @[ @(kSignUpPermissionsTypeLocalNotifications) ],
                                           kAnalyticsFlurryAPIKeyKey : @"4T6KKBMDSYFVX95PNNWT"
                                           }];
    self.initializationOptions = dictionary;
}

- (void) setUpAppAppearance
{
    [APCAppearanceInfo setAppearanceDictionary:@{
                                                 kPrimaryAppColorKey : [UIColor colorWithRed:255/255.0f green:0 blue:56/255.0f alpha:1.000]
//                                                 kPrimaryAppColorKey : [UIColor colorWithRed:0.176 green:0.706 blue:0.980 alpha:1.000]
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

//static  NSTimeInterval  kPassiveLocationDeferredUpdatesTimeout = 1.0 * 60.0;

-(void)setUpCollectors
{
//    NSError *error = nil;
//    {

//        HKQuantityType *quantityType = (HKQuantityType*)[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
//        RKSTHealthCollector *healthCollector = [self.dataSubstrate.study addHealthCollectorWithSampleType:quantityType unit:[HKUnit countUnit] startDate:nil error:&error];
//        if (!healthCollector)
//        {
//            APCLogError2(error);
//            [self.dataSubstrate.studyStore removeStudy:self.dataSubstrate.study error:nil];
//            goto errReturn;
//        }

//        RKSTMotionActivityCollector *motionCollector = [self.dataSubstrate.study addMotionActivityCollectorWithStartDate:nil error:&error];
//        if (!motionCollector)
//        {
//            [self.dataSubstrate.studyStore removeStudy:self.dataSubstrate.study error:nil];
//            goto errReturn;
//        }
        
            //    Set Up Passive Location Collection: User's Home Location is not available in Parkinson's
        
//        self.dataSubstrate.passiveLocationTracking = [[APCPassiveLocationTracking alloc] initWithDeferredUpdatesTimeout:kPassiveLocationDeferredUpdatesTimeout
//                                                                                              andHomeLocationStatus:APCPassiveLocationTrackingHomeLocationUnavailable];
//        [self.dataSubstrate.passiveLocationTracking start];
//    }
//    
//errReturn:
//    return;
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

- (RKSTTaskViewController *)consentViewController
{
    RKSTConsentDocument* consent = [[RKSTConsentDocument alloc] init];
    consent.title = @"Consent";
    consent.signaturePageTitle = @"Consent";
    consent.signaturePageContent = @"I agree  to participate in this research Study.";
    
    
    RKSTConsentSignature *participantSig = [RKSTConsentSignature signatureForPersonWithTitle:@"Participant"
                                                                            dateFormatString:nil
                                                                                  identifier:@"participant"];
    [consent addSignature:participantSig];
    
    
    NSMutableArray* components = [NSMutableArray new];
    
    NSArray* scenes = @[
                        @(RKSTConsentSectionTypeOverview),              //     0.
                        @(RKSTConsentSectionTypeDataGathering),         //     1.
                        @(RKSTConsentSectionTypePrivacy),               //     2.
                        @(RKSTConsentSectionTypeDataUse),               //     3.
                        @(RKSTConsentSectionTypeTimeCommitment),        //     4.  Issues to Consider
                        @(RKSTConsentSectionTypeStudySurvey),           //     5.
                        @(RKSTConsentSectionTypeStudyTasks),            //     6.
                        @(RKSTConsentSectionTypeWithdrawing),           //     7.
                        @(RKSTConsentSectionTypeCustom),                //     8.  Potential Benefits
                        @(RKSTConsentSectionTypeCustom),                //     9.  Risk To Privacy
                        @(RKSTConsentSectionTypeCustom),                //    10.  Issues to consider
                        @(RKSTConsentSectionTypeCustom)];               //    11.
    
    for (NSUInteger i = 0;  i < scenes.count;  i ++) {
        
        RKSTConsentSectionType sectionType = [scenes[i] integerValue];
        RKSTConsentSection *section = [[RKSTConsentSection alloc] initWithType:sectionType];
        
        switch (sectionType) {
            case RKSTConsentSectionTypeOverview:
            {
                section.title = NSLocalizedString(@"Welcome", nil);
                section.summary = @"mPower is a research study for volunteers over 18 years of age. This simple walkthrough will explain the study, the impact it may have on your life, and will allow you to provide your consent to participate.";
                section.content = @"SUMMARY\n\nYou are invited to participate in a research study to understand variations in symptoms of Parkinson’s disease (PD).  This study is designed for persons over 18 years old with or without PD.  Your participation in this study is entirely voluntary.\n\nTo be in a research study you must give your informed consent.   The purpose of this form is to help you decide if you want to participate in this study.  Please read the information carefully. If you decide to take part in this research study, you will be given a copy of this signed and dated consent form. If you decide to participate, you are free to withdraw your consent, and to discontinue participation at any time.\n\nYou should not join the research study until all of your questions are answered.\n\nParticipating in a research study is not the same as receiving medical care. The decision to join or not join the research study will not affect your medical benefits.\n\nPURPOSE OF THE STUDY\n\nPeople with PD can have very different and more or less severe symptoms day to day.  This affects quality of life and makes managing treatment difficult.  We would like to understand the causes of these symptom variations.\n\nNew technologies allow people to record and track their health and symptoms in real time.  This study will monitor individual’s health and symptoms using questionnaires and sensors via a mobile phone application and wearable devices if available.\n\nIf you decide to join the study you will need to download the study application on your mobile device.  Then periodically we will ask you to answer questions and perform some tasks via your mobile phone. These questions may be about your health, exercise, diet, sleep and medicines, in addition to other surveys.  The tasks will be some brief activities that you perform while holding your phone like walking, typing or balancing for a short period of time.  In addition, if you are able to sustain moderate physical activity, we may send you motivational prompts to remain active.  Your study data will include your responses to surveys and the measurements from the phone itself when you perform a task.\n\nYour data, without your name, will be added to the data of other study participants and made available to groups of researchers for analysis and future research. You also will have a unique account that you can use to review your own data.  We anticipate enrolling 20,000 subjects in the study.\n\nThe sponsor is Sage Bionetworks with some funding from the Robert Wood Johnson Foundation.";
            }
                break;
            case RKSTConsentSectionTypeDataGathering:
            {
                section.content = @"Download a mobile app (free) and register an account:  You need to have the study app on your phone, register an account and confirm your agreement to participate in this study. Registration will include entering your name, email address and other general information about yourself to verify your eligibility.\nHealth Surveys: We will ask you to answer questions about yourself, your medical history, and your current health. You may choose to leave any questions that you do not wish to answer blank.\nTasks:  We will ask you to perform specific tasks while holding or using your mobile phone and record sensor data directly from your phone.  Examples are:\no to record variations in your voice by saying “aaah” for 10-20 seconds into the microphone of your phone.\no to hold your phone, walk few steps forward then few steps backward to assess your posture and stability.\no to tap on the phone screen in a specific way to test your reaction time and dexterity.\no Additionally,  you may be asked for your permission to include some data from third-party fitness devices (like the Fitbit or Jawbone Up) if you use one.\n\nWe will send notices on your phone asking you to complete these tasks and surveys.You may choose to act at your convenience, (either then or later) and you may choose to participate in all or only in some parts of the study. These tasks should take you about 20 minutes each week. You have the right to refuse to answer particular questions or participate in particular aspects of the study.";
            }
                break;
            case RKSTConsentSectionTypeDataUse:
            {
                section.title = @"Sensor Data";
                section.content = @"New technologies allow people to record and track their health and symptoms in real time. This study is proposing to monitor individual’s health and symptoms using a mobile phone application. This study is unique in that it allows participants to step up as equal partners in both the surveillance and management of symptoms from breast cancer treatment as well as in the research process.\n\nWe will NOT access your personal contacts, other applications, text or email message content, or websites visited.";
            }
                break;
            case RKSTConsentSectionTypePrivacy:
            {
                section.content = @"In order to preserve your privacy, we will use a random code instead of your name on all your study data. This unique code cannot be used to directly identify you. Any data that directly identifies you will be removed before the data is transferred for analysis, although researchers will have the ability to contact you if you have chosen to allow them to do so. We will never sell, rent or lease your contact information.";
            }
                break;
            case RKSTConsentSectionTypeStudySurvey:
            {
                section.summary = @"Your de-identified data will be combined with the de-identified data from other participants.";
                section.content = @"We will combine your study data including survey responses and other measurements with those of other study participants. The combined data will be transferred to Synapse, a computational research platform, for analysis. The research team will analyze the combined data and report findings back to the community through Blog or scientific publications. The combined study data on Synapse will also be available to use for other research purposes and will be shared with registered users worldwide who agree to using the data in an ethical manner, to do no harm and not attempt to re-identify or re-contact you unless you have chosen to allow them to do so.";
            }
                break;
            case RKSTConsentSectionTypeStudyTasks:
            {
                section.title = @"Using the Data";
                section.content = @"The combined study data on Synapse will also be available to use for other research purposes and will be shared with registered users worldwide who agree to using the data in an ethical manner, to do no harm and not attempt to re-identify or re- contact you unless you have chosen to allow them to do so.\n\nUSE OF DATA FOR FUTURE RESEARCH\nSeveral databases are available to help researchers understand different diseases. These databases contain information and other data helpful to study diseases. This study will include your research data into one such database, Synapse, to be used in future research beyond this study. Your data may benefit future research.\n\nBefore your data is released to the Synapse database, your personal contact information such as your name, e-mail, etc, will be removed. Your unique code identifier will be used in place of your name when your data is released onto Synapse. The study data will be made available on Synapse to registered users who have agreed to using the data in an ethical manner, to do no harm and not attempt to re-identify or re-contact you unless you have chosen to allow them to do so. The Principal Investigator and Sponsor will have no oversight on the future use of the study data released through Synapse.\n\nAlthough you can withdraw from the study at any time, you cannot withdraw the de-identified data that have already been distributed through research databases.\n\nThe main risk of donating your de-identified data to a centralized database is the potential loss of privacy and confidentiality in case of public disclosure due to unintended data breaches, including hacking or other activities outside of the procedures authorized by the study. In such a case, your data may be misused or used for unauthorized purposes by someone sufficiently skilled in data analysis to try to re-identify you. This risk is low.";
            }
                break;
            case RKSTConsentSectionTypeTimeCommitment:
            {
                section.title = @"Issues to Consider";
                section.content = @"We do not expect any medical side effects from participating. Inconveniences associated with participation include spending approximately 20 minutes per week to respond to questions from the study application.\n\nPAYMENT\nYou will not be paid for being in this study.\n\nCOSTS\nThere is no cost to you to participate in this study other than to your mobile data plan if applicable.";
            }
                break;
            case RKSTConsentSectionTypeCustom:
            {
                if (i == 8) {
                    section.title = @"Potential Benefits";
                    section.summary = @"You will be able to see your data and potentially learn more about trends in your health.";
                    section.customImage = [UIImage imageNamed:@"consent_visualize"];
                    section.content = @"The goal of this study is to create knowledge that can benefit us as a society. The benefits are primarily the creation of insights to help current and future patients and their families to better detect, understand and manage their health. We will return the insights learned from analysis of the study data through the study website, but these insights may not be of direct benefit to you. We cannot, and thus we do not, guarantee or promise that you will personally receive any direct benefits from this study. However you will be able to track your health and export your data at will to share with your medical doctor and anyone you choose.";
                    
                } else if (i == 9) {
                    section.title = @"Risk to Privacy";
                    section.summary = @"We will make every effort to protect your information, but total anonymity cannot be guaranteed.";
                    section.customImage = [UIImage imageNamed:@"consent_privacy"];
                    section.content = @"You may have concerns about data security, privacy and confidentiality. We take great care to protect your information, however there is a slight risk of loss of privacy. This is a low risk because we separate your personal information (information that can directly identify you, such as your name or phone number) from the research data to respect your privacy. However, even with removal of this information, it is sometimes possible to re-identify an individual given enough cross-reference information about him or her. This risk, while very low, should still be contemplated prior to enrolling.\n\nCONFIDENTIALITY\nWe are committed to protect your privacy. Your identity will be kept as confidential as possible. Except as required by law, you will not be identified by name or by any other direct personal identifier. We will use a random code number instead of your name on all your data collected, analyzed, aggregated and released to researchers. Information about the code will be kept in a secure system. This study anticipates that your data will be added to a combined study dataset placed in a “repository” - an online database – like Sage Bionetworks Synapse where other researchers can access it. No name or contact information will be included in this combined study dataset. Researchers will have access to all the study data but will be unable to easily map any particular data to the identities of the participants. However, there is always a risk that the database can be breached by hackers, or that experts in re- identification may attempt to reverse our processes. Total confidentiality cannot be guaranteed.";
                } else if (i == 10) {
                    section.title = @"Issues to Consider";
                    section.summary = @"Some questions may make you uncomfortable. Simply do not respond.";
                    section.customImage = [UIImage imageNamed:@"consent_uncomfortablequestions"];
                    section.content = @"This is not a treatment study and we do not expect any medical side effects from participating.\nSome survey questions may make you feel uncomfortable. Know that the information you provide is entirely up to you and you are free to skip questions that you do not want to answer.\n\nOther people may glimpse the study notifications and/or reminders on your phone and realize you are enrolled in this study. This can make some people feel self- conscious. You can avoid this discomfort by putting a passcode on your phone to block unauthorized users from accessing your phone content.\n\nYou may have concerns about data security, privacy and confidentiality. We take great care to protect your information, however there is a slight risk of loss of privacy. This is a low risk because we separate your personal information (information that can directly identify you, such as your name or phone number) from the research data to respect your privacy. However, even with removal of this information, it is sometimes possible to re-identify an individual given enough cross-reference information about him or her. This risk, while very low, should still be contemplated prior to enrolling.\n\nData collected in this study will count against your existing mobile data plan. You may configure the application to only use WiFi connections to limit the impact this data collection has on your data plan.";
                } else if (i == 11) {
                    section.title = @"Issues to Consider";
                    section.summary = @"Participating in this study may alter how you feel. You may feel more tired, sad, energized, or happy.";
                    section.customImage = [UIImage imageNamed:@"consent_mood"];
                    section.content = @"Participation in this study may involve risks that are not known at this time.\n\nYou will be told about any new information that might change your decision to be in this study.\n\nSince no medical treatments are provided during this study there are no alternative therapies. The only alternative is to not participate.";
                }
                
            }
                break;
            case RKSTConsentSectionTypeWithdrawing:
            {
                section.title = @"Exiting the Study";
                section.summary = @"You may leave the study at any time.";
                section.content = @"Your authorization for the use and/or disclosure of your health information will expire December 31, 2060.\n\nVOLUNTARY PARTICIPATION AND WITHDRAWAL\nYour participation in this study is voluntary. You do not have to sign this consent form. But if you do not, you will not be able to participate in this research study. You may decide not to participate or you may leave the study at any time. Your decision will not result in any penalty or loss of benefits to which you are entitled.\n● You are not obligated to participate in this study.\n● Your questions should be answered clearly and to your satisfaction, before you choose to participate in the study.\n● You have a right to download or transfer a copy of all of your study data.\n● By agreeing to participate you do not waive any of your legal rights.\n\nIf you choose to withdraw from the research study, we will stop collecting your study data. At the end of the study period we will stop collecting your data, even if the application remains on your phone and you keep using it. If you were interested in joining another study afterward, we would ask you to complete another consent, like this one, explaining the risks and benefits of the new study.\n\nThe Study Principal Investigator or the sponsor may also withdraw you from the study without your consent at any time for any reason, including if it is in your best interest, you do not consent to continue in the study after being told of changes in the research that may affect you, or if the study is cancelled.";
            }
                break;
            default:
                break;
        }
        
        [components addObject:section];
    }
    
    consent.sections = [components copy];
    
    RKSTVisualConsentStep *step = [[RKSTVisualConsentStep alloc] initWithIdentifier:@"VisualStep" document:consent ];
    RKSTConsentReviewStep *reviewStep = nil;
    
    NSMutableArray  *consentSteps = [NSMutableArray new];
    [consentSteps addObject: step];
    
    if (self.dataSubstrate.currentUser.isSignedIn == NO) {
        reviewStep = [[RKSTConsentReviewStep alloc] initWithIdentifier:@"reviewStep" signature:participantSig inDocument:consent];
        reviewStep.reasonForConsent = @"By agreeing you are consenting to take part in this research study.";
        [consentSteps addObject: reviewStep];
    }
    
    RKSTOrderedTask *task = [[RKSTOrderedTask alloc] initWithIdentifier:@"consent" steps:consentSteps];
    
    RKSTTaskViewController *consentVC = [[RKSTTaskViewController alloc] initWithTask:task taskRunUUID:[NSUUID UUID]];
    
    return consentVC;
}

@end
