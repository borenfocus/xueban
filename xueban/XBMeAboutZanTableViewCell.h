//
//  XBMeAboutZanTableViewCell.h
//  xueban
//
//  Created by dang on 2016/10/24.
//  Copyright © 2016年 dang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBMeAboutZanTableViewCell : UITableViewCell

@property (nonatomic, copy) void (^contentDetailHandler)();

- (void)configWithDict:(NSDictionary *)dict;

@end
