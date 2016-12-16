//
//  XBMeAboutAPIManager.m
//  xueban
//
//  Created by dang on 2016/10/19.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBMeAboutAPIManager.h"

@implementation XBMeAboutAPIManager

#pragma mark - life cycle
- (instancetype)init {
    self = [super init];
    if (self) {
        self.validator = self;
    }
    return self;
}

#pragma mark - CTAPIManager
- (NSString *)methodName {
    return kNetPath_Me_About;
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
    if ([status intValue] == 0) {
        return NO;
    }
    return YES;
}

- (BOOL)beforePerformFailWithResponse:(CTURLResponse *)response {
    [super beforePerformFailWithResponse:response];
    NSDictionary *responseDict = response.content;
    NSNumber *code = responseDict[@"code"];
    if ([code intValue] == -8)
        _isLastPage = YES;
    else
        _isLastPage = NO;
    return YES;
}

@end
