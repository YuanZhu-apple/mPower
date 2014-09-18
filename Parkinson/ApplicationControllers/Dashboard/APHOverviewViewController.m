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
#import "APHDashboardMessageViewCell.h"
#import "APHDashboardProgressViewCell.h"

static NSString * const kDashboardGraphCellIdentifier    = @"DashboardGraphCellIdentifier";
static NSString * const kDashboardProgressCellIdentifier = @"DashboardProgressCellIdentifier";
static NSString * const kDashboardMessagesCellIdentifier = @"DashboardMessageCellIdentifier";

@interface APHOverviewViewController ()

@property (nonatomic, weak) IBOutlet UITableView *dashboardTableView;
@property (nonatomic, strong) NSMutableArray *sectionsOrder;

@end

@implementation APHOverviewViewController

#pragma mark - Init

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _sectionsOrder = [NSMutableArray arrayWithArray:[defaults objectForKey:kDashboardSectionsOrder]];
        
        if (!_sectionsOrder.count) {
            _sectionsOrder = [[NSMutableArray alloc] initWithArray:@[@(kDashboardSectionStudyOverView),
                                                                     @(kDashboardSectionActivity),
                                                                     @(kDashboardSectionBloodCount),
                                                                     @(kDashboardSectionMedications),
                                                                     @(kDashboardSectionInsights),
                                                                     @(kDashboardSectionAlerts)]];
            
            [defaults setObject:[NSArray arrayWithArray:_sectionsOrder] forKey:kDashboardSectionsOrder];
            [defaults synchronize];
        }
        
        self.title = NSLocalizedString(@"Dashboard", @"Dashboard");
    }
    
    return self;
}

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Setup table
    [self.dashboardTableView registerNib:[UINib nibWithNibName:@"APHDashboardProgressViewCell" bundle:nil] forCellReuseIdentifier:kDashboardProgressCellIdentifier];
    [self.dashboardTableView registerNib:[UINib nibWithNibName:@"APHDashboardGraphViewCell" bundle:nil] forCellReuseIdentifier:kDashboardGraphCellIdentifier];
    [self.dashboardTableView registerNib:[UINib nibWithNibName:@"APHDashboardMessageViewCell" bundle:nil] forCellReuseIdentifier:kDashboardMessagesCellIdentifier];
    
    [self.dashboardTableView setSeparatorInset:UIEdgeInsetsZero];
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Edit", nil) style:UIBarButtonItemStylePlain target:self action:@selector(editTapped)];
    [self.navigationItem setLeftBarButtonItem:editButton];
    self.dashboardTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.sectionsOrder = [NSMutableArray arrayWithArray:[defaults objectForKey:kDashboardSectionsOrder]];
    
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
    NSInteger cellType = ((NSNumber *)[self.sectionsOrder objectAtIndex:indexPath.section]).integerValue;
    
    UITableViewCell *cell = nil;
    
    switch (cellType) {
        case kDashboardSectionStudyOverView:
        {
            cell = (APHDashboardProgressViewCell *)[tableView dequeueReusableCellWithIdentifier:kDashboardProgressCellIdentifier forIndexPath:indexPath];
            
        }
            break;
        case kDashboardSectionActivity:
        {
            cell = (APHDashboardGraphViewCell *)[tableView dequeueReusableCellWithIdentifier:kDashboardGraphCellIdentifier forIndexPath:indexPath];
            ((APHDashboardGraphViewCell *)cell).titleLabel.text = NSLocalizedString(@"Activity", @"Activity");
        }
            break;
        case kDashboardSectionBloodCount:
        {
            cell = (APHDashboardGraphViewCell *)[tableView dequeueReusableCellWithIdentifier:kDashboardGraphCellIdentifier forIndexPath:indexPath];
            ((APHDashboardGraphViewCell *)cell).titleLabel.text = NSLocalizedString(@"Blood Count", @"Blood Count");
            
        }
            break;
        case kDashboardSectionMedications:
        {
            cell = (APHDashboardGraphViewCell *)[tableView dequeueReusableCellWithIdentifier:kDashboardGraphCellIdentifier forIndexPath:indexPath];
            ((APHDashboardGraphViewCell *)cell).titleLabel.text = NSLocalizedString(@"Medications", @"Medications");
            
        }
            break;
        case kDashboardSectionInsights:
        {
            cell = (APHDashboardMessageViewCell *)[tableView dequeueReusableCellWithIdentifier:kDashboardMessagesCellIdentifier forIndexPath:indexPath];
            ((APHDashboardMessageViewCell *)cell).type = kDashboardMessageViewCellTypeInsight;
            
        }
            break;
        case kDashboardSectionAlerts:
        {
            cell = (APHDashboardMessageViewCell *)[tableView dequeueReusableCellWithIdentifier:kDashboardMessagesCellIdentifier forIndexPath:indexPath];
            ((APHDashboardMessageViewCell *)cell).type = kDashboardMessageViewCellTypeAlert;
        }
            break;
        default:  NSAssert(0, @"Invalid Cell Type");
            break;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Placeholder Value. Have to change when contents are present. Esp. for Alerts and Insights.
    return 150.f;
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
