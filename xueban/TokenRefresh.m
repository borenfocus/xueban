//
//  TokenRefresh.m
//  CTNetworking
//
//  Created by dang on 16/6/10.
//  Copyright © 2016年 Long Fan. All rights reserved.
//

#import "TokenRefresh.h"
#import "LoginAPIManager.h"

extern NSString * const kBSUserTokenInvalidNotification;
extern NSString * const kBSUserTokenIllegalNotification;

extern NSString * const kBSUserTokenNotificationUserInfoKeyRequestToContinue;
extern NSString * const kBSUserTokenNotificationUserInfoKeyManagerToContinue;

@interface TokenRefresh()<CTAPIManagerParamSource, CTAPIManagerCallBackDelegate>
{
    NSNotification *notifyCopy;
}
@property (nonatomic, strong) LoginAPIManager *loginAPIManager;

@end

@implementation TokenRefresh

+ (instancetype)sharedInstance {
    static TokenRefresh *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TokenRefresh alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:sharedInstance selector:@selector(refreshTokenNotificationAction:) name:kBSUserTokenInvalidNotification object:nil];
    });
    return sharedInstance;
}

#pragma mark - CTAPIManagerParamSource
- (NSDictionary *)paramsForApi:(CTAPIBaseManager *)manager {
    NSDictionary *params = @{};
    NSString *token = [CTAppContext sharedInstance].Token;
    if (manager == self.loginAPIManager && token) {
        params = @{
                     
                  };
    }
    return params;
}

#pragma mark - CTAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(CTAPIBaseManager *)manager {
    if (manager == self.loginAPIManager) {
        NSDictionary *data = [manager fetchDataWithReformer:nil];
        [[CTAppContext sharedInstance] updateLoginToken:data[@"msg"][@"LoginToken"]];
        [notifyCopy.userInfo[kBSUserTokenNotificationUserInfoKeyManagerToContinue] loadData];
    }
}

- (void)managerCallAPIDidFailed:(CTAPIBaseManager *)manager {
    if (manager == self.loginAPIManager) {
        
    }
}

#pragma mark - event response
- (void)refreshTokenNotificationAction:(NSNotification *)notify {
    [self.loginAPIManager loadData];
    notifyCopy = notify;
}

#pragma mark - getters and setters
- (LoginAPIManager *)loginAPIManager {
    if (_loginAPIManager == nil) {
        _loginAPIManager = [[LoginAPIManager alloc] init];
        _loginAPIManager.delegate = self;
        _loginAPIManager.paramSource = self;
    }
    return _loginAPIManager;
}

@end
