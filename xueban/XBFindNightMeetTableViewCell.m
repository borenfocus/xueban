//
//  XBFindNightMeetTableViewCell.m
//  xueban
//
//  Created by dang on 16/8/9.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBFindNightMeetTableViewCell.h"
#import "XBFindNightMeetTableViewCellDataKey.h"
#import "UIButton+WebCache.h"

@interface XBFindNightMeetTableViewCell ()
@property (nonatomic, strong) UIButton    *avatarButton;
@property (nonatomic, strong) UILabel     *nameLabel;
@property (nonatomic, strong) UIImageView *sexImageView;
@property (nonatomic, strong) UILabel     *timeLabel;
@property (nonatomic, strong) UIImageView *disclosureIndicator;

@property (nonatomic, strong) UIView      *lineView;
@property (nonatomic, strong) UILabel     *scanLabel;

@property (nonatomic, strong) UIControl   *zanControl;
@property (nonatomic, strong) UIControl   *commentControl;
@property (nonatomic, strong) UIButton    *commentButton;
@property (nonatomic, strong) UILabel     *commentLabel;
@end

@implementation XBFindNightMeetTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.avatarButton];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.sexImageView];
        [self.contentView addSubview:self.timeLabel];
        //[self.contentView addSubview:self.disclosureIndicator];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.scanLabel];
        
        [self.contentView addSubview:self.zanButton];
        [self.contentView addSubview:self.zanLabel];
        [self.contentView addSubview:self.zanControl];
        
        [self.contentView addSubview:self.commentButton];
        [self.contentView addSubview:self.commentLabel];
        [self.contentView addSubview:self.commentControl];
        [_avatarButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(15.0f);
            make.left.offset(20.0f);
            make.size.mas_equalTo(CGSizeMake(40.0f, 40.0f));
        }];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_avatarButton.mas_right).offset(20.0f);
            make.top.equalTo(_avatarButton.mas_top);
        }];
        [_sexImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_nameLabel);
            make.width.height.equalTo(_nameLabel.mas_height);
            make.left.equalTo(_nameLabel.mas_right).offset(10.0f);
        }];
        [_disclosureIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_nameLabel);
            make.size.mas_equalTo(CGSizeMake(7.5f, 14.5f));
            make.right.equalTo(self.contentView).offset(-20.0f);
        }];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_nameLabel.mas_left);
            make.right.offset(0.0f);
            make.bottom.equalTo(_avatarButton.mas_bottom);
        }];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(20.0f);
            make.right.offset(-20.0f);
            make.top.equalTo(_avatarButton.mas_bottom).offset(15.0f);
        }];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(20.0f);
            make.right.offset(-20.0f);
            make.height.mas_equalTo(1.0f);
            make.top.equalTo(_contentLabel.mas_bottom).offset(12.0f);
        }];
        [_scanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(20.0f);
            make.top.equalTo(_lineView.mas_bottom).offset(15.0f);
            make.bottom.equalTo(self.contentView).offset(-20.0f);
        }];
        [_zanButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_scanLabel);
            make.right.equalTo(_zanLabel.mas_left);
        }];
        [_zanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_scanLabel);
            make.right.mas_equalTo(_commentButton.mas_left).offset(-20.0f);
        }];
        [_zanControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_zanButton.mas_left).offset(-10.0f);
            make.right.equalTo(_zanLabel.mas_right).offset(10.0f);
            make.top.equalTo(_zanButton.mas_top).offset(-10.0f);
            make.bottom.equalTo(_zanButton.mas_bottom).offset(10.0f);
        }];
        [_commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_scanLabel);
            make.right.equalTo(_commentLabel.mas_left).offset(-3);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        [_commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-20.0f);
            make.centerY.equalTo(_scanLabel);
        }];
        [_commentControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_commentButton.mas_left).offset(-10.0f);
            make.right.equalTo(_commentLabel.mas_right).offset(10.0f);
            make.top.equalTo(_commentButton.mas_top).offset(-10.0f);
            make.bottom.equalTo(_commentButton.mas_bottom).offset(10.0f);
        }];
    }
    return self;
}

#pragma mark - public method
- (void)configWithDict:(NSDictionary *)dict
{
    _contentLabel.text = dict[kFindNightMeetTableViewCellDataKeyContent];
    _scanLabel.text = dict[kFindNightMeetTableViewCellDataKeyScanCount];
    _zanLabel.text = dict[kFindNightMeetTableViewCellDataKeyZanCount];
    _commentLabel.text = dict[kFindNightMeetTableViewCellDataKeyCommentCount];
    _nameLabel.text = dict[kFindNightMeetTableViewCellDataKeyName];
    _postId = [dict[kFindNightMeetTableViewCellDataKeyId] integerValue];
    _timeLabel.text = dict[kFindNightMeetTableViewCellDataKeyTime];
    if ([dict[kFindNightMeetTableViewCellDataKeySex] isEqual:@1])
    {
        _sexImageView.image = [UIImage imageNamed:@"find_sex_male"];
        [_avatarButton sd_setImageWithURL:dict[kFindNightMeetTableViewCellDataKeyAvatarUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"find_nightmeet_avatar_male"]];
    }
    else
    {
        _sexImageView.image = [UIImage imageNamed:@"find_sex_female"];
        [_avatarButton sd_setImageWithURL:dict[kFindNightMeetTableViewCellDataKeyAvatarUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"find_nightmeet_avatar_female"]];
    }
    if ([dict[kFindNightMeetTableViewCellDataKeyIsZan] isEqual:@1])
    {
        [_zanButton setSelected:YES];
    }
    else
    {
        [_zanButton setSelected:NO];
    }
}

#pragma mark - event response
- (void)clickAvatarButton
{
    if (self.avatarHandler)
    {
        self.avatarHandler();
    }
}

- (void)clickZanControl
{
    if (self.zanHandler)
    {
        [_zanButton click];
        self.zanHandler();
    }
}

- (void)clickCommentControl
{
    if (self.commentHandler)
    {
        self.commentHandler();
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
        [_avatarButton addTarget:self action:@selector(clickAvatarButton) forControlEvents:UIControlEventTouchUpInside];
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

- (UIImageView *)sexImageView
{
    if (!_sexImageView)
    {
        _sexImageView = [[UIImageView alloc] init];
    }
    return _sexImageView;
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

- (UIImageView *)disclosureIndicator
{
    if (!_disclosureIndicator)
    {
        _disclosureIndicator = [[UIImageView alloc] init];
        _disclosureIndicator.image = [UIImage imageNamed:@"enter"];
    }
    return _disclosureIndicator;
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

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    }
    return _lineView;
}

- (UILabel *)scanLabel
{
    if (!_scanLabel)
    {
        _scanLabel = [[UILabel alloc] init];
        _scanLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _scanLabel;
}

- (UIControl *)zanControl
{
    if (!_zanControl)
    {
        _zanControl = [[UIControl alloc] init];
        [_zanControl addTarget:self action:@selector(clickZanControl) forControlEvents:UIControlEventTouchUpInside];
    }
    return _zanControl;
}

- (XBZanButton *)zanButton
{
    if (!_zanButton)
    {
        _zanButton = [[XBZanButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [_zanButton setBackgroundImage:[UIImage imageNamed:@"find_nightmeet_zan_normal"] forState:UIControlStateNormal];
        [_zanButton setBackgroundImage:[UIImage imageNamed:@"find_nightmeet_zan_selected"] forState:UIControlStateSelected];
    }
    return _zanButton;
}

- (UILabel *)zanLabel
{
    if (!_zanLabel)
    {
        _zanLabel = [[UILabel alloc] init];
        _zanLabel.textColor = [UIColor blackColor];
        _zanLabel.font = [UIFont systemFontOfSize:12];
        _zanLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _zanLabel;
}

- (UIControl *)commentControl
{
    if (!_commentControl)
    {
        _commentControl = [[UIControl alloc] init];
        [_commentControl addTarget:self action:@selector(clickCommentControl) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentControl;
}

- (UIButton *)commentButton
{
    if (!_commentButton)
    {
        _commentButton = [[UIButton alloc] init];
        _commentButton.userInteractionEnabled = NO;
        [_commentButton setBackgroundImage:[UIImage imageNamed:@"find_nightmeet_comment_normal"] forState:UIControlStateNormal];
        [_commentButton setBackgroundImage:[UIImage imageNamed:@"find_nightmeet_comment_selected"] forState:UIControlStateSelected];
    }
    return _commentButton;
}

- (UILabel *)commentLabel
{
    if (!_commentLabel)
    {
        _commentLabel = [[UILabel alloc] init];
        _commentLabel.textColor = [UIColor blackColor];
        _commentLabel.font = [UIFont systemFontOfSize:12];
        _commentLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _commentLabel;
}

@end
