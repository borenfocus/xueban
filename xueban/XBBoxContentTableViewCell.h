//
//  XBBoxContentTableViewCell.h
//  xueban
//
//  Created by dang on 16/7/11.
//  Copyright © 2016年 dang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XBBoxContentTableViewCellType) {
    //功能号
    XBBoxContentTableViewCellTypeTool,
    //订阅号
    XBBoxContentTableViewCellTypeCenter
};

@interface XBBoxContentTableViewCell : UITableViewCell

@property (nonatomic) XBBoxContentTableViewCellType cellType;

- (void)configWithDict:(NSDictionary *)dict AtIndexPath:(NSIndexPath *)indexPath;

@end
