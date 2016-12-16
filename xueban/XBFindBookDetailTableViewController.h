//
//  XBFindBookDetailTableViewController.h
//  xueban
//
//  Created by dang on 2016/11/6.
//  Copyright © 2016年 dang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBFindBookDetailTableViewController : UITableViewController

@property (nonatomic, copy) NSString *bookId;
@property (nonatomic, strong) NSDictionary *configDict;

@end
