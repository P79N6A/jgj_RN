 //
//  JGJNoManageProDefaultTableViewCell.m
//  mix
//
//  Created by Tony on 16/4/20.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJNoManageProDefaultTableViewCell.h"

@implementation JGJNoManageProSubStrModel
@end

@interface JGJNoManageProDefaultTableViewCell ()

@end

@implementation JGJNoManageProDefaultTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    NSMutableAttributedString *contentStr;
    if (!self.jgjNoManageProSubStrModel) {
        contentStr = [[NSMutableAttributedString alloc] initWithString:self.subTitleLabel.text];
        [contentStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(3, 3)];
        [contentStr addAttribute:NSForegroundColorAttributeName value:JGJMainColor range:NSMakeRange(3, 3)];
    }else{
        contentStr = [[NSMutableAttributedString alloc] initWithString:self.jgjNoManageProSubStrModel.subStr];
        [contentStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:self.jgjNoManageProSubStrModel.subStrRange];
        [contentStr addAttribute:NSForegroundColorAttributeName value:JGJMainColor range:self.jgjNoManageProSubStrModel.subStrRange];
    }
    
    self.subTitleLabel.attributedText = contentStr;
}

- (void)setJgjNoManageProSubStrModel:(JGJNoManageProSubStrModel *)jgjNoManageProSubStrModel {

    _jgjNoManageProSubStrModel = jgjNoManageProSubStrModel;
    NSMutableAttributedString *contentStr;
    contentStr = [[NSMutableAttributedString alloc] initWithString:self.jgjNoManageProSubStrModel.subStr];
    [contentStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:self.jgjNoManageProSubStrModel.subStrRange];
    [contentStr addAttribute:NSForegroundColorAttributeName value:JGJMainColor range:self.jgjNoManageProSubStrModel.subStrRange];
    self.subTitleLabel.attributedText = contentStr;
}

- (IBAction)findProBtnClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(noManageProFindPro:)]) {
        [self.delegate noManageProFindPro:self];
    }
}

@end
