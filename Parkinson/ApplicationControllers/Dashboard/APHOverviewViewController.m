//
//  APHOverviewViewController.m
//  BasicTabBar
//
//  Created by Henry McGilton on 9/7/14.
//  Copyright (c) 2014 Trilithon Software. All rights reserved.
//

/* Controllers */
#import "APHOverviewViewController.h"
#import "APHEditSectionsViewController.h"

/* Views */
#import "APHDashboardGraphViewCell.h"

static NSString * const DashboardGraphCellIdentifier = @"DashboardGraphCell";

@interface APHOverviewViewController ()

@property  (nonatomic, weak)  IBOutlet  UITableView  *dashboardTableView;
@property (nonatomic, strong) NSMutableArray *sectionsOrder;

@end

@implementation APHOverviewViewController

#pragma mark - Init

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _sectionsOrder = [NSMutableArray arrayWithArray:[defaults objectForKey:DashboardSectionsOrder]];
        
        if (!_sectionsOrder.count) {
            _sectionsOrder = [[NSMutableArray alloc] initWithArray:@[@(APHDashboardSectionStudyOverView),
                                                                     @(APHDashboardSectionActivity),
                                                                     @(APHDashboardSectionBloodCount),
                                                                     @(APHDashboardSectionMedications),
                                                                     @(APHDashboardSectionInsights),
                                                                     @(APHDashboardSectionAlerts)]];
            
            [defaults setObject:[NSArray arrayWithArray:_sectionsOrder] forKey:DashboardSectionsOrder];
            [defaults synchronize];
        }
        
        self.title = NSLocalizedString(@"Dashboard", nil);
    }
    
    return self;
}

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Setup table
    [self.dashboardTableView registerNib:[UINib nibWithNibName:@"APHDashboardGraphViewCell" bundle:nil] forCellReuseIdentifier:DashboardGraphCellIdentifier];
    [self.dashboardTableView setSeparatorInset:UIEdgeInsetsZero];
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Edit", nil) style:UIBarButtonItemStylePlain target:self action:@selector(editTapped)];
    [self.navigationItem setLeftBarButtonItem:editButton];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.sectionsOrder = [NSMutableArray arrayWithArray:[defaults objectForKey:DashboardSectionsOrder]];
    
    [self.dashboardTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeNone;
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionsOrder.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    APHDashboardGraphViewCell *cell = (APHDashboardGraphViewCell *)[tableView dequeueReusableCellWithIdentifier:DashboardGraphCellIdentifier];

    NSInteger cellType = ((NSNumber *)[self.sectionsOrder objectAtIndex:indexPath.section]).integerValue;
    
    switch (cellType) {
        case APHDashboardSectionStudyOverView:
        {
            cell.titleLabel.text = @"Study Overview";
        }
            break;
        case APHDashboardSectionActivity:
        {
            cell.titleLabel.text = @"Activity";
        }
            break;
        case APHDashboardSectionBloodCount:
        {
            cell.titleLabel.text = @"Blood Count";
        }
            break;
        case APHDashboardSectionMedications:
        {
            cell.titleLabel.text = @"Medications";
        }
            break;
        case APHDashboardSectionInsights:
        {
            cell.titleLabel.text = @"Insights";
        }
            break;
        case APHDashboardSectionAlerts:
        {
            cell.titleLabel.text = @"Alerts";
        }
            break;
        default:
            break;
    }
    
    return  cell;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125.f;
}

#pragma mark - Selection Actions

- (void)editTapped
{
    APHEditSectionsViewController *editSectionsViewController = [[APHEditSectionsViewController alloc] initWithNibName:@"APHEditSectionsViewController" bundle:nil];
    
    UINavigationController *editSectionsNavigationController = [[UINavigationController alloc] initWithRootViewController:editSectionsViewController];
    editSectionsNavigationController.navigationBar.translucent = NO;
    
    [self presentViewController:editSectionsNavigationController animated:YES completion:nil];
    
}

@end
