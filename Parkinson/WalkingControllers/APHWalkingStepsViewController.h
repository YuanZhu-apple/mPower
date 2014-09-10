//
//  APHWalkingStepsViewController.h
//  Parkinson
//
//  Created by Henry McGilton on 8/20/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ResearchKit/ResearchKit.h>

typedef  enum  _WalkingStepsPhase
{
    WalkingStepsPhaseWalkSomeDistance,
    WalkingStepsPhaseWalkBackToBase,
    WalkingStepsPhaseStandStill
}  WalkingStepsPhase;

@interface APHWalkingStepsViewController : RKStepViewController

@property  (nonatomic, assign)  WalkingStepsPhase   walkingPhase;

@end
