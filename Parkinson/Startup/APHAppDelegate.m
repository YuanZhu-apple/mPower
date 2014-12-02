//
//  APHParkinsonAppDelegate.m
//  Parkinson's
//
//  Copyright (c) 2014 <INSTITUTION-NAME-TBD>. All rights reserved.
//

@import APCAppleCore;
#import "APHAppDelegate.h"

/*********************************************************************************/
#pragma mark - Initializations Options
/*********************************************************************************/
static NSString *const kStudyIdentifier = @"Parkinson's";
static NSString *const kAppPrefix       = @"parkinson";

static NSString *const kVideoShownKey = @"VideoShown";

@interface APHAppDelegate ()

@property (nonatomic, strong) RKSTTaskViewController *consentVC;

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
                                                   HKQuantityTypeIdentifierHeight
                                                   ],
                                           kHKWritePermissionsKey                : @[
                                                   HKQuantityTypeIdentifierBodyMass,
                                                   HKQuantityTypeIdentifierHeight
                                                   ],
                                           kAppServicesListRequiredKey           : @[
                                                   @(kSignUpPermissionsTypeLocation),
                                                   //@(kSignUpPermissionsTypePushNotifications),
                                                   @(kSignUpPermissionsTypeCoremotion)
                                                   ]
                                           }];
    self.initializationOptions = dictionary;
}

- (void) setUpAppAppearance
{
    [APCAppearanceInfo setAppearanceDictionary:@{
                                                 kPrimaryAppColorKey : [UIColor colorWithRed:0.176 green:0.706 blue:0.980 alpha:1.000]
                                                 }];
    [[UINavigationBar appearance] setTintColor:[UIColor appPrimaryColor]];
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSForegroundColorAttributeName : [UIColor appSecondaryColor2],
                                                            NSFontAttributeName : [UIFont appMediumFontWithSize:17.0f]
                                                            }];
}

- (void) showOnBoarding
{
    [super showOnBoarding];
    
    if ([self isVideoShown]) {
        [self showStudyOverview];
    }
    else
    {
        NSURL *introFileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Intro" ofType:@"mp4"]];
        APCIntroVideoViewController *introVideoController = [[APCIntroVideoViewController alloc] initWithContentURL:introFileURL];
        [self setUpRootViewController:introVideoController];
    }
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
static NSTimeInterval LOCATION_COLLECTION_INTERVAL = 5 * 60.0 * 60.0;

-(void)setUpCollectors
{
    //if (self.currentUser.isConsented) {
    NSError *error = nil;
    {
        HKQuantityType *quantityType = (HKQuantityType*)[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
        RKSTHealthCollector *healthCollector = [self.dataSubstrate.study addHealthCollectorWithSampleType:quantityType unit:[HKUnit countUnit] startDate:nil error:&error];
        if (!healthCollector)
        {
            NSLog(@"Error creating health collector: %@", error);
            [self.dataSubstrate.studyStore removeStudy:self.dataSubstrate.study error:nil];
            goto errReturn;
        }
        
        HKQuantityType *quantityType2 = (HKQuantityType*)[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodGlucose];
        HKUnit *unit = [HKUnit unitFromString:@"mg/dL"];
        RKSTHealthCollector *glucoseCollector = [self.dataSubstrate.study addHealthCollectorWithSampleType:quantityType2 unit:unit startDate:nil error:&error];
        
        if (!glucoseCollector)
        {
            NSLog(@"Error creating glucose collector: %@", error);
            [self.dataSubstrate.studyStore removeStudy:self.dataSubstrate.study error:nil];
            goto errReturn;
        }
        
        HKCorrelationType *bpType = (HKCorrelationType *)[HKCorrelationType correlationTypeForIdentifier:HKCorrelationTypeIdentifierBloodPressure];
        RKSTHealthCorrelationCollector *bpCollector = [self.dataSubstrate.study addHealthCorrelationCollectorWithCorrelationType:bpType sampleTypes:@[[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureDiastolic], [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureSystolic]] units:@[[HKUnit unitFromString:@"mmHg"], [HKUnit unitFromString:@"mmHg"]] startDate:nil error:&error];
        if (!bpCollector)
        {
            NSLog(@"Error creating BP collector: %@", error);
            [self.dataSubstrate.studyStore removeStudy:self.dataSubstrate.study error:nil];
            goto errReturn;
        }
        
        RKSTMotionActivityCollector *motionCollector = [self.dataSubstrate.study addMotionActivityCollectorWithStartDate:nil error:&error];
        if (!motionCollector)
        {
            NSLog(@"Error creating motion collector: %@", error);
            [self.dataSubstrate.studyStore removeStudy:self.dataSubstrate.study error:nil];
            goto errReturn;
        }
        
        //Set Up Passive Location Collection
        self.dataSubstrate.passiveLocationTracking = [[APCPassiveLocationTracking alloc] initWithTimeInterval:LOCATION_COLLECTION_INTERVAL];
        [self.dataSubstrate.passiveLocationTracking start];
    }
    
errReturn:
    return;
    // }
    
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

//- (APCScene *)customInfoSceneForOnboarding:(APCOnboarding *)onboarding
//{
//    APCScene *scene = [APCScene new];
//    scene.name = @"APHSignUpGlucoseViewController";
//    scene.storyboardName = @"APHOnboarding";
//    scene.bundle = [NSBundle mainBundle];
//    
//    return scene;
//}

/*********************************************************************************/
#pragma mark - Consent
/*********************************************************************************/

- (RKSTTaskViewController *)consentViewController
{
    if (!self.consentVC) {
        RKSTConsentDocument* consent = [[RKSTConsentDocument alloc] init];
        consent.title = @"Demo Consent";
        consent.signaturePageTitle = @"Consent";
        consent.signaturePageContent = @"I agree  to participate in this research Study.";
        
        
        //    RKSTConsentSignature *participantSig = [RKSTConsentSignature signatureForPersonWithTitle:@"Participant" name:nil signatureImage:nil dateString:nil];
        RKSTConsentSignature *participantSig = [RKSTConsentSignature signatureForPersonWithTitle:@"Participant"
                                                                                            name:nil
                                                                                  signatureImage:nil
                                                                                      dateString:nil
                                                                                      identifier:@"participant"];
        [consent addSignature:participantSig];
        
        //    RKSTConsentSignature *investigatorSig = [RKSTConsentSignature signatureForPersonWithTitle:@"Investigator" name:@"Jake Clemson" signatureImage:[UIImage imageNamed:@"signature.png"] dateString:@"9/2/14"];
        RKSTConsentSignature *investigatorSig = [RKSTConsentSignature signatureForPersonWithTitle:@"Investigator"
                                                                                             name:@"Jake Clemson"
                                                                                   signatureImage:[UIImage imageNamed:@"signature.png"]
                                                                                       dateString:@"9/2/14"
                                                                                       identifier:@"investigator"];
        [consent addSignature:investigatorSig];
        
        
        
        
        NSMutableArray* components = [NSMutableArray new];
        
        NSArray* scenes = @[@(RKSTConsentSectionTypeOverview),
                            @(RKSTConsentSectionTypeActivity),
                            @(RKSTConsentSectionTypeSensorData),
                            @(RKSTConsentSectionTypeDeIdentification),
                            @(RKSTConsentSectionTypeCombiningData),
                            @(RKSTConsentSectionTypeUtilizingData),
                            @(RKSTConsentSectionTypeImpactLifeTime),
                            @(RKSTConsentSectionTypePotentialRiskUncomfortableQuestion),
                            @(RKSTConsentSectionTypePotentialRiskSocial),
                            @(RKSTConsentSectionTypeAllowWithdraw)];
        for (NSNumber* type in scenes) {
            RKSTConsentSection* c = [[RKSTConsentSection alloc] initWithType:type.integerValue];
            c.content = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam adhuc, meo fortasse vitio, quid ego quaeram non perspicis. Plane idem, inquit, et maxima quidem, qua fieri nulla maior potest. Quonam, inquit, modo? An potest, inquit ille, quicquam esse suavius quam nihil dolere? Cave putes quicquam esse verius. Quonam, inquit, modo?";
            [components addObject:c];
        }
        
        {
            RKSTConsentSection* c = [[RKSTConsentSection alloc] initWithType:RKSTConsentSectionTypeCustom];
            c.summary = @"Custom Scene summary";
            c.title = @"Custom Scene";
            c.content = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam adhuc, meo fortasse vitio, quid ego quaeram non perspicis. Plane idem, inquit, et maxima quidem, qua fieri nulla maior potest. Quonam, inquit, modo? An potest, inquit ille, quicquam esse suavius quam nihil dolere? Cave putes quicquam esse verius. Quonam, inquit, modo?";
            c.customImage = [UIImage imageNamed:@"image_example.png"];
            [components addObject:c];
        }
        
        {
            RKSTConsentSection* c = [[RKSTConsentSection alloc] initWithType:RKSTConsentSectionTypeOnlyInDocument];
            c.summary = @"OnlyInDocument Scene summary";
            c.title = @"OnlyInDocument Scene";
            c.content = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam adhuc, meo fortasse vitio, quid ego quaeram non perspicis. Plane idem, inquit, et maxima quidem, qua fieri nulla maior potest. Quonam, inquit, modo? An potest, inquit ille, quicquam esse suavius quam nihil dolere? Cave putes quicquam esse verius. Quonam, inquit, modo?";
            [components addObject:c];
        }
        
        consent.sections = [components copy];
        
        RKSTVisualConsentStep *step = [[RKSTVisualConsentStep alloc] initWithDocument:consent];
        RKSTConsentReviewStep *reviewStep = [[RKSTConsentReviewStep alloc] initWithSignature:participantSig inDocument:consent];
        //    RKSTOrderedTask *task = [[RKSTOrderedTask alloc] initWithidentifier:@"consent" steps:@[step,reviewStep]];
        RKSTOrderedTask *task = [[RKSTOrderedTask alloc] initWithIdentifier:@"consent" steps:@[step, reviewStep]];
        //    RKSTTaskViewController *consentVC = [[RKSTTaskViewController alloc] initWithTask:task taskInstanceUUID:[NSUUID UUID]];
        _consentVC = [[RKSTTaskViewController alloc] initWithTask:task taskRunUUID:[NSUUID UUID]];
    }
    
    return _consentVC;
}


@end
