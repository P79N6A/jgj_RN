//
//  JGJDredgeWeChatFialeView.m
//  mix
//
//  Created by Tony on 2018/12/18.
//  Copyright © 2018 JiZhi. All rights reserved.
//

#import "JGJDredgeWeChatFialeView.h"
#import "UIImage+TYCreateQRCode.h"
@interface JGJDredgeWeChatFialeView ()

@property (nonatomic, strong) UIScrollView *bgScrollView;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIView *qrcodeBackView;
@property (nonatomic, strong) UIImageView *qrcodeImage;
@property (nonatomic, strong) UIButton *saveBtn;
@end
@implementation JGJDredgeWeChatFialeView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance {
    
    [self addSubview:self.bgScrollView];
    [self.bgScrollView addSubview:self.bgImageView];
    
    [self.bgScrollView addSubview:self.qrcodeBackView];
    [self.qrcodeBackView addSubview:self.qrcodeImage];
    [self.bgScrollView addSubview:self.saveBtn];
    [self setUpLayout];
}

- (void)setCodeUrl:(NSString *)codeUrl {
    
    _codeUrl = codeUrl;
    self.qrcodeImage.image = [UIImage imageOfQRFromURL:_codeUrl];
}

// 保存照片
- (void)saveQrCodePictureClick {
    
    if (self.saveQrCodePicture) {
        
        _saveQrCodePicture();
    }
}


- (void)setUpLayout {
    
    [_bgScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.bottom.offset(0);
        
    }];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.top.mas_equalTo(30);
        make.bottom.mas_equalTo(-40);
    }];
    
    UIImage *bgImage = IMAGE(@"weixinbangdiFiale");
    _bgScrollView.contentSize = CGSizeMake(TYGetUIScreenWidth, bgImage.size.height + 70);
    
    [_qrcodeBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(72);
        make.top.mas_equalTo(90);
        make.width.height.mas_equalTo(115);
    }];
    
    [_qrcodeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.mas_equalTo(5);
        make.right.bottom.mas_equalTo(-5);
    }];
    
    [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(_qrcodeBackView.mas_centerY).offset(0);
        make.left.equalTo(_qrcodeBackView.mas_right).offset(33);
        make.width.mas_equalTo(125);
        make.height.mas_equalTo(35);
    }];
    
    
    // 延迟0.1秒后获取frame
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        _saveBtn.layer.cornerRadius = 5;
        _saveBtn.clipsToBounds = YES;
    });
}

- (UIScrollView *)bgScrollView {
    
    if (!_bgScrollView) {
        
        _bgScrollView = [[UIScrollView alloc] init];
        _bgScrollView.backgroundColor = AppFont3f3f3fColor;
        _bgScrollView.bounces = NO;
    }
    return _bgScrollView;
}

- (UIImageView *)bgImageView {
    
    if (!_bgImageView) {
        
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = IMAGE(@"weixinbangdiFiale");
    }
    return _bgImageView;
}

- (UIView *)qrcodeBackView {
    
    if (!_qrcodeBackView) {
        
        _qrcodeBackView = [[UIView alloc] init];
        _qrcodeBackView.backgroundColor = AppFontf2f5f8Color;
    }
    return _qrcodeBackView;
}

- (UIImageView *)qrcodeImage {
    
    if (!_qrcodeImage) {
        
        _qrcodeImage = [[UIImageView alloc] init];
    }
    return _qrcodeImage;
}



- (UIButton *)saveBtn {
    
    if (!_saveBtn) {
        
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveBtn setTitle:@"保存二维码到相册" forState:(UIControlStateNormal)];
        _saveBtn.titleLabel.font = FONT(AppFont24Size);
        [_saveBtn setTitleColor:AppFontffffffColor forState:(UIControlStateNormal)];
        [_saveBtn setBackgroundColor:AppFontEB4E4EColor];
        [_saveBtn addTarget:self action:@selector(saveQrCodePictureClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _saveBtn;
}


@end
