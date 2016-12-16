//
//  XBMeDetailHeaderTableViewCell.h
//  xueban
//
//  Created by dang on 2016/10/3.
//  Copyright © 2016年 dang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBMeDetailHeaderTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *avatarImageView;

- (void)configWithDict:(NSDictionary *)dict;

@end
