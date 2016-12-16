//
//  GoodsCollectionCell.h
//  BanTang
//
//  Created by liaoyp on 15/4/13.
//  Copyright (c) 2015年 JiuZhouYunDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectModel.h"
@interface HorzonItemCell : UICollectionViewCell
{
    UIImageView *_mCoverView;
    UIView      *_mDescView;
    UILabel     *_mTitleLabel;
}

- (void)isLastTypeCell;
- (void)isNormalCell:(CollectModel*)model;

@end
