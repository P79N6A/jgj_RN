//
//  JGJSingerNumInputTableViewCell.m
//  JGJCompany
//
//  Created by Tony on 2017/7/14.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJSingerNumInputTableViewCell.h"
#import "NSString+Extend.h"
@implementation JGJSingerNumInputTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _textfiled.delegate = self;
    _textfiled.keyboardType = UIKeyboardTypeDecimalPad;
    [_textfiled addTarget:self action:@selector(textchange:) forControlEvents:UIControlEventAllEditingEvents];

}
-(void)setModel:(JGJSelfLogTempRatrueModel *)model
{
    _model = model;
    _titleLable.text = model.element_name;
    _textfiled.placeholder = [@"请输入" stringByAppendingString:model.element_name];
    _uniteLable.text = model.element_unit;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([NSString isEmpty:_model.decimal_place] && [string isEqualToString:@"."]) {
        return NO;
    }else{
        if ([_model.decimal_place intValue] <= 0&& [string isEqualToString:@"."]) {
            return NO;
        }
    
    }
    if ([string isEqualToString:@"."] && ([textField.text rangeOfString:@"."].location != NSNotFound || [textField.text isEqualToString:@""])) {
        //判断之前是不是有小数点
        return NO;
    }
    NSMutableString *str = [[NSMutableString alloc] initWithString:textField.text];
    [str insertString:string atIndex:range.location];
    if (str.length >= [str rangeOfString:@"."].location+[_model.decimal_place intValue] + 2){
        return NO;
    }
    if (_model.length_range) {
        NSArray *array = [_model.length_range componentsSeparatedByString:@","];
        if (![NSString isEmpty:array.lastObject]) {
        if (textField.text.length > [array.lastObject intValue] && ![NSString isEmpty:string]){
            return NO;
        }
        }
    }
    return YES;
    
}
-(void)textchange:(UITextField *)textfiled
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(BuilderDailyTextfiledNumInputEndEidting:andTag:)]) {
        [self.delegate BuilderDailyTextfiledNumInputEndEidting:textfiled.text andTag:_textfiled.tag];
    }
}

@end
