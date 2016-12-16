//
//  XBMeSetSwitchTableViewCell.m
//  xueban
//
//  Created by dang on 16/8/15.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBMeSetSwitchTableViewCell.h"
#import "JTMaterialSwitch.h"

@interface XBMeSetSwitchTableViewCell ()
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) JTMaterialSwitch *jtSwitch;
@end

@implementation XBMeSetSwitchTableViewCell

- (instancetype)init
{
    if (self = [super init])
    {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.jtSwitch];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(20.0f);
            make.centerY.equalTo(self.contentView);
        }];
    }
    return self;
}

#pragma mark - event response
- (void)switchAction:(JTMaterialSwitch *)sender
{
    BOOL isOn = [sender isOn];
    if (isOn && self.switchOnHandler)
    {
        self.switchOnHandler();
    }
    else if (!isOn && self.switchOffHandler)
    {
        self.switchOffHandler();
    }
}

#pragma mark - getter and setter
- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"图书馆到期提醒";
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return _titleLabel;
}

- (JTMaterialSwitch *)jtSwitch
{
    if (!_jtSwitch)
    {
        _jtSwitch = [[JTMaterialSwitch alloc] initWithSize:JTMaterialSwitchSizeNormal
                                                     style:JTMaterialSwitchStyleDefault
                                                     state:JTMaterialSwitchStateOn];
        //TODO: 现在读取出来的height是44 是一个缺省值
        _jtSwitch.center = CGPointMake(SCREENWIDTH-30, 30);
        _jtSwitch.isRippleEnabled = NO;
        _jtSwitch.thumbOnTintColor = [UIColor colorWithHexString:MainColor];
        _jtSwitch.trackOnTintColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00];
        _jtSwitch.trackOffTintColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00];
        _jtSwitch.rippleFillColor = [UIColor colorWithHexString:MainColor];
        [_jtSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _jtSwitch;
}
@end
