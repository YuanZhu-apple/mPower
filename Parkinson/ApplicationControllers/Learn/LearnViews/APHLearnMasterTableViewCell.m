//
//  APHLearnMasterTableViewCell.m
//  BasicTabBar
//
//  Created by Henry McGilton on 9/7/14.
//  Copyright (c) 2014 Trilithon Software. All rights reserved.
//

#import "APHLearnMasterTableViewCell.h"
#import "UIColor+Parkinson.h"

@interface APHLearnMasterTableViewCell()

@property (weak, nonatomic) IBOutlet UIButton *readMoreButton;

@end

@implementation APHLearnMasterTableViewCell

- (void)awakeFromNib
{
    [self.titleLabel setTextColor:[UIColor parkinsonBlackColor]];
    [self.descriptionLabel setTextColor:[UIColor parkinsonLightGrayColor]];
    
    self.readMoreButton.layer.cornerRadius = CGRectGetHeight(self.readMoreButton.bounds)/2;
    self.readMoreButton.layer.borderWidth = 1.f;
    self.readMoreButton.layer.borderColor = [UIColor parkinsonLightGrayColor].CGColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (IBAction)readMoreTapped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(learnMasterTableViewCellDidTapReadMoreForCell:)]) {
        [self.delegate learnMasterTableViewCellDidTapReadMoreForCell:self];
    }
}

@end
