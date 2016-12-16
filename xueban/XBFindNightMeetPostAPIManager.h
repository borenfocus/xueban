//
//  XBFindNightMeetPostAPIManager.h
//  xueban
//
//  Created by dang on 16/8/26.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "CTAPIBaseManager.h"

@interface XBFindNightMeetPostAPIManager : CTAPIBaseManager<CTAPIManager, CTAPIManagerValidator>

@property (nonatomic, assign) NSInteger nextPageNumber;
@property (nonatomic) BOOL isFirstPage;
@property (nonatomic) BOOL isLastPage;

- (void)loadFirstPage;
- (void)loadNextPage;

@end

