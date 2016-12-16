//
//  FSShareItem.h
//  FSActionSheet
//
//  Created by lifution on 15/10/19.
//  Copyright © 2015年 lifution. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSShareItem : UIView

@property (nonatomic, retain) UIButton *button;
@property (nonatomic, retain) UILabel  *titleLabel;

@property (nonatomic, copy)   NSString *imgName;
@property (nonatomic, copy)   NSString *title;

@end
