//
//  APHWithdrawSurveyViewController.m
//  Parkinson's
//
//  Copyright (c) 2014 <INSTITUTION-NAME-TBD>. All rights reserved.
//

#import "APHWithdrawSurveyViewController.h"

@interface APHWithdrawSurveyViewController ()

@end

@implementation APHWithdrawSurveyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareContent
{
    [self surveyFromJSONFile:@"WithdrawStudy"];
    [self.tableView reloadData];
}

@end
