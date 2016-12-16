//
//  XBBoxSetInfoTableViewCell.m
//  xueban
//
//  Created by dang on 2016/11/1.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBBoxSetInfoTableViewCell.h"
#import "JTMaterialSwitch.h"

@interface XBBoxSetInfoTableViewCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIImageView *disclosureIndicator;
@property (nonatomic, strong) JTMaterialSwitch *jtSwitch;

@end

@implementation XBBoxSetInfoTableViewCell

- (instancetype)init {
    if (self = [super init]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.detailLabel];
        [self.contentView addSubview:self.lineView];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.offset(15.0f);
        }];
        [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(_titleLabel.mas_right).offset(20.0f);
        }];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.offset(1);
            make.left.equalTo(_titleLabel.mas_left);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}

#pragma mark - event response
- (void)switchAction:(JTMaterialSwitch *)sender {
    BOOL isOn = [sender isOn];
    if (isOn && self.switchOnHandler) {
        self.switchOnHandler();
    } else if (!isOn && self.switchOffHandler) {
        self.switchOffHandler();
    }
}

#pragma mark - getter and setter
- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"dalianmeng";
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:16.0f];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel {
    if (_detailLabel == nil) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.text = @"hehe";
        _detailLabel.textColor = [UIColor colorWithHexString:@"969696"];
        _detailLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return _detailLabel;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.hidden = YES;
        _lineView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    }
    return _lineView;
}

- (UIImageView *)disclosureIndicator {
    if (!_disclosureIndicator) {
        _disclosureIndicator = [[UIImageView alloc] init];
        _disclosureIndicator.image = [UIImage imageNamed:@"enter"];
    }
    return _disclosureIndicator;
}

- (JTMaterialSwitch *)jtSwitch {
    if (!_jtSwitch) {
        _jtSwitch = [[JTMaterialSwitch alloc] initWithSize:JTMaterialSwitchSizeNormal
                                                     style:JTMaterialSwitchStyleDefault
                                                     state:JTMaterialSwitchStateOn];
        _jtSwitch.center = CGPointMake(SCREENWIDTH-30, 25);
        [_jtSwitch setOn:NO animated:NO];
        _jtSwitch.isRippleEnabled = NO;
        _jtSwitch.thumbOnTintColor = [UIColor colorWithHexString:MainColor];
        _jtSwitch.trackOnTintColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00];
        _jtSwitch.trackOffTintColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00];
        _jtSwitch.rippleFillColor = [UIColor colorWithHexString:MainColor];
        [_jtSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _jtSwitch;
}

- (void)setModel:(XBBoxSetInfoModel *)model {
    _model = model;
    if (model.type == XBBoxSetInfoDisclosureIndicator) {
        [self.contentView addSubview:self.disclosureIndicator];
        [_disclosureIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.offset(-20.0);
            make.size.mas_equalTo(CGSizeMake(7.5f, 14.5f));
        }];
    } else if (model.type == XBBoxSetInfoSwitch) {
        [self.contentView addSubview:self.jtSwitch];
    }
    _titleLabel.text = model.title;
    _detailLabel.text = model.detail;
    [_jtSwitch setOn:model.isNotify animated:NO];
}
@end
