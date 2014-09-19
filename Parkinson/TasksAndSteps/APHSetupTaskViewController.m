//
//  APHSetupTaskViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 9/3/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHSetupTaskViewController.h"
#import "APCAppleCore.h"
#import "APHParkinsonAppDelegate.h"
#import <objc/message.h>

@implementation APHSetupTaskViewController

#pragma  mark  -  Instance Initialisation
+ (instancetype)customTaskViewController: (APCScheduledTask*) scheduledTask
{
    RKTask  *task = [self createTask: scheduledTask];
    APHSetupTaskViewController * controller = [[self alloc] initWithTask:task taskInstanceUUID:[NSUUID UUID]];
    controller.scheduledTask = scheduledTask;
    controller.taskDelegate = controller;
    return  controller;
}

+ (RKTask *)createTask: (APCScheduledTask*) scheduledTask
{
    return  nil;
}

/*********************************************************************************/
#pragma mark - RKTaskDelegate
/*********************************************************************************/
- (void)taskViewControllerDidComplete: (RKTaskViewController *)taskViewController
{
    self.scheduledTask.completed = @YES;
    NSError * saveError;
    [self.scheduledTask saveToPersistentStore:&saveError];
    [saveError handle];
    [taskViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)taskViewControllerDidCancel:(RKTaskViewController *)taskViewController
{
    [taskViewController suspend];
    [taskViewController dismissViewControllerAnimated:YES completion:nil];
}

//Universal Did Produce Result
- (void)taskViewController:(RKTaskViewController *)taskViewController didProduceResult:(RKResult *)result
{
    APCResult * apcResult = [APCResult storeRKResult:result inContext:((APHParkinsonAppDelegate *)[UIApplication sharedApplication].delegate).dataSubstrate.mainContext];
    apcResult.scheduledTask = self.scheduledTask;
    NSError * saveError;
    [apcResult saveToPersistentStore:&saveError];
    [saveError handle];
    NSLog(@"RKResult: %@ APCResult: %@", result,apcResult);
}

- (NSString *)filePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[paths lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", [NSUUID UUID].UUIDString]];
}

/*********************************************************************************/
#pragma mark - Misc
/*********************************************************************************/
-(NSString *)descriptionForObject:(id)objct
{
    unsigned int varCount;
    NSMutableString *descriptionString = [[NSMutableString alloc]init];
    
    
    objc_property_t *vars = class_copyPropertyList(object_getClass(objct), &varCount);
    
    for (int i = 0; i < varCount; i++)
    {
        objc_property_t var = vars[i];
        const char* name = property_getName (var);
        
        NSString *keyValueString = [NSString stringWithFormat:@"\n%@ = %@",[NSString stringWithUTF8String:name],[objct valueForKey:[NSString stringWithUTF8String:name]]];
        [descriptionString appendString:keyValueString];
    }
    
    free(vars);
    return descriptionString;
}

@end
