//
//  JGJGetPhoneVerfyTableViewCell.m
//  JGJCompany
//
//  Created by Tony on 2017/7/19.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJGetPhoneVerfyTableViewCell.h"
#import "NSString+Extend.h"
@implementation JGJGetPhoneVerfyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _phoneTextfiled.delegate = self;
    _phoneTextfiled.keyboardType = UIKeyboardTypeNumberPad;

    [_phoneTextfiled addTarget:self action:@selector(textfilefChange:) forControlEvents:UIControlEventEditingChanged];
    _currentTime = 60;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (IBAction)clickGetCodeButton:(id)sender {
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeRepeat) userInfo:nil repeats:YES];
    [_getCodeButton setTitle:[NSString stringWithFormat:@"%ld 秒后重新获取",(long)_currentTime] forState:UIControlStateNormal];

    [_getCodeButton setTitleColor:AppFontccccccColor forState:UIControlStateNormal];
    _getCodeButton.userInteractionEnabled = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickGetPhoneCodeButton)]) {
        [self.delegate clickGetPhoneCodeButton];
    }
}
-(void)timeRepeat
{

    _currentTime --;
    [_getCodeButton setTitle:[NSString stringWithFormat:@"%ld 秒后重新获取",(long)_currentTime] forState:UIControlStateNormal];

    if (_currentTime == 0) {
        [_timer invalidate];
        _getCodeButton.userInteractionEnabled = YES;
        [_getCodeButton setTitleColor:AppFontEB4E4EColor forState:UIControlStateNormal];
        [_getCodeButton setTitle:@"点击获取验证码" forState:UIControlStateNormal];

        _currentTime = 60;
    }

}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length > 3 && ![NSString isEmpty:string]) {
        return NO;
    }
    return YES;
}
-(void)textfilefChange:(UITextField *)textfiled
{

    if (self.delegate && [self.delegate respondsToSelector:@selector(textfiledEdite:)]) {
        [self.delegate textfiledEdite:textfiled.text];
    }
}
@end
