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
    kActivitiesTableViewCellTypeDefault,
    kActivitiesTableViewCellTypeSubtitle,
};

@interface APHActivitiesTableViewCell : UITableViewCell

@property (weak, nonatomic)  IBOutlet  UILabel              *titleLabel;
@property (weak, nonatomic)  IBOutlet  UILabel              *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic)  IBOutlet  APHConfirmationView  *confirmationView;
@property (nonatomic, assign, getter = isCompleted)   BOOL   completed;
@property (nonatomic, assign) APHActivitiesTableViewCellType type;

@end
