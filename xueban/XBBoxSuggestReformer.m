//
//  XBBoxSuggestReformer.m
//  xueban
//
//  Created by dang on 16/9/29.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBBoxSuggestReformer.h"
#import "XBBoxContentCellDataKey.h"

@implementation XBBoxSuggestReformer

- (id)manager:(CTAPIBaseManager *)manager reformData:(NSDictionary *)data {
    NSArray *msgList = data[@"msg"][@"officialCollection"];
    NSMutableArray *resultArr = [NSMutableArray array];
    [msgList enumerateObjectsUsingBlock:^(NSDictionary *itemDict, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *extraKey = [itemDict[@"extra"][@"keys"] firstObject];
        NSString *extraValue = [itemDict[@"extra"][@"vals"] firstObject];
        NSDictionary *resultDict = @{
                                     kBoxContentCellDataKeyId: itemDict[kBoxContentCellDataKeyId],
                                     kBoxContentCellDataKeyUrl: itemDict[kBoxContentCellDataKeyUrl],
                                     kBoxContentCellDataKeyImageUrl: itemDict[kBoxContentCellDataKeyImageUrl],
                                     kBoxContentCellDataKeyTitle: itemDict[kBoxContentCellDataKeyTitle],
                                     kBoxContentCellDataKeySubTitle: itemDict[kBoxContentCellDataKeySubTitle],
                                     kBoxContentCellDataKeyIsConcern: itemDict[kBoxContentCellDataKeyIsConcern],
                                     kBoxContentCellDataKeyType: itemDict[kBoxContentCellDataKeyType],
                                     kBoxContentCellDataKeyExtraKey: extraKey,
                                     kBoxContentCellDataKeyExtraValue: extraValue,
                                     kBoxContentCellDataKeyBelongsTo: itemDict[kBoxContentCellDataKeyBelongsTo],
                                     kBoxContentCellDataKeyNotifySetting: itemDict[kBoxContentCellDataKeyNotifySetting]
                                     };
        [resultArr addObject:resultDict];
    }];
    return [resultArr copy];
}

@end
