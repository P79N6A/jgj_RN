//
//  JGJMarkBillBottomSaveView.m
//  mix
//
//  Created by Tony on 2019/1/4.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJMarkBillBottomSaveView.h"

@interface JGJMarkBillBottomSaveView ()

@property (nonatomic, strong) UIButton *saveBtn;// 保存
@end
@implementation JGJMarkBillBottomSaveView

- (instancetype)init
{
    self = [super init];
    if (self) {
 
        self.backgroundColor = AppFontffffffColor;
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance {
    
    [self addSubview:self.saveBtn];
    [self setUpLayout];
    
    [_saveBtn updateLayout];
    
    _saveBtn.layer.cornerRadius = 5;
}

- (void)setUpLayout {
    
    [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(45);
    }];
}

- (void)saveBtnClick {
    
    if (self.saveToServer) {
        
        _saveToServer();
    }
}

- (UIButton *)saveBtn {
    
    if (!_saveBtn) {
        
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveBtn setTitle:@"保存" forState:(UIControlStateNormal)];
        _saveBtn.titleLabel.font = FONT(AppFont34Size);
        [_saveBtn setTitleColor:AppFontffffffColor forState:(UIControlStateNormal)];
        _saveBtn.backgroundColor = AppFontEB4E4EColor;
        _saveBtn.clipsToBounds = YES;
        [_saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _saveBtn;
}

@end
