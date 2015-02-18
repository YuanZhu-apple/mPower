//
//  APCMedTrackerTests.m
//  Parkinson
//
//  Created by Ron Conescu on 2/17/15.
//  Copyright (c) 2015 Apple, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <APCAppCore/APCAppCore.h>
//#import "APCMedicationDataStorageEngine.h"
//#import "APCMedicationWeeklySchedule.h"
//#import "APCMedicationLozenge.h"
//#import "APCMedTrackerMedicationSchedule+Helper.h"
//#import "APCAppDelegate.h"

@interface APCMedTrackerTests : XCTestCase

@end

@implementation APCMedTrackerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.


//    [APCMedicationDataStorageEngine startup];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void) testWithCoreDataStuff
{
    NSArray *daysOfTheWeek = @[ @(1), @(5) ];
    NSNumber *timesPerDay = @(3);
    NSOperationQueue *someQueue = [NSOperationQueue new];
    someQueue.name = @"Waiting for 'create' op to finish...";

    [APCMedTrackerMedicationSchedule newScheduleWithMedication: nil
                                                        dosage: nil
                                                         color: nil
                                                 daysOfTheWeek: daysOfTheWeek
                                           numberOfTimesPerDay: timesPerDay
                                               andUseThisQueue: someQueue
                                              toDoThisWhenDone: ^(id createdObject, NSTimeInterval operationDuration, NSManagedObjectContext *context, NSManagedObjectID *scheduleId) {

                                                  APCMedTrackerMedicationSchedule *schedule = createdObject;
                                                  NSLog (@"Created a schedule!  Creation time = %f seconds.  Schedule = %@" , operationDuration, schedule);

                                                  [self okLetsPlayWithTheSchedule: schedule fromThisContext: context withThisId: scheduleId];

                                              }];

    // This is required, or else the code may not get a chance to complete.
    // This suggests we may need to ask the system to let the app stay awake
    // 'til our CoreData stuff has finished writing.  Are we doing that?
    NSLog (@"Waiting for schedule-generator to finish...");
    [NSThread sleepForTimeInterval: 60];
    NSLog (@"Done waiting.  Hopefully exiting the app.");
}

- (void) okLetsPlayWithTheSchedule: (APCMedTrackerMedicationSchedule *) schedule
                   fromThisContext: (NSManagedObjectContext *) context
                        withThisId: (NSManagedObjectID *) scheduleId
{
    NSLog (@"The schedule is: timesPerDay: %@", schedule.numberOfTimesPerDay);
    NSLog (@"The schedule is: zeroBasedDaysOfTheWeek: %@", schedule.zeroBasedDaysOfTheWeek);
    NSLog (@"The schedule is: color: %@", schedule.color.name);
    NSLog (@"The schedule is: dosage: %@", schedule.dosage.name);
    NSLog (@"The schedule is: meds: %@", schedule.medicine.name);



    APCAppDelegate *appDelegate = (APCAppDelegate *) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *masterContextIThink = appDelegate.dataSubstrate.persistentContext;
    NSManagedObjectContext *localContext = [[NSManagedObjectContext alloc] initWithConcurrencyType: NSPrivateQueueConcurrencyType];
    localContext.parentContext = masterContextIThink;
    id thingy = [localContext objectWithID: scheduleId];

    if ([thingy isKindOfClass: [APCMedTrackerMedicationSchedule class]])
    {
        NSLog (@"And after retrieving a new one, we got: %@", thingy);
        
        APCMedTrackerMedicationSchedule *retrievedSchedule = thingy;
        NSLog (@"Is it active? [%@]", retrievedSchedule.isActive ? @"YES" : @"NO");
    }
    else
    {
        NSLog (@"Hey!  We couldn't retrieve that ID from the database as a Schedule!");
    }

//    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: NSStringFromClass([APCMedTrackerMedicationSchedule class])];
//    request.predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"objectId", scheduleId];
}

@end










