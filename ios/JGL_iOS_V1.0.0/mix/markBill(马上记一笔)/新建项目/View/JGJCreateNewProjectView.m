 //
//  JGJCreateNewProjectView.m
//  mix
//
//  Created by Tony on 2018/6/4.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJCreateNewProjectView.h"

@interface JGJCreateNewProjectView ()

@property (nonatomic, strong) UIButton *saveBtn;
@property (nonatomic, strong) UIView *topLine;

@end
@implementation JGJCreateNewProjectView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance {
    
    self.backgroundColor = AppFontfafafaColor;
    [self addSubview:self.topLine];
    [self addSubview:self.inputContent];
    [self addSubview:self.saveBtn];
    [self setUpLayout];
    
    [_inputContent updateLayout];
    [_saveBtn updateLayout];
    
    _saveBtn.layer.borderWidth = .5f;
    _saveBtn.layer.borderColor = AppFontdbdbdbColor.CGColor;
    
    _inputContent.layer.borderColor = AppFontEB4E4EColor.CGColor;
    _inputContent.layer.borderWidth = .5f;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:self.inputContent];
}

#pragma mark - 通知判断
-(void)textFiledEditChanged:(NSNotification*)obj {
    
    UITextField *textField = (UITextField *)obj.object;
    
    [NSString textEditChanged:textField maxLength:self.inputContent.maxLength];
    if (self.inputContent.text.length > 0) {
        
        [_saveBtn setBackgroundColor:AppFontEB4E4EColor];
        [_saveBtn setTitleColor:AppFontffffffColor forState:(UIControlStateNormal)];
    }else {
        
        [_saveBtn setBackgroundColor:AppFontffffffColor];
        [_saveBtn setTitleColor:AppFont333333Color forState:(UIControlStateNormal)];
    }
}

- (void)setUpLayout {
    
    _topLine.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).rightSpaceToView(self, 0).heightIs(1);
    _saveBtn.sd_layout.rightSpaceToView(self, 10).centerYEqualToView(self).heightIs(40).widthIs(63);
    _inputContent.sd_layout.leftSpaceToView(self, 10).centerYEqualToView(self).rightSpaceToView(_saveBtn, 10).heightIs(40);
}

- (void)saveProject {
    
    if (self.createProject) {
        
        _createProject(_inputContent.text);
    }
    
}

- (UIView *)topLine {
    
    if (!_topLine) {
        
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = AppFontdbdbdbColor;
    }
    return _topLine;
}

- (LengthLimitTextField *)inputContent {
    
    if (!_inputContent) {
        
        _inputContent = [[LengthLimitTextField alloc] init];
        _inputContent.backgroundColor = AppFontffffffColor;
        _inputContent.textColor = AppFont333333Color;
        _inputContent.placeholder = @"请输入项目名称";
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 5)];
        _inputContent.leftViewMode = UITextFieldViewModeAlways;
        _inputContent.leftView = leftView;
        _inputContent.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_inputContent setValue:AppFontccccccColor forKeyPath:@"_placeholderLabel.textColor"];
        [_inputContent setValue:FONT(AppFont28Size) forKeyPath:@"_placeholderLabel.font"];
        
        _inputContent.maxLength = ProNameLength;
        
    }
    return _inputContent;
}

- (UIButton *)saveBtn {
    
    if (!_saveBtn) {
        
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveBtn.titleLabel.font = FONT(AppFont26Size);
        [_saveBtn setBackgroundColor:AppFontffffffColor];
        [_saveBtn setTitleColor:AppFont333333Color forState:(UIControlStateNormal)];
        [_saveBtn setTitle:@"保存" forState:(UIControlStateNormal)];
        [_saveBtn addTarget:self action:@selector(saveProject) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _saveBtn;
}
@end
