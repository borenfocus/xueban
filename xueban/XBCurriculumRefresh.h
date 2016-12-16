//
//  XBCurriculumRefresh.h
//  xueban
//
//  Created by dang on 2016/11/2.
//  Copyright © 2016年 dang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, XBCurriculumRefreshType) {
    XBCurriculumRefreshTypeBackground,
    XBCurriculumRefreshTypeForeground
};

@interface XBCurriculumRefresh : NSObject

@property (nonatomic, copy) void (^completeHandler)();
@property (nonatomic, copy) void (^failHandler)(NSInteger code);

+ (instancetype)sharedInstance;

- (void)refreshWithType:(XBCurriculumRefreshType) type;

@end
