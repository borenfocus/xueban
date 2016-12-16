//
//  XBRefreshHeader.h
//  xueban
//
//  Created by dang on 2016/10/27.
//  Copyright © 2016年 dang. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>

@interface XBRefreshHeader : MJRefreshStateHeader

@property (nonatomic,strong) NSMutableArray *refreshFishImages;//刷新中鱼动画的图片数组
@property (nonatomic,strong) NSMutableArray *pullFishImages;   //下拉中鱼动画的图片数组
@property (nonatomic,strong) NSMutableArray *normalFishImages; //普通状态下鱼的图片数组
@property (nonatomic,strong) NSMutableArray *refreshCatImages; //刷新中猫动画的图片数组
@property (nonatomic,strong) NSMutableArray *pullCatImages;    //下拉中猫动画的图片数组
@property (nonatomic,strong) NSMutableArray *normalCatImages;  //普通状态下猫的图片数组

@property (weak, nonatomic, readonly) UIImageView *fishImageView;
@property (weak, nonatomic, readonly) UIImageView *catImageView;

@end
