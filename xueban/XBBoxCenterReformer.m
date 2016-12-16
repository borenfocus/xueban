//
//  XBBoxCenterReformer.m
//  xueban
//
//  Created by dang on 16/9/25.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBBoxCenterReformer.h"
#import "XBBoxCenterCellDataKey.h"

NSString * const kBoxCenterCellDataKeyId = @"id";
NSString * const kBoxCenterCellDataKeyType = @"type";
NSString * const kBoxCenterCellDataKeyTitle = @"title";
NSString * const kBoxCenterCellDataKeyDescription = @"description";
NSString * const kBoxCenterCellDataKeyUrl = @"url";
NSString * const kBoxCenterCellDataKeyImageUrl = @"img";
NSString * const kBoxCenterCellDataKeyTime = @"createdAt";
NSString * const kBoxCenterCellDataKeyFiles = @"files";

@implementation XBBoxCenterReformer

- (id)manager:(CTAPIBaseManager *)manager reformData:(NSDictionary *)data {
    NSArray *msgList = data[@"msg"][@"newsCollection"];
    NSMutableArray *resultArr = [NSMutableArray array];
    [msgList enumerateObjectsUsingBlock:^(NSDictionary *newsItemDict, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *timeStr = newsItemDict[kBoxCenterCellDataKeyTime];
        timeStr = [timeStr reformDateStringWithDateFormat:@"yyyy-MM-dd"];
        NSDictionary *resultDict = @{
                                     kBoxCenterCellDataKeyId : newsItemDict[kBoxCenterCellDataKeyId],
                                     kBoxCenterCellDataKeyType : newsItemDict[kBoxCenterCellDataKeyType],
                                     kBoxCenterCellDataKeyTitle : newsItemDict[kBoxCenterCellDataKeyTitle],
                                     kBoxCenterCellDataKeyDescription : newsItemDict[kBoxCenterCellDataKeyDescription],
                                     kBoxCenterCellDataKeyUrl : newsItemDict[kBoxCenterCellDataKeyUrl],
                                     kBoxCenterCellDataKeyImageUrl : newsItemDict[kBoxCenterCellDataKeyImageUrl],
                                     kBoxCenterCellDataKeyTime: timeStr,
                                     kBoxCenterCellDataKeyFiles: newsItemDict[kBoxCenterCellDataKeyFiles]
                                     };
        [resultArr addObject:resultDict];
    }];
    return [resultArr copy];
}

@end
