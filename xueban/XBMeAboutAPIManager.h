//
//  XBMeAboutAPIManager.h
//  xueban
//
//  Created by dang on 2016/10/19.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "CTAPIBaseManager.h"

@interface XBMeAboutAPIManager : CTAPIBaseManager<CTAPIManager, CTAPIManagerValidator>

@property (nonatomic) BOOL isLastPage;

@end
