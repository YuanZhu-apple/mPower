//
//  APHDashboardMessageViewCell.m
//  Parkinson
//
//  Created by Ramsundar Shandilya on 9/9/14.
//  Copyright (c) 2014 Henry McGilton. All rights reserved.
//

#import "APHDashboardMessageViewCell.h"

@implementation APHDashboardMessageViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setType:(APHDashboardMessageViewCellType)type
{
    switch (type) {
        case APHDashboardMessageViewCellTypeAlert:
        {
            self.titleLabel.text = @"Alert:";
        }
            break;
        case APHDashboardMessageViewCellTypeInsight:
        {
            self.titleLabel.text = @"Insight:";
        }
            break;
        default://TODO:NSAssert
            break;
    }
}
@end
