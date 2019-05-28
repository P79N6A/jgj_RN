//
//  YZGOnlyAddProjectViewController.m
//  mix
//
//  Created by Tony on 16/3/8.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "YZGOnlyAddProjectViewController.h"
#import "TYTextField.h"
#import "NSString+Extend.h"

@interface YZGOnlyAddProjectViewController ()
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet LengthLimitTextField *proNameTF;//项目组管理项目组名称设置默认值

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation YZGOnlyAddProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.saveButton.layer setLayerCornerRadius:5.0];
    if (self.editType == EditMineNameType) {
       self.proNameTF.maxLength = UserNameLength;
    }else {
        self.proNameTF.maxLength = ProNameLength;
    }
    
    self.proNameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    if (![NSString isEmpty:self.proNameTFPlaceholder]) {
        self.proNameTF.placeholder = self.proNameTFPlaceholder;
    }
    if (![NSString isEmpty:self.defaultProName]) {
        self.proNameTF.text = self.defaultProName;
    }
    [self.proNameTF becomeFirstResponder];
    
    if (self.editType == EditMineNameType || self.editType == EditProNameType) {
        
        self.saveButton.hidden = YES;
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnClick:)];
        
    }
    
    self.scrollView.backgroundColor = AppFontf1f1f1Color;
    
    self.saveButton.backgroundColor =AppFontEB4E4EColor;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:self.proNameTF];
}

- (IBAction)saveBtnClick:(id)sender {

    if (self.editType == EditProNameType && [NSString isEmpty:self.proNameTF.text]) {
        
        [TYShowMessage showError:@"请输入项目组名称"];
        return;
    }
    if (self.editType) { //从创建班组进入
        if ([self.delegate respondsToSelector:@selector(handleYZGOnlyAddProjectViewControllerEditName:editType:)]) {
            [self.delegate handleYZGOnlyAddProjectViewControllerEditName:self.proNameTF.text editType:self.editType];
//            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }
}

#pragma mark - 通知判断
-(void)textFiledEditChanged:(NSNotification*)obj {
    
    UITextField *textField = (UITextField *)obj.object;
    
    [NSString textEditChanged:textField maxLength:self.proNameTF.maxLength];
    
}

-(void)dealloc {
    
    [TYNotificationCenter removeObserver:self];
}

@end
