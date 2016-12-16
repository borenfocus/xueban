//
//  XBRefreshHeader.m
//  xueban
//
//  Created by dang on 2016/10/27.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBRefreshHeader.h"

@interface XBRefreshHeader()
{
    __unsafe_unretained UIImageView *_fishImageView;
    __unsafe_unretained UIImageView *_catImageView;
}
/** 所有状态对应的动画图片 */
@property (strong, nonatomic) NSMutableDictionary *fishStateImages;
@property (strong, nonatomic) NSMutableDictionary *catStateImages;
/** 所有状态对应的动画时间 */
@property (strong, nonatomic) NSMutableDictionary *fishStateDurations;
@property (strong, nonatomic) NSMutableDictionary *catStateDurations;
@end

@implementation XBRefreshHeader

#pragma mark - public method
- (void)setCatImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(MJRefreshState)state {
    if (images == nil)
        return;
    self.catStateImages[@(state)] = images;
    self.catStateDurations[@(state)] = @(duration);
}

- (void)setCatImages:(NSArray *)images forState:(MJRefreshState)state {
    [self setCatImages:images duration:images.count * 0.1 forState:state];
}

- (void)setFishImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(MJRefreshState)state {
    if (images == nil)
        return;
    self.fishStateImages[@(state)] = images;
    self.fishStateDurations[@(state)] = @(duration);
}

- (void)setFishImages:(NSArray *)images forState:(MJRefreshState)state {
    [self setFishImages:images duration:images.count * 0.1 forState:state];
}

#pragma mark - 实现父类的方法
- (void)prepare {
    [super prepare];
    self.lastUpdatedTimeLabel.hidden = YES;
    self.stateLabel.hidden = YES;
    self.mj_h = 70;
    
    [self setCatImages:self.refreshCatImages forState:MJRefreshStateRefreshing];
    [self setCatImages:self.normalCatImages forState:MJRefreshStateIdle];
    [self setCatImages:self.pullCatImages forState:MJRefreshStatePulling];
    [self setFishImages:self.refreshFishImages forState:MJRefreshStateRefreshing];
    [self setFishImages:self.normalFishImages forState:MJRefreshStateIdle];
    [self setFishImages:self.pullFishImages forState:MJRefreshStatePulling];
}

- (void)setPullingPercent:(CGFloat)pullingPercent {
    [super setPullingPercent:pullingPercent];
    NSArray *images = self.catStateImages[@(MJRefreshStatePulling)];
    if (self.state != MJRefreshStateIdle || images.count == 0)
        return;
    // 停止动画
    [self.catImageView stopAnimating];
    // 设置当前需要显示的图片
    NSUInteger index =  images.count * pullingPercent;
    if (index >= images.count) index = images.count - 1;
    self.catImageView.image = images[index];
    
    images = self.fishStateImages[@(MJRefreshStatePulling)];
    [self.fishImageView stopAnimating];
    // 设置当前需要显示的图片
    index =  images.count * pullingPercent;
    if (index >= images.count) index = images.count - 1;
    self.fishImageView.image = images[index];
}

- (void)placeSubviews {
    [super placeSubviews];
    if (self.catImageView.constraints.count||self.fishImageView.constraints.count)
        return;
    
    self.fishImageView.frame = CGRectMake(0, 0, 60, 45);
    self.fishImageView.center = CGPointMake(SCREENWIDTH/2, 10);
    
    self.catImageView.frame = CGRectMake(0, 0, 75, 45);
    self.catImageView.center = CGPointMake(SCREENWIDTH/2, 47);
    
    self.catImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.fishImageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)setState:(MJRefreshState)state {
    MJRefreshCheckState
    // 根据状态做事情
    if (state == MJRefreshStatePulling) {
        NSArray *catImages = self.catStateImages[@(state)];
        NSArray *fishImages = self.fishStateImages[@(state)];
        [self.fishImageView stopAnimating];
        [self.catImageView stopAnimating];
        if (catImages.count == 1) { // 单张图片
            self.catImageView.image = [catImages lastObject];
        } else { // 多张图片
            self.catImageView.animationImages = catImages;
            self.catImageView.animationDuration = [self.catStateDurations[@(state)] doubleValue];
            [self.catImageView startAnimating];
        }
        if (fishImages.count == 1) { // 单张图片
            self.fishImageView.image = [fishImages lastObject];
        } else { // 多张图片
            self.fishImageView.animationImages = fishImages;
            self.fishImageView.animationDuration = [self.fishStateDurations[@(state)] doubleValue];
        }
    } else if (state == MJRefreshStateRefreshing) {
        NSArray *catImages = self.catStateImages[@(state)];
        NSArray *fishImages = self.fishStateImages[@(state)];
        [self.fishImageView stopAnimating];
        [self.catImageView stopAnimating];
        if (catImages.count == 1) { // 单张图片
            self.catImageView.image = [catImages lastObject];
        } else { // 多张图片
            self.catImageView.animationImages = catImages;
            self.catImageView.animationDuration = [self.catStateDurations[@(state)] doubleValue];
        }
        if (fishImages.count == 1) { // 单张图片
            self.fishImageView.image = [fishImages lastObject];
        } else { // 多张图片
            self.fishImageView.animationImages = fishImages;
            self.fishImageView.animationDuration = [self.fishStateDurations[@(state)] doubleValue];
            [self.fishImageView startAnimating];
        }
    } else if (state == MJRefreshStateIdle) {
        [self.catImageView stopAnimating];
        [self.fishImageView stopAnimating];
    }
}

- (NSMutableArray *)normalCatImages {
    if (_normalCatImages == nil) {
        _normalCatImages = [[NSMutableArray alloc] init];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"cat_pull00"]];
        [self.normalCatImages addObject:image];
    }
    return _normalCatImages;
}

- (NSMutableArray *)pullCatImages {
    if (_pullCatImages == nil) {
        _pullCatImages = [[NSMutableArray alloc] init];
        for (NSUInteger i = 0; i<=7; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"cat_pull0%ld", i]];
            [self.pullCatImages addObject:image];
        }
    }
    return _pullCatImages;
}

- (NSMutableArray *)refreshCatImages {
    if (!_refreshCatImages) {
        _refreshCatImages = [[NSMutableArray alloc] init];
        UIImage *image = [UIImage imageNamed:@"cat_refreshing"];
        [_refreshCatImages addObject:image];
    }
    return _refreshCatImages;
}

- (NSMutableArray *)normalFishImages {
    if (_normalFishImages == nil) {
        _normalFishImages = [[NSMutableArray alloc] init];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"fish_pull00"]];
        [self.normalFishImages addObject:image];
    }
    return _normalFishImages;
}

- (NSMutableArray *)pullFishImages {
    if (_pullFishImages == nil) {
        _pullFishImages = [[NSMutableArray alloc] init];
        for (NSUInteger i = 0; i<=5; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"fish_pull0%ld", i]];
            [self.pullFishImages addObject:image];
        }
    }
    return _pullFishImages;
}

- (NSMutableArray *)refreshFishImages {
    if (_refreshFishImages == nil) {
        _refreshFishImages = [[NSMutableArray alloc] init];
        for (NSUInteger i = 0; i<=15; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"fish_refreshing0%ld", i]];
            [self.refreshFishImages addObject:image];
        }
    }
    return _refreshFishImages;
}

#pragma mark - getter
- (UIImageView *)fishImageView {
    if (!_fishImageView) {
        UIImageView *fishImageView = [[UIImageView alloc] init];
        [self addSubview:_fishImageView = fishImageView];
    }
    return _fishImageView;
}

- (UIImageView *)catImageView {
    if (!_catImageView) {
        UIImageView *catImageView = [[UIImageView alloc] init];
        [self addSubview:_catImageView = catImageView];
    }
    return _catImageView;
}

- (NSMutableDictionary *)fishStateImages {
    if (!_fishStateImages) {
        self.fishStateImages = [NSMutableDictionary dictionary];
    }
    return _fishStateImages;
}

- (NSMutableDictionary *)catStateImages {
    if (!_catStateImages) {
        self.catStateImages = [NSMutableDictionary dictionary];
    }
    return _catStateImages;
}

- (NSMutableDictionary *)fishStateDurations {
    if (!_fishStateDurations) {
        self.fishStateDurations = [NSMutableDictionary dictionary];
    }
    return _fishStateDurations;
}

- (NSMutableDictionary *)catStateDurations {
    if (!_catStateDurations) {
        self.catStateDurations = [NSMutableDictionary dictionary];
    }
    return _catStateDurations;
}

@end
