//
//  AXRuntimeInfomation.m
//  RTNetworking
//
//  Created by casa on 14-5-6.
//  Copyright (c) 2014年 casatwy. All rights reserved.
//

#import "CTAppContext.h"
#import "NSObject+AXNetworkingMethods.h"
#import "AFNetworkReachabilityManager.h"
#import "CTLogger.h"
#import "PDKeychainBindings.h"
@interface CTAppContext ()

// 用户的token管理
@property (nonatomic, copy, readwrite) NSString *LoginToken;
@property (nonatomic, copy, readwrite) NSString *Token;
@property (nonatomic, assign, readwrite) NSTimeInterval lastRefreshTime;

@property (nonatomic, copy, readwrite) NSString *sessionId; // 每次启动App时都会新生成,用于日志标记


@end

@implementation CTAppContext

@synthesize userInfo = _userInfo;
@synthesize libPassword = _libPassword;
@synthesize userID = _userID;

#pragma mark - public methods
+ (instancetype)sharedInstance
{
    static CTAppContext *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CTAppContext alloc] init];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    });
    return sharedInstance;
}

#pragma mark - public methods
- (void)updateLoginToken:(NSString *)LoginToken Token:(NSString *)Token
{
    self.LoginToken = LoginToken;
    self.Token = Token;
    self.lastRefreshTime = [[NSDate date] timeIntervalSince1970] * 1000;
    
    [[PDKeychainBindings sharedKeychainBindings] setObject:LoginToken forKey:@"LoginToken"];
    [[PDKeychainBindings sharedKeychainBindings] setObject:Token forKey:@"Token"];
}

- (void)updateLoginToken:(NSString *)LoginToken {
    self.LoginToken = LoginToken;
    [[PDKeychainBindings sharedKeychainBindings] setObject:LoginToken forKey:@"LoginToken"];
}

- (void)cleanUserInfo
{
    self.LoginToken = nil;
    self.Token = nil;
    self.userInfo = nil;
    
    [[PDKeychainBindings sharedKeychainBindings] removeObjectForKey:@"LoginToken"];
    [[PDKeychainBindings sharedKeychainBindings] removeObjectForKey:@"Token"];
}

#pragma mark - getters and setters
- (void)setUserID:(NSString *)userID
{
    _userID = [userID copy];
    [[NSUserDefaults standardUserDefaults] setObject:_userID forKey:@"userId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)userID
{
    if (_userID == nil) {
        _userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    }
    return _userID;
}

- (void)setLibPassword:(NSString *)libPassword {
    _libPassword = [libPassword copy];
    [[NSUserDefaults standardUserDefaults] setObject:_libPassword forKey:@"libPassword"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)libPassword {
    if (_libPassword == nil) {
        _libPassword = [[NSUserDefaults standardUserDefaults] objectForKey:@"libPassword"];
    }
    return _libPassword;

}

- (void)setUserInfo:(NSDictionary *)userInfo
{
    _userInfo = [userInfo copy];
    [[NSUserDefaults standardUserDefaults] setObject:_userInfo forKey:@"userInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSDictionary *)userInfo
{
    if (_userInfo == nil) {
        _userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    }
    return _userInfo;
}

- (void)setUserHasFollowings:(BOOL)userHasFollowings
{
    [[NSUserDefaults standardUserDefaults] setBool:userHasFollowings forKey:@"userHasFollowings"];
}

- (BOOL)userHasFollowings
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"userHasFollowings"];
}

- (NSString *)LoginToken
{
    if (_LoginToken == nil) {
        _LoginToken = [[PDKeychainBindings sharedKeychainBindings] objectForKey:@"LoginToken"];
    }
    return _LoginToken;
}

- (NSString *)Token
{
    if (_Token == nil) {
        _Token = [[PDKeychainBindings sharedKeychainBindings] objectForKey:@"Token"];
    }
    return _Token;
}

- (NSString *)type
{
    return @"ios";
}

- (NSString *)model
{
    return [[UIDevice currentDevice] name];
}

- (NSString *)os
{
    return [[UIDevice currentDevice] systemVersion];
}

- (NSString *)rom
{
    return [[UIDevice currentDevice] model];
}

- (NSString *)imei
{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

- (NSString *)imsi
{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

- (NSString *)deviceName
{
    return [[UIDevice currentDevice] name];
}

- (BOOL)isReachable
{
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusUnknown) {
        return YES;
    } else {
        return [[AFNetworkReachabilityManager sharedManager] isReachable];
    }
}


- (NSString *)appVersion
{
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
}

//
//- (void)appStarted
//{
//    self.sessionId = [[NSUUID UUID].UUIDString copy];
//    [[CTLocationManager sharedInstance] startLocation];
//}
//
//- (void)appEnded
//{
//    [[CTLocationManager sharedInstance] stopLocation];
//}

- (BOOL)isLoggedIn
{
    BOOL result = (self.userID.length != 0);
    return result;
}

- (BOOL)isOnline
{
    BOOL isOnline = NO;
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"CTNetworkingConfiguration" ofType:@"plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filepath]) {
        NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:filepath];
        isOnline = [settings[@"isOnline"] boolValue];
    } else {
        isOnline = kCTServiceIsOnline;
    }
    return isOnline;
}

- (NSString *)deviceToken
{
    if (_deviceToken == nil) {
        _deviceToken = @"";
    }
    return _deviceToken;
}

- (NSData *)deviceTokenData
{
    if (_deviceTokenData == nil) {
        _deviceTokenData = [NSData data];
    }
    return _deviceTokenData;
}

@end
