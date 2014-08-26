//
//  APHWalkingStepsViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 8/20/14.
//  Copyright (c) 2014 Henry McGilton. All rights reserved.
//

#import "APHWalkingStepsViewController.h"
#import "APHWalkingResultsViewController.h"

typedef  enum  _WalkingStepsPhase
{
    WalkingStepsPhaseWalkSomeDistance,
    WalkingStepsPhaseWalkBackToBase,
    WalkingStepsPhaseStandStill
}  WalkingStepsPhase;

@interface APHWalkingStepsViewController ()

@property  (nonatomic, assign)  WalkingStepsPhase   walkingPhase;
@property  (nonatomic, strong)  IBOutlet  UIView   *phaseEgressView;
@property  (nonatomic, strong)  IBOutlet  UIView   *phaseIngressView;
@property  (nonatomic, strong)  IBOutlet  UIView   *phaseStandingView;

@end

@implementation APHWalkingStepsViewController

- (IBAction)switchPhaseDisplay:(id)sender
{
    NSInteger  selected = [sender selectedSegmentIndex];
    
    if (selected == 0) {
        [self switchToWalkingPhaseView:WalkingStepsPhaseWalkSomeDistance];
    } else if (selected == 1) {
        [self switchToWalkingPhaseView:WalkingStepsPhaseWalkBackToBase];
    } else if (selected == 2) {
        [self switchToWalkingPhaseView:WalkingStepsPhaseStandStill];
    } else if (selected == 3) {
        APHWalkingResultsViewController  *controller = [[APHWalkingResultsViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma  mark  -  Helper Methods

- (void)switchToWalkingPhaseView:(WalkingStepsPhase)phase
{
    if (phase == WalkingStepsPhaseWalkSomeDistance) {
        self.phaseIngressView.hidden = YES;
        self.phaseEgressView.hidden = NO;
        self.phaseStandingView.hidden = YES;
    } else if (phase == WalkingStepsPhaseWalkBackToBase) {
        self.phaseIngressView.hidden = NO;
        self.phaseEgressView.hidden = YES;
        self.phaseStandingView.hidden = YES;
    } else if (phase == WalkingStepsPhaseStandStill) {
        self.phaseIngressView.hidden = YES;
        self.phaseEgressView.hidden = YES;
        self.phaseStandingView.hidden = NO;
    }
    self.walkingPhase = phase;
}

#pragma  mark  -  View Controller Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self switchToWalkingPhaseView:WalkingStepsPhaseWalkSomeDistance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
