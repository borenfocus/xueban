//
//  XBFindBookDetailTableViewCell.m
//  xueban
//
//  Created by dang on 2016/11/6.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBFindBookDetailTableViewCell.h"

@implementation XBFindBookDetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier]) {
        [self.contentView addSubview:self.titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15.0f);
            make.right.offset(-15.0f);
            make.top.offset(15.0f);
            make.bottom.offset(-15.0f);
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"此书刊可能正在订购中或者处理中";
        _titleLabel.textColor = [UIColor colorWithHexString:@"969696"];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

@end
