//
//  APHWalkingStepsViewController.h
//  Parkinson's
//
//  Copyright (c) 2014 <INSTITUTION-NAME-TBD>. All rights reserved.
//

#import <UIKit/UIKit.h>
@import APCAppCore;

typedef  enum  _WalkingStepsPhase
{
    WalkingStepsPhaseWalkSomeDistance,
    WalkingStepsPhaseWalkBackToBase,
    WalkingStepsPhaseStandStill
}  WalkingStepsPhase;

@interface APHWalkingStepsViewController : RKSTStepViewController

@property  (nonatomic, assign)  WalkingStepsPhase   walkingPhase;

@end
