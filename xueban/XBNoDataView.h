//
//  XBNoDataView.h
//  xueban
//
//  Created by dang on 2016/10/28.
//  Copyright © 2016年 dang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBNoDataView : UIView

@property (nonatomic, copy) NSString *labelTitle;
@property (nonatomic, copy) NSString *imgName;

+ (XBNoDataView*)configImageName:(NSString *)imageName withTitle:(NSString *)title;

@end
