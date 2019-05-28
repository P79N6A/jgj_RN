//
//  JGJNewLeaderRecordButtonView.m
//  mix
//
//  Created by Tony on 2019/1/3.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJNewLeaderRecordButtonView.h"
@interface JGJNewLeaderRecordButtonView ()

@property (nonatomic, strong) UIView *leftLine;
@property (nonatomic, strong) UIView *rightLine;
@property (nonatomic, strong) UILabel *tipsLabel;//在吉工家记工 数据永远不会丢失
@property (nonatomic, strong) UIButton *middleMarkBillBtn;// 班组长:批量记工按钮 工人:记一笔工
@property (nonatomic, strong) UIButton *rightMarkBillBtn;// 班组长:记一笔工 工人:批量记多天
@property (nonatomic, strong) UIButton *borrowOrCloseBillBtn;// 借支/结算按钮


@end
@implementation JGJNewLeaderRecordButtonView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance {
    
    [self addSubview:self.leftLine];
    [self addSubview:self.tipsLabel];
    [self addSubview:self.rightLine];
    [self addSubview:self.borrowOrCloseBillBtn];
    [self addSubview:self.middleMarkBillBtn];
    [self addSubview:self.rightMarkBillBtn];
    [self addSubview:self.scrollTipsLabel];
    [self setUpLayout];
    
    [_borrowOrCloseBillBtn updateLayout];
    [_middleMarkBillBtn updateLayout];
    [_rightMarkBillBtn updateLayout];
    [_scrollTipsLabel updateLayout];
    
    _borrowOrCloseBillBtn.layer.cornerRadius = 19;
    _middleMarkBillBtn.layer.cornerRadius = 19;
    _rightMarkBillBtn.layer.cornerRadius = 19;
    _scrollTipsLabel.layer.cornerRadius = 10;

}

- (void)setUpLayout {
    
    [_tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(15);
        make.centerX.mas_offset(0);
        make.height.mas_equalTo(12);
    }];
    
    [_leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(_tipsLabel.mas_centerY).offset(0);
        make.left.mas_equalTo(15);
        make.right.equalTo(_tipsLabel.mas_left).mas_equalTo(-10);
        make.height.mas_equalTo(1);
    }];
    
    [_rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(_tipsLabel.mas_centerY).offset(0);
        make.left.equalTo(_tipsLabel.mas_right).offset(10);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(1);
    }];
    
    [_middleMarkBillBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(0);
        make.top.equalTo(_tipsLabel.mas_bottom).mas_equalTo(15);
        make.width.mas_equalTo(135);
        make.height.mas_equalTo(37);
    }];
    
    
    [_borrowOrCloseBillBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(_middleMarkBillBtn.mas_left).offset(-15);
        make.centerY.equalTo(_middleMarkBillBtn.mas_centerY).mas_offset(0);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(37);
    }];
    
    
    [_rightMarkBillBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(_middleMarkBillBtn.mas_right).offset(15);
        make.centerY.equalTo(_middleMarkBillBtn.mas_centerY).mas_offset(0);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(37);
    }];
    
    CGSize size = [NSString stringWithContentSize:CGSizeMake(CGFLOAT_MAX, 19) content:@"左右滑动日历，可以切换月份哦～" font:12];
    
    [_scrollTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_offset(0);
        make.centerY.equalTo(_tipsLabel.mas_centerY).offset(0);
        make.height.mas_equalTo(19);
        make.width.mas_equalTo(size.width + 20);
    }];
}

- (void)hiddenScrollTipsLabel {
    
    BOOL isScrolled = [TYUserDefaults objectForKey:JGJHomeVCScrollTipsLabelHaveScroll];
    
    _scrollTipsLabel.hidden = isScrolled;
}

- (void)updateLeaderRecordButtonWithRoleID {
    
    // 中间按钮
    if (JLGisLeaderBool) {
        
        [_middleMarkBillBtn setTitle:@"批量记工" forState:(UIControlStateNormal)];
        
    }else {
        
        [_middleMarkBillBtn setTitle:@"记一笔工" forState:(UIControlStateNormal)];
    }
    
    // 右边按钮
    if (JLGisLeaderBool) {
        
        [_rightMarkBillBtn setTitle:@"记一笔工" forState:(UIControlStateNormal)];
        
    }else {
        
        [_rightMarkBillBtn setTitle:@"批量记多天" forState:(UIControlStateNormal)];
    }
}

// 借支 结算
- (void)borrowOrCloseBillBtnClick {
    
    if ([self.delegate respondsToSelector:@selector(JGJNewLeaderRecordButtonClickBorrowOrCloseMarkBillBtn)]) {

        [self.delegate JGJNewLeaderRecordButtonClickBorrowOrCloseMarkBillBtn];
    }
   
}

// 批量记
- (void)middleMarkBillBtnClick {
    
    if ([self.delegate respondsToSelector:@selector(JGJNewLeaderRecordButtonClickMiddleBtnWithType:)]) {
        
        if (JLGisLeaderBool) {
            
            // 批量记多人
            [self.delegate JGJNewLeaderRecordButtonClickMiddleBtnWithType:JGJHomeRecordButtonMakeMorePeopleBillType];
            
        }else {
            
            // 记一笔工
            [self.delegate JGJNewLeaderRecordButtonClickMiddleBtnWithType:JGJHomeRecordButtonMakeSingleBillType];
            
        }
    }
}

// 记单笔
- (void)rightMarkBillBtnClick {
    
    if ([self.delegate respondsToSelector:@selector(JGJNewLeaderRecordButtonClickRightBtnWithType:)]) {
        
        if (JLGisLeaderBool) {
            
            // 记一笔工
            [self.delegate JGJNewLeaderRecordButtonClickRightBtnWithType:JGJHomeRecordButtonMakeSingleBillType];
            
        }else {
            
            // 批量记多天
            [self.delegate JGJNewLeaderRecordButtonClickRightBtnWithType:JGJHomeRecordButtonMakeMoreDayBillType];
        }
    }
}

- (UIView *)leftLine {
    
    if (!_leftLine) {
        
        _leftLine = [[UIView alloc] init];
        _leftLine.backgroundColor = AppFontccccccColor;
    }
    return _leftLine;
}

- (UILabel *)tipsLabel {
    
    if (!_tipsLabel) {
        
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.textColor = AppFont666666Color;
        _tipsLabel.font = FONT(AppFont24Size);
        _tipsLabel.text = @"在吉工家记工 数据永远不会丢失";
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipsLabel;
}

- (UIView *)rightLine {
    
    if (!_rightLine) {
        
        _rightLine = [[UIView alloc] init];
        _rightLine.backgroundColor = AppFontccccccColor;
    }
    return _rightLine;
}

- (UIButton *)borrowOrCloseBillBtn {
    
    if (!_borrowOrCloseBillBtn) {
        
        _borrowOrCloseBillBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_borrowOrCloseBillBtn setBackgroundColor:[UIColor whiteColor]];
        [_borrowOrCloseBillBtn setTitle:@"借支/结算" forState:(UIControlStateNormal)];
        [_borrowOrCloseBillBtn setTitleColor:AppFontEB4E4EColor forState:UIControlStateNormal];
        _borrowOrCloseBillBtn.titleLabel.font = FONT(AppFont28Size);
        _borrowOrCloseBillBtn.layer.borderWidth = 1.5;
        _borrowOrCloseBillBtn.layer.borderColor = AppFontEB4E4EColor.CGColor;
        _borrowOrCloseBillBtn.clipsToBounds = YES;
        [_borrowOrCloseBillBtn addTarget:self action:@selector(borrowOrCloseBillBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _borrowOrCloseBillBtn;
}

- (UIButton *)middleMarkBillBtn {
    
    if (!_middleMarkBillBtn) {
        
        _middleMarkBillBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _middleMarkBillBtn.frame = CGRectMake(0, 0, 135, 37);
        [_middleMarkBillBtn setBackgroundColor:AppFontEB4E4EColor];
        if (JLGisLeaderBool) {
            
            [_middleMarkBillBtn setTitle:@"批量记工" forState:(UIControlStateNormal)];
            
        }else {
            
            [_middleMarkBillBtn setTitle:@"记一笔工" forState:(UIControlStateNormal)];
        }
        
        [_middleMarkBillBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _middleMarkBillBtn.titleLabel.font = FONT(AppFont36Size);
        _middleMarkBillBtn.layer.shadowOffset =  CGSizeMake(0, 2);//阴影的偏移量
        _middleMarkBillBtn.layer.shadowOpacity = 0.53;//阴影的不透明度
        _middleMarkBillBtn.layer.shadowColor = AppFontBF3434Color.CGColor;//阴影的颜色
        [_middleMarkBillBtn addTarget:self action:@selector(middleMarkBillBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _middleMarkBillBtn;
}

- (UIButton *)rightMarkBillBtn {
    
    if (!_rightMarkBillBtn) {
        
        _rightMarkBillBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightMarkBillBtn setBackgroundColor:AppFontffffffColor];
        if (JLGisLeaderBool) {
            
            [_rightMarkBillBtn setTitle:@"记一笔工" forState:(UIControlStateNormal)];
            
        }else {
            
            [_rightMarkBillBtn setTitle:@"批量记多天" forState:(UIControlStateNormal)];
        }
        
        [_rightMarkBillBtn setTitleColor:AppFontEB4E4EColor forState:(UIControlStateNormal)];
        _rightMarkBillBtn.titleLabel.font = FONT(AppFont28Size);
        _rightMarkBillBtn.layer.borderWidth = 1.5;
        _rightMarkBillBtn.layer.borderColor = AppFontEB4E4EColor.CGColor;
        _rightMarkBillBtn.clipsToBounds = YES;
        
        [_rightMarkBillBtn addTarget:self action:@selector(rightMarkBillBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightMarkBillBtn;
}

- (UILabel *)scrollTipsLabel {
    
    if (!_scrollTipsLabel) {
        
        _scrollTipsLabel = [[UILabel alloc] init];
        _scrollTipsLabel.text = @"左右滑动日历，可以切换月份哦～";
        _scrollTipsLabel.textColor = AppFontffffffColor;
        _scrollTipsLabel.font = FONT(AppFont24Size);
        _scrollTipsLabel.textAlignment = NSTextAlignmentCenter;
        _scrollTipsLabel.clipsToBounds = YES;
        _scrollTipsLabel.backgroundColor = AppFont010101Color;
    }
    return _scrollTipsLabel;
}

@end
