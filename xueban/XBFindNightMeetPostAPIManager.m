//
//  XBFindNightMeetPostAPIManager.m
//  xueban
//
//  Created by dang on 16/8/26.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBFindNightMeetPostAPIManager.h"

@implementation XBFindNightMeetPostAPIManager

#pragma mark - life cycle
- (instancetype)init {
    if (self = [super init]) {
        self.validator = self;
    }
    return self;
}

#pragma mark - Public method
- (void)loadFirstPage {
    _nextPageNumber = 0;
    self.isFirstPage = YES;
    [self loadData];
}

- (void)loadNextPage {
    if (self.isLoading) {
        return;
    }
    [self loadData];
    self.isFirstPage = NO;
}

- (NSDictionary *)reformParams:(NSDictionary *)params {
    params = @{
                @"page": [NSNumber numberWithInteger:self.nextPageNumber],
                @"limit": @"10"
             };
    return params;
}

- (BOOL)beforePerformSuccessWithResponse:(CTURLResponse *)response {
    [super beforePerformSuccessWithResponse:response];
    if ([response.content[@"msg"][@"nextPage"] isEqualToString:@"none"]) {
        _isLastPage = YES;
    } else
        self.nextPageNumber = [response.content[@"msg"][@"nextPage"] integerValue];
    return YES;
}

- (BOOL)beforePerformFailWithResponse:(CTURLResponse *)response {
    [super beforePerformFailWithResponse:response];
    return YES;
}

#pragma mark - CTAPIManager
- (NSString *)methodName {
    return kNetPath_NightMeetPosts;
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
@end
