//
//  JGJHomeAlertOneMinuteTestView.m
//  mix
//
//  Created by Tony on 2018/6/25.
//  Copyright © 2018年 JiZhi. All rights reserved.
//  iphone 6 上 width 290 height 385

#import "JGJHomeAlertOneMinuteTestView.h"
#import "UILabel+GNUtil.h"
@interface JGJHomeAlertOneMinuteTestView ()

@property (nonatomic, strong) UIImageView *alertBackView;
@property (nonatomic, strong) UILabel *welcomeLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIButton *gotoLookBtn;
@property (nonatomic, strong) UILabel *bottomLabel;

@end
@implementation JGJHomeAlertOneMinuteTestView

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
    [self.alertBackView addSubview:self.welcomeLabel];
    [self.alertBackView addSubview:self.detailLabel];
    [self.alertBackView addSubview:self.gotoLookBtn];
    [self.alertBackView addSubview:self.bottomLabel];
    [self setUpLayout];
}

- (void)setUpLayout {
    
    CGFloat ratio = TYGetUIScreenWidth / 375.0;
    _alertBackView.sd_layout.centerXEqualToView(self).centerYEqualToView(self).widthIs(290 * ratio).heightIs(385 * ratio);
    _bottomLabel.sd_layout.bottomSpaceToView(_alertBackView, 40).leftSpaceToView(_alertBackView, 0).rightSpaceToView(_alertBackView, 0).heightIs(18);
    _gotoLookBtn.sd_layout.heightIs(43).bottomSpaceToView(_bottomLabel, 16).leftSpaceToView(_alertBackView, 18).rightSpaceToView(_alertBackView, 18);
    _detailLabel.sd_layout.leftSpaceToView(_alertBackView, 0).rightSpaceToView(_alertBackView, 0).bottomSpaceToView(_gotoLookBtn, 28).heightIs(18);
    _welcomeLabel.sd_layout.leftSpaceToView(_alertBackView, 0).rightSpaceToView(_alertBackView, 0).bottomSpaceToView(_detailLabel, 16).heightIs(18);
}

- (void)gotoLookClick {
    
    if (_explaintEvent) {
        
        _explaintEvent();
        [self removeFromSuperview];
    }
}

- (UIImageView *)alertBackView {
    
    if (!_alertBackView) {
        
        _alertBackView = [[UIImageView alloc] init];
        _alertBackView.image = IMAGE(@"bg-min-min");
        _alertBackView.userInteractionEnabled = YES;
    }
    return _alertBackView;
}

- (UILabel *)welcomeLabel {
    
    if (!_welcomeLabel) {
        
        _welcomeLabel = [[UILabel alloc] init];
        _welcomeLabel.text = @"你好，欢迎加入吉工家";
        _welcomeLabel.font = [UIFont boldSystemFontOfSize:AppFont36Size];
        _welcomeLabel.textAlignment = NSTextAlignmentCenter;
        _welcomeLabel.textColor = AppFont000000Color;
    }
    return _welcomeLabel;
}

- (UILabel *)detailLabel {
    
    if (!_detailLabel) {
        
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textColor = AppFont666666Color;
        _detailLabel.text = @"一分钟说明教你快速上手使用APP";
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.font = FONT(AppFont32Size);
    }
    return _detailLabel;
}

- (UIButton *)gotoLookBtn {
    
    if (!_gotoLookBtn) {
        
        _gotoLookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_gotoLookBtn setBackgroundImage:IMAGE(@"渐变按钮") forState:(UIControlStateNormal)];
        [_gotoLookBtn setTitle:@"马上去看" forState:(UIControlStateNormal)];
        [_gotoLookBtn setTitleColor:AppFontffffffColor forState:(UIControlStateNormal)];
        _gotoLookBtn.titleLabel.font = FONT(AppFont32Size);
        [_gotoLookBtn addTarget:self action:@selector(gotoLookClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _gotoLookBtn;
}

- (UILabel *)bottomLabel {
    
    if (!_bottomLabel) {
        
        _bottomLabel = [[UILabel alloc] init];
        _bottomLabel.text = @"以后在 我 -> 帮助中心 看";
        _bottomLabel.textAlignment = NSTextAlignmentCenter;
        _bottomLabel.font = FONT(AppFont32Size);
        _bottomLabel.textColor = AppFont666666Color;
        
        [_bottomLabel markText:@"我 -> 帮助中心" withColor:AppFont000000Color];
    }
    return _bottomLabel;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (self.touchDismissBlock) {
        
        _touchDismissBlock();
    }
    [self removeFromSuperview];
}
@end
