//
//  APHActivitiesWalkingTask.m
//  Parkinson
//
//  Created by Henry McGilton on 8/29/14.
//  Copyright (c) 2014 Henry McGilton. All rights reserved.
//

#import "APHActivitiesWalkingTask.h"

@implementation APHActivitiesWalkingTask

- (NSString *)identifier
{
    return  super.identifier;
}

- (NSString *)name
{
    return  super.name;
}

- (RKStep *)stepBeforeStep:(RKStep *)step withSurveyResults:(NSDictionary *)surveyResults
{
    RKStep  *previousStep = nil;
    
    if (step != nil) {
        if ([[self.steps firstObject] isEqual:step] == NO) {
            NSUInteger  index = [self.steps indexOfObject:step];
            previousStep = [self.steps objectAtIndex:(index - 1)];
        }
    }
    return  previousStep;
}

- (RKStep *)stepAfterStep:(RKStep *)step withSurveyResults:(NSDictionary *)surveyResults
{
    RKStep  *nextStep = nil;
    
    NSLog(@"stepAfterStep number of steps = %d", [self.steps count]);
    
    if (step == nil) {
        nextStep = [self.steps firstObject];
    } else {
        NSUInteger  index = [self.steps indexOfObject:step];
        if (index == 0) {
            nextStep = [self.steps objectAtIndex:(index + 1)];
        } else if (index == 1) {
            nextStep = [self.steps objectAtIndex:(index + 1)];
        } else if (index == 2) {
            nextStep = [self.steps objectAtIndex:(index + 1)];
        } else if (index == 3) {
            nextStep = [self.steps objectAtIndex:(index + 1)];
        }
    }
    NSLog(@"stepAfterStep step = %@, returned step = %@", step, nextStep);
    return  nextStep;
}

@end
