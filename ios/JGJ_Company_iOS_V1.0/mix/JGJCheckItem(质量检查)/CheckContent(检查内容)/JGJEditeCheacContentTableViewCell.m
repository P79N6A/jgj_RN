//
//  JGJEditeCheacContentTableViewCell.m
//  JGJCompany
//
//  Created by Tony on 2017/11/17.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJEditeCheacContentTableViewCell.h"

@implementation JGJEditeCheacContentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textView.delegate = self;

}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{

    if (textView.text.length > 29 && ![NSString isEmpty:text]) {
        return NO;
    }
    

    return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (![NSString isEmpty:textView.text]) {
        self.placeLable.hidden = YES;
    }else{
        self.placeLable.hidden = NO;
        
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(JGJEditeCheacContentTextviewEdite:andTag:)]) {
        
        [self.delegate JGJEditeCheacContentTextviewEdite:textView.text andTag:self.textView.tag];
    }
    
    
}
- (IBAction)clickDeleteBtn:(id)sender {
    
    self.deleteButton = (UIButton *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(JGJEditeCheacContentClickDeleteButtonWithTag:)]) {
        [self.delegate JGJEditeCheacContentClickDeleteButtonWithTag:self.deleteButton.tag];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
