//
//  XBFindNightMeetDetailTableViewCell.m
//  xueban
//
//  Created by dang on 16/8/10.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBFindNightMeetDetailTableViewCell.h"
#import "XBFindNightMeetDetailTableViewCellDataKey.h"
#import "UIButton+WebCache.h"

@interface XBFindNightMeetDetailTableViewCell ()

@property (nonatomic, strong) UIView   *topLineView;
@property (nonatomic, strong) UIButton *avatarButton;
@property (nonatomic, strong) UILabel  *nameLabel;
@property (nonatomic, strong) UILabel  *timeLabel;
@property (nonatomic, strong) UILabel  *contentLabel;

@end

@implementation XBFindNightMeetDetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.topLineView];
        [self.contentView addSubview:self.avatarButton];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.contentLabel];
        [_topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(20.0f);
            make.right.offset(-20.0f);
            make.height.mas_equalTo(1.0f);
            make.top.offset(0);
        }];
        [_avatarButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(15.0f);
            make.left.offset(20.0f);
            make.size.mas_equalTo(CGSizeMake(30.0f, 30.0f));
        }];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_avatarButton);
            make.left.equalTo(_avatarButton.mas_right).offset(15.0f);
        }];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_avatarButton);
            make.right.offset(-20.0f);
        }];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_avatarButton.mas_bottom);
            make.left.equalTo(_nameLabel.mas_left);
            make.right.offset(-20.0f);
            make.bottom.equalTo(self.contentView).offset(-15.0f);
        }];
    }
    return self;
}

#pragma mark - public method
- (void)configWithDict:(NSDictionary *)dict {
    [_avatarButton sd_setImageWithURL:dict[kFindNightMeetDetailTableViewCellDataKeyAvatarUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"find_nightmeet_avatar_male"]];
    
    //加载html数据
    NSString * htmlString = dict[kFindNightMeetDetailTableViewCellDataKeyContent];
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSFontAttributeName: [UIFont systemFontOfSize:15]} documentAttributes:nil error:nil];
    _contentLabel.attributedText = attrStr;

    _nameLabel.text = dict[kFindNightMeetDetailTableViewCellDataKeyName];
    _timeLabel.text = dict[kFindNightMeetDetailTableViewCellDataKeyTime];
}

#pragma mark - getter and setter
- (UIButton *)avatarButton {
    if (!_avatarButton) {
        _avatarButton = [[UIButton alloc] init];
        _avatarButton.layer.cornerRadius = 15.0f;
        _avatarButton.clipsToBounds = YES;
    }
    return _avatarButton;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return _nameLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor colorWithHexString:@"969696"];
        _timeLabel.font = [UIFont systemFontOfSize:13.0f];
    }
    return _timeLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return _contentLabel;
}

- (UIView *)topLineView {
    if (!_topLineView) {
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    }
    return _topLineView;
}

@end
