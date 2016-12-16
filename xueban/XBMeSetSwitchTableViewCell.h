//
//  XBMeSetSwitchTableViewCell.h
//  xueban
//
//  Created by dang on 16/8/15.
//  Copyright © 2016年 dang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBMeSetSwitchTableViewCell : UITableViewCell

@property (nonatomic, copy) void (^switchOnHandler)();
@property (nonatomic, copy) void (^switchOffHandler)();

@end
