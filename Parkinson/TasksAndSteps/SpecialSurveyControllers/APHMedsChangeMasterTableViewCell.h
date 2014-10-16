//
//  APHMedsChangeMasterTableViewCell.h
//  Parkinson
//
//  Created by Henry McGilton on 9/24/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APHMedsChangeMasterTableViewCell : UITableViewCell

@property  (nonatomic, weak)  IBOutlet  UILabel  *medicationCaption;
@property  (nonatomic, weak)  IBOutlet  UILabel  *dosageCaption;

+ (CGFloat)cellHeight;

@end
