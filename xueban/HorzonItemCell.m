//
//  GoodsCollectionCell.m
//  BanTang
//
//  Created by liaoyp on 15/4/13.
//  Copyright (c) 2015年 JiuZhouYunDong. All rights reserved.
//

#import "HorzonItemCell.h"
#import "UIView+ViewConstraint.h"
#import "CollectModel.h"
#import "UIImageView+WebCache.h"

@implementation HorzonItemCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setUpView];
    }
    return self;
}

- (void)setUpView
{
    UIView *superView = self.contentView;
    _mCoverView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _mCoverView.backgroundColor = RGB(245, 245, 245);
    _mCoverView.layer.cornerRadius = 30;
    _mCoverView.layer.masksToBounds = YES;
    _mCoverView.contentMode = UIViewContentModeScaleAspectFill;
    _mCoverView.opaque = YES;
    [superView addSubview:_mCoverView];
    
    _mTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _mTitleLabel.numberOfLines = 2;
    _mTitleLabel.textAlignment = NSTextAlignmentCenter;
    _mTitleLabel.textColor = RGB(150, 150, 150);
    _mTitleLabel.font = [UIFont systemFontOfSize:12];
    [superView addSubview:_mTitleLabel];
    
    /*
        基本原理：
        View1（上下左右） -(相对于)- View2(上下左右) 距离值（XXX）
     */
    _mCoverView.translatesAutoresizingMaskIntoConstraints = NO;
//    // 封面的顶部 相对于 contentView 顶部往下10个像素
//    [_mCoverView addConstraint:NSLayoutAttributeTop toItem:superView targetlayoutAttribte:NSLayoutAttributeTop withValue:10];
//    // 封面宽度和 contentView宽度是相等的
//    [_mCoverView addConstraint:NSLayoutAttributeWidth toItem:superView targetlayoutAttribte:NSLayoutAttributeWidth withValue:0];
//    // 封面宽度和 左边 和 contentView 左边对齐 相距0像素
//    [_mCoverView addConstraint:NSLayoutAttributeLeading toItem:superView targetlayoutAttribte:NSLayoutAttributeLeading withValue:0];
//    // 封面高度为70像素
//    [_mCoverView addConstraintHeightWithValue:70];
    
    [_mCoverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.left.offset(5.0f);
        make.right.offset(-5.0f);
        make.height.mas_equalTo(60.0f);
    }];
    
    
    
    _mTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_mTitleLabel addConstraint:NSLayoutAttributeTop toItem:_mCoverView targetlayoutAttribte:NSLayoutAttributeBottom withValue:10];
    [_mTitleLabel addConstraint:NSLayoutAttributeWidth toItem:_mCoverView targetlayoutAttribte:NSLayoutAttributeWidth withValue:0];
    [_mTitleLabel addConstraint:NSLayoutAttributeCenterX toItem:_mCoverView targetlayoutAttribte:NSLayoutAttributeCenterX withValue:0];
}

- (void)hiddenDescView:(BOOL)hidden
{
    _mTitleLabel.hidden = hidden;
}

- (BOOL)isEmpty:(NSString *)str
{
    return ((str == nil)||[str isKindOfClass:[NSNull class]]);
}

- (void)isLastTypeCell
{
    [self hiddenDescView:YES];
    [_mCoverView setImage:[UIImage imageNamed:@"center_item_more"]];
}


- (void)isNormalCell:(CollectModel *)model
{
    [self hiddenDescView:NO];

    CollectModel *likeItem = (CollectModel *)model;
    _mTitleLabel.text = likeItem.title;

    _mCoverView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    
    [_mCoverView sd_setImageWithURL:[NSURL URLWithString:likeItem.imageUrl] placeholderImage:nil];
}


@end
