//
//  JGJBrrowOrTotalTableViewCell.m
//  mix
//
//  Created by Tony on 2017/10/10.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJBrrowOrTotalTableViewCell.h"

@implementation JGJBrrowOrTotalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _textfiled.delegate = self;
    
    _textfiled.backgroundColor = [UIColor clearColor];
    
    _textfiled.borderStyle = UITextBorderStyleNone;
    
    _textfiled.textAlignment = NSTextAlignmentRight;
    
    [_textfiled addTarget:self action:@selector(TextFieldChangeAction:)   forControlEvents:UIControlEventEditingChanged];
    
    if (self.textfiled.tag == 109) {
        
        _textfiled.textColor = AppFont333333Color;
        
    }else if (self.textfiled.tag == 110){
        
        _textfiled.textColor = AppFontd7252cColor;

    }else{
        
        _textfiled.textColor = AppFonte83c76eColor;
        
    }
    
    if (self.textfiled.tag == 109) {
        
        _textfiled.keyboardType = UIKeyboardTypeDefault;
        
    }else{
        
        _textfiled.keyboardType = UIKeyboardTypeDecimalPad;
        
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    
    if (textField.tag == 109) {
        
        textField.keyboardType = UIKeyboardTypeDefault;
        
    }else{
        
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        
    }
    if (self.delegate &&[self.delegate respondsToSelector:@selector(JGJBrrowOrTotalTextfiledEdite:andtextTag:)]) {
        
    [self.delegate JGJBrrowOrTotalTextfiledEdite:textField.text andtextTag:textField.tag];
        
    }

    
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    /*  NSInteger dotLocation = [textField.text rangeOfString:@"."].location;
     
     
     
     // 判断字符串中是否有小数点，并且小数点不在第一位
     
     // NSNotFound 表示请求操作的某个内容或者item没有发现，或者不存在
     
     // range.location 表示的是当前输入的内容在整个字符串中的位置，位置编号从0开始
     
     if (dotLocation == NSNotFound && range.location != 0) {
     
     }*/
    
    
    if (self.textfiled.tag == 109) {
        
        return YES;
        
    }
    
    if (![self inputTextFieldIsNumber:string]) {
        
        return NO;
        
    }
    if ([textField.text containsString:@"."] && [string isEqualToString:@"."]) {
        
        return NO;
        
    }
    if ([NSString isEmpty:string]) {
        NSString *deleteStr = [textField.text substringWithRange:range];
        if ([deleteStr isEqualToString:@"."] && [[textField.text stringByReplacingOccurrencesOfString:@"." withString:@""] floatValue] >=1000000) {
            
            return NO;
            
        }
    }
    
    //过滤小数点
    if ([textField.text containsString:@"."] && ![NSString isEmpty:string]) {
        NSInteger dotLocation = [textField.text rangeOfString:@"."].location;
        if (textField.text.length - dotLocation >2 && dotLocation && textField.text.length) {
            return NO;
        }
        
        
    }
    
    
    if (range.length == 1 && string.length == 0) {
        return YES;
    }
    if (range.location >=  6 &&_textfiled.tag != 109){
        
        if (![NSString isEmpty: string ]) {
            if ([[textField.text stringByAppendingString:string] floatValue] < 1000000) {
                return YES;
            }
        }
        
        if ([NSString isEmpty: string]) {
            
        }
        
        return NO;
    }else{
        
        return YES;
    }
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    //    if (self.delegate &&[self.delegate respondsToSelector:@selector(didendtextfiledfortext:withTexttag:)]) {
    //        [self.delegate didendtextfiledfortext:textField.text withTexttag:textField.tag];
    //    }
    return YES;
}

- (void)TextFieldChangeAction: (UITextField *)sender
{
    if (self.textfiled.tag == 109) {
        _textfiled.textColor = AppFont333333Color;
    }else if (self.textfiled.tag == 110){
    
        _textfiled.textColor = AppFontd7252cColor;

    }else{
        _textfiled.textColor = AppFonte83c76eColor;

    }
        if (self.delegate &&[self.delegate respondsToSelector:@selector(JGJBrrowOrTotalTextfiledEdite: andtextTag:)]) {
            [self.delegate JGJBrrowOrTotalTextfiledEdite:_textfiled.text andtextTag:sender.tag];
        }
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

@end
