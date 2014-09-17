//
//  APHParkinsonAppDelegate.m
//  Parkinson
//
//  Created by Henry McGilton on 8/20/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHParkinsonAppDelegate.h"
#import "APHIntroVideoViewController.h"

NSString *const kDatabaseName = @"db.sqlite";
NSString *const kParkinsonIdentifier = @"com.ymedialabs.aph.parkinsons";
NSString *const kBaseURL = @"http://pd-staging.sagebridge.org/api/v1/";
NSString *const kTasksAndSchedulesJSONFileName = @"APHTasksAndSchedules";

@interface APHParkinsonAppDelegate ()

@end

@implementation APHParkinsonAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initializeAppleCoreStack];
    [self loadStaticTasksAndSchedulesIfNecessary];
    
//    [self startOnBoardingProcess];

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
    }
}

- (NSString *) applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? paths[0] : nil;
    return basePath;
}


#pragma mark - Private Methods

- (void) startOnBoardingProcess {
    NSURL *introFileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"intro" ofType:@"m4v"]];
    
    APHIntroVideoViewController *introVideoController = [[APHIntroVideoViewController alloc] initWithContentURL:introFileURL];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:introVideoController];
    [self.window setRootViewController:navController];
}


@end
