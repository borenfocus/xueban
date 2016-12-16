//
//  XBFindSocialTableViewCell.m
//  xueban
//
//  Created by dang on 16/9/28.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBFindSocialTableViewCell.h"
#import "XBFindSocialCellDataKey.h"
#import "UIImageView+WebCache.h"

@interface XBFindSocialTableViewCell ()

@property (nonatomic, strong) UIView      *colorView;
@property (nonatomic, strong) UILabel     *nameLabel;
@property (nonatomic, strong) UIImageView *sexImageView;
@property (nonatomic, strong) UILabel     *schoolLabel;
@property (nonatomic, strong) UILabel     *schoolDetailLabel;
@property (nonatomic, strong) UILabel     *departmentLabel;
@property (nonatomic, strong) UILabel     *departmentDetailLabel;
@property (nonatomic, strong) UILabel     *majorLabel;
@property (nonatomic, strong) UILabel     *majorDetailLabel;
@property (nonatomic, strong) UIImageView *avatarImageView;

@end

@implementation XBFindSocialTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.colorView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.sexImageView];
        [self.contentView addSubview:self.schoolLabel];
        [self.contentView addSubview:self.schoolDetailLabel];
        [self.contentView addSubview:self.departmentLabel];
        [self.contentView addSubview:self.departmentDetailLabel];
        [self.contentView addSubview:self.majorLabel];
        [self.contentView addSubview:self.majorDetailLabel];
        [self.contentView addSubview:self.avatarImageView];

        [_colorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0.0f);
            make.top.offset(20.0f);
            make.size.mas_equalTo(CGSizeMake(20, 22));
        }];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_colorView);
            make.left.equalTo(_colorView.mas_right).offset(15.0f);
        }];
        [_sexImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_colorView);
            make.size.mas_equalTo(CGSizeMake(20.0f, 20.0f));
            make.left.equalTo(_nameLabel.mas_right).offset(15.0f);
        }];
        [_schoolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(20.0f);
            make.top.equalTo(_colorView.mas_bottom).offset(20.0f);
            make.width.mas_equalTo(35.0f);
        }];
        [_schoolDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_schoolLabel.mas_right).offset(15.0f);
            make.centerY.equalTo(_schoolLabel);
            make.right.equalTo(_avatarImageView.mas_left).offset(-5.0f);
        }];
        [_departmentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_schoolLabel.mas_left);
            make.top.equalTo(_schoolLabel.mas_bottom).offset(20.0f);
            make.right.equalTo(_schoolLabel.mas_right);
        }];
        [_departmentDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_departmentLabel);
            make.left.equalTo(_departmentLabel.mas_right).offset(15.0f);
            make.right.equalTo(_avatarImageView.mas_left).offset(-5.0f);
        }];
        [_majorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_schoolLabel.mas_left);
            make.top.equalTo(_departmentLabel.mas_bottom).offset(20.0f);
            make.right.equalTo(_schoolLabel.mas_right);
        }];
        [_majorDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_majorLabel);
            make.left.equalTo(_majorLabel.mas_right).offset(15.0f);
            make.right.equalTo(_avatarImageView.mas_left).offset(-5.0f);
        }];
        [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-20.0f);
            make.top.equalTo(_colorView.mas_top);
            make.bottom.equalTo(_majorLabel.mas_bottom);
            make.centerY.equalTo(self.contentView);
            make.width.mas_equalTo(_avatarImageView.mas_height);
        }];
    }
    return self;
}

#pragma mark - public method
- (void)configWithDict:(NSDictionary *)dict {
    _nameLabel.text = dict[kFindSocialCellDataKeyRealName];
    _schoolDetailLabel.text = dict[kFindSocialCellDataKeyUniversity];
    _departmentDetailLabel.text = dict[kFindSocialCellDataKeyDepartment];
    _majorDetailLabel.text = dict[kFindSocialCellDataKeyMajor];
    if ([dict[kFindSocialCellDataKeySex] isEqual:@1]) {
        _sexImageView.image = [UIImage imageNamed:@"find_sex_male"];
        [_avatarImageView sd_setImageWithURL:dict[kFindSocialCellDataKeyAvatarUrl] placeholderImage:nil options:SDWebImageProgressiveDownload];
    } else {
        _sexImageView.image = [UIImage imageNamed:@"find_sex_female"];
        [_avatarImageView sd_setImageWithURL:dict[kFindSocialCellDataKeyAvatarUrl]];
    }
}

#pragma mark getter and setter
- (UIView *)colorView {
    if (!_colorView) {
        _colorView = [[UIView alloc] init];
        _colorView.backgroundColor = [UIColor colorWithHexString:MainColor];
    }
    return _colorView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont systemFontOfSize:18.0f];
    }
    return _nameLabel;
}

- (UIImageView *)sexImageView {
    if (!_sexImageView) {
        _sexImageView = [[UIImageView alloc] init];
        _sexImageView.image = [UIImage imageNamed:@"find_sex_male"];
    }
    return _sexImageView;
}

- (UILabel *)schoolLabel {
    if (!_schoolLabel) {
        _schoolLabel = [[UILabel alloc] init];
        _schoolLabel.text = @"学校";
        _schoolLabel.textColor = [UIColor blackColor];
        _schoolLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return _schoolLabel;
}

- (UILabel *)schoolDetailLabel {
    if (!_schoolDetailLabel) {
        _schoolDetailLabel = [[UILabel alloc] init];
        _schoolDetailLabel.textAlignment = NSTextAlignmentLeft;
        _schoolDetailLabel.textColor = [UIColor colorWithHexString:@"969696"];
        _schoolDetailLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return _schoolDetailLabel;
}

- (UILabel *)departmentLabel {
    if(!_departmentLabel) {
        _departmentLabel = [[UILabel alloc] init];
        _departmentLabel.text = @"院系";
        _departmentLabel.textColor = [UIColor blackColor];
        _departmentLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return _departmentLabel;
}

- (UILabel *)departmentDetailLabel {
    if(!_departmentDetailLabel) {
        _departmentDetailLabel = [[UILabel alloc] init];
        _departmentDetailLabel.textAlignment = NSTextAlignmentLeft;
        _departmentDetailLabel.textColor = [UIColor colorWithHexString:@"969696"];
        _departmentDetailLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return _departmentDetailLabel;
}

- (UILabel *)majorLabel {
    if(!_majorLabel) {
        _majorLabel = [[UILabel alloc] init];
        _majorLabel.text = @"专业";
        _majorLabel.textColor = [UIColor blackColor];
        _majorLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return _majorLabel;
}

- (UILabel *)majorDetailLabel {
    if(!_majorDetailLabel) {
        _majorDetailLabel = [[UILabel alloc] init];
        _majorDetailLabel.textAlignment = NSTextAlignmentLeft;
        _majorDetailLabel.textColor = [UIColor colorWithHexString:@"969696"];
        _majorDetailLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return _majorDetailLabel;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _avatarImageView;
}
@end
