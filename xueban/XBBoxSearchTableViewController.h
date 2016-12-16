//
//  XBBoxSearchTableViewController.h
//  xueban
//
//  Created by dang on 16/7/11.
//  Copyright © 2016年 dang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBBoxSearchAPIManager.h"
@protocol XBBoxSearchTableViewControllerDelegate<NSObject>

- (void)didFinishSearch;
- (void)didScroll;

@end

@interface XBBoxSearchTableViewController : UITableViewController

@property (nonatomic, weak) id<XBBoxSearchTableViewControllerDelegate> delegate;
@property (nonatomic) NSString *searchText;
@property (nonatomic, strong) XBBoxSearchAPIManager *searchAPIManager;

@end
