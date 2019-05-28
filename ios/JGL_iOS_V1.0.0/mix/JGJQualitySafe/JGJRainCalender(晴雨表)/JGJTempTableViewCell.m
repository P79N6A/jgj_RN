//
//  JGJTempTableViewCell.m
//  mix
//
//  Created by Tony on 2017/3/28.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJTempTableViewCell.h"
#import "NSString+Extend.h"
@implementation JGJTempTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _mintextfiled.borderStyle = UITextBorderStyleNone;
    _mintextfiled.delegate = self;
    _mintextfiled.tag = 12;
//    _mintextfiled.keyboardType = UIKeyboardTypeNumberPad;
    _maxtextfiled.borderStyle = UITextBorderStyleNone;
    _maxtextfiled.delegate =self;
//    _maxtextfiled.keyboardType = UIKeyboardTypeNumberPad;
    _maxtextfiled.tag = 13;
//    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_mintextfiled.frame),  CGRectGetMinY(_mintextfiled.frame)+3, CGRectGetWidth(_mintextfiled.frame), 0.5)];
//    lable.backgroundColor = AppFont666666Color;
//    [self.contentView addSubview:lable];
//    UILabel *lables = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_uniteLable.frame)+ 20 ,  CGRectGetMinY(_maxtextfiled.frame)+3, CGRectGetWidth(_mintextfiled.frame), 0.5)];
//    lables.backgroundColor = AppFont666666Color;
//    [self.contentView addSubview:lables];
    [_mintextfiled addTarget:self action:@selector(beginEdite:) forControlEvents:UIControlEventEditingChanged];

    [_maxtextfiled addTarget:self action:@selector(beginEdite:) forControlEvents:UIControlEventEditingChanged];
}
-(void)beginEdite:(UITextField *)textfile
{
    if (textfile.tag == 12) {
        _tempMInStr = textfile.text;
        if (textfile.text.length > 0) {
            _mintextfiled.textColor = AppFont333333Color;
            
        }else{
            _mintextfiled.textColor = AppFontccccccColor;
            
        }
    }else if (textfile.tag == 13){
        _tempMaxStr = textfile.text;
        if (textfile.text.length > 0) {
            _maxtextfiled.textColor = AppFont333333Color;
        }else{
            _maxtextfiled.textColor = AppFontccccccColor;
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(endEditeMintemp:maxTemp:)]) {
        [self.delegate endEditeMintemp:_mintextfiled.text maxTemp:_maxtextfiled.text];
    }

}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 12) {
        _tempMInStr = textField.text;
        if (textField.text.length > 0) {
            _mintextfiled.textColor = AppFont333333Color;
            
        }else{
            _mintextfiled.textColor = AppFontccccccColor;
            
        }
    }else if (textField.tag == 13){
        _tempMaxStr = textField.text;
        if (textField.text.length > 0) {
            _maxtextfiled.textColor = AppFont333333Color;
        }else{
            _maxtextfiled.textColor = AppFontccccccColor;
        }
    }
    
    if (range.location  > 9 && ![NSString isEmpty:string]){
            return NO;
    }else{

//        if (self.delegate && [self.delegate respondsToSelector:@selector(endEditeMintemp:maxTemp:)]) {
//            [self.delegate endEditeMintemp:_tempMInStr?:@"" maxTemp:_tempMaxStr?:@""];
//        }
    }
    return YES;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)setTempEditetemp_am:(NSString *)temp_am temp_pm:(NSString *)temp_pm
{
    if (temp_am.length) {
        _mintextfiled.textColor = AppFont333333Color;
    }
    if (temp_pm.length) {
        _maxtextfiled.textColor = AppFont333333Color;

    }
    _mintextfiled.text = temp_am;
    _maxtextfiled.text = temp_pm;

}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [TYNotificationCenter postNotificationName:@"dissMissWeatherPicker" object:nil];

    return YES;
}
@end
