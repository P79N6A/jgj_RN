//
//  JGJSignRemarkCell.m
//  mix
//
//  Created by yj on 17/3/4.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJSignRemarkCell.h"

#import "NSString+Extend.h"

@interface JGJSignRemarkCell () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet YYTextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *remarkLable;

@property (nonatomic, assign) NSUInteger maxContentWords;
@property (weak, nonatomic) IBOutlet UILabel *remarkType;

@end

@implementation JGJSignRemarkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.textView.placeholderText = @"请描述一下今天的工作情况吧";
    
    self.textView.placeholderFont = [UIFont systemFontOfSize:AppFont28Size];
    
    self.textView.placeholderTextColor = AppFontccccccColor;
    
    [[YYTextView appearance] setTintColor:AppFontd7252cColor];
    
    self.textView.font = [UIFont systemFontOfSize:AppFont28Size];
    
    self.textView.textColor = TYColorHex(0X545454);
    
    _maxContentWords = 100;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    paragraphStyle.lineSpacing = 3;// 字体的行间距
    
    NSDictionary *attributes = @{
                                 
                                 NSFontAttributeName:self.textView.font,
                                 
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 
                                 };
    
    self.textView.typingAttributes = attributes;
    
    
    
}

- (void)setIsCheckSignInfo:(BOOL)isCheckSignInfo {

    _isCheckSignInfo = isCheckSignInfo;
    
    //查看类型不能输入信息
    self.textView.userInteractionEnabled = !_isCheckSignInfo;
    
}

- (void)setAddSignModel:(JGJAddSignModel *)addSignModel {

    _addSignModel = addSignModel;
    
    self.textView.text = _addSignModel.sign_desc;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (![NSString isEmpty:textView.text]) {
        
        if (textView.text.length > _maxContentWords) {
            
            self.textView.selectedRange = NSMakeRange(textView.text.length, 0);
            
            NSString *inputContent = [textView.text substringToIndex:_maxContentWords];
            
            self.textView.text = inputContent;
            
        }
        
    }
    
    if ([self.delegate respondsToSelector:@selector(textViewCell:didChangeText:)]) {
        
        [self.delegate textViewCell:self didChangeText:textView];
        
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

- (UITableView *)tableView
{
    UIView *tableView = self.superview;
    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
        tableView = tableView.superview;
    }
    return (UITableView *)tableView;
}
//

@end
