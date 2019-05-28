//
//  JGJHomeScrollShowMoreMaskingView.m
//  mix
//
//  Created by Tony on 2019/3/6.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJHomeScrollShowMoreMaskingView.h"
#import "JGJMangerTool.h"
@interface JGJHomeScrollShowMoreMaskingView ()

@property (nonatomic, strong) UIImageView *maskingTipsImageView;
@property (nonatomic, strong) UIImageView *arrowImageView;

@property (nonatomic, strong) JGJMangerTool *timer;
@end

@implementation JGJHomeScrollShowMoreMaskingView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance {
    
    //初始化定时器
    if (!_timer) {
        
        _timer = [[JGJMangerTool alloc] init];
        
        _timer.timeInterval = 1.0;
        
    }
//不需要这个文字提示需求 #19373
    [self addSubview:self.maskingTipsImageView];
    [self addSubview:self.arrowImageView];
    [self setUpLayout];
    
    [_maskingTipsImageView updateLayout];
    [_arrowImageView updateLayout];
}

- (void)setUpLayout {
    
    
    [_maskingTipsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
      
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    
    [_arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_offset(0);
        make.bottom.mas_offset(-9);
        make.width.height.mas_equalTo(12);
    }];
}

- (void)startAnimation {
    
    TYWeakSelf(self);
    [_timer startTimer];
    
    _timer.toolTimerBlock = ^{
        
        CAKeyframeAnimation * ani = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
        ani.duration = 1.0;
        ani.removedOnCompletion = NO;
        ani.fillMode = kCAFillModeForwards;
        ani.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        NSValue *value1 = @(CGRectGetMidY(weakself.arrowImageView.frame));
        NSValue *value2 = @(CGRectGetMidY(weakself.arrowImageView.frame) + 3);
        NSValue *value3 = @(CGRectGetMidY(weakself.arrowImageView.frame));
    
        ani.values = @[value1, value2, value3];
        [weakself.arrowImageView.layer addAnimation:ani forKey:@"PostionKeyframeValueAni"];
    };
}

- (void)startTimer {
    
    [_timer startTimer];
}

- (void)stopAnimation {
    
    [_timer inValidTimer];
}

- (UIImageView *)maskingTipsImageView {
    
    if (!_maskingTipsImageView) {
        
        _maskingTipsImageView = [[UIImageView alloc] init];
        _maskingTipsImageView.image = IMAGE(@"more_masking_circle");
    }
    return _maskingTipsImageView;
}

- (UIImageView *)arrowImageView {
    
    if (!_arrowImageView) {
        
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image = IMAGE(@"home_showMore_downArrow");
    }
    return _arrowImageView;
}

@end
