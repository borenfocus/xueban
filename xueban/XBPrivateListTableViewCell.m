//
//  XBPrivateListTableViewCell.m
//  xueban
//
//  Created by dang on 2016/10/16.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBPrivateListTableViewCell.h"
#import "XBPrivateListCellDataKey.h"
#import "UIImageView+WebCache.h"

@interface XBPrivateListTableViewCell()

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation XBPrivateListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.avatarImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.subTitleLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.badgeLabel];
        [self.contentView addSubview:self.lineView];
        [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(20.0f);
            make.top.mas_offset(10.0f);
            make.bottom.mas_equalTo(-10.0f);
            make.width.equalTo(_avatarImageView.mas_height);
        }];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_avatarImageView.mas_right).offset(20.0f);
            make.right.offset(0.0f);
            make.top.offset(10.0f);
        }];
        [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_avatarImageView.mas_right).offset(20.0f);
            make.right.offset(-80.0f);
            make.bottom.offset(-10.0f);
        }];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleLabel.mas_top);
            make.right.offset(-15.0f);
        }];
        [_badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_subTitleLabel);
            make.right.offset(-15.0f);
            make.size.mas_equalTo(CGSizeMake(20.0f, 20.0f));
        }];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_avatarImageView.mas_left);
            make.right.bottom.offset(0);
            make.height.mas_equalTo(1.0f);
        }];
    }
    return self;
}

#pragma mark - public method
- (void)configWithDict:(NSDictionary *)dict {
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:dict[kPrivateListCellDataKeyHeadImg]]];
    if ([dict[kPrivateListCellDataKeyUnreadNum] integerValue] > 0) {
        _badgeLabel.text = [NSString stringWithFormat:@"%@", dict[kPrivateListCellDataKeyUnreadNum]];
        _badgeLabel.hidden = NO;
    } else {
        _badgeLabel.hidden = YES;
    }
    _titleLabel.text = dict[kPrivateListCellDataKeyRealName];
    _subTitleLabel.text = dict[kPrivateListCellDataKeyContent];
    _timeLabel.text = dict[kPrivateListCellDataKeyTime];
}

#pragma mark - getter and setter
- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    }
    return _avatarImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:18.0f];
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel{
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.textColor = [UIColor colorWithHexString:@"969696"];
        _subTitleLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return _subTitleLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor colorWithHexString:@"969696"];
        _timeLabel.font = [UIFont systemFontOfSize:13.0f];
    }
    return _timeLabel;
}

- (UILabel *)badgeLabel {
    if (!_badgeLabel) {
        _badgeLabel = [[UILabel alloc] init];
        _badgeLabel.layer.cornerRadius = 10;
        _badgeLabel.font = [UIFont systemFontOfSize:12.0f];
        _badgeLabel.textColor = [UIColor whiteColor];
        _badgeLabel.layer.backgroundColor = [UIColor colorWithHexString:RedColor].CGColor;
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _badgeLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    }
    return _lineView;
}

@end
