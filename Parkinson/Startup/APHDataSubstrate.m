//
//  APHDataSubstrate.m
//  Parkinson's
//
//  Copyright (c) 2014 <INSTITUTION-NAME-TBD>. All rights reserved.
//

#import "APHDataSubstrate.h"

static NSTimeInterval LOCATION_COLLECTION_INTERVAL = 5 * 60.0 * 60.0;

@implementation APHDataSubstrate

-(void)setUpCollectors
{
    //if (self.currentUser.isConsented) {
        NSError *error = nil;
        {
            HKQuantityType *quantityType = (HKQuantityType*)[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
            RKSTHealthCollector *healthCollector = [self.study addHealthCollectorWithSampleType:quantityType unit:[HKUnit countUnit] startDate:nil error:&error];
            if (!healthCollector)
            {
                NSLog(@"Error creating health collector: %@", error);
                [self.studyStore removeStudy:self.study error:nil];
                goto errReturn;
            }
            
            HKQuantityType *quantityType2 = (HKQuantityType*)[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodGlucose];
            HKUnit *unit = [HKUnit unitFromString:@"mg/dL"];
            RKSTHealthCollector *glucoseCollector = [self.study addHealthCollectorWithSampleType:quantityType2 unit:unit startDate:nil error:&error];
            
            if (!glucoseCollector)
            {
                NSLog(@"Error creating glucose collector: %@", error);
                [self.studyStore removeStudy:self.study error:nil];
                goto errReturn;
            }
            
            HKCorrelationType *bpType = (HKCorrelationType *)[HKCorrelationType correlationTypeForIdentifier:HKCorrelationTypeIdentifierBloodPressure];
            RKSTHealthCorrelationCollector *bpCollector = [self.study addHealthCorrelationCollectorWithCorrelationType:bpType sampleTypes:@[[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureDiastolic], [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureSystolic]] units:@[[HKUnit unitFromString:@"mmHg"], [HKUnit unitFromString:@"mmHg"]] startDate:nil error:&error];
            if (!bpCollector)
            {
                NSLog(@"Error creating BP collector: %@", error);
                [self.studyStore removeStudy:self.study error:nil];
                goto errReturn;
            }
            
            RKSTMotionActivityCollector *motionCollector = [self.study addMotionActivityCollectorWithStartDate:nil error:&error];
            if (!motionCollector)
            {
                NSLog(@"Error creating motion collector: %@", error);
                [self.studyStore removeStudy:self.study error:nil];
                goto errReturn;
            }
            
            //Set Up Passive Location Collection
            self.passiveLocationTracking = [[APCPassiveLocationTracking alloc] initWithTimeInterval:LOCATION_COLLECTION_INTERVAL];
            [self.passiveLocationTracking start];
        }
        
    errReturn:
        return;
   // }

}

@end
