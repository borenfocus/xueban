//
//  XBFindLibrarySearchAPIManager.m
//  xueban
//
//  Created by dang on 16/9/18.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBFindLibrarySearchAPIManager.h"

@implementation XBFindLibrarySearchAPIManager

#pragma mark - life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.validator = self;
        self.nextPageNumber = 0;
    }
    return self;
}

#pragma mark - Public method
- (void)loadFirstPage {
    self.nextPageNumber = 0;
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

- (BOOL)beforePerformSuccessWithResponse:(CTURLResponse *)response
{
    [super beforePerformSuccessWithResponse:response];
    if ([response.content[@"msg"][@"searchResult"][@"next_page"] isEqualToString:@"none"])
    {
        _isNullData = YES;
        return YES;
    }
    else
    {
        _isNullData = NO;
    }
    if ([response.content[@"msg"][@"searchResult"][@"next_page"] isEqualToString:@"none"])
        _isLastPage = YES;
    else
        self.nextPageNumber = [response.content[@"msg"][@"searchResult"][@"next_page"] integerValue];
    return YES;
}

- (BOOL)beforePerformFailWithResponse:(CTURLResponse *)response
{
    [super beforePerformFailWithResponse:response];
    
    if (self.nextPageNumber > 0)
    {
        self.nextPageNumber --;
    }
    return YES;
}

#pragma mark - CTAPIManager
- (NSString *)methodName
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@/%@", kNetPath_SearchBook, self.searchText, [NSNumber numberWithInteger:self.nextPageNumber]];
    return [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];;
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
    return YES;
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

