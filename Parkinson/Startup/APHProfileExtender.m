//
//  APHProfileExtender.m
//  mPower
//
//  Copyright (c) 2015 Apple, Inc. All rights reserved.
//

#import "APHProfileExtender.h"

static  NSInteger  kDefaultNumberOfExtraSections = 2;

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

    //
    //    return  kDefaultNumberOfExtraSections  extra sections for a nicer layout in profile
    //
    //    return  0  to turn off the feature in the profile View Controller
    //
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  kDefaultNumberOfExtraSections;
}

    //
    //    Add to the number of rows
    //
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInAdjustedSection:(NSInteger)section
{
    NSInteger count = 0;
    
    if (section == 0) {
        count = 1;
    }
    
    return count;
}

    //
    //    return a default style Table View Cell unless you have special requirements
    //
- (UITableViewCell *)cellForRowAtAdjustedIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"Medication Tracker Setup"];
        cell.textLabel.text = @"Medication Tracker Setup";
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtAdjustedIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat height = tableView.rowHeight;
    
    if (indexPath.section == 0) {
        height = 44.0;
    }
    
    return height;
}

    //
    //    provide a sub-class of UIViewController to do the work
    //
    //        you can either push the controller or present it depending on your preferences
    //
- (void)navigationController:(UINavigationController *)navigationController didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    APCMedicationTrackerSetupViewController  *controller = [[APCMedicationTrackerSetupViewController alloc] initWithNibName:nil bundle:[NSBundle appleCoreBundle]];
    
    controller.navigationController.navigationBar.topItem.title = NSLocalizedString(@"Medication Tracker Setup", @"");
    
    [navigationController pushViewController:controller animated:YES];
}

@end
