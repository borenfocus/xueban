//
//  XBMeSetTableViewCell.m
//  xueban
//
//  Created by dang on 16/8/15.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBMeSetTableViewCell.h"

@interface XBMeSetTableViewCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *disclosureIndicator;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation XBMeSetTableViewCell

- (instancetype)init
{
    if (self = [super init])
    {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.disclosureIndicator];
        [self.contentView addSubview:self.lineView];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(150, 20));
            make.left.offset(20.0f);
            make.centerY.equalTo(self.contentView);
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
- (void)configureCellAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3)
    {
        self.titleLabel.text = @"切换语言";
    }
    else if (indexPath.row == 4)
    {
        self.titleLabel.text = @"帮助与反馈";
    }
    else if (indexPath.row == 5)
    {
        self.titleLabel.text = @"关于";
        [self.lineView setHidden:YES];
    }
    else if (indexPath.row == 7)
    {
        self.titleLabel.text = @"退出登录";
        [self.disclosureIndicator setHidden:YES];
        [self.lineView setHidden:YES];
    }
}

#pragma mark - getters and setters
- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UIImageView *)disclosureIndicator
{
    if (!_disclosureIndicator)
    {
        _disclosureIndicator = [[UIImageView alloc] init];
        _disclosureIndicator.image = [UIImage imageNamed:@"enter"];
    }
    return _disclosureIndicator;
}

- (UIView *)lineView
{
    if (!_lineView)
    {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    }
    return _lineView;
}

@end
