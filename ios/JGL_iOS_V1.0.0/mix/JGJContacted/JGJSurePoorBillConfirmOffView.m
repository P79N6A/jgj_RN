//
//  JGJSurePoorBillConfirmOffView.m
//  mix
//
//  Created by Tony on 2019/2/19.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJSurePoorBillConfirmOffView.h"
#import "UILabel+GNUtil.h"
@interface JGJSurePoorBillConfirmOffView ()

@property (nonatomic, strong) UILabel *firstPointLabel;
@property (nonatomic, strong) UILabel *firstInfoLabel;

@property (nonatomic, strong) UILabel *secondPointLabel;
@property (nonatomic, strong) UILabel *secondInfoLabel;

@property (nonatomic, strong) UILabel *thirdPointLabel;
@property (nonatomic, strong) UILabel *thirdInfoLabel;

@property (nonatomic, strong) UIButton *startBtn;

@end
@implementation JGJSurePoorBillConfirmOffView

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
    
    [self addSubview:self.firstPointLabel];
    [self addSubview:self.firstInfoLabel];
    
    [self addSubview:self.secondPointLabel];
    [self addSubview:self.secondInfoLabel];
    
    [self addSubview:self.thirdPointLabel];
    [self addSubview:self.thirdInfoLabel];
    
    [self addSubview:self.startBtn];
    
    [self setUpLayout];
    
    [_firstPointLabel updateLayout];
    [_secondPointLabel updateLayout];
    [_thirdPointLabel updateLayout];
    [_startBtn updateLayout];
    
    _firstPointLabel.clipsToBounds = YES;
    _firstPointLabel.layer.cornerRadius = 9;
    
    _secondPointLabel.clipsToBounds = YES;
    _secondPointLabel.layer.cornerRadius = 9;
    
    _thirdPointLabel.clipsToBounds = YES;
    _thirdPointLabel.layer.cornerRadius = 9;
    
    _startBtn.layer.cornerRadius = 5;
}

- (void)setUpLayout {
    
    [_firstPointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(40);
        make.width.height.mas_equalTo(18);
    }];
    
    CGFloat firstContentHeight = [NSString stringWithContentSize:CGSizeMake(TYGetUIScreenWidth - 58, CGFLOAT_MAX) content:_firstInfoLabel.text font:AppFont30Size].height + 5;
    
    [_firstInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_firstPointLabel.mas_right).offset(11);
        make.right.mas_equalTo(-19);
        make.top.equalTo(_firstPointLabel.mas_top).offset(-4);
        make.height.mas_equalTo(firstContentHeight);
    }];
    
    [_secondPointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(10);
        make.top.equalTo(_firstInfoLabel.mas_bottom).offset(11);
        make.width.height.mas_equalTo(18);
    }];
    
    CGFloat secondContentHeight = [NSString stringWithContentSize:CGSizeMake(TYGetUIScreenWidth - 58, CGFLOAT_MAX) content:_secondInfoLabel.text font:AppFont30Size].height + 5;
    
    [_secondInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_secondPointLabel.mas_right).offset(11);
        make.right.mas_equalTo(-19);
        make.top.equalTo(_secondPointLabel.mas_top).offset(-4);
        make.height.mas_equalTo(secondContentHeight);
    }];
    
    [_thirdPointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(10);
        make.top.equalTo(_secondInfoLabel.mas_bottom).offset(11);
        make.width.height.mas_equalTo(18);
    }];
    
    CGFloat thirdContentHeight = [NSString stringWithContentSize:CGSizeMake(TYGetUIScreenWidth - 58, CGFLOAT_MAX) content:_thirdInfoLabel.text font:AppFont30Size].height + 5;
    
    [_thirdInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_thirdPointLabel.mas_right).offset(11);
        make.right.mas_equalTo(-19);
        make.top.equalTo(_thirdPointLabel.mas_top).offset(-4);
        make.height.mas_equalTo(thirdContentHeight);
    }];
    
    [_startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_offset(0);
        make.top.equalTo(_thirdInfoLabel.mas_bottom).offset(30);
        make.width.mas_equalTo(160);
        make.height.mas_equalTo(45);
    }];
}

- (void)startConfirm {
    
    if (self.startConfirmBlock) {
        
        _startConfirmBlock();
    }
}


- (UILabel *)firstPointLabel {
    
    if (!_firstPointLabel) {
        
        _firstPointLabel = [[UILabel alloc] init];
        _firstPointLabel.text = @"1";
        _firstPointLabel.textColor = [UIColor whiteColor];
        _firstPointLabel.backgroundColor = AppFontEB4E4EColor;
        _firstPointLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _firstPointLabel;
}

- (UILabel *)firstInfoLabel {
    
    if (!_firstInfoLabel) {
        
        _firstInfoLabel = [[UILabel alloc] init];
        _firstInfoLabel.text = @"关闭 [我要对账]，所有的记工记账只有自己可见， 同时对方也不能查看你对他的记工记账;";
        _firstInfoLabel.textColor = AppFont666666Color;
        _firstInfoLabel.font = FONT(AppFont30Size);
        _firstInfoLabel.numberOfLines = 0;
        _firstInfoLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [_firstInfoLabel markattributedTextArray:@[@"[我要对账]"] color:AppFont000000Color];
    }
    return _firstInfoLabel;
}


- (UILabel *)secondPointLabel {
    
    if (!_secondPointLabel) {
        
        _secondPointLabel = [[UILabel alloc] init];
        _secondPointLabel.text = @"2";
        _secondPointLabel.textColor = [UIColor whiteColor];
        _secondPointLabel.backgroundColor = AppFontEB4E4EColor;
        _secondPointLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _secondPointLabel;
}

- (UILabel *)secondInfoLabel {
    
    if (!_secondInfoLabel) {
        
        _secondInfoLabel = [[UILabel alloc] init];
        _secondInfoLabel.text = @"记账双方开启 [我要对账]，可及时查看工人/班 组长对我记工记账的详细工天数;";
        _secondInfoLabel.textColor = AppFont666666Color;
        _secondInfoLabel.font = FONT(AppFont30Size);
        _secondInfoLabel.numberOfLines = 0;
        _secondInfoLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [_secondInfoLabel markattributedTextArray:@[@"[我要对账]"] color:AppFont000000Color];
    }
    return _secondInfoLabel;
}

- (UILabel *)thirdPointLabel {
    
    if (!_thirdPointLabel) {
        
        _thirdPointLabel = [[UILabel alloc] init];
        _thirdPointLabel.text = @"3";
        _thirdPointLabel.textColor = [UIColor whiteColor];
        _thirdPointLabel.backgroundColor = AppFontEB4E4EColor;
        _thirdPointLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _thirdPointLabel;
}

- (UILabel *)thirdInfoLabel {
    
    if (!_thirdInfoLabel) {
        
        _thirdInfoLabel = [[UILabel alloc] init];
        _thirdInfoLabel.text = @"如要开启 [我要对账]，请点击 我的记工账本 > 记工设置 > 我要对账，开启 [我要对账]";
        _thirdInfoLabel.textColor = AppFont666666Color;
        _thirdInfoLabel.font = FONT(AppFont30Size);
        _thirdInfoLabel.numberOfLines = 0;
        _thirdInfoLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [_thirdInfoLabel markattributedTextArray:@[@"[我要对账]",@"我的记工账本 > 记工设置 > 我要对账",@"[我要对账]"] color:AppFont000000Color font:FONT(AppFont30Size) isGetAllText:YES];
    }
    return _thirdInfoLabel;
}

- (UIButton *)startBtn {
    
    if (!_startBtn) {
        
        _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startBtn setTitle:@"点击开启 [我要对账]" forState:(UIControlStateNormal)];
        _startBtn.layer.borderWidth = 1;
        _startBtn.layer.borderColor = AppFontEB4E4EColor.CGColor;
        _startBtn.clipsToBounds = YES;
        [_startBtn setTitleColor:AppFontEB4E4EColor forState:(UIControlStateNormal)];
        _startBtn.backgroundColor = AppFontffffffColor;
        _startBtn.titleLabel.font = FONT(AppFont30Size);
        [_startBtn addTarget:self action:@selector(startConfirm) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    return _startBtn;
}

@end
