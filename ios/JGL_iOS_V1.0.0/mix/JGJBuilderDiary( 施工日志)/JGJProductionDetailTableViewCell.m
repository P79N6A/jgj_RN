//
//  JGJProductionDetailTableViewCell.m
//  mix
//
//  Created by Tony on 2017/4/5.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJProductionDetailTableViewCell.h"
#import "NSString+Extend.h"
@implementation JGJProductionDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _TextView.delegate = self;

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length >0) {
       
        _placeLable.hidden = YES;
        
    }else{
        
        _placeLable.hidden = NO;
    }
    
    if (![NSString isEmpty:textView.text]) {
        
        NSArray *array = [_model.length_range componentsSeparatedByString:@","];
        
        NSInteger maxLength = [array.lastObject intValue];
        
        if (textView.text.length > maxLength) {
            
            textView.selectedRange = NSMakeRange(textView.text.length, 0);
            
            NSString *inputContent = [textView.text substringToIndex:maxLength];
            
            textView.text = inputContent;
            
        }
        
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(BuilderDailyTextViewEndEidting: andTag:)]) {
        
        [self.delegate BuilderDailyTextViewEndEidting:textView.text andTag:textView.tag];
    }
    //    if (textView.markedTextRange == nil) {
    //        NSLog(@"text:%@", textView.text);
    //    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (_TextView.text.length) {
        
        _placeLable.hidden = YES;
    }
    if (_model.length_range) {
        
        NSArray *array = [_model.length_range componentsSeparatedByString:@","];
        
        if (![NSString isEmpty:array.lastObject]) {

            if (textView.text.length >= [array.lastObject intValue] && ![NSString isEmpty:text]){
            
                return NO;
            }
        }
    }


    if (range.location > 999 && ![NSString isEmpty:text]) {
        
        return NO;
    }
    return YES;
}
- (void)setModel:(JGJSelfLogTempRatrueModel *)model {

    _model = model;
    _topTitleLable.text = [@"   " stringByAppendingString: model.element_name ];
    if ([NSString isEmpty:_model.element_name]) {
    
        _placeLable.text = [@"请输入" stringByAppendingString:model.element_name];
    }
}


@end
