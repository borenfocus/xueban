//
//  XBFindNightMeetDetailViewController.h
//  xueban
//
//  Created by dang on 16/8/26.
//  Copyright © 2016年 dang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBFindNightMeetDetailViewController : UIViewController

@property (nonatomic) NSIndexPath *indexPath;
@property (nonatomic, strong) NSDictionary *configDict;
@property (nonatomic) NSInteger postId;
@property (nonatomic) BOOL shouldShowKeyboard;
@end
