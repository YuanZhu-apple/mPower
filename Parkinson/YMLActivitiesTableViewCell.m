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

@synthesize completed = _completed;

- (void)awakeFromNib
{
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
        self.confirmation.completed = aCompleted;
    }
}

@end
