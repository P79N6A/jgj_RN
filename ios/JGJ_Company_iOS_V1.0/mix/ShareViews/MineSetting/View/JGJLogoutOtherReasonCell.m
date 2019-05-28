//
//  JGJLogoutOtherReasonCell.m
//  mix
//
//  Created by yj on 2018/6/6.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJLogoutOtherReasonCell.h"

@interface JGJLogoutOtherReasonCell () <YYTextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UIButton *selButton;

@property (nonatomic, assign) NSUInteger maxContentWords;

@end

@implementation JGJLogoutOtherReasonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.textView.placeholderText = @"请输入注销原因...";
    
    self.textView.contentInset = UIEdgeInsetsMake(10, 10, 0, 0);
    
    self.textView.placeholderFont = [UIFont systemFontOfSize:AppFont28Size];
    
    self.textView.placeholderTextColor = AppFontccccccColor;
    
    [[YYTextView appearance] setTintColor:AppFontd7252cColor];
    
    self.textView.font = [UIFont systemFontOfSize:AppFont28Size];
    
    self.textView.textColor = AppFont333333Color;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:YYTextViewTextDidChangeNotification object:self];
    
    self.maxContentWords = 100;
    
    [self.textView.layer setLayerBorderWithColor:AppFontccccccColor width:1.0 radius:3.0];
    
    self.contentView.backgroundColor = AppFontEBEBEBColor;
    
    self.textView.delegate = self;
    
    self.textView.scrollEnabled = YES;
}

- (void)setDesModel:(JGJLogoutReasonModel *)desModel {
    
    _desModel = desModel;
    
    self.title.text = desModel.name;
    
    self.selButton.selected = desModel.isSel;
    
    if ([NSString isEmpty:desModel.des]) {
        
        self.textView.text = desModel.des;
    }
    
}

- (void)textDidChange {
    if (self.reasonCellBlock) {
        
        self.reasonCellBlock(self.textView.text);
    }
    
}

- (void)textViewDidChange:(YYTextView *)textView {
    
    if (![NSString isEmpty:textView.text]) {
        
        if (textView.text.length > _maxContentWords) {
            
            self.textView.selectedRange = NSMakeRange(textView.text.length, 0);
            
            NSString *inputContent = [textView.text substringToIndex:_maxContentWords];
            
            self.textView.text = inputContent;
            
        }
        
    }
    
    if (self.reasonCellBlock) {
        
        self.reasonCellBlock(textView.text);
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

+ (CGFloat)cellHeight {
    
    return 170.0;
}

@end
