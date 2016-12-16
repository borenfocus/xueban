//
//  XBProgressHUD.h
//  xueban
//
//  Created by dang on 16/7/27.
//  Copyright © 2016年 dang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBProgressHUD : UIView

+ (instancetype)showHUDAddedTo:(UIView *)view;

+ (void)hideHUDForView:(UIView *)view;

@end

