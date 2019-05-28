//
//  TYTextView.m
//  mix
//
//  Created by Tony on 16/6/20.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "TYTextView.h"

@interface TYTextView ()
<
    UITextViewDelegate
>
{
    CGFloat _oldCurHeight;//记录上一次的高度
}
@property (nonatomic, copy)     NSString *placeholderStr;

@property (nonatomic, strong)   UIColor *placeholderColor;

@property (nonatomic, strong)   UIColor *contentColor;

@end

@implementation TYTextView

- (id)getText{
    NSString *textStr = self.text;
    if ([textStr isEqualToString:self.placeholderStr]) {
        textStr = @"";
    }
    return textStr;
}

- (void)setPlaceholderStr:(NSString *)placeholderStr placeholderColor:(UIColor *)placeholderColor{
    self.placeholderStr = placeholderStr;
    self.placeholderColor = placeholderColor;
}

- (void)setContentColor:(UIColor *)contentColor{
    _contentColor = contentColor;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    [self startShowTextView];
}

- (void)startShowTextView{
    self.delegate = self;
    self.tintColor = self.placeholderColor;
    if (self.text.length == 0) {
        self.text = self.placeholderStr;
        self.textColor = self.placeholderColor;
    }else if([self.text isEqualToString:self.placeholderStr]){
        self.textColor = self.placeholderColor;
    }else{
        self.textColor = self.contentColor;
    }
}

//开始编辑
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:self.placeholderStr]) {
        textView.text = @"";
        [textView setTextColor:self.contentColor];
    }
    
    if (self.TYTextDelegate && [self.TYTextDelegate respondsToSelector:@selector(TYTextViewBeginEditing:)]) {
        [self.TYTextDelegate TYTextViewBeginEditing:textView];
    }
    return YES;
}

//结束编辑
- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0) {
        textView.text = self.placeholderStr;
        textView.textColor = self.placeholderColor;
    }else{
        textView.textColor = self.contentColor;
    }
    

    if (self.TYTextDelegate && [self.TYTextDelegate respondsToSelector:@selector(TYTextViewDidEndEditing:)]) {
        [self.TYTextDelegate TYTextViewDidEndEditing:textView.text];
    }
    [self endEditing:YES];
}

- (void)textViewDidChange:(UITextView *)textView{
    if (self.TYTextDelegate && [self.TYTextDelegate respondsToSelector:@selector(TYTextViewDidChange:)]) {
        [self.TYTextDelegate TYTextViewDidChange:textView];
    }
    
    //---- 计算高度 ---- //
    CGSize size = CGSizeMake(self.frame.size.width, CGFLOAT_MAX);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:self.font.pointSize],NSFontAttributeName, nil];
    
    CGFloat curheight = [textView.text boundingRectWithSize:size
                                                    options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                 attributes:dic
                                                    context:nil].size.height;
    
    //如果变化太小就不需要更新
    if (fabs(_oldCurHeight - curheight) < 1.0) {
        return;
    }
    
    _oldCurHeight = curheight;
    
    if (self.TYTextDelegate && [self.TYTextDelegate respondsToSelector:@selector(TYTextViewCurheight:curHeight:)]) {
        [self.TYTextDelegate TYTextViewCurheight:self curHeight:curheight];
    }
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    //这个判断相当于是textfield中的点击return的代理方法
    if ([text isEqualToString:@"\n"]) {
        if (self.canReturn) {
            return YES;
        }else{
            [textView resignFirstResponder];
            return NO;
        }
    }
    
    return YES;
}
@end
