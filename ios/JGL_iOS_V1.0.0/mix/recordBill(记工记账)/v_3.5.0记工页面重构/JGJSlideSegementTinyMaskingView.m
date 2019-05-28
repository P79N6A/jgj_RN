//
//  JGJSlideSegementTinyMaskingView.m
//  mix
//
//  Created by Tony on 2019/1/10.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJSlideSegementTinyMaskingView.h"
#import "SJButton.h"
@interface JGJSlideSegementTinyMaskingView ()

@property (nonatomic, strong) UIView *btnBackView;
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UIImageView *tipsImageView;
@end
@implementation JGJSlideSegementTinyMaskingView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self initializeAppearance];
        self.backgroundColor = [AppFont000000Color colorWithAlphaComponent:0.74];
    }
    return self;
}

- (void)initializeAppearance {
    
    [self addSubview:self.btnBackView];
    [self.btnBackView addSubview:self.topImageView];
    
    [self addSubview:self.tipsImageView];
    
    [self setUpLayout];
    
    [_btnBackView updateLayout];

    _btnBackView.layer.cornerRadius = 5;
}

- (void)setUpLayout {
    
    CGFloat btnWidth = 80;
    CGFloat btnHeight = 65;
    CGFloat width = TYGetUIScreenWidth / 3;
    
    UIImage *btnBackImage = IMAGE(@"slideSegementTopMaskingView");
    [_btnBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-(width / 2 - btnWidth / 2) - 10);
        make.height.mas_equalTo(btnBackImage.size.height);
        make.left.mas_equalTo(width / 2 - btnWidth / 2 + 10);
        make.top.mas_equalTo(54);
        
    }];
    
    [_topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    
    
    UIImage *tipsImage = IMAGE(@"slideSegementNewMiddleMaskingView");
    [_tipsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.height.mas_equalTo(tipsImage.size.height);
        make.width.mas_equalTo(tipsImage.size.width);
        make.centerX.mas_offset(0);
        make.top.equalTo(_btnBackView.mas_bottom).offset(20);
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (_maskingTouch) {
        
        _maskingTouch();
    }
    
}

- (UIView *)btnBackView {
    
    if (!_btnBackView) {
        
        _btnBackView = [[UIView alloc] init];
        _btnBackView.backgroundColor = AppFont3A3F4EColor;
        _btnBackView.clipsToBounds = YES;
    }
    return _btnBackView;
}

- (UIImageView *)topImageView {
    
    if (!_topImageView) {
        
        _topImageView = [[UIImageView alloc] init];
        _topImageView.image = IMAGE(@"slideSegementTopMaskingView");
    }
    return _topImageView;
}

- (UIImageView *)tipsImageView {
    
    if (!_tipsImageView) {
        
        _tipsImageView = [[UIImageView alloc] init];
        _tipsImageView.image = IMAGE(@"slideSegementNewMiddleMaskingView");
    }
    return _tipsImageView;
}
@end
