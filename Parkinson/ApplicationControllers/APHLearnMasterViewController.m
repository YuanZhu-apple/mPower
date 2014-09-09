//
//  APHLearnMasterViewController.m
//  BasicTabBar
//
//  Created by Henry McGilton on 9/7/14.
//  Copyright (c) 2014 Trilithon Software. All rights reserved.
//

#import "APHLearnMasterViewController.h"
#import "APHLearnMasterTableViewCell.h"

static  NSString  *kMasterTableCellName = @"APHLearnMasterTableViewCell";

static  CGFloat  kHeightOfMasterTableViewCell = 166.0;

@interface APHLearnMasterViewController ()  <UITableViewDataSource, UITableViewDelegate>

@property  (nonatomic, weak)  IBOutlet  UITableView  *tabulator;

@end

@implementation APHLearnMasterViewController

#pragma mark - Init

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
        self.title = NSLocalizedString(@"Learn", nil);
    }
    
    return self;
}

- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeNone;
}


#pragma  mark  -  Table View Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    APHLearnMasterTableViewCell  *cell = (APHLearnMasterTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kMasterTableCellName];
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  kHeightOfMasterTableViewCell;
}

#pragma  mark  -  Table View Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma  mark  -  View Controller Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib  *masterTableCellNib = [UINib nibWithNibName:kMasterTableCellName bundle:[NSBundle mainBundle]];
    [self.tabulator registerNib:masterTableCellNib forCellReuseIdentifier:kMasterTableCellName];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
