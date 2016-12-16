//
//  AboutXueCustomTableViewCell.m
//  ssdutAssistant
//
//  Created by OurEDA on 15/9/11.
//  Copyright (c) 2015年 OurEDA. All rights reserved.
//

#import "AboutXueCustomTableViewCell.h"
@interface AboutXueCustomTableViewCell()
@property(nonatomic,strong)IBOutlet UILabel * titleLabel;
@property(nonatomic,strong)IBOutlet UIView * lineView;
@end

@implementation AboutXueCustomTableViewCell

-(void)setCellType:(NSInteger)cellIndex
{
    switch (cellIndex) {
        case 1:
            self.titleLabel.text = @"用户协议";
            self.lineView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
            break;
        case 2:
            self.titleLabel.text = @"去评分";
            self.lineView.hidden = YES;
            break;
            
        default:
            break;
    }
}
@end
