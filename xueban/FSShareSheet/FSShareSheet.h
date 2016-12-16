//
//  FSShareSheet.h
//  FSActionSheet
//
//  Created by lifution on 15/10/19.
//  Copyright © 2015年 lifution. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FSShareSheetDelegate;

@interface FSShareSheet : UIView

@property (nonatomic, assign) id<FSShareSheetDelegate> delegate;

- (instancetype)initWithTitle:(NSString *)title delegate:(id<FSShareSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle;

- (void)show;

@end

@protocol FSShareSheetDelegate <NSObject>

@optional

- (void)shareSheet:(FSShareSheet *)shareView clickedButtonAtIndex:(NSInteger)index;

@end
