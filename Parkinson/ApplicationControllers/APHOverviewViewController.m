//
//  APHOverviewViewController.m
//  BasicTabBar
//
//  Created by Henry McGilton on 9/7/14.
//  Copyright (c) 2014 Trilithon Software. All rights reserved.
//

#import "APHOverviewViewController.h"

@interface APHOverviewViewController ()  <UITableViewDataSource, UITableViewDelegate>

@property  (nonatomic, weak)  IBOutlet  UITableView  *tabulator;

@end

@implementation APHOverviewViewController

#pragma  mark  -  Table View Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString  *identifier = @"PlaceHolder";
    
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = @"Place Holder";
    
    return  cell;
}

#pragma  mark  -  Table View Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
