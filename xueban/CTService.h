//
//  CTService.h
//  xueban
//
//  Created by dang on 2016/10/15.
//  Copyright © 2016年 dang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTService : NSObject

@property (nonatomic, strong, readonly) NSString *apiBaseUrl;

- (instancetype)initWithBaseUrl:(NSString *)baseUrl;

@end
