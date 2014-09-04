//
//  APHParkinsonAppDelegate.m
//  Parkinson
//
//  Created by Henry McGilton on 8/20/14.
//  Copyright (c) 2014 Henry McGilton. All rights reserved.
//

#import "APHParkinsonAppDelegate.h"

static NSString * databaseName = @"db.sqlite";
NSString *const ParkinsonStudyIdentifier = @"com.ymedialabs.parkinsons";

@interface APHParkinsonAppDelegate ()

@end

@implementation APHParkinsonAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.networkManager = [[APCSageNetworkManager alloc] initWithBaseURL:@"http://localhost:4567/api/v1"];
    self.dataSubstrate = [[APCDataSubstrate alloc] initWithPersistentStorePath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:databaseName] additionalModels: nil studyIdentifier:ParkinsonStudyIdentifier];
    return YES;
}

- (NSString *) applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? paths[0] : nil;
    return basePath;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
