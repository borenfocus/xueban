//
//  XBMeTableViewCell.h
//  xueban
//
//  Created by dang on 16/7/26.
//  Copyright © 2016年 dang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBMeTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *badgeLabel;

- (void)configureCellAtIndexPath:(NSIndexPath *)indexPath;
@end
