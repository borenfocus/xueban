//
//  XBFindLibraryHeaderTableViewCell.m
//  xueban
//
//  Created by dang on 2016/10/21.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBFindLibraryHeaderTableViewCell.h"

@interface XBFindLibraryHeaderTableViewCell()

@property (nonatomic, strong) UIView *colorView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation XBFindLibraryHeaderTableViewCell

- (instancetype)init{
    if (self = [super init]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.colorView];
        [self.contentView addSubview:self.titleLabel];
        [_colorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15.0f);
            make.top.offset(10.0f);
            make.bottom.offset(-10.0f);
            make.width.mas_equalTo(8.0f);
        }];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(_colorView.mas_right).offset(15.0f);
            make.size.mas_equalTo(CGSizeMake(100, 30));
        }];
    }
    return self;
}

#pragma mark - getter and setter
- (UIView *)colorView {
    if (!_colorView) {
        _colorView = [[UIView alloc] init];
        _colorView.backgroundColor = [UIColor colorWithHexString:MainColor];
    }
    return _colorView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"我的书架";
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

@end
