//
//  JGJCommonTitleCell.m
//  mix
//
//  Created by yj on 2018/1/11.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJCommonTitleCell.h"

#import "JGJCustomLable.h"

@interface JGJCommonTitleCell ()

@property (weak, nonatomic) IBOutlet JGJCustomLable *titleLable;

@end

@implementation JGJCommonTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLable.textColor = AppFont333333Color;
    
}

- (void)setDesModel:(JGJCreatTeamModel *)desModel {
    
    _desModel = desModel;
    
    self.titleLable.text = desModel.title;
    
}

- (void)setTextInsets:(UIEdgeInsets)textInsets {
    
    _textInsets = textInsets;
    
    self.titleLable.textInsets = textInsets;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
