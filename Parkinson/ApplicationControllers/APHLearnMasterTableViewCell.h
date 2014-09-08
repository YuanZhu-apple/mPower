//
//  APHLearnMasterTableViewCell.h
//  BasicTabBar
//
//  Created by Henry McGilton on 9/7/14.
//  Copyright (c) 2014 Trilithon Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APHLearnMasterTableViewCell : UITableViewCell

@property  (nonatomic, weak)  IBOutlet  UIView    *confirmationView;
@property  (nonatomic, weak)  IBOutlet  UILabel   *titleLabel;
@property  (nonatomic, weak)  IBOutlet  UILabel   *descriptionLabel;
@property  (nonatomic, weak)  IBOutlet  UIButton  *readMoreButton;

@end
