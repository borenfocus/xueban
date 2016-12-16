//
//  XBBoxCenterTableViewCell.h
//  xueban
//
//  Created by dang on 16/7/11.
//  Copyright © 2016年 dang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBBoxCenterTableViewCell : UITableViewCell

- (void)configWithDict:(NSDictionary *)dict;

@property (nonatomic, strong) UIImageView *newsImageView;

@property (nonatomic) NSNumber *imageViewHeight;

@end
