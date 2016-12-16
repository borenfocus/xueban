//
//  XBSocialInfoContainerView.h
//  xueban
//
//  Created by dang on 2016/10/27.
//  Copyright © 2016年 dang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBSocialInfoContainerView : UIView

@property (nonatomic, strong) NSDictionary *configDict;
@property (nonatomic, copy) void (^avatarHandler)();
@property (nonatomic, copy) void (^chatHandler)();

@end
