//
//  XBBoxUnionIdAPIManager.m
//  xueban
//
//  Created by dang on 2016/10/14.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBBoxUnionIdAPIManager.h"

@implementation XBBoxUnionIdAPIManager

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
    return kNetPath_Official_UnionId;
}

- (NSString *)serviceType {
    return kXueBanService;
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypePost;
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

@end
