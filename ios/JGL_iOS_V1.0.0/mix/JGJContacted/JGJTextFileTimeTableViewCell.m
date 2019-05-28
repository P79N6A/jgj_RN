//
//  JGJTextFileTimeTableViewCell.m
//  mix
//
//  Created by Tony on 2017/2/28.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJTextFileTimeTableViewCell.h"
#import "NSString+Extend.h"
@implementation JGJTextFileTimeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _holdView.layer.masksToBounds = YES;
    _holdView.layer.cornerRadius  = 5;
    _subTextFiled.backgroundColor = [UIColor clearColor];
    _subTextFiled.borderStyle = UITextBorderStyleNone;
    _subTextFiled.textAlignment = NSTextAlignmentRight;
    _subTextFiled.delegate = self;
    _leftLogo.layer.masksToBounds = YES;
    _leftLogo.layer.cornerRadius  = CGRectGetWidth(_leftLogo.frame)/2;
    [_subTextFiled addTarget:self action:@selector(searchTextFieldChangeAction:)   forControlEvents:UIControlEventEditingChanged];
    if (TYGetUIScreenWidth <=320) {
        _subTextFiled.font = [UIFont systemFontOfSize:11];
    }else{
        _subTextFiled.font = [UIFont systemFontOfSize:AppFont26Size];
    }
    _subTextFiled.textColor = AppFontbdbdc3Color;
}
-(void)setBigBool:(BOOL)BigBool
{
    if (BigBool) {
        _leftLogo.backgroundColor = [UIColor whiteColor];
        _leftLogo.transform = CGAffineTransformMakeScale(2.6, 2.6);
        _uplable.transform = CGAffineTransformMakeTranslation(0, -4);
        _downLable.transform = CGAffineTransformMakeTranslation(0, 4);
    }else{
        _leftLogo.backgroundColor = AppFonte8e8e8Color;
        _uplable.transform = CGAffineTransformMakeTranslation(0, 0);
        _downLable.transform = CGAffineTransformMakeTranslation(0, 0);
         }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
[super setSelected:selected animated:animated];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.text.length>0) {
        _subTextFiled.textColor = AppFont333333Color;

    _leftLogo.transform = CGAffineTransformMakeScale(2.6, 2.6);

    }

}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 2) {
        
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(didendtextfiledfortext:withTexttag:)]) {
        [self.delegate didendtextfiledfortext:_subTextFiled.text withTexttag:_subTextFiled.tag];
    }
    }

    
    if (textField.tag != 0) {
    textField.keyboardType = UIKeyboardTypeDecimalPad;
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
    if (textField.tag == 0) {
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
if (range.location >=  6 &&(_subTextFiled.tag == 1 || _subTextFiled.tag == 10)){
  
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

- (void)searchTextFieldChangeAction: (UITextField *)sender
{
    if (_subTextFiled.tag == 10) {
    _subTextFiled.textColor = AppFonte83c76eColor;

        if (self.delegate &&[self.delegate respondsToSelector:@selector(didendtextfiledfortext:withTexttag:)]) {
            [self.delegate didendtextfiledfortext:_subTextFiled.text withTexttag:_subTextFiled.tag];
        }

    }else if (_subTextFiled.tag == 1){
        _subTextFiled.textColor = AppFont333333Color;

    if (self.delegate &&[self.delegate respondsToSelector:@selector(didendtextfiledfortext:withTexttag:)]) {
            [self.delegate didendtextfiledfortext:_subTextFiled.text withTexttag:_subTextFiled.tag];
        }
    }else if (_subTextFiled.tag == 0){
    _subTextFiled.textColor = AppFont333333Color;
    if (self.delegate &&[self.delegate respondsToSelector:@selector(didendtextfiledfortext:withTexttag:)]) {
            [self.delegate didendtextfiledfortext:_subTextFiled.text withTexttag:_subTextFiled.tag];
        }
    }else{
        if (sender == _subTextFiled) {
            if (sender.text.length > 6) {
                sender.text = [sender.text substringToIndex:6 ];
            }
        }
        _subTextFiled.textColor = AppFont333333Color;
        
if (self.delegate &&[self.delegate respondsToSelector:@selector(didendtextfiledfortext:withTexttag:)]) {
    
    [self.delegate didendtextfiledfortext:_subTextFiled.text withTexttag:_subTextFiled.tag];
    
       }

    }
        if ([_subTextFiled.text length] == 0 )
    {
            _leftLogo.transform = CGAffineTransformMakeScale(1,1);
                switch (_subTextFiled.tag) {
                    case 0:
                        _leftLogo.image = [UIImage imageNamed:@""];
                        break;
                    case 1:
                        _leftLogo.image = [UIImage imageNamed:@""];
        
                        break;
                    case 2:
                        _leftLogo.image = [UIImage imageNamed:@""];
        
                        break;
                    case 10:
                        _leftLogo.image = [UIImage imageNamed:@""];
        
                        break;
                    default:
                        break;
                }
    }else{
    
            _leftLogo.transform = CGAffineTransformMakeScale(2.6, 2.6);
            switch (_subTextFiled.tag) {
                case 0:
                    _leftLogo.image = [UIImage imageNamed:@"projects"];
                    break;
                case 1:
                    _leftLogo.image = [UIImage imageNamed:@"wage"];
                    
                    break;
                case 2:
                    _leftLogo.image = [UIImage imageNamed:@"number"];
                    
                    break;
                case 10:
                    _leftLogo.image = [UIImage imageNamed:@"msjyb_icon_price_selected"];
                    
                    break;
                default:
                    break;
            }
            
        


    
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
