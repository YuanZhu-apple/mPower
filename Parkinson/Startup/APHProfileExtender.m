//
//  APHProfileExtender.m
//  mPower
//
//  Copyright (c) 2015 Apple, Inc. All rights reserved.
//

#import "APHProfileExtender.h"


@implementation APHProfileExtender

- (instancetype) init {
    self = [super init];

    if (self) {
        
    }
    
    return self;
}

- (BOOL)willDisplayCell:(NSIndexPath *)indexPath {
    return YES;
}

//This is all the content (rows, sections) that is prepared at the appCore level
/*
- (NSArray *)preparedContent:(NSArray *)array {
    return array;
}
*/

//Add to the number of sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

//Add to the number of sections
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInAdjustedSection:(NSInteger)section {
    
    NSInteger count = 0;
    
    if (section == 0) {
        count = 1;
    }
    
    return count;
}

- (UIView *)cellForRowAtAdjustedIndexPath:(NSIndexPath *)indexPath {
    
    UILabel *view = nil;
    if (indexPath.section == 0) {
        CGSize screen = [[UIScreen mainScreen] bounds].size;
        view = (UILabel *)[[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, screen.width, 60.0)];
        view.text = NSLocalizedString(@"Medication Tracker Setup", @"");
        view.textAlignment = NSTextAlignmentCenter;
    }

    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtAdjustedIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = tableView.rowHeight;
    
    if (indexPath.section == 0) {
        height = 60.0;
    }
    
    return height;
}

- (void)navigationController:(UINavigationController *)navigationController didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIViewController *controller = [[UIViewController alloc] init];
    
    controller.navigationController.navigationBar.topItem.title = NSLocalizedString(@"Medication Tracker", @"");
    
    [navigationController pushViewController:controller animated:YES];
}

@end
