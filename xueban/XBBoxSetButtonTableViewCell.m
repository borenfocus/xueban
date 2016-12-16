//
//  XBBoxSetButtonTableViewCell.m
//  xueban
//
//  Created by dang on 2016/11/1.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBBoxSetButtonTableViewCell.h"

@implementation XBBoxSetButtonTableViewCell

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.button];
        [_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(25.0f);
            make.right.offset(-25.0f);
            make.top.offset(3);
            make.bottom.offset(-3.0f);
        }];
    }
    return self;
}

- (void)clickFollowButton {
    if (self.followHandler) {
        self.followHandler();
    }
}

- (UIButton *)button {
    if (!_button) {
        _button = [[UIButton alloc] init];
        _button.layer.cornerRadius = 5.0;
        _button.clipsToBounds = YES;
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(clickFollowButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}
@end
