//
//  AXRuntimeInfomation.h
//  RTNetworking
//
//  Created by casa on 14-5-6.
//  Copyright (c) 2014年 casatwy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTNetworkingConfiguration.h"
#import "CTAPIBaseManager.h"

@interface CTAppContext : NSObject

//凡是未声明成readonly的都是需要在初始化的时候由外面给的

// 运行环境相关
@property (nonatomic, assign, readonly) BOOL isReachable;
@property (nonatomic, assign, readonly) BOOL isOnline;

// 用户token相关
@property (nonatomic, copy, readonly) NSString *LoginToken;
@property (nonatomic, copy, readonly) NSString *Token;
@property (nonatomic, assign, readonly) NSTimeInterval lastRefreshTime;

// 用户信息
@property (nonatomic, copy, readonly) NSString *libPassword;
@property (nonatomic, copy) NSDictionary *userInfo;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, readonly) BOOL isLoggedIn;

// app信息
@property (nonatomic, copy, readonly) NSString *sessionId; // 每次启动App时都会新生成
@property (nonatomic, readonly) NSString *appVersion;

// 推送相关
@property (nonatomic, copy) NSData *deviceTokenData;
@property (nonatomic, copy) NSString *deviceToken;
@property (nonatomic, strong) CTAPIBaseManager *updateTokenAPIManager;

+ (instancetype)sharedInstance;

- (void)updateLoginToken:(NSString *)LoginToken Token:(NSString *)Token;
- (void)updateLoginToken:(NSString *)LoginToken;
- (void)cleanUserInfo;
- (void)setLibPassword:(NSString *)libPassword;

@end
