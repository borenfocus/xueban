//
//  XBFindLibrarySearchReformer.m
//  xueban
//
//  Created by dang on 16/9/19.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBFindLibrarySearchReformer.h"
#import "XBFindLibrarySearchCellDataKey.h"

NSString * const kFindLibraryCellDataKeyBookUrl = @"image_src";
NSString *const kFindLibraryCellDataKeyBookName = @"book_name";
NSString *const kFindLibraryCellDataKeyPublisher = @"publisher";
NSString *const kFindLibraryCellDataKeyAuthor = @"author";
NSString *const kFindLibraryCellDataKeyCode = @"code";
NSString *const kFindLibraryCellDataKeyBookNum = @"lend_num";
NSString *const kFindLibraryCellDataKeyBookId = @"book_id";

@implementation XBFindLibrarySearchReformer
- (id)manager:(CTAPIBaseManager *)manager reformData:(NSDictionary *)data {
    NSArray *msgList = data[@"msg"][@"searchResult"][@"result"];
    NSMutableArray *resultArr = [NSMutableArray array];
    [msgList enumerateObjectsUsingBlock:^(NSDictionary *bookDict, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *resultDict = @{
                                     kFindLibraryCellDataKeyBookUrl: bookDict[kFindLibraryCellDataKeyBookUrl],
                                     kFindLibraryCellDataKeyBookName: bookDict[kFindLibraryCellDataKeyBookName],
                                     kFindLibraryCellDataKeyPublisher: [NSString stringWithFormat:@"出版社：%@", bookDict[kFindLibraryCellDataKeyPublisher]],
                                     kFindLibraryCellDataKeyAuthor: [NSString stringWithFormat:@"作者：%@", bookDict[kFindLibraryCellDataKeyAuthor]],
                                     kFindLibraryCellDataKeyCode: [NSString stringWithFormat:@"图书编号：%@", bookDict[kFindLibraryCellDataKeyCode]],
                                     kFindLibraryCellDataKeyBookNum: [NSString stringWithFormat:@"剩余数量：%@", bookDict[kFindLibraryCellDataKeyBookNum]],
                                     kFindLibraryCellDataKeyBookId: bookDict[kFindLibraryCellDataKeyBookId]
                                     };
        [resultArr addObject:resultDict];
    }];
    return [resultArr copy];
}

@end
