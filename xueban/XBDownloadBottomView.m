//
//  XBDownloadBottomView.m
//  xueban
//
//  Created by dang on 2016/11/3.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBDownloadBottomView.h"

@implementation XBDownloadBottomView

- (instancetype)init
{
    if (self = [super init])
    {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setup];
    }
    return self;
}

- (void)setup
{
    [self setBackgroundColor:[UIColor colorWithRed:1.00 green:0.93 blue:0.75 alpha:1.00]];
    [self addSubview:self.closeButton];
    [self addSubview:self.iconImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.progressButton];
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.offset(12.0f);
        make.size.mas_equalTo(CGSizeMake(18.0, 18.0f));
    }];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(_closeButton.mas_right).offset(12.0f);
        make.top.offset(10.0f);
        make.bottom.offset(-10.0f);
        make.width.mas_equalTo(_iconImageView.mas_height);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(_iconImageView.mas_right).offset(10.0f);
        make.right.equalTo(_progressButton.mas_left).offset(-15.0f);
    }];
    [_progressButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.top.offset(10.0f);
        make.bottom.offset(-8.0f);
        make.right.offset(-15.0f);
        make.width.mas_equalTo(80.0f);
    }];
}

#pragma mark - event response
- (void)clickCloseButton
{
    if (self.closeHandler)
    {
        self.closeHandler();
    }
}

- (void)clickProgressButton
{
    if (self.progressHandler)
    {
        self.progressHandler();
    }
}

#pragma mark - getter and setter
- (UIButton *)closeButton
{
    if (_closeButton == nil)
    {
        _closeButton = [[UIButton alloc] init];
        [_closeButton setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(clickCloseButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UIImageView *)iconImageView
{
    if (_iconImageView == nil)
    {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    }
    return _iconImageView;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil)
    {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}

- (UIButton *)progressButton
{
    if (_progressButton == nil)
    {
        _progressButton = [[UIButton alloc] init];
        _progressButton.enabled = NO;
        _progressButton.layer.cornerRadius = 5.0f;
        [_progressButton setBackgroundColor:[UIColor colorWithHexString:@"Aaaaaa"]];
        [_progressButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [_progressButton setTitle:@"正在下载" forState:UIControlStateNormal];
        [_progressButton addTarget:self action:@selector(clickProgressButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _progressButton;
}
@end
