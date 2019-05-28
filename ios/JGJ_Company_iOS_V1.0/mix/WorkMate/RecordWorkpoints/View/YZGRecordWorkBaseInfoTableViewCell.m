//
//  YZGRecordWorkBaseInfoTableViewCell.m
//  mix
//
//  Created by Tony on 16/3/4.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "YZGRecordWorkBaseInfoTableViewCell.h"

@interface YZGRecordWorkBaseInfoTableViewCell ()
<
    UITextFieldDelegate
>
{
    BOOL _isOnlyNum;
}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailTFLayoutR;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelLayoutL;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLineLayoutL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLineLayoutR;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;


@end

@implementation YZGRecordWorkBaseInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.detailTF.delegate = self;
    self.detailTF.keyboardType = UIKeyboardTypeDefault;
    self.jgjCellBottomLineView = self.bottomLineView;
}

- (void)setDetailIsOnlyNum:(BOOL )isOnlyNum{
    _isOnlyNum = isOnlyNum;
    self.detailTF.keyboardType = isOnlyNum?UIKeyboardTypeDecimalPad:UIKeyboardTypeDefault;
    self.detailTF.maxLength = 8;
}

- (void)setDetailIsOnlyDecimalPad {
    self.detailTF.keyboardType = UIKeyboardTypeDecimalPad;
     self.detailTF.maxLength = 8;
    LengthLimitTextField *moneyTF = self.detailTF;
    self.detailTF.valueDidChange = ^(NSString *v){
        
        if ([v rangeOfString:@"."].location != NSNotFound) {
            NSString *point = [v componentsSeparatedByString:@"."][1];
            if (point.length > 2) {
                moneyTF.text = [v substringToIndex:v.length - 1];
            }
            if ([self countOfStringWithString:v] > 1) {

                moneyTF.text = [v substringToIndex:v.length - 1];
            }
        }
    };
}

- (void)saveDataPoint:(NSInteger)numPoint {

    self.detailTF.keyboardType = UIKeyboardTypeDecimalPad;
    self.detailTF.maxLength = 8;
    LengthLimitTextField *moneyTF = self.detailTF;
    self.detailTF.valueDidChange = ^(NSString *v){
        
        if ([v rangeOfString:@"."].location != NSNotFound) {
            NSString *point = [v componentsSeparatedByString:@"."][1];
            if (point.length > numPoint) {
                moneyTF.text = [v substringToIndex:v.length - 1];
            }
            if ([self countOfStringWithString:v] > 1) {
                moneyTF.text = [v substringToIndex:v.length - 1];
            }
        }
    };
}

- (void)setDetailTFEnable:(BOOL )enabled{
    self.detailTF.enabled = enabled;
}

- (void)setDetail:(NSString *)detail{
    if (detail) self.detailTF.text = detail;
}

- (NSString *)getDetail{
    return self.detailTF.text;
}

- (void)setDetailColor:(UIColor *)detailColor{
    if (detailColor) self.detailTF.textColor = detailColor;
}

- (void)setDetailTFPlaceholder:(NSString *)placeholder{
    if (placeholder) self.detailTF.placeholder = placeholder;
}

- (void)setTitle:(NSString *)title setDetail:(NSString *)detail{
    if (title) self.titleLabel.text = title;
    if (detail) self.detailTF.text = detail;
}

- (void)setTitleColor:(UIColor *)titleColor setDetailColor:(UIColor *)detailColor{
    if (titleColor) self.titleLabel.textColor = titleColor;
    if (detailColor) self.detailTF.textColor = detailColor;
}

- (void)setTitleLeft:(NSInteger )leftValue setDetailTFRight:(NSInteger )rightValue{
    if (leftValue) self.titleLabelLayoutL.constant = leftValue;
    if (rightValue) self.detailTFLayoutR.constant = rightValue;
}

- (void)setBottomLineLeft:(NSInteger )leftValue setBottomLineRight:(NSInteger )rightValue{
    if (leftValue) self.bottomLineLayoutL.constant = leftValue;
    if (rightValue) self.bottomLineLayoutR.constant = rightValue;
}

#pragma mark - textField
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{  //string就是此时输入的那个字符textField就是此时正在输入的那个输入框返回YES就是可以改变输入框的值NO相反
    if ([string isEqualToString:@"\n"])  //按回车可以改变
    {
        return YES;
    }
    
    if (_isOnlyNum) {//只能输入数字
        //只能输入数字
        unichar single= string.length >0?[string characterAtIndex:0]:'0';
        if (!((single >='0' && single<='9')))//数字不能输入
        {
            return NO;
        }
    }

    //延迟的目的主要是避免还是没有修改的值
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(100 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(RecordWorkBaseInfoShouldChange:)]) {
            [self.delegate RecordWorkBaseInfoShouldChange:self];
        }
    });
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.delegate && [self.delegate respondsToSelector:@selector(RecordWorkBaseInfoEndEditing:detailStr:)]) {
        [self.delegate RecordWorkBaseInfoEndEditing:self detailStr:textField.text];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (self.delegate && [self.delegate respondsToSelector:@selector(RecordWorkBaseInfoShouldBeginEditing:)]) {
        return [self.delegate RecordWorkBaseInfoShouldBeginEditing:self];
    }
    
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (self.delegate && [self.delegate respondsToSelector:@selector(RecordWorkBaseInfoBeginEditing:)]) {
        [self.delegate RecordWorkBaseInfoBeginEditing:self];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (self.delegate && [self.delegate respondsToSelector:@selector(RecordWorkBaseInfoReturn:)]) {
        [textField resignFirstResponder];
        [self.delegate RecordWorkBaseInfoReturn:self];
    }
    return YES;
}

//判断字符串中小数点个数
- (NSInteger)countOfStringWithString:(NSString *)string {
    
    NSInteger count = 0;
    for (int i = 0; i < string.length; i++) {
        
        char c = [string characterAtIndex:i];
        if (c == '.') count++;
    }
    return count;
}
@end
