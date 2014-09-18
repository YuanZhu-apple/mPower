//
//  APHParkinsonAppDelegate.m
//  Parkinson
//
//  Created by Henry McGilton on 8/20/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APCAppleCore.h"
#import "APHParkinsonAppDelegate.h"
#import "APHIntroVideoViewController.h"

static NSString *const kDatabaseName = @"db.sqlite";
static NSString *const kParkinsonIdentifier = @"com.ymedialabs.aph.parkinsons";
static NSString *const kBaseURL = @"http://pd-staging.sagebridge.org/api/v1/";
static NSString *const kTasksAndSchedulesJSONFileName = @"APHTasksAndSchedules";
static NSString *const kLoggedInKey = @"LoggedIn";

@interface APHParkinsonAppDelegate ()

@end

@implementation APHParkinsonAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initializeAppleCoreStack];
    [self loadStaticTasksAndSchedulesIfNecessary];
    [self registerNotifications];
    
    if (![self isLoggedIn]) {
        [self startOnBoardingProcess];
    }

    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [super applicationDidBecomeActive:application];
}

/*********************************************************************************/
#pragma mark - Helpers
/*********************************************************************************/

- (void) initializeAppleCoreStack
{
    self.networkManager = [[APCSageNetworkManager alloc] initWithBaseURL:kBaseURL];
    self.dataSubstrate = [[APCDataSubstrate alloc] initWithPersistentStorePath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:kDatabaseName] additionalModels: nil studyIdentifier:kParkinsonIdentifier];
    self.scheduler = [[APCScheduler alloc] initWithDataSubstrate:self.dataSubstrate];
    self.dataMonitor = [[APCDataMonitor alloc] initWithDataSubstrate:self.dataSubstrate networkManager:(APCSageNetworkManager*)self.networkManager scheduler:self.scheduler];
}

- (void)loadStaticTasksAndSchedulesIfNecessary
{
    if (![APCDBStatus isSeedLoadedWithContext:self.dataSubstrate.persistentContext]) {
        [APCDBStatus setSeedLoadedWithContext:self.dataSubstrate.persistentContext];
        NSString *resource = [[NSBundle mainBundle] pathForResource:kTasksAndSchedulesJSONFileName ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:resource];
        NSError * error;
        NSDictionary * dictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        [error handle];
        [self.dataSubstrate loadStaticTasksAndSchedules:dictionary];
#ifdef TARGET_IPHONE_SIMULATOR
        NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
        [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
#endif
    }
}

- (NSString *) applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? paths[0] : nil;
    return basePath;
}


#pragma mark - Private Methods

- (void) registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginNotification:) name:(NSString *)APCUserLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logOutNotification:) name:(NSString *)APCUserLogOutNotification object:nil];
}

- (void) startOnBoardingProcess {
    NSURL *introFileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"intro" ofType:@"m4v"]];
    
    APHIntroVideoViewController *introVideoController = [[APHIntroVideoViewController alloc] initWithContentURL:introFileURL];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:introVideoController];
    [self.window setRootViewController:navController];
}

- (BOOL) isLoggedIn
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kLoggedInKey];
}


#pragma mark - Notifications
- (void) loginNotification:(NSNotification *)notification {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    UITabBarController *tabBarController = (UITabBarController *)[storyBoard instantiateInitialViewController];
    self.window.rootViewController = tabBarController;
}

- (void) logOutNotification:(NSNotification *)notification {
    [self startOnBoardingProcess];
}

@end
