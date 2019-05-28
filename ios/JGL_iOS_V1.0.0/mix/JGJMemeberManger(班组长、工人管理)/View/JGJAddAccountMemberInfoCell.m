//
//  JGJAddAccountMemberInfoCell.m
//  mix
//
//  Created by yj on 2018/6/7.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJAddAccountMemberInfoCell.h"

#import "TYTextField.h"

#import "UILabel+GNUtil.h"

@interface JGJAddAccountMemberInfoCell ()

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet LengthLimitTextField *textField;

@end

@implementation JGJAddAccountMemberInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    TYWeakSelf(self);
    
    self.textField.valueDidChange = ^(NSString *value) {
      
        weakself.desModel.des = value;
        
        if (weakself.desModel.desType == JGJCommonInfoTelType) {
            
            if (weakself.accountMemberInfoCellBlock) {
                
                weakself.accountMemberInfoCellBlock(_desModel);
            }
        }
    };
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:self.textField];
    
}

- (void)setDesModel:(JGJCommonInfoDesModel *)desModel {
    
    _desModel = desModel;
    
    self.title.text = desModel.title;
    
    [self.title markText:![NSString isEmpty:desModel.remarkTitle] ? desModel.remarkTitle : @"" withColor:AppFontEB4E4EColor];
    
    self.textField.placeholder = desModel.placeholder;
    
    if ([self.contractor_type isEqualToString:@"1"]) {
        
       [self.textField setValue:[UIFont systemFontOfSize:13.5] forKeyPath:@"_placeholderLabel.font"];
    }
    
    if (desModel.desType == JGJCommonInfoDesNameType) {
        
        self.textField.maxLength = UserNameLength;
        
        //班组长承包姓名限制15个
        if (desModel.nameLength > self.textField.maxLength) {
            
            self.textField.maxLength = desModel.nameLength;
        }
        
        self.textField.keyboardType = UIKeyboardTypeDefault;
        
        if (!self.textField.isFirstResponder && !desModel.isCanFirstResponder) {

            desModel.isCanFirstResponder = YES;
            
            [self.textField becomeFirstResponder];
        }
    }
    
    if (desModel.desType == JGJCommonInfoTelType) {
        
         self.textField.maxLength = 11;
        
        self.textField.keyboardType = UIKeyboardTypePhonePad;
    }
    
    if (![NSString isEmpty:desModel.des]) {
        
        self.textField.text = desModel.des;
    }
    
    self.textField.userInteractionEnabled = !desModel.isUnCanEdit;
}

#pragma mark - 通知判断
-(void)textFiledEditChanged:(NSNotification*)obj {
    
    UITextField *textField = (UITextField *)obj.object;
    
    [NSString textEditChanged:textField maxLength:self.textField.maxLength];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
