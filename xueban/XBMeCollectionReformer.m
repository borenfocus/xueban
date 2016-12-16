//
//  XBMeCollectionReformer.m
//  xueban
//
//  Created by dang on 2016/10/18.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBMeCollectionReformer.h"
#import "XBMeCollectionCellDataKey.h"

NSString * const kMeCollectionCellDataKeyTime = @"createdAt";
NSString * const kMeCollectionCellDataKeyImageUrl = @"imageUrl";
NSString * const kMeCollectionCellDataKeyNewsId = @"newsId";
NSString * const kMeCollectionCellDataKeyOfficialImageUrl = @"officialImage";
NSString * const kMeCollectionCellDataKeyOfficialTitle = @"officialTitle";
NSString * const kMeCollectionCellDataKeyTitle = @"title";
NSString * const kMeCollectionCellDataKeyUrl = @"url";
NSString * const kMeCollectionCellDataKeyId = @"id";

@implementation XBMeCollectionReformer

- (id)manager:(CTAPIBaseManager *)manager reformData:(NSDictionary *)data {
    NSArray *msgList = data[@"msg"][@"newsCollection"];
    NSMutableArray *resultArr = [NSMutableArray array];
    [msgList enumerateObjectsUsingBlock:^(NSDictionary *newsItemDict, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *timeStr = newsItemDict[kMeCollectionCellDataKeyTime];
        NSDictionary *resultDict = @{
                                     kMeCollectionCellDataKeyTime: timeStr,
                                     kMeCollectionCellDataKeyImageUrl: newsItemDict[kMeCollectionCellDataKeyImageUrl],
                                     kMeCollectionCellDataKeyNewsId: newsItemDict[kMeCollectionCellDataKeyNewsId],
                                     kMeCollectionCellDataKeyOfficialImageUrl: newsItemDict[kMeCollectionCellDataKeyOfficialImageUrl],
                                     kMeCollectionCellDataKeyOfficialTitle: newsItemDict[kMeCollectionCellDataKeyOfficialTitle],
                                     kMeCollectionCellDataKeyTitle : newsItemDict[kMeCollectionCellDataKeyTitle],
                                     kMeCollectionCellDataKeyUrl : newsItemDict[kMeCollectionCellDataKeyUrl],
                                     kMeCollectionCellDataKeyId : newsItemDict[kMeCollectionCellDataKeyId],
                                     };
        [resultArr addObject:resultDict];
    }];
    return [resultArr copy];
}

@end
