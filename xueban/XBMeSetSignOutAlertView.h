//
//  XBMeSetSignOutAlertView.h
//  xueban
//
//  Created by dang on 16/8/25.
//  Copyright © 2016年 dang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBMeSetSignOutAlertView : UIView

@property (nonatomic, copy) void (^cancelHandler)();
@property (nonatomic, copy) void (^confirmHandler)();

- (void)show;
- (void)close;
@end
