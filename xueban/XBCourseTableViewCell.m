//
//  XBCourseTableViewCell.m
//  xueban
//
//  Created by dang on 2016/10/30.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBCourseTableViewCell.h"
#import "XBCourseCellDataKey.h"

@interface XBCourseTableViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel     *className;
@property (nonatomic, strong) UIView      *lineView;
@property (nonatomic, strong) UIImageView *timeImageView;
@property (nonatomic, strong) UILabel     *timeLabel;
@property (nonatomic, strong) UIImageView *weekImageView;
@property (nonatomic, strong) UILabel     *weekLabel;
@property (nonatomic, strong) UIImageView *locationImageView;
@property (nonatomic, strong) UILabel     *locationLabel;
@property (nonatomic, strong) UIImageView *teacherImageView;
@property (nonatomic, strong) UILabel     *teacherLabel;
@property (nonatomic, strong) UIImageView *creditImageView;
@property (nonatomic, strong) UILabel     *creditLabel;

@end

@implementation XBCourseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.iconImageView];
        [self addSubview:self.className];
        [self addSubview:self.lineView];
        [self addSubview:self.timeImageView];
        [self addSubview:self.timeLabel];
        [self addSubview:self.weekImageView];
        [self addSubview:self.weekLabel];
        [self addSubview:self.locationImageView];
        [self addSubview:self.locationLabel];
        [self addSubview:self.teacherImageView];
        [self addSubview:self.teacherLabel];
        [self addSubview:self.creditImageView];
        [self addSubview:self.creditLabel];
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(15.0f);
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.left.equalTo(self).offset(20.0f);
        }];
        [_className mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImageView.mas_right).offset(5);
            make.right.offset(-30);
            make.centerY.equalTo(self.iconImageView);
        }];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20.0f);
            make.right.equalTo(self).offset(-20.0f);
            make.top.equalTo(self.iconImageView.mas_bottom).offset(10.0f);
            make.height.mas_equalTo(2);
        }];
        [_timeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20.0f);
            make.size.mas_equalTo(CGSizeMake(20, 20));
            make.top.equalTo(self.lineView.mas_bottom).offset(15.0f);
        }];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_timeImageView.mas_right).offset(10.0f);
            make.centerY.equalTo(self.timeImageView);
            make.right.equalTo(self.lineView.mas_right);
        }];
        [_weekImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.timeImageView.mas_bottom).offset(15.0f);
            make.left.equalTo(self.timeImageView);
            make.size.mas_equalTo(self.timeImageView);
        }];
        [_weekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.timeLabel);
            make.centerY.equalTo(self.weekImageView);
            make.right.equalTo(self.timeLabel.mas_right);
        }];
        [_locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.weekImageView.mas_bottom).offset(15.0f);
            make.left.equalTo(self.timeImageView);
            make.size.mas_equalTo(self.timeImageView);
        }];
        [_locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.timeLabel);
            make.centerY.equalTo(self.locationImageView);
            make.right.equalTo(self.timeLabel.mas_right);
        }];
        [_teacherImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.locationImageView.mas_bottom).offset(15.0f);
            make.left.equalTo(self.timeImageView);
            make.size.mas_equalTo(self.timeImageView);
        }];
        [_teacherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.timeLabel);
            make.centerY.equalTo(self.teacherImageView);
            make.right.equalTo(self.timeLabel.mas_right);
        }];
        [_creditImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.teacherImageView.mas_bottom).offset(15.0f);
            make.left.equalTo(self.timeImageView);
            make.size.mas_equalTo(self.timeImageView);
        }];
        [_creditLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.timeLabel);
            make.centerY.equalTo(self.creditImageView);
            make.right.equalTo(self.timeLabel.mas_right);
        }];
    }
    return self;
}

#pragma mark - public method
- (void)configWithDict:(NSDictionary *)dict {
    _className.text = dict[kCourseCellDataKeyName];
    _timeLabel.text = [NSString stringWithFormat:@"时间 ：%@", dict[kCourseCellDataKeyTime]];
    _weekLabel.text = [NSString stringWithFormat:@"周数 ：%@", dict[kCourseCellDataKeyWeek]];
    _locationLabel.text = [NSString stringWithFormat:@"地点 ：%@", dict[kCourseCellDataKeyLocation]];
    _teacherLabel.text = [NSString stringWithFormat:@"老师 ：%@", dict[kCourseCellDataKeyTeacher]];
    _creditLabel.text = [NSString stringWithFormat:@"学分 ：%@", dict[kCourseCellDataKeyCredit]];
}

#pragma mark - getters and setters
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"erp_classdetail_icon"];
    }
    return _iconImageView;
}

- (UILabel *)className {
    if (!_className) {
        _className = [[UILabel alloc] init];
        _className.font = [UIFont systemFontOfSize:18.0f];
    }
    return _className;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:MainColor];
    }
    return _lineView;
}

- (UIImageView *)timeImageView {
    if (!_timeImageView) {
        _timeImageView = [[UIImageView alloc] init];
        _timeImageView.image = [UIImage imageNamed:@"erp_classdetail_time"];
    }
    return _timeImageView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor colorWithHexString:@"969696"];
        _timeLabel.font = [UIFont systemFontOfSize:16.0f];
    }
    return _timeLabel;
}

- (UIImageView *)weekImageView {
    if (!_weekImageView) {
        _weekImageView = [[UIImageView alloc] init];
        _weekImageView.image = [UIImage imageNamed:@"erp_classdetail_week"];
    }
    return _weekImageView;
}

- (UILabel *)weekLabel {
    if (!_weekLabel) {
        _weekLabel = [[UILabel alloc] init];
        _weekLabel.textColor = [UIColor colorWithHexString:@"969696"];
        _weekLabel.font = [UIFont systemFontOfSize:16.0f];
    }
    return _weekLabel;
}

- (UIImageView *)locationImageView {
    if (!_locationImageView) {
        _locationImageView = [[UIImageView alloc] init];
        _locationImageView.image = [UIImage imageNamed:@"erp_classdetail_location"];
    }
    return _locationImageView;
}

- (UILabel *)locationLabel {
    if (!_locationLabel) {
        _locationLabel = [[UILabel alloc] init];
        _locationLabel.textColor = [UIColor colorWithHexString:@"969696"];
        _locationLabel.font = [UIFont systemFontOfSize:16.0f];
    }
    return _locationLabel;
}

- (UIImageView *)teacherImageView {
    if (!_teacherImageView) {
        _teacherImageView = [[UIImageView alloc] init];
        _teacherImageView.image = [UIImage imageNamed:@"erp_classdetail_teacher"];
    }
    return _teacherImageView;
}

- (UILabel *)teacherLabel {
    if (!_teacherLabel) {
        _teacherLabel = [[UILabel alloc] init];
        _teacherLabel.textColor = [UIColor colorWithHexString:@"969696"];
        _teacherLabel.font = [UIFont systemFontOfSize:16.0f];
    }
    return _teacherLabel;
}

- (UIImageView *)creditImageView {
    if (!_creditImageView) {
        _creditImageView = [[UIImageView alloc] init];
        _creditImageView.image = [UIImage imageNamed:@"erp_classdetail_credit"];
    }
    return _creditImageView;
}

- (UILabel *)creditLabel {
    if (!_creditLabel) {
        _creditLabel = [[UILabel alloc] init];
        _creditLabel.textColor = [UIColor colorWithHexString:@"969696"];
        _creditLabel.font = [UIFont systemFontOfSize:16.0f];
    }
    return _creditLabel;
}

@end
