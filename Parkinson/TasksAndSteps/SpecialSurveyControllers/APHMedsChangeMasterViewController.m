//
//  APHMedsChangeMasterViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 9/24/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHMedsChangeMasterViewController.h"
#import "APHMedsChangeMasterTableViewCell.h"

static  NSString  *kPHMedsChangeMasterTableViewCellIdentifer = @"APHMedsChangeMasterTableViewCell";

@interface APHMedsChangeMasterViewController  ( )  <UITableViewDataSource, UITableViewDelegate>

@property  (nonatomic, weak)  IBOutlet  UITableView  *tabulator;

@end

@implementation APHMedsChangeMasterViewController

#pragma  mark  -  Table View Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  [APHMedsChangeMasterTableViewCell cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    APHMedsChangeMasterTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:kPHMedsChangeMasterTableViewCellIdentifer];
    
    return  cell;
}

#pragma  mark  -  View Controller Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tabulator registerNib:[UINib nibWithNibName:@"APHMedsChangeMasterTableViewCell"
                                               bundle:[NSBundle mainBundle]] forCellReuseIdentifier:(NSString *)kPHMedsChangeMasterTableViewCellIdentifer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
