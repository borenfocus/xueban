//
//  XBMeTableViewCell.m
//  xueban
//
//  Created by dang on 16/7/26.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBMeTableViewCell.h"

@interface XBMeTableViewCell ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *disclosureIndicator;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation XBMeTableViewCell

- (instancetype)init
{
    if (self = [super init])
    {
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.badgeLabel];
        [self.contentView addSubview:self.disclosureIndicator];
        [self.contentView addSubview:self.lineView];
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(20.0f);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(150, 20));
            make.left.equalTo(_iconImageView.mas_right).offset(15.0f);
            make.centerY.equalTo(_iconImageView);
        }];
        [_badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.mas_equalTo(_disclosureIndicator.mas_left).offset(-10.0f);
            make.size.mas_equalTo(CGSizeMake(20.0f, 20.0f));
        }];
        [_disclosureIndicator mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(7.5f, 14.5f));
            make.right.equalTo(self.contentView).offset(-20.0f);
        }];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleLabel);
            make.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}

#pragma mark - public method
- (void)configureCellAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3)
    {
        _iconImageView.image = [UIImage imageNamed:@"me_post"];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.titleLabel.text = @"与我相关";
    }
    else if (indexPath.row == 4)
    {
        NSInteger allUnreadNum = 0;
        NSArray *unreadArray = [[NSUserDefaults standardUserDefaults] objectForKey:MyUnreadArray];
        for (NSDictionary *dict in unreadArray)
        {
            allUnreadNum += [dict[@"unreadNum"] integerValue];
        }
        if (allUnreadNum > 0)
        {
            _badgeLabel.hidden = NO;
            _badgeLabel.text = [NSString stringWithFormat:@"%ld", (long)[UIApplication sharedApplication].applicationIconBadgeNumber];
        }
        else
            _badgeLabel.hidden = YES;
        _iconImageView.image = [UIImage imageNamed:@"me_privateletter"];
        self.titleLabel.text = @"我的私信";
    }
    else if (indexPath.row == 5)
    {
        _iconImageView.image = [UIImage imageNamed:@"me_collection"];
        self.titleLabel.text = @"我的收藏";
        [self.lineView setHidden:YES];
    }
    else if (indexPath.row == 7)
    {
        _iconImageView.image = [UIImage imageNamed:@"me_file"];
        self.titleLabel.text = @"文件";
    }
    else if (indexPath.row == 8)
    {
        _iconImageView.image = [UIImage imageNamed:@"me_help"];
        self.titleLabel.text = @"帮助与反馈";
        [self.lineView setHidden:YES];
    }
    else if (indexPath.row == 10)
    {
        _iconImageView.image = [UIImage imageNamed:@"me_setting"];
        self.titleLabel.text = @"设置";
        [self.lineView setHidden:YES];
    }
}

#pragma mark - getters and setters
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UILabel *)badgeLabel
{
    if (!_badgeLabel)
    {
        _badgeLabel = [[UILabel alloc] init];
        _badgeLabel.hidden = YES;
        _badgeLabel.text = @"2";
        _badgeLabel.layer.cornerRadius = 10;
        _badgeLabel.font = [UIFont systemFontOfSize:12.0f];
        _badgeLabel.textColor = [UIColor whiteColor];
        _badgeLabel.layer.backgroundColor = [UIColor colorWithHexString:RedColor].CGColor;
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _badgeLabel;
}

- (UIImageView *)disclosureIndicator {
    if (!_disclosureIndicator) {
        _disclosureIndicator = [[UIImageView alloc] init];
        _disclosureIndicator.image = [UIImage imageNamed:@"enter"];
    }
    return _disclosureIndicator;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    }
    return _lineView;
}

@end
