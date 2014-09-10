//
//  APHLearnMasterViewController.m
//  BasicTabBar
//
//  Created by Henry McGilton on 9/7/14.
//  Copyright (c) 2014 Trilithon Software. All rights reserved.
//

/* ViewControllers */
#import "APHLearnMasterViewController.h"

/* Views */
#import "APHLearnMasterTableViewCell.h"
#import "APHLearnResourceViewCell.h"

static  NSString  *LearnMasterViewCellIdentifier = @"LearnMasterTableViewCell";
static  NSString  *LearnResourceViewCellIdentifier = @"LearnResourceTableViewCell";

static  CGFloat  kMasterTableViewCellHeight = 166.0;
static  CGFloat  kResourceTableViewCellHeight = 120.0;

@interface APHLearnMasterViewController ()  <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *learnTableView;

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

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.learnTableView registerNib:[UINib nibWithNibName:@"APHLearnMasterTableViewCell" bundle:nil] forCellReuseIdentifier:LearnMasterViewCellIdentifier];
    [self.learnTableView registerNib:[UINib nibWithNibName:@"APHLearnResourceViewCell" bundle:nil] forCellReuseIdentifier:LearnResourceViewCellIdentifier];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            APHLearnMasterTableViewCell  *cell = (APHLearnMasterTableViewCell *)[tableView dequeueReusableCellWithIdentifier:LearnMasterViewCellIdentifier];
            return  cell;
        }
            break;
        case 1:
        {
            APHLearnResourceViewCell  *cell = (APHLearnResourceViewCell *)[tableView dequeueReusableCellWithIdentifier:LearnResourceViewCellIdentifier];
            return  cell;
        }
            break;
        default:
            break;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    
    switch (indexPath.section) {
        case 0:
        {
            height = kMasterTableViewCellHeight;
        }
            break;
        case 1:
        {
            height = kResourceTableViewCellHeight;
        }
            break;
        default:
            break;
    }
    
    return  height;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = @"";
    
    switch (section) {
        case 0:
        {
            title = @"";
        }
            break;
        case 1:
        {
            title = @"Resources";
        }
            break;
        default:
            break;
    }
    
    return  title;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
