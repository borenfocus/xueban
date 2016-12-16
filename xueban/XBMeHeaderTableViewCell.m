//
//  XBMeHeaderTableViewCell.m
//  xueban
//
//  Created by dang on 16/7/26.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBMeHeaderTableViewCell.h"
#import "XBPersonInfoKey.h"
#import "UIImageView+WebCache.h"

@interface XBMeHeaderTableViewCell()

@property (nonatomic, strong)UILabel     *titleLabel;
@property (nonatomic, strong)UILabel     *subTitleLabel;
@property (nonatomic, strong)UIImageView *disclosureIndicator;

@end

@implementation XBMeHeaderTableViewCell

- (instancetype)init {
    if (self = [super init]) {
        [self.contentView addSubview:self.circleImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.subTitleLabel];
        [self.contentView addSubview:self.disclosureIndicator];
        [_circleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(20.0f);
            make.top.mas_offset(10.0f);
            make.bottom.mas_equalTo(-10.0f);
            make.width.equalTo(_circleImageView.mas_height);
        }];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_circleImageView.mas_right).offset(20.0f);
            make.right.offset(0.0f);
            make.top.offset(20.0f);
        }];
        [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_circleImageView.mas_right).offset(20.0f);
            make.right.offset(0.0f);
            make.bottom.offset(-20.0f);
        }];
        [_disclosureIndicator mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(7.5f, 14.5f));
            make.right.equalTo(self.contentView).offset(-20.0f);
        }];
    }
    return self;
}

#pragma mark - public method
- (void)configWithDict:(NSDictionary *)dict {
    _titleLabel.text = dict[kPersonInfoRealName];
    _circleImageView.layer.cornerRadius = (100-10-10)/2;
    _circleImageView.clipsToBounds = YES;
    [_circleImageView sd_setImageWithURL:[NSURL URLWithString:dict[kPersonInfoAvatarUrl]] placeholderImage:nil];
}

#pragma mark getter and setter
- (UIImageView *)circleImageView {
    if (!_circleImageView) {
        _circleImageView = [[UIImageView alloc] init];
        _circleImageView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        _circleImageView.clipsToBounds = YES;
    }
    return _circleImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:18.0f];
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel{
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        //FIXME: 数据不应该在这里
        NSArray *weekDayArr = @[@"一", @"二", @"三", @"四", @"五", @"六", @"日"];
        NSInteger nowWeekNum = [[[NSUserDefaults standardUserDefaults] objectForKey:@"weekNum"] integerValue];
        NSInteger nowWeekDay = [[[NSUserDefaults standardUserDefaults] objectForKey:@"weekDay"] integerValue];
        _subTitleLabel.text = [NSString stringWithFormat:@"第%ld周 星期%@", (long)nowWeekNum, weekDayArr[nowWeekDay-1]];
        _subTitleLabel.textColor = [UIColor colorWithHexString:@"969696"];
        _subTitleLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return _subTitleLabel;
}

- (UIImageView *)disclosureIndicator {
    if (!_disclosureIndicator) {
        _disclosureIndicator = [[UIImageView alloc] init];
        _disclosureIndicator.image = [UIImage imageNamed:@"enter"];
    }
    return _disclosureIndicator;
}

@end
