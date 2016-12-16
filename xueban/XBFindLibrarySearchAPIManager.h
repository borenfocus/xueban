//
//  XBFindLibrarySearchAPIManager.h
//  xueban
//
//  Created by dang on 16/9/18.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "CTNetworking.h"

@interface XBFindLibrarySearchAPIManager : CTAPIBaseManager<CTAPIManager, CTAPIManagerValidator>

@property (nonatomic, assign) NSInteger nextPageNumber;
@property (nonatomic, strong) NSString *searchText;
@property (nonatomic) BOOL isNullData;
@property (nonatomic) BOOL isFirstPage;
@property (nonatomic) BOOL isLastPage;


- (void)loadFirstPage;
- (void)loadNextPage;

@end
