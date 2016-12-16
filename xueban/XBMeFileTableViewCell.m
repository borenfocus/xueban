//
//  XBMeFileTableViewCell.m
//  xueban
//
//  Created by dang on 16/8/10.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBMeFileTableViewCell.h"

@interface XBMeFileTableViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UIView      *lineView;

@end

@implementation XBMeFileTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.lineView];
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(20.0f);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(25.0f, 25.0f));
        }];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(_iconImageView.mas_right).offset(10.0f);
            make.right.offset(-20.0f);
        }];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(20.0f);
            make.bottom.right.offset(0);
            make.height.mas_equalTo(1.0f);
        }];
    }
    return self;
}

#pragma mark - getter and setter
- (void)setFileName:(NSString *)fileName {
    _fileName = fileName;
    _titleLabel.text = fileName;
    NSInteger location = [fileName rangeOfString:@"."].location;
    NSString *formate = [fileName substringFromIndex:location];
    UIImage * fileImage;
    if ([formate isEqual:@".apk"]) {
        fileImage = UIIMGName(@"me_file_apk");
    } else if ([formate isEqual:@".doc"] || [formate isEqual:@".docx"]) {
        fileImage = UIIMGName(@"me_file_doc");
    } else if ([formate isEqual:@".pdf"]) {
        fileImage = UIIMGName(@"me_file_pdf");
    } else if ([formate isEqual:@".jpg"]||[formate isEqual:@".jpeg"]||[formate isEqual:@".png"]) {
        fileImage = UIIMGName(@"me_file_pic");
    } else if ([formate isEqual:@".txt"]) {
        fileImage = UIIMGName(@"me_file_txt");
    } else if ([formate isEqual:@".xls"] || [formate isEqual:@".xlsx"]) {
        fileImage = UIIMGName(@"me_file_xls");
    } else if ([formate isEqual:@".zip"] ) {
        fileImage = UIIMGName(@"me_file_zip");
    } else {
        fileImage = UIIMGName(@"me_file_other");
    }
    _iconImageView.image = fileImage;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    }
    return _lineView;
}
@end
