
//
//  XBFindBookDetailReformer.m
//  xueban
//
//  Created by dang on 2016/11/6.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBFindBookDetailReformer.h"

@implementation XBFindBookDetailReformer

- (id)manager:(CTAPIBaseManager *)manager reformData:(NSDictionary *)data {
    NSArray *msgList = [data[@"msg"][@"bookDetail"] firstObject][@"library_message"];
    return msgList;
}

@end
