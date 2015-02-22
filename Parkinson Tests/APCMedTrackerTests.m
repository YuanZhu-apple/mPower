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


/*
 Throughout this file are calls to dispatch_semaphore_XXXX (),
 which effectively force certain methods to be syncronous.
 That is only for this test-case file, because, otherswise,
 the test harness will exit before the asynch operation in
 question actually finishes.  In real life, though, please
 design your stuff to work with and expect asynch calls:
 put something on the screen, fire off one of these requests,
 and let the user do whatever she wants until the results
 come back (which will usually be a small fraction of a second
 later, but, still).
 */


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



// ---------------------------------------------------------
#pragma mark - Create a Schedule based on existing entites
// ---------------------------------------------------------

- (void) testCreateOneSchedule
{
    NSOperationQueue *someQueue = [NSOperationQueue sequentialOperationQueueWithName: @"Waiting for 'create' op to finish..."];


    // Pick one:
    // BOOL shouldReloadPlistFiles = YES;
    BOOL shouldReloadPlistFiles = NO;

    dispatch_semaphore_t semaphore = dispatch_semaphore_create (0);

    [APCMedTrackerDataStorageManager startupReloadingDefaults: shouldReloadPlistFiles
                                          andThenUseThisQueue: someQueue
                                                     toDoThis: ^{
         dispatch_semaphore_signal (semaphore);
     }];

    dispatch_semaphore_wait (semaphore, DISPATCH_TIME_FOREVER);


    NSArray *__block allMeds = nil;
    NSArray *__block allPossibleDosages = nil;
    NSArray *__block allColors = nil;


    /*
     NOTE:  in real life, for each of the calls below,
     we have to handle the possible errors.  There are
     three types of error situations:
     
     if (returnedResults == nil)
     {
        // by definition:  an error occurred.  What type?

        if (error == nil)
        {
            // Error, but no error message.
        }
        else
        {
            // Error + error message.
        }
     }
     else if (returnedResults.count == 0)
     {
        // no results, but no known error.  This could
        // be good or bad, depending on the situation.
     }
     else
     {
        // got real stuff
     }

     */


    semaphore = dispatch_semaphore_create (0);

    [APCMedTrackerMedication fetchAllFromCoreDataAndUseThisQueue: someQueue
                                                toDoThisWhenDone: ^(NSArray *arrayOfGeneratedObjects,
                                                                    NSTimeInterval operationDuration,
                                                                    NSError *error)
     {
         allMeds = arrayOfGeneratedObjects;
         dispatch_semaphore_signal (semaphore);
     }];

    dispatch_semaphore_wait (semaphore, DISPATCH_TIME_FOREVER);
    semaphore = dispatch_semaphore_create (0);

    [APCMedTrackerPossibleDosage fetchAllFromCoreDataAndUseThisQueue: someQueue
                                                    toDoThisWhenDone: ^(NSArray *arrayOfGeneratedObjects,
                                                                        NSTimeInterval operationDuration,
                                                                        NSError *error)
     {
         allPossibleDosages = arrayOfGeneratedObjects;
         dispatch_semaphore_signal (semaphore);
     }];

    dispatch_semaphore_wait (semaphore, DISPATCH_TIME_FOREVER);
    semaphore = dispatch_semaphore_create (0);

    [APCMedTrackerScheduleColor fetchAllFromCoreDataAndUseThisQueue: someQueue
                                                   toDoThisWhenDone: ^(NSArray *arrayOfGeneratedObjects,
                                                                       NSTimeInterval operationDuration,
                                                                       NSError *error)
     {
         allColors = arrayOfGeneratedObjects;
         dispatch_semaphore_signal (semaphore);
     }];

    dispatch_semaphore_wait (semaphore, DISPATCH_TIME_FOREVER);
    semaphore = dispatch_semaphore_create (0);


    /*
     We still have access to the data because they come from
     a Context object that the DefaultManager keeps around.
     This also means that if we wanna connect these objects
     together, we have to do so on the defaultManager's queue.
     */

    NSLog (@"Got all meds, dosages, and colors:\n%@\n%@\n%@", allMeds, allPossibleDosages, allColors);

    NSUInteger medNumber        = arc4random() % allMeds.count;
    NSUInteger colorNumber      = arc4random() % allColors.count;
    NSUInteger dosageNumber     = arc4random() % allPossibleDosages.count;

    APCMedTrackerMedication *theMed             = allMeds [medNumber];
    APCMedTrackerScheduleColor *theColor        = allColors [colorNumber];
    APCMedTrackerPossibleDosage *theDosage      = allPossibleDosages [dosageNumber];
    NSArray *effectivelyRandomListOfDaysToUse   = @[ @1, @4 ];
    NSNumber *timesPerDay                       = @3;
    NSArray *dayNamesInWeek                     = @[ @"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday"];

    /*
     Conceptually, we're doing this:
     NSArray    *daysOfTheWeek   = @[ @"Monday", @"Thursday" ];
     NSNumber   *timesPerDay     = @(3);

     ...but the GUI currently expects to send and receive this:
        @{ @"Sunday"  : @(0),
           @"Monday"  : @(3),
           @"Tuesday" : @(0),
           
            ...etc.
        }
     
     So let's create that dictionary.
     */
    NSMutableDictionary *requiredInputArrayForFrequencyAndDays = [NSMutableDictionary new];

    for (NSInteger dayIndex = 0; dayIndex < dayNamesInWeek.count; dayIndex ++)
    {
        NSNumber *valueToUse = @0;

        if ([effectivelyRandomListOfDaysToUse containsObject: @(dayIndex)])
        {
            valueToUse = timesPerDay;
        }

        NSString *dayName = dayNamesInWeek [dayIndex];
            requiredInputArrayForFrequencyAndDays [dayName] = valueToUse;
    }

    [APCMedTrackerMedicationSchedule newScheduleWithMedication: theMed
                                                        dosage: theDosage
                                                         color: theColor
                                              frequencyAndDays: requiredInputArrayForFrequencyAndDays
                                               andUseThisQueue: someQueue
                                              toDoThisWhenDone: ^(id createdObject,
                                                                  NSTimeInterval operationDuration)
     {
         APCMedTrackerMedicationSchedule *schedule = createdObject;
         NSLog (@"Created a schedule!  Creation time = %f seconds.  Schedule = %@" , operationDuration, schedule);


         //
         // The following calls represent the data the MedTracker
         // view needs to extract from a Schedule.  (I think.
         // Evolving.)
         //

         NSLog (@"The schedule's own .description: %@", schedule);

         NSLog (@"Specific schedule data:");
         NSLog (@"  -  meds: %@", schedule.medicine.name);
         NSLog (@"  -  dosage: %@", schedule.dosage.name);
         NSLog (@"  -  timesPerDay: %@", schedule.numberOfTimesPerDay);
         NSLog (@"  -  days of the week: %@", schedule.zeroBasedDaysOfTheWeek);
         NSLog (@"  -  color: (%@)    rgba: (%@,%@,%@,%@)    UIColor: (%@)",
                schedule.color.name,
                schedule.color.redAsInteger,
                schedule.color.greenAsInteger,
                schedule.color.blueAsInteger,
                schedule.color.alphaAsFloat,
                schedule.color.UIColor);

         NSLog (@"  -  created on: %@", schedule.dateStartedUsing);
         NSLog (@"  -  has been saved to disk: %@", schedule.objectID.isTemporaryID ? @"NO" : @"YES");

         dispatch_semaphore_signal (semaphore);
     }];

    dispatch_semaphore_wait (semaphore, DISPATCH_TIME_FOREVER);
    NSLog (@"That whole schedule-creation process has finally finished.  :-)  And this should be the last print statement.  Did it work?");
}


/*
 Please don't delete this.  This method is in progress.
 */
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



// ---------------------------------------------------------
#pragma mark - Load All Entities
// ---------------------------------------------------------

- (void) testRetrieveAllEntitiesAfterLoadingThemFromPlistFiles
{
    [self retrieveAllEntitiesLoadingThemFromDiskFirst: YES];
}

- (void) testRetrieveAllEntitiesWithoutLoadingThemExplicitly
{
    [self retrieveAllEntitiesLoadingThemFromDiskFirst: NO];
}

- (void) retrieveAllEntitiesLoadingThemFromDiskFirst: (BOOL) shouldReloadPlistFiles
{
    NSOperationQueue *someQueue = [NSOperationQueue sequentialOperationQueueWithName: @"Waiting for 'create' op to finish..."];

    dispatch_semaphore_t semaphore = dispatch_semaphore_create (0);

    [APCMedTrackerDataStorageManager startupReloadingDefaults: shouldReloadPlistFiles
                                          andThenUseThisQueue: someQueue
                                                     toDoThis: ^{
         dispatch_semaphore_signal (semaphore);
     }];

    dispatch_semaphore_wait (semaphore, DISPATCH_TIME_FOREVER);


    semaphore = dispatch_semaphore_create (0);

     // Queue all this up using the StorageManager's queue, to be sure all its existing startup stuff has finished before I try to work.
     [APCMedTrackerDataStorageManager.defaultManager.queue addOperationWithBlock:
      ^{
          NSManagedObjectContext *localContext = APCMedTrackerDataStorageManager.defaultManager.context;

          // Simplest-possible requests
          NSError *scheduleRequestError       = nil;
          NSError *medRequestError            = nil;
          NSError *possibleDosageRequestError = nil;
          NSError *colorsRequestError         = nil;
          NSError *doseHistoryRequestError    = nil;

          NSFetchRequest *scheduleRequest       = [NSFetchRequest fetchRequestWithEntityName: NSStringFromClass ([APCMedTrackerMedicationSchedule class])];
          NSFetchRequest *medRequest            = [NSFetchRequest fetchRequestWithEntityName: NSStringFromClass ([APCMedTrackerMedication class])];
          NSFetchRequest *possibleDosageRequest = [NSFetchRequest fetchRequestWithEntityName: NSStringFromClass ([APCMedTrackerPossibleDosage class])];
          NSFetchRequest *colorsRequest         = [NSFetchRequest fetchRequestWithEntityName: NSStringFromClass ([APCMedTrackerScheduleColor class])];
          NSFetchRequest *doseHistoryRequest    = [NSFetchRequest fetchRequestWithEntityName: NSStringFromClass ([APCMedTrackerActualDosageTaken class])];

          NSArray *schedules       = [localContext executeFetchRequest: scheduleRequest        error: &scheduleRequestError];
          NSArray *meds            = [localContext executeFetchRequest: medRequest             error: &medRequestError];
          NSArray *possibleDosages = [localContext executeFetchRequest: possibleDosageRequest  error: &possibleDosageRequestError];
          NSArray *colors          = [localContext executeFetchRequest: colorsRequest          error: &colorsRequestError];
          NSArray *doseHistory     = [localContext executeFetchRequest: doseHistoryRequest     error: &doseHistoryRequestError];

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
    NSLog (@"'Fetch All' complete...  and this should be the last printout from the test case.  Did it work?");
}

- (void) testFetchAllExistingSchedulesUsingFetchAllMethod
{
    NSOperationQueue *someQueue = [NSOperationQueue sequentialOperationQueueWithName: @"Waiting for 'create' op to finish..."];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create (0);

    [APCMedTrackerDataStorageManager startupReloadingDefaults: YES
                                          andThenUseThisQueue: someQueue
                                                     toDoThis: ^{
                                                         dispatch_semaphore_signal (semaphore);
                                                     }];

    dispatch_semaphore_wait (semaphore, DISPATCH_TIME_FOREVER);
    semaphore = dispatch_semaphore_create (0);

    [APCMedTrackerMedicationSchedule fetchAllFromCoreDataAndUseThisQueue: someQueue
                                                        toDoThisWhenDone: ^(NSArray *arrayOfGeneratedObjects,
                                                                            NSTimeInterval operationDuration,
                                                                            NSError *error)
     {
         NSLog (@"Fetched all schedules.  Result: %@", arrayOfGeneratedObjects);

         NSLog (@"The 'frequencyAndDays' dictionary for each schedule is:");

         for (APCMedTrackerMedicationSchedule *schedule in arrayOfGeneratedObjects)
         {
             NSLog (@"    %@", schedule.frequencyAndDays);
         }

         dispatch_semaphore_signal (semaphore);
     }];

    dispatch_semaphore_wait (semaphore, DISPATCH_TIME_FOREVER);
    NSLog (@"'Fetch All' complete...  and this should be the last printout from the test case.  Did it work?");
}



// ---------------------------------------------------------
#pragma mark - Delete All Entities
// ---------------------------------------------------------

/**
 Deletes all data from the current device.  I'm not
 at all sure this is a good idea.
 
 The issue: the data is persisting across runs of my
 test cases.  Sometimes, that's wonderful; sometimes,
 it's in the way.
 
 I named this to make sure it alphabetizes last.
 
 Also, if you edit the Parkinson Tests "Scheme" in Xcode,
 you'll see I removed this from the list of tests to run
 automatically.  You can still click it's "play" button
 here.
 */
- (void) testZZZZZZZ_deleteAllData
{
    NSOperationQueue *someQueue = [NSOperationQueue sequentialOperationQueueWithName: @"Deleting all data..."];

    dispatch_semaphore_t semaphore = dispatch_semaphore_create (0);

    [APCMedTrackerDataStorageManager startupReloadingDefaults: NO
                                          andThenUseThisQueue: someQueue
                                                     toDoThis: ^{

                                                         [self deleteEverything];

                                                         dispatch_semaphore_signal (semaphore);
                                                     }];
    
    dispatch_semaphore_wait (semaphore, DISPATCH_TIME_FOREVER);

    NSLog (@"All data should be deleted.  And this should be the last print statement in the test case.  Did it work?");
}

- (void) deleteEverything
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create (0);

    [APCMedTrackerDataStorageManager.defaultManager.queue addOperationWithBlock: ^{

        NSManagedObjectContext *context = APCMedTrackerDataStorageManager.defaultManager.context;

        NSError *scheduleRequestError       = nil;
        NSError *medRequestError            = nil;
        NSError *possibleDosageRequestError = nil;
        NSError *colorsRequestError         = nil;
        NSError *doseHistoryRequestError    = nil;

        NSFetchRequest *scheduleRequest         = [NSFetchRequest fetchRequestWithEntityName: NSStringFromClass ([APCMedTrackerMedicationSchedule class])];
        NSFetchRequest *medRequest              = [NSFetchRequest fetchRequestWithEntityName: NSStringFromClass ([APCMedTrackerMedication class])];
        NSFetchRequest *possibleDosageRequest   = [NSFetchRequest fetchRequestWithEntityName: NSStringFromClass ([APCMedTrackerPossibleDosage class])];
        NSFetchRequest *colorsRequest           = [NSFetchRequest fetchRequestWithEntityName: NSStringFromClass ([APCMedTrackerScheduleColor class])];
        NSFetchRequest *doseHistoryRequest      = [NSFetchRequest fetchRequestWithEntityName: NSStringFromClass ([APCMedTrackerActualDosageTaken class])];

        NSArray *schedules       = [context executeFetchRequest: scheduleRequest error: &scheduleRequestError];
        NSArray *meds            = [context executeFetchRequest: medRequest error: &medRequestError];
        NSArray *possibleDosages = [context executeFetchRequest: possibleDosageRequest error: &possibleDosageRequestError];
        NSArray *colors          = [context executeFetchRequest: colorsRequest error: &colorsRequestError];
        NSArray *doseHistory     = [context executeFetchRequest: doseHistoryRequest error: &doseHistoryRequestError];


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

            [context deleteObject: thingy];
        }

        // To use our save() method, I need a pointer to at least
        // one object.  (...or else I have to duplicate that whole
        // save() concept.  Not sure I'm ready to do that.)
        NSError *deletionError = nil;
        [firstThingy saveToPersistentStore: & deletionError];


        NSLog (@"======== All objects deleted.  Deletion error: =======");
        NSLog (@"%@", deletionError);


        NSLog (@"======== Re-running all queries to see what we missed: =======");

        schedules       = [context executeFetchRequest: scheduleRequest error: &scheduleRequestError];
        meds            = [context executeFetchRequest: medRequest error: &medRequestError];
        possibleDosages = [context executeFetchRequest: possibleDosageRequest error: &possibleDosageRequestError];
        colors          = [context executeFetchRequest: colorsRequest error: &colorsRequestError];
        doseHistory     = [context executeFetchRequest: doseHistoryRequest error: &doseHistoryRequestError];

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
}

@end










