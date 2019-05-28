//
//  JGJWorkReportTomarrowTableViewCell.m
//  JGJCompany
//
//  Created by Tony on 2017/5/22.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJWorkReportTomarrowTableViewCell.h"

@implementation JGJWorkReportTomarrowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _textview.delegate = self;
    // Initialization code
}
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length >0) {
        _placeLable.hidden = YES;
        
    }else{
        _placeLable.hidden = NO;
        
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(endeditingtomorrowWorkPlan:)]) {
        [self.delegate endeditingtomorrowWorkPlan:textView.text];
    }
    //    if (textView.markedTextRange == nil) {
    //        NSLog(@"text:%@", textView.text);
    //    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
