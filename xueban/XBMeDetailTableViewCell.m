//
//  XBMeDetailTableViewCell.m
//  xueban
//
//  Created by dang on 16/9/30.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBMeDetailTableViewCell.h"
#import "XBPersonInfoKey.h"

@interface XBMeDetailTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIView  *lineView;

@end

@implementation XBMeDetailTableViewCell

- (instancetype)init {
    if (self = [super init]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.detailLabel];
        [self.contentView addSubview:self.lineView];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20.0f);
            make.centerY.equalTo(self.contentView);
        }];
        [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-20.0f);
        }];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleLabel);
            make.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}

#pragma mark - public method
- (void)configWithDict:(NSDictionary *)dict AtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        self.titleLabel.text = @"性别";
        self.detailLabel.text = dict[kPersonInfoSex];
        [self.lineView setHidden:YES];
    } else if (indexPath.row == 5) {
        self.titleLabel.text = @"姓名";
        self.detailLabel.text = dict[kPersonInfoRealName];
    } else if (indexPath.row == 6) {
        self.titleLabel.text = @"学号";
        self.detailLabel.text = dict[kPersonInfoStudentNumber];
        [self.lineView setHidden:YES];
    } else if (indexPath.row == 8) {
        self.titleLabel.text = @"学校";
        self.detailLabel.text = dict[kPersonInfoCompus];
    } else if (indexPath.row == 9) {
        self.titleLabel.text = @"院系";
        self.detailLabel.text = dict[kPersonInfoDepartment];
        [self.lineView setHidden:YES];
    }
}

#pragma mark - getters and setters
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = [UIFont systemFontOfSize:15];
        _detailLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _detailLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    }
    return _lineView;
}

@end
