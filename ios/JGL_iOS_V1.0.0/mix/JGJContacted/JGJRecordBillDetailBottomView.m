//
//  JGJRecordBillDetailBottomView.m
//  mix
//
//  Created by Tony on 2018/6/5.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJRecordBillDetailBottomView.h"

@interface JGJRecordBillDetailBottomView ()

@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIButton *modifyBtn;

@end
@implementation JGJRecordBillDetailBottomView

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
    
    [self addSubview:self.topLine];
    [self addSubview:self.deleteBtn];
    [self addSubview:self.modifyBtn];
    [self setUpLayout];
    [_deleteBtn updateLayout];
    [_modifyBtn updateLayout];
    
    _deleteBtn.layer.cornerRadius = 3;
    _modifyBtn.layer.cornerRadius = 3;
}

- (void)setUpLayout {
    
    CGFloat btnWidth = (TYGetUIScreenWidth - 30 - 30) / 2;
    _topLine.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).rightSpaceToView(self, 0).heightIs(.5);
    _modifyBtn.sd_layout.widthIs(btnWidth).rightSpaceToView(self, 10).bottomSpaceToView(self, 20).heightIs(45);
    _deleteBtn.sd_layout.leftSpaceToView(self, 10).widthIs(btnWidth).heightIs(45).bottomSpaceToView(self, 20);
}

- (void)deleteTheBill {
    
    if (_deleteBill) {
        
        _deleteBill();
    }
}

- (void)modifyTheBill {
    
    if (_modifyBill) {
        
        _modifyBill();
    }
}

- (UIView *)topLine {
    
    if (!_topLine) {
        
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = AppFontdbdbdbColor;
    }
    return _topLine;
}

- (UIButton *)deleteBtn {
    
    if (!_deleteBtn) {
        
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.backgroundColor = AppFontffffffColor;
        _deleteBtn.titleLabel.font = FONT(AppFont30Size);
        [_deleteBtn setTitle:@"删除" forState:(UIControlStateNormal)];
        [_deleteBtn setTitleColor:AppFont000000Color forState:(UIControlStateNormal)];
        _deleteBtn.layer.borderWidth = 1;
        _deleteBtn.layer.borderColor = AppFont666666Color.CGColor;
        
        [_deleteBtn addTarget:self action:@selector(deleteTheBill) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    return _deleteBtn;
}

- (UIButton *)modifyBtn {
    
    if (!_modifyBtn) {
        
        _modifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _modifyBtn.backgroundColor = AppFontffffffColor;
        _modifyBtn.titleLabel.font = FONT(AppFont30Size);
        [_modifyBtn setTitle:@"修改" forState:(UIControlStateNormal)];
        [_modifyBtn setTitleColor:AppFont000000Color forState:(UIControlStateNormal)];
        _modifyBtn.layer.borderWidth = 1;
        _modifyBtn.layer.borderColor = AppFont666666Color.CGColor;
        [_modifyBtn addTarget:self action:@selector(modifyTheBill) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _modifyBtn;
}
@end
