//
//  XBBoxSetTableViewController.h
//  xueban
//
//  Created by dang on 2016/11/1.
//  Copyright © 2016年 dang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBBoxSetTableViewController : UITableViewController

//@property (nonatomic, strong) NSDictionary *configDict;
@property (nonatomic) XBBoxSetType setType;
@property (nonatomic, copy) NSString *officialId;

@end
