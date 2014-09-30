//
//  APHMedsChangeMasterTableViewCell.m
//  Parkinson
//
//  Created by Henry McGilton on 9/24/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHMedsChangeMasterTableViewCell.h"

static  CGFloat  kCellHeight = 80;

@implementation APHMedsChangeMasterTableViewCell

+ (CGFloat)cellHeight
{
    return  kCellHeight;
}

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
