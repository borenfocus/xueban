//
//  XBBoxCenterNewsWebViewController.h
//  xueban
//
//  Created by dang on 2016/10/11.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBWebViewController.h"

@interface XBBoxCenterNewsWebViewController : XBWebViewController

//TODO: 把前两个删掉
@property (nonatomic, strong) NSString *urlStr;
@property (nonatomic, strong) NSArray *fileArray;
@property (nonatomic, strong) NSString *officialId;
@property (nonatomic, strong) NSDictionary *newsDict;
//所属公众号
@property (nonatomic, strong) NSString *officialTitle;
@property (nonatomic, strong) NSString *officialImageUrl;
@property (nonatomic, strong) NSDictionary *officialConfigDict;
@end
