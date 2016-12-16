//
//  XBFindLibraryBorrowInfoReformer.m
//  xueban
//
//  Created by dang on 16/9/19.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBFindLibraryBorrowInfoReformer.h"
#import "XBFindLibraryTableViewCellDataKey.h"

NSString *const kFindLibraryTableViewCellDataKeyImageUrl = @"image_src";
NSString *const kFindLibraryTableViewCellDataKeyTitle = @"title";
NSString *const kFindLibraryTableViewCellDataKeyBorrowDate = @"borrow_date";
NSString *const kFindLibraryTableViewCellDataKeyReturnDate = @"return_date";
NSString *const kFindLibraryTableViewCellDataKeyBookPlace = @"book_place";
NSString *const kFindLibraryTableViewCellDataKeyRenewCount = @"renew_count";

@implementation XBFindLibraryBorrowInfoReformer
- (id)manager:(CTAPIBaseManager *)manager reformData:(NSDictionary *)data {
    NSArray *msgList = data[@"msg"][@"borrowInfo"];
    NSMutableArray *resultArr = [NSMutableArray array];
    [msgList enumerateObjectsUsingBlock:^(NSDictionary *bookDict, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *resultDict = @{
                                     kFindLibraryTableViewCellDataKeyImageUrl: bookDict[kFindLibraryTableViewCellDataKeyImageUrl],
                                     kFindLibraryTableViewCellDataKeyTitle: bookDict[kFindLibraryTableViewCellDataKeyTitle],
                                     kFindLibraryTableViewCellDataKeyBorrowDate: bookDict[kFindLibraryTableViewCellDataKeyBorrowDate],
                                     kFindLibraryTableViewCellDataKeyReturnDate: bookDict[kFindLibraryTableViewCellDataKeyReturnDate],
                                     kFindLibraryTableViewCellDataKeyBookPlace: bookDict[kFindLibraryTableViewCellDataKeyBookPlace],
                                     kFindLibraryTableViewCellDataKeyRenewCount: bookDict[kFindLibraryTableViewCellDataKeyRenewCount]
                                    };
        [resultArr addObject:resultDict];
    }];
    return [resultArr copy];
}

@end
