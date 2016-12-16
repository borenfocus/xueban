//
//  XBFindSocialAPIManager.h
//  xueban
//
//  Created by dang on 16/9/27.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "CTAPIBaseManager.h"
#import "XBFindSocialTableViewController.h"

@interface XBFindSocialAPIManager : CTAPIBaseManager<CTAPIManager, CTAPIManagerValidator>

@property (nonatomic) SocialType type;

@end
