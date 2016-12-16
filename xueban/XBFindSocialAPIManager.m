//
//  XBFindSocialAPIManager.m
//  xueban
//
//  Created by dang on 16/9/27.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBFindSocialAPIManager.h"

@implementation XBFindSocialAPIManager

#pragma mark - life cycle
- (instancetype)init {
    if (self = [super init]) {
        self.validator = self;
    }
    return self;
}

#pragma mark - CTAPIManager
- (NSString *)methodName {
    if (self.type == SocialTypeClassmate)
        return kNetPath_Social_Classmate;
    else
        return kNetPath_Social_Townee;
}

- (NSString *)serviceType {
    return kXueBanService;
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}

- (BOOL)shouldCache {
    return NO;
}

#pragma mark - CTAPIManagerValidator
- (BOOL)manager:(CTAPIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data {
    return YES;
}

- (BOOL)manager:(CTAPIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data {
    NSNumber *status = data[@"status"];
    if ([status intValue] == 0)
    {
        return NO;
    }
    return YES;
}

@end
