//
//  XBMeDetailHeaderTableViewCell.m
//  xueban
//
//  Created by dang on 2016/10/3.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBMeDetailHeaderTableViewCell.h"
#import "XBPersonInfoKey.h"
#import "UIImageView+WebCache.h"

@interface XBMeDetailHeaderTableViewCell ()

@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UIImageView *disclosureIndicator;

@end

@implementation XBMeDetailHeaderTableViewCell
- (instancetype)init {
    if (self = [super init]) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.avatarImageView];
        [self.contentView addSubview:self.disclosureIndicator];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20.0f);
            make.centerY.equalTo(self.contentView);
        }];
        [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(8.0f);
            make.bottom.offset(-8.0f);
            make.width.mas_equalTo(_avatarImageView.mas_height);
            make.right.mas_equalTo(_disclosureIndicator.mas_left).offset(-10.0f);
        }];
        [_disclosureIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.mas_equalTo(-20.0f);
            make.size.mas_equalTo(CGSizeMake(7.5f, 14.5f));
        }];
    }
    return self;
}

#pragma mark - public method
- (void)configWithDict:(NSDictionary *)dict {
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:dict[kPersonInfoAvatarUrl]]];
}

#pragma mark - getters and setters
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"头像";
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        _avatarImageView.layer.cornerRadius = (80-8-8)/2;
        _avatarImageView.clipsToBounds = YES;
    }
    return _avatarImageView;
}

- (UIImageView *)disclosureIndicator {
    if (!_disclosureIndicator) {
        _disclosureIndicator = [[UIImageView alloc] init];
        _disclosureIndicator.image = [UIImage imageNamed:@"enter"];
    }
    return _disclosureIndicator;
}

@end
