//
//  APCMedTrackerTests.m
//  AppCore
//
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

- (void) testCreateOneScheduleAsynchronously
{
    /*
     Wait for my asynch operation to finish.
     Learned how from here:
     http://stackoverflow.com/questions/4326350/how-do-i-wait-for-an-asynchronously-dispatched-block-to-finish
     */
    dispatch_semaphore_t semaphore = dispatch_semaphore_create (0);


    NSArray *daysOfTheWeek = @[ @(1), @(5) ];
    NSNumber *timesPerDay = @(3);
    NSOperationQueue *someQueue = [NSOperationQueue sequentialOperationQueueWithName: @"Waiting for 'create' op to finish..."];

    [APCMedTrackerMedicationSchedule newScheduleWithMedication: nil
                                                        dosage: nil
                                                         color: nil
                                                 daysOfTheWeek: daysOfTheWeek
                                           numberOfTimesPerDay: timesPerDay
                                               andUseThisQueue: someQueue
                                              toDoThisWhenDone: ^(id createdObject,
                                                                  NSTimeInterval operationDuration,
                                                                  NSManagedObjectContext *context,
                                                                  NSManagedObjectID *scheduleId)
     {
         APCMedTrackerMedicationSchedule *schedule = createdObject;
         NSLog (@"Created a schedule!  Creation time = %f seconds.  Schedule = %@" , operationDuration, schedule);

         [self okLetsPlayWithTheSchedule: schedule
                         fromThisContext: context
                              withThisId: scheduleId];

         dispatch_semaphore_signal (semaphore);
     }];


    // And wait for the op to finish.
    dispatch_semaphore_wait (semaphore, DISPATCH_TIME_FOREVER);
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
    NSLog (@"The schedule is: Created on: %@", schedule.dateStartedUsing);
    NSLog (@"The schedule is: object ID is temporary: %@", scheduleId.isTemporaryID ? @"YES" : @"NO");
//    schedule.t


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
        NSLog (@"timesPerDay:  [%@]", retrievedSchedule.numberOfTimesPerDay);
        NSLog (@"date created:  [%@]", retrievedSchedule.dateStartedUsing);
        NSLog (@"temp ID:  [%d]", retrievedSchedule.objectID.isTemporaryID);
    }
    else
    {
        NSLog (@"Hey!  We couldn't retrieve that ID from the database as a Schedule!");
    }

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: NSStringFromClass ([APCMedTrackerMedicationSchedule class])];
//    request.predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"objectId", "*"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey: NSStringFromSelector( @selector (dateStartedUsing))
                                                              ascending: YES]];

//    [localContext objectWithID: ]

    NSError *error = nil;
    NSArray *allSchedules = [localContext executeFetchRequest: request error: &error];
    NSLog (@"All schedules in the system are now: %@", allSchedules);
}

/**
 This does not yet work.  (In progress.)
 */
- (void) testCreateOneScheduleWithRealLinks
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create (0);
    NSOperationQueue *someQueue = [NSOperationQueue sequentialOperationQueueWithName: @"Waiting for 'create' op to finish..."];

    [APCMedTrackerDataStorageManager startupAndThenUseThisQueue: someQueue toDoThis:
     ^{
         dispatch_semaphore_signal (semaphore);
     }];

    dispatch_semaphore_wait (semaphore, DISPATCH_TIME_FOREVER);


//    NSArray *__block allMeds = nil;
//    NSArray *__block allPossibleDosages = nil;
//    NSArray *__block allColors = nil;
//
//    [APCMedTrackerMedication fetchAllFromCoreDataAndUseThisQueue: someQueue
//                                                toDoThisWhenDone: ^(NSArray *arrayOfGeneratedObjects,
//                                                                    NSTimeInterval operationDuration,
//                                                                    NSError *error)
//     {
//         allMeds = arrayOfGeneratedObjects;
//         dispatch_semaphore_signal (semaphore);
//     }];
//
//    dispatch_semaphore_wait (semaphore, DISPATCH_TIME_FOREVER);
//    semaphore = dispatch_semaphore_create (0);
//
//    [APCMedTrackerPossibleDosage fetchAllFromCoreDataAndUseThisQueue: someQueue
//                                                    toDoThisWhenDone: ^(NSArray *arrayOfGeneratedObjects,
//                                                                        NSTimeInterval operationDuration,
//                                                                        NSError *error)
//     {
//         allPossibleDosages = arrayOfGeneratedObjects;
//         dispatch_semaphore_signal (semaphore);
//     }];
//
//    dispatch_semaphore_wait (semaphore, DISPATCH_TIME_FOREVER);
//    semaphore = dispatch_semaphore_create (0);
//
//    [APCMedTrackerScheduleColor fetchAllFromCoreDataAndUseThisQueue: someQueue
//                                                   toDoThisWhenDone: ^(NSArray *arrayOfGeneratedObjects,
//                                                                       NSTimeInterval operationDuration,
//                                                                       NSError *error)
//     {
//         allColors = arrayOfGeneratedObjects;
//         dispatch_semaphore_signal (semaphore);
//     }];
//
//    dispatch_semaphore_wait (semaphore, DISPATCH_TIME_FOREVER);
//
//    NSLog (@"Got all meds, dosages, and colors:\n%@\n%@\n%@", allMeds, allPossibleDosages, allColors);
//
//
//    NSArray *daysOfTheWeek = @[ @(1), @(5) ];
//    NSNumber *timesPerDay = @(3);
//
//    NSUInteger medNumber = arc4random() % allMeds.count;
//    NSUInteger colorNumber = arc4random() % allColors.count;
//    NSUInteger dosageNumber = arc4random() % allPossibleDosages.count;
//
//    APCMedTrackerMedication *theMed = allMeds [medNumber];
//    APCMedTrackerScheduleColor *theColor = allColors [colorNumber];
//    APCMedTrackerPossibleDosage *theDosage = allPossibleDosages [dosageNumber];
//
//    [APCMedTrackerMedicationSchedule newScheduleWithMedication: theMed
//                                                        dosage: theDosage
//                                                         color: theColor
//                                                 daysOfTheWeek: daysOfTheWeek
//                                           numberOfTimesPerDay: timesPerDay
//                                               andUseThisQueue: someQueue
//                                              toDoThisWhenDone: ^(id createdObject,
//                                                                  NSTimeInterval operationDuration,
//                                                                  NSManagedObjectContext *context,
//                                                                  NSManagedObjectID *scheduleId)
//     {
//         APCMedTrackerMedicationSchedule *schedule = createdObject;
//         NSLog (@"Created a schedule!  Creation time = %f seconds.  Schedule = %@" , operationDuration, schedule);
//
//         [self okLetsPlayWithTheSchedule: schedule
//                         fromThisContext: context
//                              withThisId: scheduleId];
//
//         dispatch_semaphore_signal (semaphore);
//     }];
//
//    dispatch_semaphore_wait (semaphore, DISPATCH_TIME_FOREVER);
//    NSLog (@"That whole schedule-creation process has finally finished.  :-)");
}

//    - (void) testSampleFetchedResultsController
//    {
//        NSFetchedResultsController * controller = [[NSFetchedResultsController alloc] initWithFetchRequest: someRequest
//                                                                                      managedObjectContext: someContext
//                                                                                        sectionNameKeyPath: nil  /* path to the string for the "section names" */
//                                                                                                 cacheName: nil];
//        controller.delegate = <id>;
//
//        NSError *error = nil;
//        [controller performFetch: & error];
//
//        /*
//         then:
//         */
//         sectionCount = frc.sections.count;
//         id <nsfetchresltssectioninfo> sectionInfo = frc.sections [sectionNumbrer];
//         nsinteger rows = sectionInfo.numberOfObjects;
//
//        /* then, when table asks for indexpath: */
//        Person *person = [frc objectAtIndexPath: indexPath];
//
//        /* to filter:  add/remove predicate and sortDescxriptors to frc.fetchRequest, and then */
//        [frc performFetch: error];
//    }

- (void) testRetrieveAllEntitiesWithoutProvidingThem
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create (0);
    NSOperationQueue *someQueue = [NSOperationQueue sequentialOperationQueueWithName: @"Waiting for 'create' op to finish..."];

    [APCMedTrackerDataStorageManager startupAndThenUseThisQueue: someQueue toDoThis:
     ^{
         dispatch_semaphore_signal (semaphore);
     }];

    dispatch_semaphore_wait (semaphore, DISPATCH_TIME_FOREVER);


    semaphore = dispatch_semaphore_create (0);

     // Queue all this up using the StorageManager's queue, to be sure all its existing startup stuff has finished before I try to work.
     [APCMedTrackerDataStorageManager.defaultManager.queue addOperationWithBlock:
      ^{
          NSManagedObjectContext *localContext = APCMedTrackerDataStorageManager.defaultManager.context;

          // Simplest-possible requests
          NSFetchRequest  *scheduleRequest        = nil,
                          *medRequest             = nil,
                          *possibleDosageRequest  = nil,
                          *colorsRequest          = nil,
                          *doseHistoryRequest     = nil;

          NSArray *schedules          = nil,
                  *meds               = nil,
                  *possibleDosages    = nil,
                  *colors             = nil,
                  *doseHistory        = nil;

          NSError *scheduleRequestError       = nil,
                  *medRequestError            = nil,
                  *possibleDosageRequestError = nil,
                  *colorsRequestError         = nil,
                  *doseHistoryRequestError    = nil;

          scheduleRequest         = [NSFetchRequest fetchRequestWithEntityName: NSStringFromClass ([APCMedTrackerMedicationSchedule class])];
          medRequest              = [NSFetchRequest fetchRequestWithEntityName: NSStringFromClass ([APCMedTrackerMedication class])];
          possibleDosageRequest   = [NSFetchRequest fetchRequestWithEntityName: NSStringFromClass ([APCMedTrackerPossibleDosage class])];
          colorsRequest           = [NSFetchRequest fetchRequestWithEntityName: NSStringFromClass ([APCMedTrackerScheduleColor class])];
          doseHistoryRequest      = [NSFetchRequest fetchRequestWithEntityName: NSStringFromClass ([APCMedTrackerActualDosageTaken class])];

          schedules       = [localContext executeFetchRequest: scheduleRequest        error: &scheduleRequestError];
          meds            = [localContext executeFetchRequest: medRequest             error: &medRequestError];
          possibleDosages = [localContext executeFetchRequest: possibleDosageRequest  error: &possibleDosageRequestError];
          colors          = [localContext executeFetchRequest: colorsRequest          error: &colorsRequestError];
          doseHistory     = [localContext executeFetchRequest: doseHistoryRequest     error: &doseHistoryRequestError];

          NSLog (@"scheduleRequestError:  %@",        scheduleRequestError);
          NSLog (@"medRequestError:  %@",             medRequestError);
          NSLog (@"possibleDosageRequestError:  %@",  possibleDosageRequestError);
          NSLog (@"colorsRequestError:  %@",          colorsRequestError);
          NSLog (@"doseHistoryRequestError:  %@",     doseHistoryRequestError);

          NSLog (@"Schedules retrieved:\n----------\n%@\n----------",         schedules);
          NSLog (@"Meds retrieved:\n----------\n%@\n----------",              meds);
          NSLog (@"PossibleDosages retrieved:\n----------\n%@\n----------",   possibleDosages);
          NSLog (@"Colors retrieved:\n----------\n%@\n----------",            colors);
          NSLog (@"Dose History retrieved:\n----------\n%@\n----------",      doseHistory);

          dispatch_semaphore_signal (semaphore);
      }];

    dispatch_semaphore_wait (semaphore, DISPATCH_TIME_FOREVER);
    NSLog (@"Safely finished with test method.");
}

- (void) testGenerateAllStaticData
{
    NSLog (@"Loading predefined items from disk...");

    // This is all we need to do.  We'll see a printout when it succeeds.  I hope.
    [APCMedTrackerDataStorageManager defaultManager];

    [NSThread sleepForTimeInterval: 5];
}

/**
 Making sure this alphabetizes last.  Deletes all
 data from the device in question.  Maybe.  Not at all
 sure this is a good idea.  The issue is that the data
 is persisting across runs of my test cases.  Sometimes,
 that's wonderful; sometimes, it's in the way.
 */
- (void) testZZZZZZZ_deleteAllData
{
    // Create a context on the current thread, whatever it is.  (Happens to be the main thread.)
    NSManagedObjectContext *localContext = [[APCMedTrackerDataStorageManager defaultManager] newContextOnCurrentQueue];

    // Simplest-possible requests
    NSFetchRequest  *scheduleRequest        = nil,
                    *medRequest             = nil,
                    *possibleDosageRequest  = nil,
                    *colorsRequest          = nil,
                    *doseHistoryRequest     = nil;

    NSArray *schedules          = nil,
            *meds               = nil,
            *possibleDosages    = nil,
            *colors             = nil,
            *doseHistory        = nil;

    NSError *scheduleRequestError       = nil,
            *medRequestError            = nil,
            *possibleDosageRequestError = nil,
            *colorsRequestError         = nil,
            *doseHistoryRequestError    = nil;

    scheduleRequest         = [NSFetchRequest fetchRequestWithEntityName: NSStringFromClass ([APCMedTrackerMedicationSchedule class])];
    medRequest              = [NSFetchRequest fetchRequestWithEntityName: NSStringFromClass ([APCMedTrackerMedication class])];
    possibleDosageRequest   = [NSFetchRequest fetchRequestWithEntityName: NSStringFromClass ([APCMedTrackerPossibleDosage class])];
    colorsRequest           = [NSFetchRequest fetchRequestWithEntityName: NSStringFromClass ([APCMedTrackerScheduleColor class])];
    doseHistoryRequest      = [NSFetchRequest fetchRequestWithEntityName: NSStringFromClass ([APCMedTrackerActualDosageTaken class])];

    schedules       = [localContext executeFetchRequest: scheduleRequest error: &scheduleRequestError];
    meds            = [localContext executeFetchRequest: medRequest error: &medRequestError];
    possibleDosages = [localContext executeFetchRequest: possibleDosageRequest error: &possibleDosageRequestError];
    colors          = [localContext executeFetchRequest: colorsRequest error: &colorsRequestError];
    doseHistory     = [localContext executeFetchRequest: doseHistoryRequest error: &doseHistoryRequestError];


    NSLog (@"======== About to delete all objects.  Here's what we're going to delete: =======");

    NSLog (@"scheduleRequestError:  %@",        scheduleRequestError);
    NSLog (@"medRequestError:  %@",             medRequestError);
    NSLog (@"possibleDosageRequestError:  %@",  possibleDosageRequestError);
    NSLog (@"colorsRequestError:  %@",          colorsRequestError);
    NSLog (@"doseHistoryRequestError:  %@",     doseHistoryRequestError);

    NSLog (@"Schedules retrieved:\n----------\n%@\n----------",         schedules);
    NSLog (@"Meds retrieved:\n----------\n%@\n----------",              meds);
    NSLog (@"PossibleDosages retrieved:\n----------\n%@\n----------",   possibleDosages);
    NSLog (@"Colors retrieved:\n----------\n%@\n----------",            colors);
    NSLog (@"Dose History retrieved:\n----------\n%@\n----------",      doseHistory);


    NSMutableArray *stuffToDelete = [NSMutableArray new];
    [stuffToDelete addObjectsFromArray: schedules];
    [stuffToDelete addObjectsFromArray: meds];
    [stuffToDelete addObjectsFromArray: possibleDosages];
    [stuffToDelete addObjectsFromArray: colors];
    [stuffToDelete addObjectsFromArray: doseHistory];

    NSManagedObject *firstThingy = nil;

    for (id thingy in stuffToDelete)
    {
        if (firstThingy == nil)
        {
            firstThingy = thingy;
        }

        [localContext deleteObject: thingy];
    }

    // To use our save() method, I need a pointer to at least
    // one object.  (...or else I have to duplicate that whole
    // save() concept.  Not sure I'm ready to do that.)
    NSError *deletionError = nil;
    [firstThingy saveToPersistentStore: & deletionError];


    NSLog (@"======== All objects deleted.  Deletion error: =======");
    NSLog (@"%@", deletionError);


    NSLog (@"======== Re-running all queries to see what we missed: =======");

    schedules       = [localContext executeFetchRequest: scheduleRequest error: &scheduleRequestError];
    meds            = [localContext executeFetchRequest: medRequest error: &medRequestError];
    possibleDosages = [localContext executeFetchRequest: possibleDosageRequest error: &possibleDosageRequestError];
    colors          = [localContext executeFetchRequest: colorsRequest error: &colorsRequestError];
    doseHistory     = [localContext executeFetchRequest: doseHistoryRequest error: &doseHistoryRequestError];

    NSLog (@"scheduleRequestError:  %@",        scheduleRequestError);
    NSLog (@"medRequestError:  %@",             medRequestError);
    NSLog (@"possibleDosageRequestError:  %@",  possibleDosageRequestError);
    NSLog (@"colorsRequestError:  %@",          colorsRequestError);
    NSLog (@"doseHistoryRequestError:  %@",     doseHistoryRequestError);

    NSLog (@"Schedules retrieved:\n----------\n%@\n----------",         schedules);
    NSLog (@"Meds retrieved:\n----------\n%@\n----------",              meds);
    NSLog (@"PossibleDosages retrieved:\n----------\n%@\n----------",   possibleDosages);
    NSLog (@"Colors retrieved:\n----------\n%@\n----------",            colors);
    NSLog (@"Dose History retrieved:\n----------\n%@\n----------",      doseHistory);
}

@end










