//
//  JGJWindTableViewCell.m
//  mix
//
//  Created by Tony on 2017/3/28.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJWindTableViewCell.h"
#import "NSString+Extend.h"
@implementation JGJWindTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _Minlable.borderStyle = UITextBorderStyleNone;
    _Minlable.delegate = self;
//    _Minlable.keyboardType = UIKeyboardTypePhonePad;
    _Minlable.tag = 10;
    _maxlable.borderStyle = UITextBorderStyleNone;
//    _maxlable.keyboardType = UIKeyboardTypePhonePad;

    _maxlable.delegate = self;
    _maxlable.tag = 11;
//    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_Minlable.frame),  CGRectGetMinY(_Minlable.frame)-22, CGRectGetWidth(_Minlable.frame), 0.5)];
//    lable.backgroundColor = AppFont666666Color;
//    [self.contentView addSubview:lable];
//    UILabel *lables = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_uniteLable.frame)+ 20,  CGRectGetMinY(_maxlable.frame)-22,CGRectGetWidth(_Minlable.frame), 0.5)];
//    lables.backgroundColor = AppFont666666Color;
//    [self.contentView addSubview:lables];

    [_Minlable addTarget:self action:@selector(beginEdite:) forControlEvents:UIControlEventEditingChanged];
    [_maxlable addTarget:self action:@selector(beginEdite:) forControlEvents:UIControlEventEditingChanged];

}
-(void)beginEdite:(UITextField *)textfile
{
    if (textfile.tag == 10) {
        _windMinStr = textfile.text;
        if (textfile.text.length > 0) {
            _Minlable.textColor = AppFont333333Color;
        }else{
            _Minlable.textColor = AppFontccccccColor;
        }
    }else if (textfile.tag == 11){
        _windMaxStr = textfile.text;
        if (textfile.text.length > 0) {
            _maxlable.textColor = AppFont333333Color;
        }else{
            _maxlable.textColor = AppFontccccccColor;
        }
    }
    if (self.delegate &&[self.delegate respondsToSelector:@selector(endEditeMinWind:maxwind:)]) {
        [self.delegate endEditeMinWind:_Minlable.text maxwind:_maxlable.text];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField.tag == 10) {
        _windMinStr = textField.text;
        if (textField.text.length > 0) {
            _Minlable.textColor = AppFont333333Color;
            
        }else{
            _Minlable.textColor = AppFontccccccColor;
            
        }
    }else if (textField.tag == 11){
        _windMaxStr = textField.text;
        if (textField.text.length > 0) {
            _maxlable.textColor = AppFont333333Color;
        }else{
            _maxlable.textColor = AppFontccccccColor;
            
        }
    }

    
    if (range.location  > 9 && ![NSString isEmpty:string]){
        return NO;
    }else{
//        if (self.delegate &&[self.delegate respondsToSelector:@selector(endEditeMinWind:maxwind:)]) {
//            [self.delegate endEditeMinWind:_windMinStr maxwind:_windMaxStr];
//        }
    }
    return YES;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];


}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setTempEditewind_am:(NSString *)wind_am wind_pm:(NSString *)wind_pm
{
    _Minlable.text = wind_am;
    _maxlable.text = wind_pm;

}

@end
