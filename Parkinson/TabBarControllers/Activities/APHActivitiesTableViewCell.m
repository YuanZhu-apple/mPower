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

static NSInteger kNumberOfLinesForTypeDefault  = 2;
static NSInteger kNumberOfLinesForTypeSubtitle = 1;

static CGFloat kTitleLabelHeightContraintConstantDefault  = 36.0f;
static CGFloat kTitleLabelHeightContraintConstantSubtitle = 36.0f;

static CGFloat kTitleLabelCenterYContraintConstantDefault  = 0.0f;
static CGFloat kTitleLabelCenterYContraintConstantSubtitle = 10.0f;

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
        case kActivitiesTableViewCellTypeDefault:
        {
            self.titleLabel.numberOfLines = kNumberOfLinesForTypeDefault;
            self.titleLabelHeightConstraint.constant = kTitleLabelHeightContraintConstantDefault;
            self.titleLabelCenterYConstraint.constant = kTitleLabelCenterYContraintConstantDefault;
            self.subTitleLabel.hidden = YES;
        }
            break;
        case kActivitiesTableViewCellTypeSubtitle:
        {
            self.titleLabel.numberOfLines = kNumberOfLinesForTypeSubtitle;
            self.titleLabelHeightConstraint.constant = kTitleLabelHeightContraintConstantSubtitle;
            self.titleLabelCenterYConstraint.constant = kTitleLabelCenterYContraintConstantSubtitle;
            self.subTitleLabel.hidden = NO;
        }
            break;
        default:
            break;
    }
    
    [self setNeedsLayout];
}

@end
