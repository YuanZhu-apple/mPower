//
//  APHFitnessTestSummaryViewController.m
//  CardioHealth
//
//  Created by Justin Warmkessel on 10/21/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHCommonTaskSummaryViewController.h"
//@import APCAppleCore;

static NSString *ActivityCell = @"ActivityProgressCell";
static NSString *HeartAgeCell = @"HeartAgeCell";
static NSString *InformationCell = @"InformationCell";

//static CGFloat kProgressBarHeight = 10.0;

@interface APHCommonTaskSummaryViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;


@property (weak, nonatomic) IBOutlet UIView *circularProgressBar;

@property (nonatomic, strong) APCCircularProgressView *circularProgress;
//@property (nonatomic, strong) APCStepProgressBar *progressBar;
@end

@implementation APHCommonTaskSummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //If iPhone plus then make the phone larger. Constraints have aspect ratio set.
    NSArray *labelArray = @[self.label1, self.label2, self.label3, self.label4, self.label5];
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(nativeScale)]){
        if ([UIScreen mainScreen].nativeScale > 2.1) { // Nativescale is always 3 for iPhone 6 Plus, even when running in scaled mode
            for (UILabel *label in labelArray) {
                [label setFont:[UIFont systemFontOfSize:20]];
            }
            
        } else if ([UIScreen mainScreen].nativeScale == 2.1) {
            
        }
    }
    
    UIColor *viewBackgroundColor = [UIColor appSecondaryColor4];
    self.label1.textColor = [UIColor appSecondaryColor3];
    [self.view setBackgroundColor:viewBackgroundColor];
    self.navigationItem.title = NSLocalizedString(@"Survey Complete", @"Survey Complete");
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    
    self.circularProgress = [[APCCircularProgressView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.circularProgressBar.frame), CGRectGetHeight(self.circularProgressBar.frame))];
    self.circularProgress.hidesProgressValue = YES;
    NSUInteger allScheduledTasks = ((APCAppDelegate *)[UIApplication sharedApplication].delegate).dataSubstrate.allScheduledTasksForToday;
    NSUInteger completedScheduledTasks = ((APCAppDelegate *)[UIApplication sharedApplication].delegate).dataSubstrate.completedScheduledTasksForToday;
    completedScheduledTasks = MIN(allScheduledTasks, completedScheduledTasks+1);
    CGFloat percent = (CGFloat) completedScheduledTasks / (CGFloat) allScheduledTasks;
    [self.circularProgress setProgress:percent];
    self.circularProgress.tintColor = [UIColor appTertiaryColor1];
    [self.circularProgressBar addSubview:self.circularProgress];
    
    self.label3.text = [NSString stringWithFormat:@"%lu/%lu", completedScheduledTasks, allScheduledTasks];

}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    CGRect rect = CGRectMake(0, 0, CGRectGetWidth(self.circularProgressBar.frame), CGRectGetHeight(self.circularProgressBar.frame));
    [self.circularProgress setFrame:rect];
    
//    CGRect progressBarRect = CGRectMake(0, 0, self.view.frame.size.width, kProgressBarHeight);
//    [self.progressBar setFrame:progressBarRect];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                           target:self
                                                                                           action:@selector(doneButtonTapped:)];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

//    [self.progressBar setCompletedSteps:6 animation:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)doneButtonTapped:(UIBarButtonItem *)sender
{
    if (self.delegate != nil) {
        if ([self.delegate respondsToSelector:@selector(stepViewControllerDidFinish:navigationDirection:)] == YES) {
            [self.delegate stepViewControllerDidFinish:self navigationDirection:RKStepViewControllerNavigationDirectionForward];
        }
    }
}



@end
