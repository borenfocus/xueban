//
//  XBBoxSetButtonTableViewCell.h
//  xueban
//
//  Created by dang on 2016/11/1.
//  Copyright © 2016年 dang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBBoxSetButtonTableViewCell : UITableViewCell

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, copy) void (^followHandler)();

@end
