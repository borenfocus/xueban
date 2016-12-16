//
//  XBBoxCenterHeaderTableViewCell.m
//  xueban
//
//  Created by dang on 16/7/11.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBBoxCenterHeaderTableViewCell.h"

@interface XBBoxCenterHeaderTableViewCell()

@property (nonatomic, strong) UIView *colorView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation XBBoxCenterHeaderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.colorView];
        [self.contentView addSubview:self.titleLabel];
        [_colorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.offset(0.0f);
            make.centerY.equalTo(self.contentView);
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
        _titleLabel.text = @"我的订阅";
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}
@end
