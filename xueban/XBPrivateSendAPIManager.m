//
//  XBPrivateSendAPIManager.m
//  xueban
//
//  Created by dang on 2016/10/16.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBPrivateSendAPIManager.h"

@implementation XBPrivateSendAPIManager

#pragma mark - life cycle
- (instancetype)init
{
    if (self = [super init])
    {
        self.validator = self;
    }
    return self;
}

#pragma mark - CTAPIManager
- (NSString *)methodName
{
    return kNetPath_PrivateLetter_Send;
}

- (NSString *)serviceType
{
    return kXueBanService;
}

- (CTAPIManagerRequestType)requestType
{
    return CTAPIManagerRequestTypePost;
}

- (BOOL)shouldCache
{
    return NO;
}

#pragma mark - CTAPIManagerValidator
- (BOOL)manager:(CTAPIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data
{
    return YES;
}

- (BOOL)manager:(CTAPIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data
{
    NSNumber *status = data[@"status"];
    if ([status intValue] == 0)
    {
        return NO;
    }
    return YES;
}

@end
