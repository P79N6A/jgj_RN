//
//  JGJCheckPlanPeopleTableViewCell.m
//  JGJCompany
//
//  Created by Tony on 2017/11/22.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJCheckPlanPeopleTableViewCell.h"

#import "UILabel+GNUtil.h"
@implementation JGJCheckPlanPeopleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.baseView.backgroundColor = AppFontf1f1f1Color;
    [_titleLable markText:@"(点击头像可删除)" withColor:AppFont999999Color];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
