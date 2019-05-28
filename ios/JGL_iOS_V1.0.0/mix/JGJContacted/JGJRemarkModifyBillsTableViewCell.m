//
//  JGJRemarkModifyBillsTableViewCell.m
//  mix
//
//  Created by Tony on 2017/10/9.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJRemarkModifyBillsTableViewCell.h"

#import "UILabel+GNUtil.h"
@implementation JGJRemarkModifyBillsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _textView.delegate = self;
    
    [self.titleLable markText:@"(该备注信息仅自己可见)" withFont:[UIFont systemFontOfSize:13] color:AppFont999999Color];
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(RemarkModifyBillsTextfiledEting:)]) {
        [self.delegate RemarkModifyBillsTextfiledEting:textView.text];
    }
    

}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (![NSString isEmpty:textView.text] || ![NSString isEmpty: text]) {
        _placeLable.hidden = YES;
        
    }else{
        
        _placeLable.hidden = NO;

    }
    if (![NSString isEmpty:text]  && textView.text.length >=  199) {
        
        return NO;
        
    }
    return YES;
    

}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![NSString isEmpty:string]  && range.location >=  199) {
        return NO;
        
    }
    return YES;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
