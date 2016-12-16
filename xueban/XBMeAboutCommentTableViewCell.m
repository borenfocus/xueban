//
//  XBMeAboutCommentTableViewCell.m
//  xueban
//
//  Created by dang on 2016/10/24.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBMeAboutCommentTableViewCell.h"
#import "XBMeAboutCellDataKey.h"
#import "UIButton+WebCache.h"

@interface XBMeAboutCommentTableViewCell()
@property (nonatomic, strong) UIButton *avatarButton;
@property (nonatomic, strong) UILabel  *nameLabel;
@property (nonatomic, strong) UILabel  *timeLabel;
@property (nonatomic, strong) UILabel  *commentLabel;
@property (nonatomic, strong) UIButton *contentDetailButton;
@property (nonatomic, strong) UILabel  *contentLabel;
@end

@implementation XBMeAboutCommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.avatarButton];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.commentLabel];
        [self.contentView addSubview:self.contentDetailButton];
        [self.contentView addSubview:self.contentLabel];
        [_avatarButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(15.0f);
            make.left.offset(15.0f);
            make.size.mas_equalTo(CGSizeMake(40.0f, 40.0f));
        }];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_avatarButton.mas_right).offset(15.0f);
            make.top.equalTo(_avatarButton.mas_top);
        }];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_nameLabel.mas_left);
            make.right.offset(0.0f);
            make.bottom.equalTo(_avatarButton.mas_bottom);
        }];
        [_commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_avatarButton.mas_bottom).offset(15.0f);
            make.left.offset(15.0f);
            make.right.offset(-15.0f);
        }];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(30.0f);
            make.right.bottom.offset(-30.0f);
            make.top.equalTo(_commentLabel.mas_bottom).offset(30.0f);
            make.bottom.offset(-30.0f);
        }];
        [_contentDetailButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_commentLabel.mas_bottom).offset(15.0f);
            make.left.offset(15.0f);
            make.right.offset(-15.0f);
            make.bottom.offset(-15.0f);
        }];
    }
    return self;
}

#pragma mark - public method
- (void)configWithDict:(NSDictionary *)dict
{
    [_avatarButton sd_setBackgroundImageWithURL:[NSURL URLWithString:dict[kMeAboutCellDataKeyHeadImg]] forState:UIControlStateNormal];
    _nameLabel.text = dict[kMeAboutCellDataKeyRealName];
    _timeLabel.text = dict[kMeAboutCellDataKeyTime];
    _commentLabel.text = dict[kMeAboutCellDataKeyCommentContent];
    _contentLabel.text = dict[kMeAboutCellDataKeyPostContent];
}

#pragma mark - event response
- (void)clickContentDetailButton
{
    if (self.contentDetailHandler)
    {
        self.contentDetailHandler();
    }
}

#pragma mark - getter and setter
- (UIButton *)avatarButton
{
    if (!_avatarButton)
    {
        _avatarButton = [[UIButton alloc] init];
        _avatarButton.layer.cornerRadius = 20.0f;
        _avatarButton.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        _avatarButton.clipsToBounds = YES;
    }
    return _avatarButton;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel)
    {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel)
    {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor colorWithHexString:@"969696"];
        _timeLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    return _timeLabel;
}

- (UILabel *)commentLabel
{
    if (!_commentLabel)
    {
        _commentLabel = [[UILabel alloc] init];
        _commentLabel.numberOfLines = 0;
    }
    return _commentLabel;
}

- (UIButton *)contentDetailButton
{
    if (!_contentDetailButton)
    {
        _contentDetailButton = [[UIButton alloc] init];
        _contentDetailButton.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00];
        [_contentDetailButton addTarget:self action:@selector(clickContentDetailButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _contentDetailButton;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel)
    {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return _contentLabel;
}
@end
