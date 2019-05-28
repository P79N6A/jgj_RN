//
//  JGJAlreadContactedTableViewCell.m
//  mix
//
//  Created by Tony on 16/4/21.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJAlreadContactedTableViewCell.h"

@interface JGJAlreadContactedTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *showSkillButton;
@property (weak, nonatomic) IBOutlet UIButton *showAppraiseButton;

@end

@implementation JGJAlreadContactedTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.excludeContentH = 94;

    self.prepayLabel.textColor = JGJMainColor;
    self.createTimeLabel.textColor = AppFont999999Color;
    [self.prepayLabel.layer setLayerBorderWithColor:JGJMainColor width:0.5 ration:0.05];
    
    [self.showSkillButton setTitleColor:AppFont333333Color forState:UIControlStateNormal];
    [self.showAppraiseButton setTitleColor:AppFont333333Color forState:UIControlStateNormal];
    [self.showSkillButton.layer setLayerBorderWithColor:AppFont666666Color width:0.5 ration:0.03];
    [self.showAppraiseButton.layer setLayerBorderWithColor:AppFont666666Color width:0.5 ration:0.03];
    self.showAppraiseButton.hidden = YES;
}

- (void)setSubViewBy:(JLGFindProjectModel *)jlgFindProjectModel{
    //是否需要垫资
    self.prepayLabel.hidden = !jlgFindProjectModel.prepay;
    self.createTimeLabel.text = jlgFindProjectModel.create_time_txt;
}

- (IBAction)showBtnClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(AlreadContactedShowSubView:subViewType:)]) {
        [self.delegate AlreadContactedShowSubView:self subViewType:(JGJAlreadContactedSubViewType )sender.tag];
    }
}

@end
