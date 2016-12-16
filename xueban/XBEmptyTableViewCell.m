//
//  XBEmptyTableViewCell.m
//  xueban
//
//  Created by dang on 16/8/8.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBEmptyTableViewCell.h"

@implementation XBEmptyTableViewCell

- (instancetype)init {
    if (self = [super init]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    }
    return self;
}

@end
