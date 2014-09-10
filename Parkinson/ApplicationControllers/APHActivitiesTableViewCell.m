//
//  APHActivitiesTableViewCell.m
//  Parkinson
//
//  Created by Henry McGilton on 8/20/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHActivitiesTableViewCell.h"
#import "APHConfirmationView.h"
#import "UIColor+Parkinson.h"

@interface APHActivitiesTableViewCell()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelCenterYConstraint;

@end

@implementation APHActivitiesTableViewCell

@synthesize completed = _completed;

- (void)awakeFromNib
{
    [self.titleLabel setTextColor:[UIColor parkinsonBlackColor]];
    [self.subTitleLabel setTextColor:[UIColor parkinsonBlackColor]];
    [self.durationLabel setTextColor:[UIColor parkinsonBlackColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (BOOL)isCompleted
{
    return  _completed;
}

- (void)setCompleted:(BOOL)aCompleted
{
    if (_completed != aCompleted) {
        _completed = aCompleted;
        self.confirmationView.completed = aCompleted;
    }
}

- (void)setType:(APHActivitiesTableViewCellType)type
{
    _type = type;
    
    switch (type) {
        case APHActivitiesTableViewCellTypeDefault:
        {
            self.titleLabel.numberOfLines = 2;
            self.titleLabelHeightConstraint.constant = 36.f;
            self.titleLabelCenterYConstraint.constant = 0;
            self.subTitleLabel.hidden = YES;
        }
            break;
        case APHActivitiesTableViewCellTypeSubtitle:
        {
            self.titleLabel.numberOfLines = 1;
            self.titleLabelHeightConstraint.constant = 18.f;
            self.titleLabelCenterYConstraint.constant = 10;
            self.subTitleLabel.hidden = NO;
        }
            break;
        default:
            break;
    }
    
    [self setNeedsLayout];
}

@end
