//
//  XBBoxSearchTableViewCell.h
//  xueban
//
//  Created by dang on 2016/10/30.
//  Copyright © 2016年 dang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBBoxSearchTableViewCell : UITableViewCell

@property (nonatomic, strong)UIImageView *circleImageView;

- (void)configWithDict:(NSDictionary *)dict;

@end
