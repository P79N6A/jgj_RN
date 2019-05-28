//
//  TYTextField.m
//  mix
//
//  Created by Tony on 15/12/31.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "TYTextField.h"

@implementation TYTextField

+ (void)textFieldDidBeginEditingColor:(UITextField *)textField color:(UIColor *)color{
    textField.layer.cornerRadius  = 4.0f;
    textField.layer.borderWidth   = 0.5f;
    textField.layer.masksToBounds = YES;
    textField.layer.borderColor   = color.CGColor;
}

+ (void)textFieldDidEndEditing:(UITextField *)textField color:(UIColor *)color{
    textField.layer.cornerRadius  = 4.0f;
    textField.layer.borderWidth   = 0.5f;
    textField.layer.masksToBounds = YES;
    textField.layer.borderColor   = color.CGColor;
}
@end

@implementation BaseTextField

- (void)customInit {
    
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self customInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]) != nil) {
        [self customInit];
    }
    
    return self;
}

@end


@implementation NormalTextField

- (void)customInit {
    
    NSString *place = self.placeholder;
    if (place) {
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:place attributes:@{NSForegroundColorAttributeName: ColorHex(0Xb8b8b8),NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    }
    
    self.textColor = ColorHex(0X333e4c);
    self.font = [UIFont systemFontOfSize:15];
    
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"webViewFailure_Image"]];
    self.rightView = imgView;
    
}

@end

@implementation LengthLimitTextField

- (void)customInit {
    
    self.maxLength = NSIntegerMax;
    [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [super customInit];
    
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self) {
        
        NSString *toBeString = textField.text;
        
        NSString *lang = [self.textInputMode primaryLanguage]; // 键盘输入模式
        
        if([lang isEqualToString:@"zh-Hans"]) { //简体中文输入，包括简体拼音，健体五笔，简体手写
            UITextRange *selectedRange = [textField markedTextRange];
            //获取高亮部分
            UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
            //没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if(!position) {
                if(toBeString.length > self.maxLength) {
                    textField.text = [toBeString substringToIndex:self.maxLength];
                }else{
                    if (self.valueDidChange) {
                        self.valueDidChange(textField.text);
                    }
                }
            }else{//有高亮选择的字符串，则暂不对文字进行统计和限制
            }
        }else{//中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
            if(toBeString.length > self.maxLength) {
                textField.text= [toBeString substringToIndex:self.maxLength];
            }else{
                if (self.valueDidChange) {
                    self.valueDidChange(textField.text);
                }
            }
        }
    }
}

@end
