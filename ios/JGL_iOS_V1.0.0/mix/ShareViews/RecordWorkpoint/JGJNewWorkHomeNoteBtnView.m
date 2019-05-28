//
//  JGJNewWorkHomeNoteBtnView.m
//  mix
//
//  Created by Tony on 2019/1/3.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJNewWorkHomeNoteBtnView.h"

@interface JGJNewWorkHomeNoteBtnView ()

@property (nonatomic, strong) UIButton *borrowOrCloseBillBtn;// 借支 结算
@property (nonatomic, strong) UIButton *singleMarkBillBtn;// 记单笔按钮
@end
@implementation JGJNewWorkHomeNoteBtnView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = AppFontffffffColor;
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance {
    
    [self addSubview:self.borrowOrCloseBillBtn];
    [self addSubview:self.singleMarkBillBtn];
    [self setUpLayout];
    
    [_borrowOrCloseBillBtn updateLayout];
    [_singleMarkBillBtn updateLayout];
    
    _borrowOrCloseBillBtn.layer.cornerRadius = 5;
    _singleMarkBillBtn.layer.cornerRadius = 5;
}

- (void)setUpLayout {
    
    [_borrowOrCloseBillBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_offset(20);
        make.centerY.mas_offset(0);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(45);
    }];
    
    [_singleMarkBillBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(_borrowOrCloseBillBtn.mas_centerY).offset(0);
        make.left.equalTo(_borrowOrCloseBillBtn.mas_right).offset(35);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(45);
    }];
}

- (void)borrowOrCloseBillBtnClick {
    
    if ([self.delegate respondsToSelector:@selector(JGJNewWorkHomeNoteButtonClickBorrowOrCloseMarkBillBtn)]) {
        
        [self.delegate JGJNewWorkHomeNoteButtonClickBorrowOrCloseMarkBillBtn];
    }
}

- (void)singleMarkBillBtnClick {
    
    if ([self.delegate respondsToSelector:@selector(JGJNewWorkHomeNoteButtonClickSingleMarkBillBtn)]) {
        
        [self.delegate JGJNewWorkHomeNoteButtonClickSingleMarkBillBtn];
    }
}


- (UIButton *)borrowOrCloseBillBtn {
    
    if (!_borrowOrCloseBillBtn) {
        
        _borrowOrCloseBillBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_borrowOrCloseBillBtn setBackgroundColor:AppFontffffffColor];
        [_borrowOrCloseBillBtn setTitle:@"借支/结算" forState:(UIControlStateNormal)];
        [_borrowOrCloseBillBtn setTitleColor:AppFont000000Color forState:(UIControlStateNormal)];
        _borrowOrCloseBillBtn.titleLabel.font = FONT(AppFont30Size);
        _borrowOrCloseBillBtn.layer.borderWidth = 1;
        _borrowOrCloseBillBtn.layer.borderColor = AppFont666666Color.CGColor;
        _borrowOrCloseBillBtn.clipsToBounds = YES;
        [_borrowOrCloseBillBtn addTarget:self action:@selector(borrowOrCloseBillBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _borrowOrCloseBillBtn;
}

- (UIButton *)singleMarkBillBtn {
    
    if (!_singleMarkBillBtn) {
        
        _singleMarkBillBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_singleMarkBillBtn setBackgroundColor:AppFontEB4E4EColor];
        [_singleMarkBillBtn setTitle:@"马上记一笔工" forState:(UIControlStateNormal)];
        [_singleMarkBillBtn setTitleColor:AppFontffffffColor forState:(UIControlStateNormal)];
        _singleMarkBillBtn.titleLabel.font = FONT(AppFont30Size);
        _singleMarkBillBtn.clipsToBounds = YES;
        [_singleMarkBillBtn addTarget:self action:@selector(singleMarkBillBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _singleMarkBillBtn;
}
@end
