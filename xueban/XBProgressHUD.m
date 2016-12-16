//
//  XBProgressHUD.m
//  xueban
//
//  Created by dang on 16/7/27.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBProgressHUD.h"

@interface XBProgressHUD ()

@property (nonatomic, strong) UIImageView *catImageView;

@end

@implementation XBProgressHUD

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = SCREENWIDTH/6;
        self.layer.borderWidth = 3.0f;
        self.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.4].CGColor;
        self.frame = CGRectMake(0, 0, SCREENWIDTH/3, SCREENWIDTH/3);
        self.center = CGPointMake(SCREENWIDTH/2.0, SCREENHEIGHT/2.0 - 60);
        [self addSubview:self.catImageView];
        [_catImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.offset(7.0f);
            make.right.bottom.offset(-7.0f);
        }];
    }
    return self;
}

+ (instancetype)showHUDAddedTo:(UIView *)view {
    XBProgressHUD *hud = [[self alloc] init];
    [view addSubview:hud];
    return hud;
}

+ (void)hideHUDForView:(UIView *)view {
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            [subview removeFromSuperview];
        }
    }
}

+ (XBProgressHUD *)HUDForView:(UIView *)view {
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            return (XBProgressHUD *)subview;
        }
    }
    return nil;
}

#pragma mark - getter and setter
- (UIImageView *)catImageView {
    if (!_catImageView) {
        _catImageView = [[UIImageView alloc] init];
        NSMutableArray *catImageListArray = [NSMutableArray array];
        for (NSInteger i=1; i<=30; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"load0%ld", i]];
            [catImageListArray addObject:image];
        }
        _catImageView.animationImages = catImageListArray;
        _catImageView.animationDuration = 1.5;
        [_catImageView startAnimating];
    }
    return _catImageView;
}

@end
