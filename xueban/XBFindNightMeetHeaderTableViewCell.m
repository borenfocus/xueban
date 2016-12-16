
//
//  XBFindNightMeetHeaderTableViewCell.m
//  xueban
//
//  Created by dang on 16/8/9.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBFindNightMeetHeaderTableViewCell.h"

@interface XBFindNightMeetHeaderTableViewCell ()
@property (nonatomic, strong) UIView      *colorView;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UIImageView *disclosureIndicator;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel     *detailLabel;
@end

@implementation XBFindNightMeetHeaderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.colorView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.disclosureIndicator];
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.detailLabel];
        [_colorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(20.0f);
            make.top.offset(15.0f);
            make.size.mas_equalTo(CGSizeMake(5, 25));
        }];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_colorView);
            make.left.equalTo(_colorView.mas_right).offset(15.0f);
            make.size.mas_equalTo(CGSizeMake(200, 30));
        }];
        [_disclosureIndicator mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(_colorView);
            make.size.mas_equalTo(CGSizeMake(7.5f, 14.5f));
            make.right.equalTo(self.contentView).offset(-20.0f);
        }];
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_colorView.mas_left);
            make.top.equalTo(_titleLabel.mas_bottom).offset(10.0f);
            make.width.mas_equalTo(70.0f);
            make.height.equalTo(_iconImageView.mas_width).multipliedBy(160.0/172);
        }];
        [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-20.0f);
            make.bottom.equalTo(_iconImageView.mas_bottom);
            make.left.equalTo(_iconImageView.mas_right).offset(20.0f);
            make.top.equalTo(_iconImageView.mas_top);
        }];
    }
    return self;
}

#pragma mark - getter and setter
- (UIView *)colorView
{
    if (!_colorView) {
        _colorView = [[UIView alloc] init];
        _colorView.backgroundColor = [UIColor colorWithHexString:MainColor];
    }
    return _colorView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"版本公告【发帖规则】";
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UIImageView *)disclosureIndicator {
    if (!_disclosureIndicator) {
        _disclosureIndicator = [[UIImageView alloc] init];
        _disclosureIndicator.image = [UIImage imageNamed:@"enter"];
    }
    return _disclosureIndicator;
}


- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"find_nightmeet_icon"];
    }
    return _iconImageView;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.text = @"1.此版块默认匿名发帖。\n2.杜绝色情、广告、人身攻击等。\n3.欢迎大家在此广泛吐槽";
        _detailLabel.textColor = [UIColor colorWithHexString:@"969696"];
        _detailLabel.numberOfLines = 3;
        _detailLabel.textAlignment = NSTextAlignmentLeft;
        _detailLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return _detailLabel;
}
@end
