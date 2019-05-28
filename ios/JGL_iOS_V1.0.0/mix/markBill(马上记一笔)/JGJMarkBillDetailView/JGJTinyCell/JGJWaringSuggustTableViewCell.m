//
//  JGJWaringSuggustTableViewCell.m
//  mix
//
//  Created by Tony on 2018/1/3.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJWaringSuggustTableViewCell.h"

@implementation JGJWaringSuggustTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lookBtn.layer.masksToBounds = YES;
    self.lookBtn.layer.cornerRadius = 3;
    self.lookBtn.layer.borderColor = AppFontEB4E4EColor.CGColor;
    self.lookBtn.layer.borderWidth = 0.5;
    [self.lookBtn setTitleColor:AppFontEB4E4EColor forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)clickBtn:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickLookforDetailBtn)]) {
        [self.delegate clickLookforDetailBtn];
    }
}

@end
