//
//  XBZanButton.m
//  CatZanButton
//
//  Created by dang on 16/8/20.
//  Copyright © 2016年 dang. All rights reserved.
//

#import "XBZanButton.h"

@interface XBZanButton ()<CAAnimationDelegate>
@property (nonatomic, strong) CAEmitterLayer *effectLayer;
@property (nonatomic, strong) CAEmitterCell  *effectCell;
@end

@implementation XBZanButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        [self setup];
    }
    return self;
}

-(void)setup
{
    _effectLayer = [CAEmitterLayer layer];
    [_effectLayer setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    [self.layer addSublayer:_effectLayer];
    [_effectLayer setEmitterShape:kCAEmitterLayerCircle];
    [_effectLayer setEmitterMode:kCAEmitterLayerOutline];
    [_effectLayer setEmitterPosition:CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2)];
    [_effectLayer setEmitterSize:CGSizeMake(CGRectGetWidth(self.frame)-20, CGRectGetHeight(self.frame)-30)];
    
    _effectCell = [CAEmitterCell emitterCell];
    [_effectCell setName:@"zanShape"];
    [_effectCell setContents:(__bridge id)[UIImage imageNamed:@"find_nightmeet_zan_effect"].CGImage];
    [_effectCell setAlphaSpeed:-1.0f];
    [_effectCell setLifetime:1.0f];
    [_effectCell setBirthRate:0];
    [_effectCell setVelocity:30];
    [_effectCell setVelocityRange:20];
    [_effectLayer setEmitterCells:@[_effectCell]];
    _effectCell.scale          = 0.4;
    _effectCell.scaleRange     = 0.3;
}

- (void)click
{
    if (self.selected) {
        
    }
    else
    {
        [UIView animateWithDuration:0.3f delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:5 options:UIViewAnimationOptionCurveLinear animations:^{
            CABasicAnimation *effectLayerAnimation = [CABasicAnimation animationWithKeyPath:@"emitterCells.zanShape.birthRate"];
            [effectLayerAnimation setFromValue:[NSNumber numberWithFloat:100]];
            [effectLayerAnimation setToValue:[NSNumber numberWithFloat:0]];
            [effectLayerAnimation setDuration:0.0f];
            [effectLayerAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            [_effectLayer addAnimation:effectLayerAnimation forKey:@"ZanCount"];
        } completion:^(BOOL finished) {
        }];
    }
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.3;
    animation.delegate = self;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    animation.values = values;
    [self.layer addAnimation:animation forKey:nil];
}


@end
