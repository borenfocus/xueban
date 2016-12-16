//
//  XBMeCollectionTableViewCell.m
//  xueban
//
//  Created by dang on 2016/10/18.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBMeCollectionTableViewCell.h"
#import "XBMeCollectionCellDataKey.h"
#import "UIImageView+WebCache.h"

@interface XBMeCollectionTableViewCell ()
@property (nonatomic, strong) UIImageView *officialImageView;
@property (nonatomic, strong) UILabel *officialTitleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *postImageView;
@property (nonatomic, strong) UILabel *contentLabel;
@end

@implementation XBMeCollectionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.officialImageView];
        [self.contentView addSubview:self.officialTitleLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.postImageView];
        [self.contentView addSubview:self.contentLabel];
        [_officialImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.offset(20.0f);
            make.size.mas_equalTo(CGSizeMake(20.0f, 20.0f));
        }];
        [_officialTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_officialImageView);
            make.left.equalTo(_officialImageView.mas_right).offset(15.0f);
        }];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_officialImageView);
            make.right.offset(-20.0f);
        }];
        [_postImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_officialImageView.mas_left);
            make.top.equalTo(_officialImageView.mas_bottom).offset(15.0f);
            make.bottom.offset(-20.0f);
            make.width.mas_equalTo(_postImageView.mas_height);
        }];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_postImageView.mas_top);
            make.left.equalTo(_postImageView.mas_right).offset(15.0f);
            make.right.offset(-30.0f);
        }];
    }
    return self;
}

#pragma mark - public method
- (void)configWithDict:(NSDictionary *)dict {
    [_officialImageView sd_setImageWithURL:[NSURL URLWithString:dict[kMeCollectionCellDataKeyOfficialImageUrl]]];
    _officialTitleLabel.text = dict[kMeCollectionCellDataKeyOfficialTitle];
    _timeLabel.text = dict[kMeCollectionCellDataKeyTime];
    [_postImageView sd_setImageWithURL:[NSURL URLWithString:dict[kMeCollectionCellDataKeyImageUrl]]];
    _contentLabel.text = dict[kMeCollectionCellDataKeyTitle];
}

#pragma mark - getter and setter
- (UIImageView *)officialImageView {
    if (!_officialImageView) {
        _officialImageView = [[UIImageView alloc] init];
        _officialImageView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    }
    return _officialImageView;
}

- (UILabel *)officialTitleLabel {
    if (!_officialTitleLabel) {
        _officialTitleLabel = [[UILabel alloc] init];
        _officialTitleLabel.textColor = [UIColor colorWithHexString:@"969696"];
        _officialTitleLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return _officialTitleLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor colorWithHexString:@"969696"];
        _timeLabel.font = [UIFont systemFontOfSize:13.0f];
    }
    return _timeLabel;
}

- (UIImageView *)postImageView {
    if (!_postImageView) {
        _postImageView = [[UIImageView alloc] init];
        _postImageView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    }
    return _postImageView;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
    }
    return _contentLabel;
}
@end
