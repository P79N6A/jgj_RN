//
//  JGJNewCreateProjectAlertView.m
//  mix
//
//  Created by Tony on 2019/2/20.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJNewCreateProjectAlertView.h"
#import "TYTextField.h"
@interface JGJNewCreateProjectAlertView ()

@property (nonatomic, strong) UIView *containView;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
//@property (nonatomic, strong) LengthLimitTextField *inputProjectField;
@property (nonatomic, strong) UITextView *inputProjectField;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIView *middleLine;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;

@end
@implementation JGJNewCreateProjectAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
     
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance {
    
    [self addSubview:self.containView];
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.inputProjectField];
    [self.bgView addSubview:self.line];
    [self.bgView addSubview:self.middleLine];
    [self.bgView addSubview:self.leftBtn];
    [self.bgView addSubview:self.rightBtn];
    
    [self setUpLayout];
    
    [_bgView updateLayout];
    [_inputProjectField updateLayout];
    
    _bgView.layer.cornerRadius = 5;
    _inputProjectField.layer.cornerRadius = 2;
}

- (void)setUpLayout {
    
    [_containView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(53);
        make.right.mas_equalTo(-53);
        make.height.mas_equalTo(177);
    }];
    
    CGSize labelSize = [NSString stringWithContentSize:CGSizeMake(TYGetUIScreenWidth - 148, CGFLOAT_MAX) content:_titleLabel.text font:15];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(21);
        make.top.mas_equalTo(25);
        make.right.mas_equalTo(-21);
        make.height.mas_equalTo(labelSize.height + 1);
        
    }];
    
    [_inputProjectField mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(21);
        make.top.equalTo(_titleLabel.mas_bottom).offset(15);
        make.right.mas_equalTo(-21);
        make.height.mas_equalTo(35);
        
    }];

    [_middleLine mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_offset(0);
        make.width.mas_equalTo(1);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(45);
    }];
    
    [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(0);
        make.right.equalTo(_middleLine.mas_left).offset(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(45);
    }];
    
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(0);
        make.left.equalTo(_middleLine.mas_right).offset(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(45);
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.right.mas_equalTo(0);
        make.bottom.equalTo(_leftBtn.mas_top).offset(0);
        make.height.mas_equalTo(1);
    }];
    
}

- (void)leftBtnClick {
    
    [self endEditing:YES];
    if (self.cancle) {
        
        _cancle();
    }
    
    [self removeFromSuperview];
}

- (void)rightBtnClick {
    
    if (_inputProjectField.text.length == 0) {
        
        [TYShowMessage showPlaint:@"请输入项目名称"];
        return;
    }
    if (self.agree) {
        
        _agree(_inputProjectField.text,self);
    }
    
    
}

- (void)show {
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    [window addSubview:self];
}

- (void)setProjectName:(NSString *)projectName {
    
    _projectName = projectName;
    _inputProjectField.text = _projectName;
    [_inputProjectField becomeFirstResponder];



}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self endEditing:YES];
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
        _bgView.clipsToBounds = YES;
    }
    return _bgView;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"该项目已经创建有班组，是否要创建一个相似名称的项目：";
        _titleLabel.textColor = AppFont666666Color;
        _titleLabel.font = FONT(AppFont30Size);
        _titleLabel.numberOfLines = 0;
        
    }
    return _titleLabel;
}

- (UITextView *)inputProjectField {
    
    if (!_inputProjectField) {
        
        _inputProjectField = [[UITextView alloc] init];
        _inputProjectField.backgroundColor = AppFontEBEBEBColor;
        _inputProjectField.layer.borderColor = AppFontdbdbdbColor.CGColor;
        _inputProjectField.layer.borderWidth = 1;
        _inputProjectField.clipsToBounds = YES;
        _inputProjectField.textColor = AppFont000000Color;
        _inputProjectField.font = FONT(AppFont28Size);
        
    }
    return _inputProjectField;
}

- (UIView *)line {
    
    if (!_line) {
        
        _line = [[UIView alloc] init];
        _line.backgroundColor = AppFontdbdbdbColor;
    }
    return _line;
}

- (UIView *)middleLine {
    
    if (!_middleLine) {
        
        _middleLine = [[UIView alloc] init];
        _middleLine.backgroundColor = AppFontdbdbdbColor;
    }
    return _middleLine;
}

- (UIButton *)leftBtn {
    
    if (!_leftBtn) {
        
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftBtn setTitle:@"取消" forState:(UIControlStateNormal)];
        [_leftBtn setTitleColor:AppFont333333Color forState:(UIControlStateNormal)];
        _leftBtn.titleLabel.font = FONT(AppFont30Size);
        _leftBtn.backgroundColor = AppFontfafafaColor;
        [_leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _leftBtn;
}

- (UIButton *)rightBtn {
    
    if (!_rightBtn) {
        
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setTitle:@"确定" forState:(UIControlStateNormal)];
        [_rightBtn setTitleColor:AppFontEB4E4EColor forState:(UIControlStateNormal)];
        _rightBtn.titleLabel.font = FONT(AppFont30Size);
        _rightBtn.backgroundColor = AppFontfafafaColor;
        [_rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _rightBtn;
}
@end
