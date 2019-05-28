//
//  JGJShowWorkDayView.m
//  mix
//
//  Created by Tony on 2018/7/21.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJShowWorkDayView.h"

@interface JGJShowWorkDayView ()

@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIImageView *redPacketImageView;
@property (nonatomic, strong) UIButton *shareWorkDayBtn;

@end

@implementation JGJShowWorkDayView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initializeAppearance];
        self.backgroundColor = [AppFontffffffColor colorWithAlphaComponent:0.01];
    }
    return self;
}

- (void)initializeAppearance {
    
    [self addSubview:self.redPacketImageView];
    [self addSubview:self.shareWorkDayBtn];
    [self addSubview:self.closeBtn];
    [self setUpLayout];
}

- (void)setUpLayout {
    
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.right.mas_equalTo(0);
        make.width.height.mas_equalTo(18);
    }];
    
    [_redPacketImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(0);
        make.right.mas_offset(0);
        make.top.equalTo(_closeBtn.mas_bottom).offset(0);
        make.bottom.mas_equalTo(0);
    }];
    
    [_shareWorkDayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(0);
        make.right.mas_offset(0);
        make.top.equalTo(_closeBtn.mas_bottom).offset(0);
        make.bottom.mas_equalTo(0);
        
    }];
    
}

- (void)shareWorkDayBtnClick {
    
    if (_showWorkDay) {
        
        _showWorkDay();
    }
}

- (void)closeBtnClick {
    
    [self removeFromSuperview];
}

- (UIImageView *)redPacketImageView {
    
    if (!_redPacketImageView) {
        
        _redPacketImageView = [[UIImageView alloc] init];
        _redPacketImageView.contentMode = UIViewContentModeRight;
        _redPacketImageView.image = IMAGE(@"home_ get_redPacket");
    }
    return _redPacketImageView;
}

- (UIButton *)shareWorkDayBtn {
    
    if (!_shareWorkDayBtn) {
        
        _shareWorkDayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareWorkDayBtn addTarget:self action:@selector(shareWorkDayBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _shareWorkDayBtn;
}

- (UIButton *)closeBtn {
    
    if (!_closeBtn) {
        
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:IMAGE(@"showWorkDayClose") forState:(UIControlStateNormal)];
        [_closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _closeBtn;
}

@end
