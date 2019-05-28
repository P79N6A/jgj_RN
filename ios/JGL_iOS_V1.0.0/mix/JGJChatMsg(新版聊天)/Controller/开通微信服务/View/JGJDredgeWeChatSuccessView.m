//
//  JGJDredgeWeChatSuccessView.m
//  mix
//
//  Created by Tony on 2018/12/18.
//  Copyright © 2018 JiZhi. All rights reserved.
//

#import "JGJDredgeWeChatSuccessView.h"

@interface JGJDredgeWeChatSuccessView ()

@property (nonatomic, strong) UIImageView *successImage;
@property (nonatomic, strong) UILabel *successInfo;
@property (nonatomic, strong) UILabel *detailInfo;

@property (nonatomic, strong) UIButton *gotoGetRedPacket;
@end
@implementation JGJDredgeWeChatSuccessView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance {
    
    [self addSubview:self.successImage];
    [self addSubview:self.successInfo];
    [self addSubview:self.detailInfo];
    [self addSubview:self.gotoGetRedPacket];
    [self setUpLayout];
    
    [_gotoGetRedPacket updateLayout];
    _gotoGetRedPacket.layer.cornerRadius = 5;
    
}

- (void)setIsWebViewComeIn:(BOOL)isWebViewComeIn {
    
    _isWebViewComeIn = isWebViewComeIn;
    if (_isWebViewComeIn) {
        
        _gotoGetRedPacket.hidden = NO;
    }
}

// 马上去领取红包
- (void)getRedPacketClick {
    
    if (self.getRedPacket) {
        
        _getRedPacket();
    }
    
    
}

- (void)setUpLayout {
    
    [_successImage mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(137);
        make.width.height.mas_equalTo(47);
    }];
    
    [_successInfo mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(0);
        make.top.equalTo(_successImage.mas_bottom).offset(20);
        make.height.mas_equalTo(20);
    }];
    
    [_detailInfo mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(0);
        make.top.equalTo(_successInfo.mas_bottom).offset(20);
        make.height.mas_equalTo(15);
        
    }];
    
    [_gotoGetRedPacket mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(0);
        make.top.equalTo(_detailInfo.mas_bottom).offset(40);
        make.height.mas_equalTo(45);
        make.width.mas_equalTo(155);
    }];
}

- (UIImageView *)successImage {
    
    if (!_successImage) {
        
        _successImage = [[UIImageView alloc] init];
        _successImage.image = IMAGE(@"dredgeWeChatSuccessLogo");
    }
    return _successImage;
}

- (UILabel *)successInfo {
    
    if (!_successInfo) {
        
        _successInfo = [[UILabel alloc] init];
        _successInfo.text = @"恭喜，你已成功开通微信服务";
        _successInfo.textColor = AppFont4688ebColor;
        _successInfo.font = [UIFont boldSystemFontOfSize:AppFont36Size];
        _successInfo.textAlignment = NSTextAlignmentCenter;
    }
    return _successInfo;
}

- (UILabel *)detailInfo {
    
    if (!_detailInfo) {
        
        _detailInfo = [[UILabel alloc] init];
        _detailInfo.text = @"以后可以通过微信接收工作消息了";
        _detailInfo.textColor = AppFont000000Color;
        _detailInfo.font = [UIFont boldSystemFontOfSize:AppFont30Size];
        _detailInfo.textAlignment = NSTextAlignmentCenter;
    }
    return _detailInfo;
}

- (UIButton *)gotoGetRedPacket {
    
    if (!_gotoGetRedPacket) {
        
        _gotoGetRedPacket = [UIButton buttonWithType:UIButtonTypeCustom];
        _gotoGetRedPacket.backgroundColor = AppFontEB4E4EColor;
        [_gotoGetRedPacket setTitle:@"马上去领取" forState:(UIControlStateNormal)];
        [_gotoGetRedPacket setTitleColor:AppFontffffffColor forState:(UIControlStateNormal)];
        _gotoGetRedPacket.titleLabel.font = FONT(AppFont30Size);
        [_gotoGetRedPacket addTarget:self action:@selector(getRedPacketClick) forControlEvents:(UIControlEventTouchUpInside)];
        _gotoGetRedPacket.hidden = YES;
        _gotoGetRedPacket.clipsToBounds = YES;
    }
    return _gotoGetRedPacket;
}
@end
