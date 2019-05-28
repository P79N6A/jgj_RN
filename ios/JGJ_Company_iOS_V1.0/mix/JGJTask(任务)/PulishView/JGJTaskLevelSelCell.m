//
//  JGJTaskLevelSelCell.m
//  mix
//
//  Created by yj on 2017/6/5.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJTaskLevelSelCell.h"

@interface JGJTaskLevelSelCell ()

@property (weak, nonatomic) IBOutlet UILabel *levelLable;

@property (weak, nonatomic) IBOutlet UIButton *selButton;

@end

@implementation JGJTaskLevelSelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setTaskLevelSelModel:(JGJTaskLevelSelModel *)taskLevelSelModel {

    _taskLevelSelModel = taskLevelSelModel;
    
    self.levelLable.text = _taskLevelSelModel.levelName;
    
    self.selButton.selected = _taskLevelSelModel.iSLevelSel;
    
    self.levelLable.textColor = _taskLevelSelModel.iSLevelSel ? AppFontd7252cColor : AppFont666666Color;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
