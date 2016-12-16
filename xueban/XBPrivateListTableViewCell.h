//
//  XBPrivateListTableViewCell.h
//  xueban
//
//  Created by dang on 2016/10/16.
//  Copyright © 2016年 dang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBPrivateListTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *badgeLabel;

- (void)configWithDict:(NSDictionary *)dict;

@end
