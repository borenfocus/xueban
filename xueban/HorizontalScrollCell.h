//
//  CenterCell.h
//  BanTang
//
//  Created by liaoyp on 15/4/22.
//  Copyright (c) 2015年 JiuZhouYunDong. All rights reserved.
//

#import "HorizontalScrollCellDeleagte.h"

@interface HorizontalScrollCell : UITableViewCell <UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic ,strong)UICollectionView *collectionView;

@property (weak, nonatomic) id <HorizontalScrollCellDeleagte> delegate;

@property (strong, nonatomic) NSIndexPath *tableViewIndexPath;

- (void)reloadData;

@end
