//
//  XBBoxCenterUnfollowAlertView.h
//  xueban
//
//  Created by dang on 16/8/11.
//  Copyright © 2016年 dang. All rights reserved.
//

#import <UIKit/UIKit.h>
//@protocol CustomIOSAlertViewDelegate <NSObject>
//
//- (void)didConfirmButtonClicked;
//
//- (void)didCancelButtonClicked;
//
//@end

@interface XBBoxCenterUnfollowAlertView : UIView
//@property (nonatomic, assign) id<CustomIOSAlertViewDelegate> delegate;

@property (nonatomic, copy) void (^cancelHandler)();
@property (nonatomic, copy) void (^confirmHandler)();
- (void)show;
- (void)close;

@end
