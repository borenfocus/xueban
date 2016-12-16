//
//  XBBoxCenterTableViewCell.m
//  xueban
//
//  Created by dang on 16/7/11.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBBoxCenterTableViewCell.h"
#import "XBBoxCenterCellDataKey.h"

@interface XBBoxCenterTableViewCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *readAllLabel;
@property (nonatomic, strong) UIImageView *disclosureIndicator;

@end

@implementation XBBoxCenterTableViewCell

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

#pragma mark - public method
- (void)configWithDict:(NSDictionary *)dict {
    _titleLabel.text = dict[kBoxCenterCellDataKeyTitle];
    _timeLabel.text = dict[kBoxCenterCellDataKeyTime];
    if ([dict[kBoxCenterCellDataKeyType] isEqual:@1]) {
        [self.contentView addSubview:self.newsImageView];
        [self.contentView addSubview:self.readAllLabel];
        [self.contentView addSubview:self.disclosureIndicator];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-15.0f);
            make.bottom.equalTo(_newsImageView.mas_top).offset(-5.0f);
        }];
        [_newsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15.0f);
            make.right.offset(-15.0f);
//            make.height.mas_equalTo(_newsImageView.mas_width).multipliedBy(3.2/5.2);
            make.height.mas_equalTo([self.imageViewHeight floatValue]);
            make.bottom.mas_equalTo(_readAllLabel.mas_top).offset(-15.0f);
        }];
        [_readAllLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_titleLabel);
            make.bottom.offset(-15.0f);
        }];
        [_disclosureIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_readAllLabel);
            make.right.equalTo(_titleLabel.mas_right);
            make.size.mas_equalTo(CGSizeMake(7.5f, 14.5f));
        }];
    } else {
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-15.0f);
            make.bottom.offset(-10.0f);
        }];
    }
}

#pragma mark - private method
- (void)setup {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.timeLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15.0f);
        make.top.offset(20.0f);
        //make.size.mas_equalTo(CGSizeMake(150, 30));
        make.right.offset(-15.0f);
        make.bottom.equalTo(_timeLabel.mas_top).offset(-5.0f);
    }];
}

#pragma mark - getter and setter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:18.0];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor colorWithHexString:@"969696"];
        _timeLabel.font = [UIFont systemFontOfSize:14.0f];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _timeLabel;
}

- (UIImageView *)newsImageView {
    if (!_newsImageView) {
        _newsImageView = [[UIImageView alloc] init];
        _newsImageView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    }
    return _newsImageView;
}

- (UILabel *)readAllLabel {
    if (!_readAllLabel) {
        _readAllLabel = [[UILabel alloc] init];
        _readAllLabel.text = @"阅读全文";
        _readAllLabel.textColor = [UIColor blackColor];
        _readAllLabel.font = [UIFont systemFontOfSize:13.0f];
    }
    return _readAllLabel;
}

- (UIImageView *)disclosureIndicator {
    if (!_disclosureIndicator) {
        _disclosureIndicator = [[UIImageView alloc] init];
        _disclosureIndicator.image = [UIImage imageNamed:@"enter"];
    }
    return _disclosureIndicator;
}
@end
