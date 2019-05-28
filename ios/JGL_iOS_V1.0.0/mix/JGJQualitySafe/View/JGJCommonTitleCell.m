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

@property (weak, nonatomic) IBOutlet JGJCustomLable *title;

@end

@implementation JGJCommonTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.title.textColor = AppFont333333Color;
    
    self.lineView.hidden = YES;
}

- (void)setDesModel:(JGJCreatTeamModel *)desModel {
    
    _desModel = desModel;
    
    self.title.text = desModel.title;
    
}

- (void)setTextInsets:(UIEdgeInsets)textInsets {
    
    _textInsets = textInsets;
    
    self.title.textInsets = textInsets;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
