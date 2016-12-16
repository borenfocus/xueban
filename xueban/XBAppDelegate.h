//
//  XBAppDelegate.h
//  xueban
//
//  Created by dang on 16/6/10.
//  Copyright © 2016年 dang. All rights reserved.
//

#import <UIKit/UIKit.h>
//极光推送
static NSString *appKey = @"";
static NSString *channel = @"Publish channel";
static BOOL isProduction = FALSE;

@interface XBAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
