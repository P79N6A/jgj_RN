//
//  JGJMarkBillTextFileTableViewCell.m
//  mix
//
//  Created by Tony on 2018/1/2.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJMarkBillTextFileTableViewCell.h"

@interface JGJMarkBillTextFileTableViewCell ()
{
    
    NSString *_firstInputStr;
}
@end
@implementation JGJMarkBillTextFileTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.textfiled.borderStyle = UITextBorderStyleNone;
    self.textfiled.delegate = self;
    [self.textfiled addTarget:self action:@selector(searchTextFieldChangeAction:) forControlEvents:UIControlEventEditingChanged];

}


- (void)setEditeMoney:(CGFloat)editeMoney {
    
    _editeMoney = editeMoney;
//    self.textfiled.text = [NSString]
    if (_editeMoney == 0) {
        
        self.textfiled.placeholder = @"请输入金额";
    }else {
        
        self.textfiled.text = [NSString stringWithFormat:@"%.2f",_editeMoney];
    }
}
- (void)setNumberType:(JGJNumberType)numberType {
    
    _numberType = numberType;
    if (self.numberType == JGJNumberKeyBoardType) {//金额数字键盘 UIKeyboardTypeDecimalPad
        
        self.textfiled.keyboardType = UIKeyboardTypeNumberPad;
        
    }else{
        
        self.textfiled.keyboardType = UIKeyboardTypeDefault;
    }
}

- (void)setShowMoreButton:(BOOL)showMoreButton {
    
    _showMoreButton = showMoreButton;
    if (_showMoreButton) {
        
        _choiceMoreBtn.hidden = NO;
    }else {
        
        _choiceMoreBtn.hidden = YES;
    }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(JGJMarkBillWillBeginTextFilEditing)]) {
        [self.delegate JGJMarkBillWillBeginTextFilEditing];
    }
    if (self.numberType == JGJNumberKeyBoardType) { //金额数字键盘带小数点输入
//        self.textfiled.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        self.textfiled.keyboardType = UIKeyboardTypeDecimalPad;
        if (![NSString isEmpty: textField.text]) {
            if ([textField.text floatValue] == 0 || [textField.text isEqualToString:@"-.-"]) {
                textField.text = @"";
            }
        }
    }else if (self.numberType == JGJNumberKeyNoDecimalBoardType) { //金额数字键盘不带小数点输入
        
        self.textfiled.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        if (![NSString isEmpty: textField.text ]) {
            if ([textField.text floatValue] == 0 || [textField.text isEqualToString:@"-.-"]) {
                textField.text = @"";
            }
        }
    }
    else{
        
        self.textfiled.keyboardType = UIKeyboardTypeDefault;
    }
    return YES;
}
- (void)searchTextFieldChangeAction: (UITextField *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(JGJMarkBillTextFileEditingText:WithTag:)]) {
        [self.delegate JGJMarkBillTextFileEditingText:sender.text WithTag:sender.tag];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    UITextField *countTextField = self.textfiled;
    NSString *NumbersWithDot = @"-.1234567890";
    NSString *NumbersWithoutDot = @"-1234567890";
    if (![string isEqualToString:@""]) {
        
        if (range.location == 0) {
            
            _firstInputStr = string;
        }
        NSCharacterSet *cs;
        
        if ([textField isEqual:countTextField]) {
            
            // 小数点在字符串中的位置 第一个数字从0位置开始
            
            NSInteger dotLocation = [textField.text rangeOfString:@"."].location;
            
            // 判断字符串中是否有小数点，并且小数点不在第一位
            
            // NSNotFound 表示请求操作的某个内容或者item没有发现，或者不存在
            
            // range.location 表示的是当前输入的内容在整个字符串中的位置，位置编号从0开始
            
            if (dotLocation == NSNotFound && range.location != 0) {
                
                
                // 取只包含“myDotNumbers”中包含的内容，其余内容都被去掉
                
                /*
                 
                 [NSCharacterSet characterSetWithCharactersInString:myDotNumbers]的作用是去掉"myDotNumbers"中包含的所有内容，只要字符串中有内容与"myDotNumbers"中的部分内容相同都会被舍去
                 
                 在上述方法的末尾加上invertedSet就会使作用颠倒，只取与“myDotNumbers”中内容相同的字符
                 
                 */
                
                cs = [[NSCharacterSet characterSetWithCharactersInString:NumbersWithDot] invertedSet];
                
                if ([_firstInputStr isEqualToString:@"-"]) {
                    
                    if (range.location >= 7) {
                        
                        
                        if ([string isEqualToString:@"."] && range.location == 7) {
                            
                            return YES;
                            
                        }
                        
                        return NO;
                        
                    }
                }else {
                    
                    if (range.location >= 7) {
                        
                        
                        if ([string isEqualToString:@"."] && range.location == 6) {
                            
                            return YES;
                            
                        }
                        
                        return NO;
                        
                    }
                }
                
                
            }else {
                
                cs = [[NSCharacterSet characterSetWithCharactersInString:NumbersWithoutDot] invertedSet];
                
            }
            
            // 按cs分离出数组,数组按@""分离出字符串
            
            NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
            
            BOOL basicTest = [string isEqualToString:filtered];
            
            if (!basicTest) {
                
                NSLog(@"只能输入数字和小数点");
                
                return NO;
                
            }
            
            if (dotLocation != NSNotFound && range.location > dotLocation + 2) {
                
                NSLog(@"小数点后最多两位");
                
                return NO;
                
            }
            
            
            if ([_firstInputStr isEqualToString:@"-"]) {
                
                if (textField.text.length > 9) {
                    
                    return NO;
                    
                }
                
            }else {
                
                if (textField.text.length > 8) {
                    
                    return NO;
                    
                }
            }
            
            
        }
        
    }
    
    return YES;
}

-(BOOL)inputTextFieldIsNumber:(NSString *)text
{
    
    //判断是否为 非数字 和 @“.”
    
    NSArray *moneyArr = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0",@"."];
    
    for (NSInteger i = 0; i < text.length; i++)
    {
        
        NSString *subChar = [text substringWithRange:NSMakeRange(i, 1)];
        
        if (![moneyArr containsObject:subChar])
            
        {
            
            return NO;
            
        }
        
    }
    
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(JGJMarkBillTextFilEndEditing)]) {
        [self.delegate JGJMarkBillTextFilEndEditing];
    }
    
}


@end

@implementation JGJNocopyTextfiled

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}

@end
