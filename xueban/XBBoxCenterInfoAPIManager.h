//
//  XBBoxCenterInfoAPIManager.h
//  xueban
//
//  Created by dang on 2016/11/9.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "CTAPIBaseManager.h"

@interface XBBoxCenterInfoAPIManager : CTAPIBaseManager<CTAPIManager, CTAPIManagerValidator>

@property (nonatomic ,strong) NSString *officialId;

@end
