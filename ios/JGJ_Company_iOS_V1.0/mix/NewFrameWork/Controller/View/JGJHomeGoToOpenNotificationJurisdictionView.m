//
//  JGJHomeGoToOpenNotificationJurisdictionView.m
//  mix
//
//  Created by Tony on 2019/3/25.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJHomeGoToOpenNotificationJurisdictionView.h"

@interface JGJHomeGoToOpenNotificationJurisdictionView ()

@property (nonatomic, strong) UIImageView *alertBackView;
@property (nonatomic, strong) UIButton *gotoOpenBtn;
@property (nonatomic, strong) UIButton *refuseBtn;

@end
@implementation JGJHomeGoToOpenNotificationJurisdictionView

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
    [self.alertBackView addSubview:self.gotoOpenBtn];
    [self setUpLayout];
    
    [_gotoOpenBtn updateLayout];
    _gotoOpenBtn.layer.cornerRadius = 22.5;
}

- (void)setUpLayout {
    
    UIImage *backImage = IMAGE(@"openNotificationAlert");
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
    
    
    [_gotoOpenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(-47);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(180);
        make.height.mas_equalTo(45);
    }];
    
    
}

// 马上去推荐
- (void)rightAwayToRecommend {
    
    if (_openNotificationBlock) {
        
        _openNotificationBlock();
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
        _alertBackView.image = IMAGE(@"openNotificationAlert");
        _alertBackView.userInteractionEnabled = YES;
        
    }
    return _alertBackView;
}

- (UIButton *)refuseBtn {
    
    if (!_refuseBtn) {
        
        _refuseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_refuseBtn setBackgroundImage:IMAGE(@"closeOpenNotificationAlert") forState:(UIControlStateNormal)];
        [_refuseBtn addTarget:self action:@selector(refuse) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _refuseBtn;
}


- (UIButton *)gotoOpenBtn {
    
    if (!_gotoOpenBtn) {
        
        _gotoOpenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _gotoOpenBtn.backgroundColor = AppFontEB4E4EColor;
        [_gotoOpenBtn setTitleColor:AppFontffffffColor forState:(UIControlStateNormal)];
        _gotoOpenBtn.titleLabel.font = FONT(AppFont30Size);
        [_gotoOpenBtn setTitle:@"去开启" forState:(UIControlStateNormal)];
        _gotoOpenBtn.clipsToBounds = YES;
        [_gotoOpenBtn addTarget:self action:@selector(rightAwayToRecommend) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _gotoOpenBtn;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (self.touchDismissBlock) {
        
        _touchDismissBlock();
    }
    [self removeFromSuperview];
}

@end
