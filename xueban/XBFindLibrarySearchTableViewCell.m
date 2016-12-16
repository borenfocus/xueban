//
//  XBFindLibrarySearchTableViewCell.m
//  xueban
//
//  Created by dang on 16/9/19.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBFindLibrarySearchTableViewCell.h"
#import "XBFindLibrarySearchCellDataKey.h"
#import "UIImageView+WebCache.h"

@interface XBFindLibrarySearchTableViewCell ()
@property (nonatomic, strong) UIImageView *bookImageView;
@property (nonatomic, strong) UILabel *bookNameLabel;
@property (nonatomic, strong) UILabel *publisherLabel;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *codeLabel;
@property (nonatomic, strong) UILabel *bookNumLabel;
@end

@implementation XBFindLibrarySearchTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self.contentView addSubview:self.bookImageView];
        [self.contentView addSubview:self.bookNameLabel];
        [self.contentView addSubview:self.publisherLabel];
        [self.contentView addSubview:self.authorLabel];
        [self.contentView addSubview:self.codeLabel];
        [self.contentView addSubview:self.bookNumLabel];
        [_bookImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(25.0f);
            make.top.offset(20.0f);
            make.bottom.offset(-20.0f);
            make.width.mas_equalTo(_bookImageView.mas_height).multipliedBy(1/1.4);
        }];
        [_bookNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_bookImageView.mas_right).offset(20.0f);
            make.top.equalTo(_bookImageView.mas_top);
            make.right.offset(-25.0f);
        }];
        [_publisherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_bookNameLabel.mas_left);
            make.bottom.equalTo(_authorLabel.mas_top).offset(-5.0f);
            make.right.offset(-20.0f);
        }];
        [_authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_bookNameLabel.mas_left);
            make.bottom.equalTo(_codeLabel.mas_top).offset(-5.0f);
            make.right.offset(-20.0f);
        }];
        [_codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_bookNameLabel.mas_left);
            make.bottom.equalTo(_bookNumLabel.mas_top).offset(-5.0f);
            make.right.offset(-20.0f);
        }];
        [_bookNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_bookNameLabel.mas_left);
            make.bottom.equalTo(_bookImageView.mas_bottom);
            make.right.offset(-20.0f);
        }];
    }
    return self;
}

- (void)configWithDict:(NSDictionary *)dict
{
    [_bookImageView sd_setImageWithURL:[NSURL URLWithString:dict[kFindLibraryCellDataKeyBookUrl]] placeholderImage:[UIImage imageNamed:@"find_library_book"]];
    _bookNameLabel.text = dict[kFindLibraryCellDataKeyBookName];
    _publisherLabel.text = dict[kFindLibraryCellDataKeyPublisher];
    _authorLabel.text = dict[kFindLibraryCellDataKeyAuthor];
    _codeLabel.text = dict[kFindLibraryCellDataKeyCode];
    _bookNumLabel.text = dict[kFindLibraryCellDataKeyBookNum];
}

#pragma mark - getter and setter
- (UIImageView *)bookImageView
{
    if (_bookImageView == nil)
    {
        _bookImageView = [[UIImageView alloc] init];
        _bookImageView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    }
    return _bookImageView;
}

- (UILabel *)bookNameLabel
{
    if (_bookNameLabel == nil)
    {
        _bookNameLabel = [[UILabel alloc] init];
        _bookNameLabel.textColor = [UIColor blackColor];
        _bookNameLabel.font = [UIFont systemFontOfSize:16.0f];
        _bookNameLabel.numberOfLines = 2;
    }
    return _bookNameLabel;
}

- (UILabel *)publisherLabel
{
    if (_publisherLabel == nil)
    {
        _publisherLabel = [[UILabel alloc] init];
        _publisherLabel.textColor = [UIColor colorWithHexString:@"969696"];
        _publisherLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _publisherLabel;
}

- (UILabel *)authorLabel
{
    if (_authorLabel == nil)
    {
        _authorLabel = [[UILabel alloc] init];
        _authorLabel.textColor = [UIColor colorWithHexString:@"969696"];
        _authorLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _authorLabel;
}

- (UILabel *)codeLabel
{
    if (_codeLabel == nil)
    {
        _codeLabel = [[UILabel alloc] init];
        _codeLabel.textColor = [UIColor colorWithHexString:@"969696"];
        _codeLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _codeLabel;
}

- (UILabel *)bookNumLabel
{
    if (_bookNumLabel == nil)
    {
        _bookNumLabel = [[UILabel alloc] init];
        _bookNumLabel.textColor = [UIColor colorWithHexString:@"969696"];
        _bookNumLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _bookNumLabel;
}

@end
