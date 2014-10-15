//
//  APHInclusionCriteriaViewController.m
//  Parkinson
//
//  Created by Ramsundar Shandilya on 9/25/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHInclusionCriteriaViewController.h"
#import "APHSignUpGeneralInfoViewController.h"

@interface APHInclusionCriteriaViewController ()
@property (weak, nonatomic) IBOutlet UILabel *question1Label;
@property (weak, nonatomic) IBOutlet UILabel *question2Label;
@property (weak, nonatomic) IBOutlet UILabel *question3Label;
@property (weak, nonatomic) IBOutlet UILabel *question4Label;

@property (weak, nonatomic) IBOutlet UIButton *question1Option1;
@property (weak, nonatomic) IBOutlet UIButton *question1Option2;

@property (weak, nonatomic) IBOutlet UIButton *question2Option1;
@property (weak, nonatomic) IBOutlet UIButton *question2Option2;
@property (weak, nonatomic) IBOutlet UIButton *question2Option3;

@property (weak, nonatomic) IBOutlet UIButton *question4Option1;
@property (weak, nonatomic) IBOutlet UIButton *question4Option2;
@property (weak, nonatomic) IBOutlet UIButton *question4Option3;


@property (nonatomic, strong) NSArray * questions; //Of APCSegmentedButtons

@end

@implementation APHInclusionCriteriaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.questions = @[
                       [[APCSegmentedButton alloc] initWithButtons:@[self.question1Option1, self.question1Option2] normalColor:[UIColor appSecondaryColor3] highlightColor:[UIColor appPrimaryColor]],
                       [[APCSegmentedButton alloc] initWithButtons:@[self.question2Option1, self.question2Option2, self.question2Option3] normalColor:[UIColor appSecondaryColor3] highlightColor:[UIColor appPrimaryColor]],
                       [[APCSegmentedButton alloc] initWithButtons:@[self.question4Option1, self.question4Option2, self.question4Option3] normalColor:[UIColor appSecondaryColor3] highlightColor:[UIColor appPrimaryColor]]
                       ];
    [self setUpAppearance];
}

- (void) setUpAppearance
{
    self.question1Label.textColor = [UIColor appSecondaryColor1];
    self.question2Label.textColor = [UIColor appSecondaryColor1];
    self.question3Label.textColor = [UIColor appSecondaryColor1];
    self.question4Label.textColor = [UIColor appSecondaryColor1];
    
    
    self.question2Option3.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.question2Option3.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.question2Option3 setTitle:@"Not\nSure" forState:UIControlStateNormal];
}

- (void)startSignUp
{
    [self.navigationController pushViewController:[APHSignUpGeneralInfoViewController new] animated:YES];
}

/*********************************************************************************/
#pragma mark - Misc Fix
/*********************************************************************************/
-(void)viewDidLayoutSubviews
{
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
}

@end
