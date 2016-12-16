//
//  XBPersonInfoDataCenter.m
//  xueban
//
//  Created by dang on 16/9/20.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBPersonInfoDataCenter.h"

@implementation XBPersonInfoDataCenter

#pragma mark - public methods
+ (instancetype)sharedInstance {
    static dispatch_once_t UserDataCenterOnceToken;
    static XBPersonInfoDataCenter *sharedInstance = nil;
    dispatch_once(&UserDataCenterOnceToken, ^{
        sharedInstance = [[XBPersonInfoDataCenter alloc] init];
    });
    return sharedInstance;
}

- (void)saveUser:(NSDictionary*)userDict {
    //获取应用程序沙盒的Documents目录
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath = [paths objectAtIndex:0];
    //得到完整的文件名
    NSString *filename = [plistPath stringByAppendingPathComponent:@"currentuser.plist"];
    //输入写入
    [userDict writeToFile:filename atomically:YES];
}

- (NSDictionary*)loadUser {
    //获取应用程序沙盒的Documents目录
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath = [paths objectAtIndex:0];
    //得到完整的文件名
    NSString *filename = [plistPath stringByAppendingPathComponent:@"currentuser.plist"];
    NSDictionary *data = [[NSDictionary alloc] initWithContentsOfFile:filename];
    return data;
}

- (void)changeAvatarUrl:(NSString *)avatarUrl {
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithDictionary:[self loadUser]];
    [data setObject:avatarUrl forKey:@"head_img"];
    [self saveUser:[data copy]];
}

@end
