//
//  JGJPushContentCell.m
//  mix
//
//  Created by yj on 2017/5/31.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJPushContentCell.h"

#import "NSString+Extend.h"

#import "UIView+GNUtil.h"

//#define MaxWords 1000

@interface JGJPushContentCell ()

@property (weak, nonatomic) IBOutlet YYTextView *textView;

@end

@implementation JGJPushContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.textView.placeholderText = @"请输入任务内容";
    
    self.textView.placeholderFont = [UIFont systemFontOfSize:AppFont30Size];
    
    self.textView.placeholderTextColor = AppFontccccccColor;
    
    [[YYTextView appearance] setTintColor:AppFontd7252cColor];
    
    self.textView.font = [UIFont systemFontOfSize:AppFont30Size];
    
    self.textView.textColor = AppFont333333Color;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:YYTextViewTextDidChangeNotification object:self];
    
    self.maxContentWords = 400;
    
}

- (void)setPlaceholderText:(NSString *)placeholderText {

    _placeholderText = placeholderText;
    
    if (![NSString isEmpty:self.placeholderText]) {
        
        self.textView.placeholderText = self.placeholderText;
    }

}

- (void)setCheckRecordDefaultText:(NSString *)checkRecordDefaultText {

    _checkRecordDefaultText = checkRecordDefaultText;
    
    if (![NSString isEmpty:_checkRecordDefaultText]) {
        
        self.textView.text = _checkRecordDefaultText;
        
        [self textViewDidChange:self.textView];
    }

}

- (void)textDidChange {
   
//    self.textView.attributedText = [NSString setAttributedStringText:self.textView.text lineSapcing:3.0];
   
    if (self.pushContentCellBlock) {
        
         self.pushContentCellBlock(self.textView);   
    }
}

- (void)textViewDidChange:(YYTextView *)textView {

//    textView.attributedText = [NSString setAttributedStringText:textView.text lineSapcing:3.0];
    
    if (![NSString isEmpty:textView.text]) {
        
        if (textView.text.length > _maxContentWords) {
            
            self.textView.selectedRange = NSMakeRange(textView.text.length, 0);
            
            NSString *inputContent = [textView.text substringToIndex:_maxContentWords];
            
            self.textView.text = inputContent;
            
            
        }
        
    }
    
    if (self.pushContentCellBlock) {
        
        self.pushContentCellBlock(textView);
    }
    
}

- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    
    if (![NSString isEmpty:textView.text]) {
        
        if (textView.text.length > _maxContentWords && ![text isEqualToString:@""]) {
            
            return NO;
        }
    }
    
    return YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    
    [TYNotificationCenter removeObserver:self];
}

@end
