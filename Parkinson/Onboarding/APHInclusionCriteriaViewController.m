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


@property (nonatomic, strong) APCSegmentedButton * question1;

@end

@implementation APHInclusionCriteriaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.question1 = [[APCSegmentedButton alloc] initWithButtons:@[self.question1Option1, self.question1Option2] normalColor:[UIColor appSecondaryColor3] highlightColor:[UIColor appPrimaryColor]];
    [self setUpAppearance];
}

- (void) setUpAppearance
{
//    [self.question1Option1 setTitleColor:[UIColor appSecondaryColor3] forState:UIControlStateNormal];
//    [self.question1Option2 setTitleColor:[UIColor appSecondaryColor3] forState:UIControlStateNormal];
//    
//    [self.question1Option1 setTitleColor:[UIColor appPrimaryColor] forState:UIControlStateHighlighted];
//    [self.question1Option2 setTitleColor:[UIColor appPrimaryColor] forState:UIControlStateHighlighted];
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
