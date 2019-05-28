//
//  JGJCheacContentTableViewCell.m
//  JGJCompany
//
//  Created by Tony on 2017/11/17.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJCheacContentTableViewCell.h"

@implementation JGJCheacContentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textFiled.borderStyle = UITextBorderStyleNone;
    self.textFiled.delegate = self;
    [self.textFiled addTarget:self action:@selector(searchTextFieldChangeAction:)   forControlEvents:UIControlEventEditingChanged];

}
- (void)searchTextFieldChangeAction: (UITextField *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(JGJCheckContentTextfiledEdite:)]) {
        [self.delegate JGJCheckContentTextfiledEdite:self.textFiled.text];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(JGJCheckContentTextfiledEdite:andTag:)]) {
        [self.delegate JGJCheckContentTextfiledEdite:self.textFiled.text andTag:self.textFiled.tag];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
