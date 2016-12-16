//
//  XBFindChatCommentTableViewCell.m
//  xueban
//
//  Created by dang on 2016/10/25.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBFindChatCommentTableViewCell.h"

@implementation XBFindChatCommentTableViewCell

- (instancetype)init {
    if (self = [super init]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.activityView];
        [self.contentView addSubview:self.alertLabel];
        [_activityView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(30.0f);
            make.centerX.equalTo(self.contentView);
        }];
        [_alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.centerY.equalTo(self.contentView);
        }];
    }
    return self;
}

- (UIActivityIndicatorView *)activityView {
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//        _activityView.color = [UIColor colorWithHexString:@"f5f5f5"];
        [_activityView startAnimating];
    }
    return _activityView;
}

- (UILabel *)alertLabel {
    if (!_alertLabel) {
        _alertLabel = [[UILabel alloc] init];
        _alertLabel.textColor = [UIColor colorWithHexString:@"969696"];
        _alertLabel.font = [UIFont systemFontOfSize:13.0f];
        _alertLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _alertLabel;
}

@end
