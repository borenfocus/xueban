//
//  XBFindScoreTableViewCell.m
//  xueban
//
//  Created by dang on 16/7/26.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBFindScoreTableViewCell.h"
#import "XBFindScoreTableViewCellDataKey.h"

@interface XBFindScoreTableViewCell ()

@property (nonatomic, strong) UIView  *whiteBgView;
@property (nonatomic, strong) UILabel *nameLabel;
 /** 第一次出现该条成绩时在右面添加一个蓝色的圆点*/
@property (nonatomic, strong) UIView  *bluePoint;
@property (nonatomic, strong) UIView  *lineView;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UILabel *creditLabel;
@property (nonatomic, strong) UILabel *statusLabel;

@end

@implementation XBFindScoreTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        [self.contentView addSubview:self.whiteBgView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.bluePoint];
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.typeLabel];
        [self.contentView addSubview:self.scoreLabel];
        [self.contentView addSubview:self.creditLabel];
        [self.contentView addSubview:self.statusLabel];
        [_whiteBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(10.0f);
            make.left.right.bottom.offset(0.0f);
        }];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_whiteBgView.mas_left).offset(20.0f);
            make.top.equalTo(_whiteBgView).offset(20.0f);
            make.right.equalTo(_bluePoint.mas_left).offset(-5.0f);
        }];
        [_bluePoint mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_nameLabel);
            make.right.equalTo(_whiteBgView.mas_right).offset(-20.0f);
            make.size.mas_equalTo(CGSizeMake(10.0f, 10.0f));
        }];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_nameLabel.mas_bottom).offset(10.0f);
            make.left.equalTo(_nameLabel);
            make.right.equalTo(_whiteBgView.mas_right);
            make.height.mas_equalTo(1.0f);
        }];
        [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_nameLabel);
            make.top.equalTo(_lineView.mas_bottom).offset(10.0f);
        }];
        [_scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_typeLabel);
            make.right.equalTo(_whiteBgView.mas_right);
            make.left.equalTo(self.contentView.mas_centerX).offset(10.0f);
        }];
        [_creditLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_nameLabel);
            make.top.equalTo(_typeLabel.mas_bottom).offset(10.0f);
            make.bottom.equalTo(_whiteBgView.mas_bottom).offset(-5.0f);
        }];
        [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_creditLabel);
            make.left.equalTo(_scoreLabel);
        }];
    }
    return self;
}

#pragma mark - public method
- (void)configWithDict:(NSDictionary *)dict {
    _nameLabel.text = dict[kFindScoreTableViewCellDataKeyName];
    _typeLabel.text = dict[kFindScoreTableViewCellDataKeyType];
    _scoreLabel.text = dict[kFindScoreTableViewCellDataKeyScore];
    _creditLabel.text = dict[kFindScoreTableViewCellDataKeyCredit];
    _statusLabel.text = dict[kFindScoreTableViewCellDataKeyStatus];
    if ([dict[kFindScoreTableViewCellDataKeyState] integerValue] == 0) {
        _bluePoint.hidden = NO;
    } else {
        _bluePoint.hidden = YES;
    }
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

- (UIView *)bluePoint {
    if (!_bluePoint) {
        _bluePoint = [[UIView alloc] init];
        _bluePoint.hidden = YES;
        _bluePoint.backgroundColor = [UIColor colorWithHexString:BlueColor];
        _bluePoint.layer.cornerRadius = 5.0f;
        _bluePoint.clipsToBounds = YES;
    }
    return _bluePoint;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    }
    return _lineView;
}

- (UILabel *)typeLabel {
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.textColor = [UIColor colorWithHexString:@"969696"];
        _typeLabel.textAlignment = NSTextAlignmentLeft;
        _typeLabel.font = [UIFont systemFontOfSize:17.0f];
    }
    return _typeLabel;
}

- (UILabel *)scoreLabel {
    if (!_scoreLabel) {
        _scoreLabel = [[UILabel alloc] init];
        _scoreLabel.textColor = [UIColor colorWithHexString:@"969696"];
        _scoreLabel.textAlignment = NSTextAlignmentLeft;
        _scoreLabel.font = [UIFont systemFontOfSize:17.0f];
    }
    return _scoreLabel;
}

- (UILabel *)creditLabel {
    if (!_creditLabel) {
        _creditLabel = [[UILabel alloc] init];
        _creditLabel.textColor = [UIColor colorWithHexString:@"969696"];
        _creditLabel.textAlignment = NSTextAlignmentLeft;
        _creditLabel.font = [UIFont systemFontOfSize:17.0f];
    }
    return _creditLabel;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.textColor = [UIColor colorWithHexString:@"969696"];
        _statusLabel.textAlignment = NSTextAlignmentLeft;
        _statusLabel.font = [UIFont systemFontOfSize:17.0f];
    }
    return _statusLabel;
}

@end
