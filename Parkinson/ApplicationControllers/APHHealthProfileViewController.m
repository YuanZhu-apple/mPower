//
//  APHHealthProfileViewController.m
//  BasicTabBar
//
//  Created by Henry McGilton on 9/7/14.
//  Copyright (c) 2014 2014 Y Media Labs. All rights reserved.
//

#import "APHHealthProfileViewController.h"

@interface APHHealthProfileViewController ()  <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation APHHealthProfileViewController

#pragma  mark  -  Table View Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //
    //    place holder return value for future use
    //
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //
    //    place holder return value for future use
    //
    return  1;
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

//
//    place holder return value for future use
//
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
