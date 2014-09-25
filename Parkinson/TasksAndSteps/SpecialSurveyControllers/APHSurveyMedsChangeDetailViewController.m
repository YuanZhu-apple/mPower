//
//  APHSurveyMedsChangeDetailViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 9/25/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHSurveyMedsChangeDetailViewController.h"
#import "APHSurveyMedsChangeDetailTableViewCell.h"

static  NSString  *kPHMedsChangeMasterTableViewCellIdentifer = @"APHSurveyMedsChangeDetailTableViewCell";

@interface APHSurveyMedsChangeDetailViewController ()

@property  (nonatomic, weak)  IBOutlet  UITableView  *tabulator;

@end

@implementation APHSurveyMedsChangeDetailViewController

#pragma  mark  -  Table View Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  1;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return  [APHSurveyMedsChangeDetailTableViewCell cellHeight];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    APHSurveyMedsChangeDetailTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:kPHMedsChangeMasterTableViewCellIdentifer];
    
    return  cell;
}

#pragma  mark  -  View Controller Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
