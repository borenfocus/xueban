//
//  XBFindTableViewCell.m
//  xueban
//
//  Created by dang on 16/7/26.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBFindTableViewCell.h"

@interface XBFindTableViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation XBFindTableViewCell

- (instancetype)init {
    if (self = [super init]) {
        [self initView];
    }
    return self;
}

#pragma mark - public method
- (void)configureCellAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        _iconImageView.image = [UIImage imageNamed:@"find_nightmeet"];
        _titleLabel.text = @"卧谈会";
        [_lineView setHidden:YES];
    } else if (indexPath.row == 3) {
        _iconImageView.image = [UIImage imageNamed:@"find_bottle"];
        _titleLabel.text = @"我的同学";
    } else if (indexPath.row == 4) {
        _iconImageView.image = [UIImage imageNamed:@"find_producer"];
        _titleLabel.text = @"找同乡";
        [_lineView setHidden:YES];
    } else if (indexPath.row == 6) {
        _iconImageView.image = [UIImage imageNamed:@"find_library"];
        _titleLabel.text = @"图书馆";
        [_lineView setHidden:YES];
    } else if (indexPath.row == 8) {
        _iconImageView.image = [UIImage imageNamed:@"find_score"];
        _titleLabel.text = @"考试成绩";
    } else if (indexPath.row == 9) {
        _iconImageView.image = [UIImage imageNamed:@"find_exam"];
        _titleLabel.text = @"考场安排";
        [_lineView setHidden:YES];
    }
}

#pragma mark - private method
- (void)initView {
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
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
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
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

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    }
    return _lineView;
}

@end
