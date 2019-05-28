//
//  JGJEditNameVc.m
//  mix
//
//  Created by yj on 16/12/20.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJEditNameVc.h"
#import "TYTextField.h"
#import "NSString+Extend.h"
@interface JGJEditNameVc ()

@property (weak, nonatomic) IBOutlet LengthLimitTextField *nameTF;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightItem;
@end

@implementation JGJEditNameVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nameTF.textColor = AppFont333333Color;
    self.nameTF.text = self.name;
    self.nameTF.maxLength = UserNameLength;
    [self.nameTF becomeFirstResponder];
    if (![NSString isEmpty:self.defaultName]) {
        self.nameTF.text = self.defaultName;
    }
    
    if (![NSString isEmpty:self.namePlaceholder]) {
        self.nameTF.placeholder = self.namePlaceholder;
    }
    
    if (self.editNameVcType != JGJEditContactedNameVcType) {
        self.rightItem.enabled = ![NSString isEmpty:self.defaultName];
        __weak typeof(self) weakSelf = self;
        self.nameTF.valueDidChange = ^(NSString *value){
            weakSelf.rightItem.enabled = ![NSString isEmpty:value];
        };
    }
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:self.nameTF];
}

- (IBAction)handleRightItemAction:(UIBarButtonItem *)sender {
//    if ([NSString isEmpty:self.nameTF.text]) {
//        [TYShowMessage showPlaint:@"请输入备注姓名"];
//        return;
//    }
    if ([NSString isEmpty:self.nameTF.text] && self.editNameVcType != JGJEditContactedNameVcType) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(editNameVc:nameString:)]) {
        [self.delegate editNameVc:self nameString:self.nameTF.text];
    }
}

#pragma mark - 通知判断
-(void)textFiledEditChanged:(NSNotification*)obj {
    
    UITextField *textField = (UITextField *)obj.object;

    [NSString textEditChanged:textField maxLength:self.nameTF.maxLength];
    
}

@end
