//
//  YMLActivitiesTableViewCell.m
//  Parkinson
//
//  Created by Henry McGilton on 8/20/14.
//  Copyright (c) 2014 Henry McGilton. All rights reserved.
//

#import "YMLActivitiesTableViewCell.h"
#import "YMLConfirmationView.h"

@implementation YMLActivitiesTableViewCell

@dynamic  completed;

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (BOOL)isCompleted
{
    return  completed;
}

- (void)setCompleted:(BOOL)aCompleted
{
    self.confirmation.completed = aCompleted;
}

@end
