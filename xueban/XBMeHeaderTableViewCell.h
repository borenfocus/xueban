//
//  XBMeHeaderTableViewCell.h
//  xueban
//
//  Created by dang on 16/7/26.
//  Copyright © 2016年 dang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBMeHeaderTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *circleImageView;

- (void)configWithDict:(NSDictionary *)dict;

@end
