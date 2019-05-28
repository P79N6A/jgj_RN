//
//  JGJSyncProjectInfoBottomView.m
//  mix
//
//  Created by Tony on 2018/12/12.
//  Copyright © 2018 JiZhi. All rights reserved.
//

#import "JGJSyncProjectInfoBottomView.h"

@interface JGJSyncProjectInfoBottomView ()

@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) UIView *topLine;
@end
@implementation JGJSyncProjectInfoBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initializeAppearance];
        
    }
    return self;
}

- (void)initializeAppearance {

    self.backgroundColor = AppFontffffffColor;
    [self addSubview:self.topLine];
    
    [self addSubview:self.leftBtn];
    [self addSubview:self.rightBtn];
    [self setUpLayout];
    
    [_leftBtn updateLayout];
    [_rightBtn updateLayout];
    
    _leftBtn.clipsToBounds = YES;
    _leftBtn.layer.cornerRadius = 5;
    _leftBtn.layer.borderWidth = 1;
    _leftBtn.layer.borderColor = AppFontEBEBEBColor.CGColor;
    
    _rightBtn.clipsToBounds = YES;
    _rightBtn.layer.cornerRadius = 5;
    _rightBtn.layer.borderWidth = 1;
    _rightBtn.layer.borderColor = AppFontEBEBEBColor.CGColor;
    
}

- (void)setUpLayout {
    
    CGFloat btnWidth = (TYGetUIScreenWidth - 30) / 2;
    [_topLine mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.mas_offset(0);
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(btnWidth);
        make.height.mas_equalTo(40);
    }];
    
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_offset(0);
        make.right.mas_equalTo(-10);
        make.width.mas_equalTo(btnWidth);
        make.height.mas_equalTo(40);
    }];
}

- (void)bottomBtnClick:(UIButton *)sender {

    // 0 代表点击左边按钮 1 代表点击右边按钮
    NSInteger index = sender.tag - 10;
    if (self.bottomBlock) {
        
        _bottomBlock(index);
    }
}


- (UIView *)topLine {
    
    if (!_topLine) {
        
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = AppFontEBEBEBColor;
    }
    return _topLine;
}

- (UIButton *)leftBtn {
    
    if (!_leftBtn) {
        
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.backgroundColor = [UIColor whiteColor];
        [_leftBtn setTitle:@"拒绝" forState:(UIControlStateNormal)];
        [_leftBtn setTitleColor:AppFont000000Color forState:(UIControlStateNormal)];
        _leftBtn.titleLabel.font = FONT(AppFont30Size);
        _leftBtn.tag = 10;
        [_leftBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _leftBtn;
}

- (UIButton *)rightBtn {
    
    if (!_rightBtn) {
        
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.backgroundColor = AppFontEB4E4EColor;
        [_rightBtn setTitle:@"同步" forState:(UIControlStateNormal)];
        [_rightBtn setTitleColor:AppFontffffffColor forState:(UIControlStateNormal)];
        _rightBtn.titleLabel.font = FONT(AppFont30Size);
        _rightBtn.tag = 11;
        [_rightBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _rightBtn;
}
@end
