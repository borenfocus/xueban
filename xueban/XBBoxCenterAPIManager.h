//
//  XBBoxCenterAPIManager.h
//  xueban
//
//  Created by dang on 16/9/25.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "CTAPIBaseManager.h"

@interface XBBoxCenterAPIManager : CTAPIBaseManager<CTAPIManager, CTAPIManagerValidator>

@property (nonatomic ,strong) NSString *officialId;
@property (nonatomic) BOOL isLastPage;

@end
