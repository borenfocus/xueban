//
//  VersionAgent.h
//  xueban
//
//  Created by dang on 16/8/3.
//  Copyright © 2016年 dang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VersionAgent : NSObject
{
    NSString *appVersion;
    NSString *appName;
}

+ (id)sharedInstance;
- (void)checkVersion;
- (BOOL)shouldShowLocalNotification;

@end
