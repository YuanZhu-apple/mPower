//
//  APHDashboardProgressViewCell.m
//  Parkinson
//
//  Created by Ramsundar Shandilya on 9/9/14.
//  Copyright (c) 2014 Henry McGilton. All rights reserved.
//

#import "APHDashboardProgressViewCell.h"
#import "APCCircularProgressView.h"

@implementation APHDashboardProgressViewCell

- (void)awakeFromNib {
    // Initialization code
    
    //TODO: Sammple Value. Remove later.
    self.progressView.progress = 0.74;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
