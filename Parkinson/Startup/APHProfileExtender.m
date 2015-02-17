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

- (UITableViewCell *)cellForRowAtAdjustedIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"Medication Tracker Setup"];
        cell.textLabel.text = @"Medication Tracker Setup";
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtAdjustedIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = tableView.rowHeight;
    
    if (indexPath.section == 0) {
        height = 44.0;
    }
    
    return height;
}

- (void)navigationController:(UINavigationController *)navigationController didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    APCMedicationTrackerSetupViewController *controller = [[APCMedicationTrackerSetupViewController alloc] initWithNibName:nil bundle:[NSBundle appleCoreBundle]];
    
    controller.navigationController.navigationBar.topItem.title = NSLocalizedString(@"Medication Tracker Setup", @"");
    
    [navigationController pushViewController:controller animated:YES];
}

@end
