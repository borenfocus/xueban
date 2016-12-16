//
//  XBPrivateListTableViewController.h
//  xueban
//
//  Created by dang on 2016/10/16.
//  Copyright © 2016年 dang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBPrivateListAPIManager.h"

@interface XBPrivateListTableViewController : UITableViewController

@property (nonatomic, strong) XBPrivateListAPIManager *listAPIManager;

@end
