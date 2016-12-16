//
//  XBBoxListReformer.m
//  xueban
//
//  Created by dang on 16/9/25.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBBoxListReformer.h"
#import "XBBoxContentCellDataKey.h"

NSString *const kBoxContentCellDataKeyId = @"id";
NSString *const kBoxContentCellDataKeyType = @"type";
NSString *const kBoxContentCellDataKeyUrl = @"redirect_url";
NSString *const kBoxContentCellDataKeyImageUrl = @"head_img";
NSString *const kBoxContentCellDataKeyTitle = @"title";
NSString *const kBoxContentCellDataKeySubTitle = @"description";
NSString *const kBoxContentCellDataKeyIsConcern = @"isConcerned";
NSString *const kBoxContentCellDataKeyExtraKey = @"kBoxContentCellDataKeyExtraKey";
NSString *const kBoxContentCellDataKeyExtraValue = @"kBoxContentCellDataKeyExtraValue";
NSString *const kBoxContentCellDataKeyBelongsTo = @"belongsTo";
NSString *const kBoxContentCellDataKeyNotifySetting = @"notifySettings";

@implementation XBBoxListReformer
- (id)manager:(CTAPIBaseManager *)manager reformData:(NSDictionary *)data {
    NSArray *msgList = data[@"msg"][@"officialCollection"];
    NSMutableArray *toolArr = [NSMutableArray array];
    NSMutableArray *centerArr = [NSMutableArray array];
    [msgList enumerateObjectsUsingBlock:^(NSDictionary *itemDict, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *extraKey = [itemDict[@"extra"][@"keys"] firstObject];
        NSString *extraValue = [itemDict[@"extra"][@"vals"] firstObject];
        NSDictionary *resultDict = @{
                                     kBoxContentCellDataKeyId: itemDict[kBoxContentCellDataKeyId],
                                     kBoxContentCellDataKeyUrl: itemDict[kBoxContentCellDataKeyUrl],
                                     kBoxContentCellDataKeyImageUrl: itemDict[kBoxContentCellDataKeyImageUrl],
                                     kBoxContentCellDataKeyTitle: itemDict[kBoxContentCellDataKeyTitle],
                                     kBoxContentCellDataKeyType: itemDict[kBoxContentCellDataKeyType],
                                     kBoxContentCellDataKeySubTitle: itemDict[kBoxContentCellDataKeySubTitle],
                                     kBoxContentCellDataKeyIsConcern: itemDict[kBoxContentCellDataKeyIsConcern],
                                     kBoxContentCellDataKeyExtraKey: extraKey,
                                     kBoxContentCellDataKeyExtraValue: extraValue,
                                     kBoxContentCellDataKeyBelongsTo: itemDict[kBoxContentCellDataKeyBelongsTo],
                                     kBoxContentCellDataKeyNotifySetting: itemDict[kBoxContentCellDataKeyNotifySetting]
                                     };
        if ([itemDict[kBoxContentCellDataKeyType]  isEqual: @0])
            [toolArr addObject:resultDict];
        else
            [centerArr addObject:resultDict];
    }];
    return @{
             @"toolListArray": [toolArr copy],
             @"centerListArray": [centerArr copy]
             };
}

@end
