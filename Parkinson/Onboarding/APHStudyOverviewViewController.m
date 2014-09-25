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

@end

@implementation APHStudyOverviewViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupTable
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kStudyOverviewCellIdentifier];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kStudyOverviewCellIdentifier forIndexPath:indexPath];
    
    cell.imageView.backgroundColor = [UIColor grayColor];
    cell.imageView.layer.cornerRadius = 3.0f;
    
    cell.textLabel.text = @"What is this study about?";
    
    return cell;
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

@end
