//
//  AXServiceFactory.h
//  RTNetworking
//
//  Created by casa on 14-5-12.
//  Copyright (c) 2014年 casatwy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTService.h"
#import "XueBanService.h"
#import "CTJPushService.h"

@interface CTServiceFactory : NSObject

+ (instancetype)sharedInstance;
- (XueBanService *)serviceWithIdentifier:(NSString *)identifier;

@end
