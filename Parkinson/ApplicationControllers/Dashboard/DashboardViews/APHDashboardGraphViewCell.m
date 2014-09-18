//
//  APHDashboardGraphViewCell.m
//  Parkinson
//
//  Created by Ramsundar Shandilya on 9/8/14.
//  Copyright (c) 2014 Henry McGilton. All rights reserved.
//

#import "APHDashboardGraphViewCell.h"
#import "YMLLineChartView.h"
#import "YMLTimeLineChartView.h"

@implementation APHDashboardGraphViewCell

- (void)awakeFromNib {
    // Initialization code
    self.graphView.layer.cornerRadius = 3.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)expandTapped:(id)sender
{
    if([self.delegate respondsToSelector:@selector(dashboardGraphViewCellDidTapExpandForCell:)]){
        [self.delegate dashboardGraphViewCellDidTapExpandForCell:self];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    for (UIView *subview in self.graphView.subviews) {
        subview.frame = self.graphView.bounds;
//        if ([subview isKindOfClass:[YMLLineChartView class]]) {
//            YMLLineChartView * currentView = (YMLLineChartView*) subview;
//            [currentView draw];
//        }
//        if ([subview isKindOfClass:[YMLTimeLineChartView class]]) {
//            YMLTimeLineChartView * currentView = (YMLTimeLineChartView*) subview;
//            [currentView redrawCanvas];
//        }
    }
}

@end
