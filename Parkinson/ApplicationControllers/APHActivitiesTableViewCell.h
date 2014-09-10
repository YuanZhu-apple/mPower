//
//  APHActivitiesTableViewCell.h
//  Parkinson
//
//  Created by Henry McGilton on 8/20/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  APHConfirmationView;

typedef NS_ENUM(NSUInteger, APHActivitiesTableViewCellType) {
    APHActivitiesTableViewCellTypeDefault,
    APHActivitiesTableViewCellTypeSubtitle,
};

@interface APHActivitiesTableViewCell : UITableViewCell

@property (nonatomic, weak)  IBOutlet  UILabel              *titleLabel;
@property (nonatomic, weak)  IBOutlet  UILabel              *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (nonatomic, weak)  IBOutlet  APHConfirmationView  *confirmationView;
@property (nonatomic, assign, getter = isCompleted)   BOOL   completed;
@property (nonatomic, assign) APHActivitiesTableViewCellType type;

@end
