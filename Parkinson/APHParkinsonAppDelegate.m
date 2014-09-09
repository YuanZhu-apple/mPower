//
//  APHParkinsonAppDelegate.m
//  Parkinson
//
//  Created by Henry McGilton on 8/20/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHParkinsonAppDelegate.h"

NSString *const kDatabaseName = @"db.sqlite";
NSString *const kParkinsonIdentifier = @"com.ymedialabs.aph.parkinsons";
NSString *const kBaseURL = @"http://localhost:4567/api/v1";

@interface APHParkinsonAppDelegate ()

@end

@implementation APHParkinsonAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initializeAppleCoreStack];
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
}

- (NSString *) applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? paths[0] : nil;
    return basePath;
}

@end
