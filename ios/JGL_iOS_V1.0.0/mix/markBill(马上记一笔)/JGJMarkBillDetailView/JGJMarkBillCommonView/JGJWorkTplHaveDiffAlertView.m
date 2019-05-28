//
//  JGJWorkTplHaveDiffAlertView.m
//  mix
//
//  Created by Tony on 2018/12/17.
//  Copyright © 2018 JiZhi. All rights reserved.
//

#import "JGJWorkTplHaveDiffAlertView.h"
#import "UILabel+GNUtil.h"
@interface JGJWorkTplHaveDiffAlertView ()

@property (nonatomic, strong) UIView *containView;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *diffTopLabel;
@property (nonatomic, strong) UIView *nameBgView;
@property (nonatomic, strong) UILabel *counterpartNameLabel;// 对方名称
@property (nonatomic, strong) UILabel *myNameLabel;
@property (nonatomic, strong) UILabel *workLabel;// 上班
@property (nonatomic, strong) UILabel *counterpartWorkTimeLabel;// 对方设置的上班时间
@property (nonatomic, strong) UILabel *myWorkTimeLabel;// 我设置的上班时间

@property (nonatomic, strong) UILabel *overLabel;// 加班
@property (nonatomic, strong) UILabel *counterpartOverTimeLabel;// 对方设置的加班时间
@property (nonatomic, strong) UILabel *myOverTimeLabel;// 我设置的加班时间

@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UIButton *cancleBtn;// 取消
@property (nonatomic, strong) UIView *line2;
@property (nonatomic, strong) UIButton *agreeWageLevel;//同意工资标准

@end
@implementation JGJWorkTplHaveDiffAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initializeAppearance];
    }
    return self;
}


- (void)initializeAppearance {
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [self addSubview:self.containView];
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.diffTopLabel];
    
    [self.bgView addSubview:self.nameBgView];
    [self.nameBgView addSubview:self.counterpartNameLabel];
    [self.nameBgView addSubview:self.myNameLabel];
    
    [self.bgView addSubview:self.workLabel];
    [self.bgView addSubview:self.counterpartWorkTimeLabel];
    [self.bgView addSubview:self.myWorkTimeLabel];
    
    [self.bgView addSubview:self.overLabel];
    [self.bgView addSubview:self.counterpartOverTimeLabel];
    [self.bgView addSubview:self.myOverTimeLabel];
    
    [self.bgView addSubview:self.line1];
    [self.bgView addSubview:self.cancleBtn];
    [self.bgView addSubview:self.line2];
    [self.bgView addSubview:self.agreeWageLevel];
    [self setUpLayout];
    
    [_bgView updateLayout];
    _bgView.clipsToBounds = YES;
    _bgView.layer.cornerRadius = 5;
}

- (void)setUpLayout {
    
    [_containView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.height.mas_equalTo(220);
    }];
    
    [_diffTopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(43);
    }];
    
    CGFloat btnWidth = (TYGetUIScreenWidth - 80) / 2;
    [_cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(45);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(btnWidth);
    }];
    
    [_line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_cancleBtn.mas_right).offset(0);
        make.height.mas_equalTo(45);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(1);
    }];
    
    [_agreeWageLevel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(45);
        make.bottom.mas_equalTo(0);
        make.left.equalTo(_line2.mas_right).offset(0);
    }];
    
    [_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(_cancleBtn.mas_top).offset(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    
    [_overLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(12);
        make.height.mas_equalTo(13);
        make.width.mas_equalTo(30);
        make.bottom.equalTo(_line1.mas_top).offset(-25);
    }];
    
    CGFloat labelWidth = (TYGetUIScreenWidth - 40 - 12 - 30 - 15 - 18 - 40) / 2;
    [_counterpartOverTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_overLabel.mas_right).offset(15);
        make.height.mas_equalTo(13);
        make.centerY.equalTo(_overLabel.mas_centerY).offset(0);
        make.width.mas_equalTo(labelWidth);
    }];
    
    [_myOverTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-18);
        make.centerY.equalTo(_overLabel.mas_centerY).offset(0);
        make.height.mas_equalTo(13);
        make.left.equalTo(_counterpartOverTimeLabel.mas_right).offset(0);
    }];
    
    [_workLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(12);
        make.height.mas_equalTo(13);
        make.width.mas_equalTo(30);
        make.bottom.equalTo(_overLabel.mas_top).offset(-15);
    }];
    
    [_counterpartWorkTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_workLabel.mas_right).offset(15);
        make.height.mas_equalTo(13);
        make.centerY.equalTo(_workLabel.mas_centerY).offset(0);
        make.width.mas_equalTo(labelWidth);
    }];
    
    [_myWorkTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-18);
        make.centerY.equalTo(_workLabel.mas_centerY).offset(0);
        make.height.mas_equalTo(13);
        make.left.equalTo(_counterpartWorkTimeLabel.mas_right).offset(0);
    }];
    
    
    [_nameBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(0);
        make.top.equalTo(_diffTopLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(35);
    }];
    
    [_myNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(_myWorkTimeLabel.mas_centerX).offset(0);
        make.height.mas_equalTo(13);
        make.centerY.mas_equalTo(0);
    }];
    
    [_counterpartNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(_counterpartWorkTimeLabel.mas_centerX).offset(0);
        make.height.mas_equalTo(13);
        make.centerY.mas_equalTo(0);
    }];
}

- (void)setDifTplBill:(JGJGetWorkTplByUidModel *)difTplBill {
    
    _difTplBill = difTplBill;
    
    NSInteger intInt = _difTplBill.oth_tpl.w_h_tpl * 10;
    NSInteger lefInt = intInt % 10;
    NSString *counterpartWorkTimeStr;
    if (lefInt > 0) {// 1.5 2.5...
        
        counterpartWorkTimeStr = [NSString stringWithFormat:@"%.1f小时算一个工",_difTplBill.oth_tpl.w_h_tpl];
        
    }else {
        
        counterpartWorkTimeStr= [NSString stringWithFormat:@"%.0f小时算一个工",_difTplBill.oth_tpl.w_h_tpl];
    }
    
    _counterpartWorkTimeLabel.text = counterpartWorkTimeStr;
    
    NSInteger intInt1 = _difTplBill.my_tpl.w_h_tpl * 10;
    NSInteger lefInt1 = intInt1 % 10;
    NSString *myWorkTimeStr;
    if (lefInt1 > 0) {
        
        myWorkTimeStr = [NSString stringWithFormat:@"%.1f小时算一个工",_difTplBill.my_tpl.w_h_tpl];
    }else {
        
        myWorkTimeStr = [NSString stringWithFormat:@"%.0f小时算一个工",_difTplBill.my_tpl.w_h_tpl];
    }
    
    _myWorkTimeLabel.text = myWorkTimeStr;
    
    NSInteger intInt2 = _difTplBill.oth_tpl.o_h_tpl * 10;
    NSInteger lefInt2 = intInt2 % 10;
    NSString *counterpartOverTimeStr;
    if (lefInt2 > 0) {
        
        counterpartOverTimeStr = [NSString stringWithFormat:@"%.1f小时算一个工",_difTplBill.oth_tpl.o_h_tpl];
        
    }else {
        
        counterpartOverTimeStr = [NSString stringWithFormat:@"%.0f小时算一个工",_difTplBill.oth_tpl.o_h_tpl];
    }
    
    if (_difTplBill.oth_tpl.hour_type == 1) {
        
        counterpartOverTimeStr = [NSString stringWithFormat:@"%.2f元/小时",_difTplBill.oth_tpl.o_s_tpl];
    }
    
    _counterpartOverTimeLabel.text = counterpartOverTimeStr;
    
    
    NSInteger intInt3 = _difTplBill.my_tpl.o_h_tpl * 10;
    NSInteger lefInt3 = intInt3 % 10;
    NSString *myOverTimeStr;
    if (lefInt3 > 0) {
        
        myOverTimeStr = [NSString stringWithFormat:@"%.1f小时算一个工",_difTplBill.my_tpl.o_h_tpl];
    }else {
        
        myOverTimeStr = [NSString stringWithFormat:@"%.0f小时算一个工",_difTplBill.my_tpl.o_h_tpl];
    }
    
    if (_difTplBill.my_tpl.hour_type == 1) {
        
        myOverTimeStr = [NSString stringWithFormat:@"%.2f元/小时",_difTplBill.my_tpl.o_s_tpl];
    }
    
    _myOverTimeLabel.text = myOverTimeStr;
    
    if (_difTplBill.my_tpl.w_h_tpl != _difTplBill.oth_tpl.w_h_tpl) {
        
        _counterpartWorkTimeLabel.textColor = AppFontEB4E4EColor;
    }
    
    if (_difTplBill.oth_tpl.hour_type != _difTplBill.my_tpl.hour_type) {
        
        _counterpartOverTimeLabel.textColor = AppFontEB4E4EColor;
        
    }else {
        
        if (_difTplBill.oth_tpl.hour_type == 0) {// 加班按工天
            
            if (_difTplBill.my_tpl.o_h_tpl != _difTplBill.oth_tpl.o_h_tpl) {
                
                _counterpartOverTimeLabel.textColor = AppFontEB4E4EColor;
            }
            
        }else {// 加班按小时
            
            if (_difTplBill.my_tpl.o_s_tpl != _difTplBill.oth_tpl.o_s_tpl) {
                
                _counterpartOverTimeLabel.textColor = AppFontEB4E4EColor;
            }
        }
    }
    
    
    _counterpartNameLabel.text = _difTplBill.user_name;
}

- (void)setMarkSlectBtnType:(JGJMarkSelectBtnType)markSlectBtnType {
    
    _markSlectBtnType = markSlectBtnType;
    if (_markSlectBtnType == JGJMarkSelectTinyBtnType) {
        
        _diffTopLabel.text = [NSString stringWithFormat:@"%@与你设置的工资标准不一样",_difTplBill.user_name];
        [_cancleBtn setTitle:@"使用我的标准" forState:(UIControlStateNormal)];
        [_agreeWageLevel setTitle:@"同意他的工资标准" forState:(UIControlStateNormal)];
        
    }else if (_markSlectBtnType == JGJMarkSelectContractBtnType) {
        
        _diffTopLabel.text = [NSString stringWithFormat:@"%@与你设置的考勤模板不一样",_difTplBill.user_name];
        [_cancleBtn setTitle:@"使用我的模板" forState:(UIControlStateNormal)];
        [_agreeWageLevel setTitle:@"同意他的考勤模板" forState:(UIControlStateNormal)];
    }
    [_diffTopLabel markattributedTextArray:@[_difTplBill.user_name?:@""] color:AppFont000000Color];
    
    
}

- (void)show {
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    [window addSubview:self];
}

- (void)diffViewBtnClick:(UIButton *)sender {
    
    NSInteger index = sender.tag - 100;
    if (index == 0) {// 取消
        
        if (self.cancle) {
            
            _cancle();
        }
        
    }else if (index == 1) {// 同意
        
        if (self.agree) {
            
            _agree();
        }
    }
    [self removeFromSuperview];
}

- (UIView *)containView {
    
    if (!_containView) {
        
        _containView = [[UIView alloc] init];
        _containView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    }
    return _containView;
}
- (UIView *)bgView {
    
    if (!_bgView) {
        
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UILabel *)diffTopLabel {
    
    if (!_diffTopLabel) {
        
        _diffTopLabel = [[UILabel alloc] init];
        _diffTopLabel.textAlignment = NSTextAlignmentCenter;
        _diffTopLabel.font = FONT( AppFont26Size);
        _diffTopLabel.textColor = AppFont666666Color;
        _diffTopLabel.numberOfLines = 0;
    }
    return _diffTopLabel;
}

- (UIView *)nameBgView {
    
    if (!_nameBgView) {
        
        _nameBgView = [[UIView alloc] init];
        _nameBgView.backgroundColor = AppFontf1f1f1Color;
    }
    return _nameBgView;
}

- (UILabel *)counterpartNameLabel {
    
    if (!_counterpartNameLabel) {
        
        _counterpartNameLabel = [[UILabel alloc] init];
        _counterpartNameLabel.textAlignment = NSTextAlignmentCenter;
        _counterpartNameLabel.font = FONT(AppFont28Size);
        _counterpartNameLabel.textColor = AppFont666666Color;
    }
    return _counterpartNameLabel;
}

- (UILabel *)myNameLabel {
    
    if (!_myNameLabel) {
        
        _myNameLabel = [[UILabel alloc] init];
        _myNameLabel.text = @"我";
        _myNameLabel.textAlignment = NSTextAlignmentCenter;
        _myNameLabel.font = FONT(AppFont28Size);
        _myNameLabel.textColor = AppFont666666Color;
    }
    return _myNameLabel;
    
}

- (UILabel *)workLabel {
    
    if (!_workLabel) {
        
        _workLabel = [[UILabel alloc] init];
        _workLabel.text = @"上班";
        _workLabel.textAlignment = NSTextAlignmentCenter;
        _workLabel.textColor = AppFont666666Color;
        _workLabel.font = FONT(AppFont26Size);
    }
    return _workLabel;
}

- (UILabel *)counterpartWorkTimeLabel {
    
    if (!_counterpartWorkTimeLabel) {
        
        _counterpartWorkTimeLabel = [[UILabel alloc] init];
        _counterpartWorkTimeLabel.textAlignment = NSTextAlignmentCenter;
        _counterpartWorkTimeLabel.textColor = AppFont000000Color;
        _counterpartWorkTimeLabel.font = FONT(AppFont26Size);
    }
    return _counterpartWorkTimeLabel;
}

- (UILabel *)myWorkTimeLabel {
    
    if (!_myWorkTimeLabel) {
        
        _myWorkTimeLabel = [[UILabel alloc] init];
        _myWorkTimeLabel.textAlignment = NSTextAlignmentCenter;
        _myWorkTimeLabel.textColor = AppFont000000Color;
        _myWorkTimeLabel.font = FONT(AppFont26Size);
    }
    return _myWorkTimeLabel;
}

- (UILabel *)overLabel {
    
    if (!_overLabel) {
        
        _overLabel = [[UILabel alloc] init];
        _overLabel.text = @"加班";
        _overLabel.textAlignment = NSTextAlignmentCenter;
        _overLabel.textColor = AppFont666666Color;
        _overLabel.font = FONT(AppFont26Size);
    }
    return _overLabel;
}

- (UILabel *)counterpartOverTimeLabel {
    
    if (!_counterpartOverTimeLabel) {
        
        _counterpartOverTimeLabel = [[UILabel alloc] init];
        _counterpartOverTimeLabel.textAlignment = NSTextAlignmentCenter;
        _counterpartOverTimeLabel.textColor = AppFont000000Color;
        _counterpartOverTimeLabel.font = FONT(AppFont26Size);
    }
    return _counterpartOverTimeLabel;
}

- (UILabel *)myOverTimeLabel {
    
    if (!_myOverTimeLabel) {
        
        _myOverTimeLabel = [[UILabel alloc] init];
        _myOverTimeLabel.textAlignment = NSTextAlignmentCenter;
        _myOverTimeLabel.textColor = AppFont000000Color;
        _myOverTimeLabel.font = FONT(AppFont26Size);
    }
    return _myOverTimeLabel;
}

- (UIView *)line1 {
    
    if (!_line1) {
        
        _line1 = [[UIView alloc] init];
        _line1.backgroundColor = AppFontdbdbdbColor;
    }
    return _line1;
}

- (UIButton *)cancleBtn {
    
    if (!_cancleBtn) {
        
        _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancleBtn.backgroundColor = AppFontfafafaColor;
        [_cancleBtn setTitle:@"使用我的标准" forState:(UIControlStateNormal)];
        [_cancleBtn setTitleColor:AppFont333333Color forState:(UIControlStateNormal)];
        _cancleBtn.titleLabel.font = FONT(AppFont30Size);
        _cancleBtn.tag = 100;
        [_cancleBtn addTarget:self action:@selector(diffViewBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _cancleBtn;
}

- (UIView *)line2 {
    
    if (!_line2) {
        
        _line2 = [[UIView alloc] init];
        _line2.backgroundColor = AppFontdbdbdbColor;
    }
    return _line2;
}

- (UIButton *)agreeWageLevel {
    
    if (!_agreeWageLevel) {
        
        _agreeWageLevel = [UIButton buttonWithType:UIButtonTypeCustom];
        _agreeWageLevel.backgroundColor = AppFontfafafaColor;
        [_agreeWageLevel setTitle:@"同意他的工资标准" forState:(UIControlStateNormal)];
        [_agreeWageLevel setTitleColor:AppFontEB4E4EColor forState:(UIControlStateNormal)];
        _agreeWageLevel.titleLabel.font = FONT(AppFont30Size);
        
        _agreeWageLevel.tag = 101;
        [_agreeWageLevel addTarget:self action:@selector(diffViewBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _agreeWageLevel;
}
@end
