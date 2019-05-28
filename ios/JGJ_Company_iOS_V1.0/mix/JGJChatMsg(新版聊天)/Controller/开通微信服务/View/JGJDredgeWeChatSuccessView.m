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
    [self setUpLayout];
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

@end
