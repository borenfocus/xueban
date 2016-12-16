//
//  XBBoxSetInfoTableViewCell.h
//  xueban
//
//  Created by dang on 2016/11/1.
//  Copyright © 2016年 dang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBBoxSetInfoModel.h"

@interface XBBoxSetInfoTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) XBBoxSetInfoModel *model;
@property (nonatomic, copy) void (^switchOnHandler)();
@property (nonatomic, copy) void (^switchOffHandler)();

@end
