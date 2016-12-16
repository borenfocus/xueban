//
//  XBBoxBannerTableViewCell.h
//  xueban
//
//  Created by dang on 16/8/13.
//  Copyright © 2016年 dang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HorizonScrollTableView.h"

@interface XBBoxBannerTableViewCell : UITableViewCell

@property (nonatomic, strong) HorizonScrollTableView *horizonTableView;

//选择位置
typedef void (^BannerBlock)(NSInteger index, id shareType);

@property (nonatomic,copy) BannerBlock block;

- (void)configWithArray:(NSMutableArray *)array;

@end
