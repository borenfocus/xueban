//
//  XBPrivateContentViewController.h
//  xueban
//
//  Created by dang on 2016/10/16.
//  Copyright © 2016年 dang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBPrivateContentViewController : UIViewController
//userId在我的同学进入私信时有用
@property (nonatomic) NSNumber *userId;

@property (nonatomic) NSString *avatarUrl;
//@property (nonatomic) NSNumber *lastId;
@property (nonatomic, strong) NSDictionary *configDict;

@end
