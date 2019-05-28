//
//  JGJTechniqueTableViewCell.m
//  mix
//
//  Created by Tony on 2017/4/5.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJTechniqueTableViewCell.h"
#import "NSString+Extend.h"
@implementation JGJTechniqueTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _textview.delegate = self;

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
    if (self.delegate && [self.delegate respondsToSelector:@selector(BuilderDailyTechTextViewEndEidting:)]) {
        [self.delegate BuilderDailyTechTextViewEndEidting:textView.text];
    }

}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (_textview.text.length) {
        _placeLable.hidden = YES;
    }
    if (range.location > 999 && ![NSString isEmpty:text]) {
        return NO;
    }
    return YES;
}
@end
