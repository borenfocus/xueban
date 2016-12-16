//
//  XBFindLibraryTableViewCell.m
//  xueban
//
//  Created by dang on 16/9/19.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBFindLibraryTableViewCell.h"
#import "XBFindLibraryTableViewCellDataKey.h"
#import "UIImageView+WebCache.h"

@interface XBFindLibraryTableViewCell ()
@property (nonatomic, strong) UIImageView *bookImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *bookPlaceLabel;
@property (nonatomic, strong) UILabel *borrowDateLabel;
@property (nonatomic, strong) UILabel *returnDateLabel;
@property (nonatomic, strong) UILabel *renewCountLabel;
@end

@implementation XBFindLibraryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.bookImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.bookPlaceLabel];
        [self.contentView addSubview:self.borrowDateLabel];
        [self.contentView addSubview:self.returnDateLabel];
        [self.contentView addSubview:self.renewCountLabel];
        [_bookImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(25.0f);
            make.top.offset(20.0f);
            make.bottom.offset(-20.0f);
            make.width.mas_equalTo(_bookImageView.mas_height).multipliedBy(1/1.4);
        }];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_bookImageView.mas_right).offset(20.0f);
            make.top.equalTo(_bookImageView.mas_top);
            make.right.offset(-20.0f);
        }];
        [_bookPlaceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleLabel.mas_left);
            make.bottom.equalTo(_borrowDateLabel.mas_top).offset(-5.0f);
            make.right.offset(-10.0f);
        }];
        [_borrowDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleLabel.mas_left);
            make.bottom.equalTo(_returnDateLabel.mas_top).offset(-5.0f);
        }];
        [_returnDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleLabel.mas_left);
            make.bottom.equalTo(_renewCountLabel.mas_top).offset(-5.0f);
        }];
        [_renewCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleLabel.mas_left);
            make.bottom.equalTo(_bookImageView.mas_bottom);
        }];
    }
    return self;
}

- (void)configWithDict:(NSDictionary *)dict
{
    [_bookImageView sd_setImageWithURL:[NSURL URLWithString:dict[kFindLibraryTableViewCellDataKeyImageUrl]] placeholderImage:[UIImage imageNamed:@"find_library_book"]];
    _titleLabel.text = dict[kFindLibraryTableViewCellDataKeyTitle];
    _bookPlaceLabel.text = dict[kFindLibraryTableViewCellDataKeyBookPlace];
    _borrowDateLabel.text = dict[kFindLibraryTableViewCellDataKeyBorrowDate];
    _returnDateLabel.text = dict[kFindLibraryTableViewCellDataKeyReturnDate];
    _renewCountLabel.text = [NSString stringWithFormat:@"%@", dict[kFindLibraryTableViewCellDataKeyRenewCount]];
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

- (UILabel *)titleLabel
{
    if (_titleLabel == nil)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:16.0f];
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UILabel *)bookPlaceLabel
{
    if (_bookPlaceLabel == nil)
    {
        _bookPlaceLabel = [[UILabel alloc] init];
        _bookPlaceLabel.textColor = [UIColor colorWithHexString:@"969696"];
        _bookPlaceLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _bookPlaceLabel;
}

- (UILabel *)borrowDateLabel
{
    if (_borrowDateLabel == nil)
    {
        _borrowDateLabel = [[UILabel alloc] init];
        _borrowDateLabel.textColor = [UIColor colorWithHexString:@"969696"];
        _borrowDateLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _borrowDateLabel;
}

- (UILabel *)returnDateLabel
{
    if (_returnDateLabel == nil)
    {
        _returnDateLabel = [[UILabel alloc] init];
        _returnDateLabel.textColor = [UIColor colorWithHexString:@"969696"];
        _returnDateLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _returnDateLabel;
}

- (UILabel *)renewCountLabel
{
    if (_renewCountLabel == nil)
    {
        _renewCountLabel = [[UILabel alloc] init];
        _renewCountLabel.textColor = [UIColor colorWithHexString:@"969696"];
        _renewCountLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _renewCountLabel;
}
@end
