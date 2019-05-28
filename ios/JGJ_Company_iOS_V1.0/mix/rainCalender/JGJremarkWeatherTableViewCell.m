//
//  JGJremarkWeatherTableViewCell.m
//  mix
//
//  Created by Tony on 2017/3/28.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJremarkWeatherTableViewCell.h"
#import "NSString+Extend.h"
@implementation JGJremarkWeatherTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _textview.delegate = self;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginediting:) name:UITextViewTextDidBeginEditingNotification object:self];
    //停止编辑
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endediting:) name:UITextViewTextDidEndEditingNotification object:self];
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
  
    if (self.delegate &&[self.delegate respondsToSelector:@selector(endEditeRemarkContent:)]) {
        [self.delegate endEditeRemarkContent:textView.text];
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];


}
-(void)setTempEditecontent:(NSString *)content
{
    _placeLable.hidden = YES;

    _textview.text = content;

}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![NSString isEmpty:string]  && textField.text.length >50) {
        return NO;
 
    }
    return YES;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (![NSString isEmpty:text]  && textView.text.length >50) {
        return NO;
        
    }
    return YES;


}

@end
