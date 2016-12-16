//
//  XBFindNightMeetWritePostContainerView.m
//  xueban
//
//  Created by dang on 16/8/13.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBFindNightMeetWritePostContainerView.h"

@interface XBFindNightMeetWritePostContainerView ()
@property (nonatomic, strong) UIView      *whiteTopBackgroundView;

@property (nonatomic, strong) UIView      *whiteBottomBackgroundView;
@property (nonatomic, strong) UILabel     *hideNameLabel;

@property (nonatomic, strong) UIButton    *confirmButton;
@end

@implementation XBFindNightMeetWritePostContainerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        [self addSubview:self.whiteTopBackgroundView];
        [self.whiteTopBackgroundView addSubview:self.textView];
        [self.whiteTopBackgroundView addSubview:self.textNumLabel];
        [self addSubview:self.whiteBottomBackgroundView];
        [_whiteBottomBackgroundView addSubview:self.hideNameLabel];
        [_whiteBottomBackgroundView addSubview:self.jtSwitch];
        [self addSubview:self.confirmButton];
        [_whiteTopBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.offset(0);
            make.height.mas_equalTo(180.0f);
        }];
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.offset(10.0f);
            make.right.bottom.offset(-10.0f);
        }];
        [_textNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(-10.0f);
            make.right.offset(-20.0f);
//            make.size.mas_equalTo(CGSizeMake(120, 20));
        }];
        [_whiteBottomBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_whiteTopBackgroundView.mas_bottom).offset(10.0f);
            make.left.right.offset(0);
            make.height.mas_equalTo(44.0f);
        }];
        [_hideNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(20.0f);
            make.centerY.equalTo(_whiteBottomBackgroundView);
        }];
        [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(25.0f);
            make.right.offset(-25.0f);
            make.top.equalTo(_whiteBottomBackgroundView.mas_bottom).offset(20.0f);
            //FIXME: 改成等比例
            make.height.mas_equalTo(40);
        }];
    }
    return self;
}

#pragma mark - event response
- (void)clickUnfollowButton {
    if (self.confirmHandler) {
        self.confirmHandler();
    }
}

-(void)switchAction:(JTMaterialSwitch *)sender
{
    
}

#pragma mark - getter and setter
- (UIView *)whiteTopBackgroundView {
    if (!_whiteTopBackgroundView) {
        _whiteTopBackgroundView = [[UIView alloc] init];
        _whiteTopBackgroundView.backgroundColor = [UIColor whiteColor];
    }
    return _whiteTopBackgroundView;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.text = @"你想说点什么？...";
        _textView.textColor = [UIColor colorWithHexString:@"969696"];
        _textView.font = [UIFont systemFontOfSize:15.0f];
        _textView.scrollEnabled = NO;
    }
    return _textView;
}

- (UILabel *)textNumLabel {
    if (!_textNumLabel) {
        _textNumLabel = [[UILabel alloc] init];
        _textNumLabel.font = [UIFont systemFontOfSize:12.0f];
        _textNumLabel.text = @"140/140";
        _textNumLabel.textColor = [UIColor colorWithHexString:@"969696"];
        _textNumLabel.textAlignment = NSTextAlignmentRight;
    }
    return _textNumLabel;
}

- (UIView *)whiteBottomBackgroundView {
    if (!_whiteBottomBackgroundView) {
        _whiteBottomBackgroundView = [[UIView alloc] init];
        _whiteBottomBackgroundView.backgroundColor = [UIColor whiteColor];
    }
    return _whiteBottomBackgroundView;
}

- (UILabel *)hideNameLabel {
    if (!_hideNameLabel) {
        _hideNameLabel = [[UILabel alloc] init];
        _hideNameLabel.text = @"匿名发布该消息";
        _hideNameLabel.textColor = [UIColor blackColor];
        _hideNameLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return _hideNameLabel;
}

- (JTMaterialSwitch *)jtSwitch {
    if (!_jtSwitch) {
        _jtSwitch = [[JTMaterialSwitch alloc] initWithSize:JTMaterialSwitchSizeNormal
                                                     style:JTMaterialSwitchStyleDefault
                                                     state:JTMaterialSwitchStateOn];
        _jtSwitch.center = CGPointMake(SCREENWIDTH-30, 22);
        _jtSwitch.isRippleEnabled = NO;
        _jtSwitch.thumbOnTintColor = [UIColor colorWithHexString:MainColor];
        _jtSwitch.trackOnTintColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00];
        _jtSwitch.trackOffTintColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00];
        _jtSwitch.rippleFillColor = [UIColor colorWithHexString:MainColor];
        [_jtSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _jtSwitch;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [[UIButton alloc] init];
        _confirmButton.layer.cornerRadius = 5.0;
        _confirmButton.clipsToBounds = YES;
        [_confirmButton setTitle:@"确认发布" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confirmButton.backgroundColor = [UIColor colorWithHexString:BlueColor];
        [_confirmButton addTarget:self action:@selector(clickUnfollowButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

@end
