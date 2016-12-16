//
//  AXRequestGenerator.m
//  RTNetworking
//
//  Created by casa on 14-5-14.
//  Copyright (c) 2014年 casatwy. All rights reserved.
//

#import "CTRequestGenerator.h"
#import "CTServiceFactory.h"
#import "CTCommonParamsGenerator.h"
#import "NSDictionary+AXNetworkingMethods.h"
#import "CTNetworkingConfiguration.h"
#import "NSObject+AXNetworkingMethods.h"
#import <AFNetworking/AFNetworking.h>
#import "CTService.h"
#import "NSObject+AXNetworkingMethods.h"
#import "CTLogger.h"
#import "NSURLRequest+CTNetworkingMethods.h"

@interface CTRequestGenerator ()

@property (nonatomic, strong) AFHTTPRequestSerializer *httpRequestSerializer;
@property (nonatomic, strong) AFJSONRequestSerializer *jsonRequestSerializer;
@end

@implementation CTRequestGenerator
#pragma mark - public methods
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static CTRequestGenerator *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CTRequestGenerator alloc] init];
    });
    return sharedInstance;
}

- (NSURLRequest *)generateGETRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName
{
    CTService *service = [[CTServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
    NSString *urlString;

    urlString = [NSString stringWithFormat:@"%@/%@", service.apiBaseUrl, methodName];
    [self.httpRequestSerializer setValue:@"DLUT" forHTTPHeaderField:@"School"];
    
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"GET" URLString:urlString parameters:requestParams error:NULL];
    request.requestParams = requestParams;
    if ([CTAppContext sharedInstance].LoginToken) {
        [request setValue:[CTAppContext sharedInstance].LoginToken forHTTPHeaderField:@"LoginToken"];
    }
    return request;
}

- (NSURLRequest *)generatePOSTRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName
{
    CTService *service = [[CTServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", service.apiBaseUrl,  methodName];
   
    [self.httpRequestSerializer setValue:@"DLUT" forHTTPHeaderField:@"School"];
    
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"POST" URLString:urlString parameters:requestParams error:NULL];
    NSString *bodyString = AFQueryStringFromParameters(requestParams);
    request.HTTPBody = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    if ([CTAppContext sharedInstance].LoginToken) {
        [request setValue:[CTAppContext sharedInstance].LoginToken forHTTPHeaderField:@"LoginToken"];
    }
    request.requestParams = requestParams;
    return request;
}

#pragma mark - getters and setters
- (AFHTTPRequestSerializer *)httpRequestSerializer
{
    if (_httpRequestSerializer == nil)
    {
        _httpRequestSerializer = [AFHTTPRequestSerializer serializer];
        _httpRequestSerializer.timeoutInterval = kCTNetworkingTimeoutSeconds;
        _httpRequestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    return _httpRequestSerializer;
}

- (AFJSONRequestSerializer *)jsonRequestSerializer
{
    if (_jsonRequestSerializer == nil)
    {
        _jsonRequestSerializer = [AFJSONRequestSerializer serializer];
        _jsonRequestSerializer.timeoutInterval = kCTNetworkingTimeoutSeconds;
        _jsonRequestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    return _jsonRequestSerializer;
}
@end
