//
//  CTService.m
//  xueban
//
//  Created by dang on 2016/10/15.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "CTService.h"

@interface CTService()

@property (nonatomic, strong, readwrite) NSString *apiBaseUrl;

@end

@implementation CTService

- (instancetype)initWithBaseUrl:(NSString *)baseUrl {
    self = [super init];
    if (self) {
        self.apiBaseUrl = baseUrl;
    }
    return self;
}

@end
