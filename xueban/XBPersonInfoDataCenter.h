//
//  XBPersonInfoDataCenter.h
//  xueban
//
//  Created by dang on 16/9/20.
//  Copyright © 2016年 dang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XBPersonInfoDataCenter : NSObject

+ (instancetype)sharedInstance;

- (void)saveUser:(NSDictionary*)userDict;
- (NSDictionary*)loadUser;
- (void)changeAvatarUrl:(NSString *)avatarUrl;

@end
