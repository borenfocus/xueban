//
//  XBBoxToolWebViewController.h
//  xueban
//
//  Created by dang on 2016/10/11.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBWebViewController.h"

@interface XBBoxToolWebViewController : XBWebViewController

//TODO: 删掉前两个
@property (nonatomic, strong) NSString *urlStr;
@property (nonatomic, strong) NSString *officialId;
@property (nonatomic, strong) NSDictionary *configDict;

@end
