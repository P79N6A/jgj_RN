//
//  JGJHomeAlertRightAwayRecommendView.m
//  mix
//
//  Created by Tony on 2018/6/26.
//  Copyright © 2018年 JiZhi. All rights reserved.
//  iphone6 上 height 337 width 270

#import "JGJHomeAlertRightAwayRecommendView.h"
#import "UILabel+GNUtil.h"
#import "NSString+Extend.h"
@interface JGJHomeAlertRightAwayRecommendView ()

@property (nonatomic, strong) UIImageView *alertBackView;
@property (nonatomic, strong) UIButton *gotoRecommendBtn;
@property (nonatomic, strong) UIButton *refuseBtn;
@end
@implementation JGJHomeAlertRightAwayRecommendView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self initializeAppearance];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return self;
}

- (void)initializeAppearance {
    
    [self addSubview:self.alertBackView];
    [self.alertBackView addSubview:self.refuseBtn];
    [self.alertBackView addSubview:self.gotoRecommendBtn];
    [self setUpLayout];
    
    [_gotoRecommendBtn updateLayout];
    _gotoRecommendBtn.layer.cornerRadius = 20;
}

- (void)setUpLayout {
    
    UIImage *backImage = IMAGE(@"推荐弹窗背景");
    [_alertBackView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_offset(0);
        make.centerY.mas_offset(0);
        make.width.mas_equalTo(backImage.size.width);
        make.height.mas_equalTo(backImage.size.height);
        
    }];
    
    [_refuseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.width.height.mas_equalTo(11);
    }];

    
    [_gotoRecommendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.mas_equalTo(-37);
        make.left.mas_equalTo(18);
        make.right.mas_equalTo(-18);
        make.height.mas_equalTo(40);
    }];
    
    
}

// 马上去推荐
- (void)rightAwayToRecommend {
    
    if (_rightAwayToRecommendBlock) {
        
        _rightAwayToRecommendBlock();
        [self removeFromSuperview];
    }
}

// 拒绝
- (void)refuse {
    
    [self removeFromSuperview];
    
}

- (UIImageView *)alertBackView {
    
    if (!_alertBackView) {
        
        _alertBackView = [[UIImageView alloc] init];
        _alertBackView.image = IMAGE(@"推荐弹窗背景");
        _alertBackView.userInteractionEnabled = YES;
        
    }
    return _alertBackView;
}

- (UIButton *)refuseBtn {
    
    if (!_refuseBtn) {
        
        _refuseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_refuseBtn setBackgroundImage:IMAGE(@"homeRecomndCancle") forState:(UIControlStateNormal)];
        [_refuseBtn addTarget:self action:@selector(refuse) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _refuseBtn;
}


- (UIButton *)gotoRecommendBtn {
    
    if (!_gotoRecommendBtn) {
        
        _gotoRecommendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _gotoRecommendBtn.backgroundColor = AppFontffffffColor;
        [_gotoRecommendBtn setTitleColor:AppFontEB4E4EColor forState:(UIControlStateNormal)];
        _gotoRecommendBtn.titleLabel.font = FONT(AppFont36Size);
        [_gotoRecommendBtn setTitle:@"马上去推荐" forState:(UIControlStateNormal)];
        _gotoRecommendBtn.clipsToBounds = YES;
        [_gotoRecommendBtn addTarget:self action:@selector(rightAwayToRecommend) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _gotoRecommendBtn;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (self.touchDismissBlock) {
        
        _touchDismissBlock();
    }
    [self removeFromSuperview];
}

@end
