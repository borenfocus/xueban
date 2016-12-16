//
//  XBFindBookDetailAPIManager.h
//  xueban
//
//  Created by dang on 2016/11/6.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "CTAPIBaseManager.h"

@interface XBFindBookDetailAPIManager : CTAPIBaseManager<CTAPIManager, CTAPIManagerValidator>

@property (nonatomic, copy) NSString *bookId;

@end
