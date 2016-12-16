//
//  XBSocialInfoContainerView.m
//  xueban
//
//  Created by dang on 2016/10/27.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBSocialInfoContainerView.h"
#import "XBFindSocialCellDataKey.h"
#import "UIImageView+WebCache.h"
#import "XBZoomPictureTool.h"

@interface XBSocialInfoContainerView ()

@property (nonatomic, strong) UIView      *whiteTopBackgroundView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIView      *coverView;
@property (nonatomic, strong) UIImageView *sexImageView;
@property (nonatomic, strong) UILabel     *nameLabel;
@property (nonatomic, strong) UILabel     *schoolLabel;
@property (nonatomic, strong) UIView      *whiteBottomBackgroundView;
@property (nonatomic, strong) UILabel     *addressLabel;
@property (nonatomic, strong) UILabel     *addressDetailLabel;

@property (nonatomic, strong) UIButton    *chatButton;

@end

@implementation XBSocialInfoContainerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        
        [self addSubview:self.whiteTopBackgroundView];
        [_whiteTopBackgroundView addSubview:self.avatarImageView];
        [_whiteTopBackgroundView addSubview:self.coverView];
        [_coverView addSubview:self.sexImageView];
        [_coverView addSubview:self.nameLabel];
        [_whiteTopBackgroundView addSubview:self.schoolLabel];
        [self addSubview:self.whiteBottomBackgroundView];
        [_whiteBottomBackgroundView addSubview:self.addressLabel];
        [_whiteBottomBackgroundView addSubview:self.addressDetailLabel];
        [self addSubview:self.chatButton];
        [_whiteTopBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.offset(0);
            make.bottom.equalTo(_schoolLabel.mas_bottom).offset(20.0f);
        }];
        [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(15.0f);
            make.centerX.equalTo(_whiteTopBackgroundView);
            make.size.mas_equalTo(CGSizeMake(80.0f, 80.0f));
        }];
        [_coverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_avatarImageView.mas_bottom).offset(15.0f);
            make.centerX.equalTo(_whiteTopBackgroundView);
            make.height.mas_equalTo(25.0f);
        }];
        [_sexImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_coverView.mas_left);
            make.size.mas_equalTo(CGSizeMake(20.0f, 20.0f));
            make.centerY.equalTo(_coverView);
        }];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_sexImageView.mas_right).offset(10.0f);
            make.centerY.equalTo(_coverView);
            make.right.equalTo(_coverView.mas_right);
        }];
        [_schoolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_whiteTopBackgroundView);
            make.top.equalTo(_coverView.mas_bottom).offset(15.0f);
        }];
        [_whiteBottomBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_whiteTopBackgroundView.mas_bottom).offset(10.0f);
            make.left.right.offset(0);
            make.height.mas_equalTo(44.0f);
        }];
        [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(20.0f);
            make.centerY.equalTo(_whiteBottomBackgroundView);
        }];
        [_addressDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_addressLabel.mas_right).offset(15.0f);
            make.centerY.equalTo(_whiteBottomBackgroundView);
        }];
        [_chatButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(25.0f);
            make.right.offset(-25.0f);
            make.top.equalTo(_whiteBottomBackgroundView.mas_bottom).offset(20.0f);
            make.height.mas_equalTo(40);
        }];
    }
    return self;
}

#pragma mark - event response
- (void)clickAvatarImageView {
    [[XBZoomPictureTool sharedInstance] showImage:self.avatarImageView];
}

- (void)clickChatButton {
    if (self.chatHandler) {
        self.chatHandler();
    }
}

#pragma mark - getter and setter
- (void)setConfigDict:(NSDictionary *)configDict {
    _configDict = configDict;
    if ([configDict[kFindSocialCellDataKeySex] isEqual:@1]) {
        _sexImageView.image = [UIImage imageNamed:@"find_sex_male"];
    } else {
        _sexImageView.image = [UIImage imageNamed:@"find_sex_female"];
    }
    [_avatarImageView sd_setImageWithURL:configDict[kFindSocialCellDataKeyHeadImg] placeholderImage:[UIImage imageNamed:@"find_nightmeet_avatar_male"]];
    _nameLabel.text = configDict[kFindSocialCellDataKeyRealName];
    _schoolLabel.text = [NSString stringWithFormat:@"大连理工大学 %@", configDict[kFindSocialCellDataKeyDepartment]];
    _addressDetailLabel.text = configDict[kFindSocialCellDataKeyProvince];
}

- (UIView *)whiteTopBackgroundView {
    if (!_whiteTopBackgroundView) {
        _whiteTopBackgroundView = [[UIView alloc] init];
        _whiteTopBackgroundView.backgroundColor = [UIColor whiteColor];
    }
    return _whiteTopBackgroundView;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        _avatarImageView.layer.cornerRadius = 40.0f;
        _avatarImageView.clipsToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAvatarImageView)];
        _avatarImageView.userInteractionEnabled = YES;
        [_avatarImageView addGestureRecognizer:tap];
    }
    return _avatarImageView;
}
- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = [UIColor clearColor];
    }
    return _coverView;
}

- (UIImageView *)sexImageView {
    if (!_sexImageView) {
        _sexImageView = [[UIImageView alloc] init];
    }
    return _sexImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont systemFontOfSize:16.0f];
    }
    return _nameLabel;
}

- (UILabel *)schoolLabel {
    if (!_schoolLabel) {
        _schoolLabel = [[UILabel alloc] init];
        _schoolLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _schoolLabel;
}

- (UIView *)whiteBottomBackgroundView {
    if (!_whiteBottomBackgroundView) {
        _whiteBottomBackgroundView = [[UIView alloc] init];
        _whiteBottomBackgroundView.backgroundColor = [UIColor whiteColor];
    }
    return _whiteBottomBackgroundView;
    
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.text = @"地区";
        _addressLabel.textColor = [UIColor blackColor];
        _addressLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return _addressLabel;
}

- (UILabel *)addressDetailLabel {
    if (!_addressDetailLabel) {
        _addressDetailLabel = [[UILabel alloc] init];
        _addressDetailLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return _addressDetailLabel;
}

- (UIButton *)chatButton {
    if (!_chatButton) {
        _chatButton = [[UIButton alloc] init];
        _chatButton.layer.cornerRadius = 5.0;
        _chatButton.clipsToBounds = YES;
        [_chatButton setBackgroundColor:[UIColor colorWithHexString:BlueColor]];
        [_chatButton setTitle:@"私信" forState:UIControlStateNormal];
        [_chatButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_chatButton addTarget:self action:@selector(clickChatButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chatButton;
}

@end
