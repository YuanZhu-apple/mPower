//
//  APHStudyOverviewViewController.m
//  Parkinson
//
//  Created by Ramsundar Shandilya on 9/25/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHStudyOverviewViewController.h"
#import "APHSignInViewController.h"
#import "APHSignUpGeneralInfoViewController.h"
#import "APHInclusionCriteriaViewController.h"

static NSString * const kStudyOverviewCellIdentifier = @"kStudyOverviewCellIdentifier";

@interface APHStudyOverviewViewController ()

@property (nonatomic, strong) NSArray *studyDetailsArray;

@end

@implementation APHStudyOverviewViewController

- (void)prepareContent
{
    _studyDetailsArray = [self studyDetailsFromJSONFile:@"StudyOverview"];
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareContent];
    self.diseaseNameLabel.text = self.diseaseName;
    self.logoImageView.image = [UIImage imageNamed:@"logo_research_institute"];
    [self setUpAppearance];
    [self setupTable];
}

- (void)setUpAppearance
{
    //Headerview
    self.headerView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.headerView.layer.shadowOffset = CGSizeMake(0, 1);
    self.headerView.layer.shadowOpacity = 0.6;
    self.headerView.layer.shadowRadius = 0.5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupTable
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.studyDetailsArray.count;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kStudyOverviewCellIdentifier forIndexPath:indexPath];
    
    APCStudyDetails *studyDetails = self.studyDetailsArray[indexPath.row];
    UILabel * label = (UILabel*) [cell viewWithTag:300];
    label.text = studyDetails.title;
    
    [self setUpCellAppearance:cell];
    return cell;
}

- (void) setUpCellAppearance: (UITableViewCell*) cell
{
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
}

#pragma mark - IBActions

- (void)signInTapped:(id)sender
{
    APCSignInViewController *signInViewController = [[APHSignInViewController alloc] initWithNibName:@"APCSignInViewController" bundle:[NSBundle appleCoreBundle]];
    [self.navigationController pushViewController:signInViewController animated:YES];
}

- (void)signUpTapped:(id)sender
{
    [self.navigationController pushViewController:[APHInclusionCriteriaViewController new] animated:YES];
}

-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
