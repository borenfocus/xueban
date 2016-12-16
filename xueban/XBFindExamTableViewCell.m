//
//  XBFindExamTableViewCell.m
//  xueban
//
//  Created by dang on 16/7/26.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBFindExamTableViewCell.h"
#import "XBFindExamTableViewCellDataKey.h"

@interface XBFindExamTableViewCell()
@property (nonatomic, strong) UIView *whiteBgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *countDownLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *overImageView;
@end

@implementation XBFindExamTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        [self.contentView addSubview:self.whiteBgView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.countDownLabel];
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.locationLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.overImageView];
        [_whiteBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(15.0f);
            make.left.equalTo(self.contentView).offset(0.0f);
            make.right.equalTo(self.contentView).offset(0.0f);
            make.bottom.offset(0);
        }];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_whiteBgView.mas_left).offset(20.0f);
            make.top.equalTo(_whiteBgView).offset(20.0f);
//            make.right.equalTo(_countDownLabel.mas_left).offset(-10.0f);
            make.right.offset(-140.0f);
        }];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_nameLabel.mas_bottom).offset(10.0f);
            make.left.equalTo(_nameLabel);
            make.right.equalTo(_whiteBgView.mas_right);
            make.height.mas_equalTo(1.0f);
        }];
        [_locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_nameLabel);
            make.top.equalTo(_lineView.mas_bottom).offset(10.0f);
            make.right.equalTo(_whiteBgView.mas_right);
        }];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_nameLabel);
            make.top.equalTo(_locationLabel.mas_bottom).offset(10.0f);
            make.right.equalTo(_whiteBgView.mas_right);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-15.0f);
        }];
        [_overImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(30.0f);
            make.right.offset(-15.0f);
            make.size.mas_equalTo(CGSizeMake(75.0f, 75.0f));
        }];
    }
    return self;
}

#pragma mark - public method
- (void)configWithDict:(NSDictionary *)dict {
    _nameLabel.text = dict[kFindExamTableViewCellDataKeyName];
    if ([dict[kFindExamTableViewCellDataKeyCountDown] isEqualToString:@"已过期"]) {
        _overImageView.hidden = NO;
        _countDownLabel.hidden = YES;
        _nameLabel.textColor = [UIColor colorWithHexString:@"969696"];
    } else if ([dict[kFindExamTableViewCellDataKeyCountDown] isEqualToString:@"none"]) {
        _overImageView.hidden = YES;
        _countDownLabel.hidden = YES;
        _nameLabel.textColor = [UIColor blackColor];
    } else {
        _overImageView.hidden = YES;
        _countDownLabel.hidden = NO;
        _countDownLabel.text = dict[kFindExamTableViewCellDataKeyCountDown];
        _nameLabel.textColor = [UIColor blackColor];
    }
    _locationLabel.text = dict[kFindExamTableViewCellDataKeyLocation];
    _timeLabel.text = dict[kFindExamTableViewCellDataKeyTime];
}

#pragma mark - getter and setter
- (UIView *)whiteBgView {
    if (!_whiteBgView) {
        _whiteBgView = [[UIView alloc] init];
        _whiteBgView.backgroundColor = [UIColor whiteColor];
    }
    return _whiteBgView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.numberOfLines = 0;
        _nameLabel.font = [UIFont systemFontOfSize:18.0f];
    }
    return _nameLabel;
}

- (UILabel *)countDownLabel {
    if (!_countDownLabel) {
        _countDownLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH-120, 20+10, 120, 30)];
        _countDownLabel.backgroundColor = [UIColor colorWithHexString:MainColor];
        _countDownLabel.textColor = [UIColor blackColor];
        _countDownLabel.textAlignment = NSTextAlignmentCenter;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_countDownLabel.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _countDownLabel.bounds;
        maskLayer.path = maskPath.CGPath;
        _countDownLabel.layer.mask = maskLayer;
    }
    return _countDownLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    }
    return _lineView;
}

- (UILabel *)locationLabel {
    if (!_locationLabel) {
        _locationLabel = [[UILabel alloc] init];
        _locationLabel.textColor = [UIColor colorWithHexString:@"969696"];
        _locationLabel.textAlignment = NSTextAlignmentLeft;
        _locationLabel.font = [UIFont systemFontOfSize:17.0f];
    }
    return _locationLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor colorWithHexString:@"969696"];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.font = [UIFont systemFontOfSize:17.0f];
    }
    return _timeLabel;
}

- (UIImageView *)overImageView
{
    if (!_overImageView)
    {
        _overImageView = [[UIImageView alloc] init];
        _overImageView.image = [UIImage imageNamed:@"find_exam_expire"];
    }
    return _overImageView;
}
@end
