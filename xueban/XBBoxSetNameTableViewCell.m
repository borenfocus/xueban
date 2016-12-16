//
//  XBBoxSetNameTableViewCell.m
//  xueban
//
//  Created by dang on 2016/11/1.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBBoxSetNameTableViewCell.h"

@implementation XBBoxSetNameTableViewCell

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        [self.contentView addSubview:self.circleImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.subTitleLabel];
        [_circleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(25.0f);
            make.top.mas_offset(20.0f);
            make.bottom.mas_equalTo(-20.0f);
            make.width.equalTo(_circleImageView.mas_height);
        }];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_circleImageView.mas_right).offset(20.0f);
            make.right.offset(0.0f);
            make.centerY.equalTo(self.contentView);
        }];
        [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_circleImageView.mas_right).offset(20.0f);
            make.right.offset(0.0f);
            make.bottom.offset(-10.0f);
        }];
    }
    return self;
}

- (UIImageView *)circleImageView {
    if (!_circleImageView) {
        _circleImageView = [[UIImageView alloc] init];
        _circleImageView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        _circleImageView.layer.cornerRadius = 30;
        _circleImageView.clipsToBounds = YES;
    }
    return _circleImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:18.0f];
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.textColor = [UIColor colorWithHexString:@"969696"];
        _subTitleLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return _subTitleLabel;
}

@end
