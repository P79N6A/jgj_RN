//
//  JGJSelSynMemberCell.m
//  mix
//
//  Created by yj on 2018/4/16.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJSelSynMemberCell.h"

@implementation JGJSelSynMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //隐藏姓名子类使用
    [self setHiddenMemberTel];
}

#pragma mark - 隐藏姓名子类使用
- (void)setHiddenMemberTel {
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
