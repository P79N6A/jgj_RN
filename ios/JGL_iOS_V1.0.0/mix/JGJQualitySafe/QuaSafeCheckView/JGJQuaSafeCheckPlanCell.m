//
//  JGJQuaSafeCheckPlanCell.m
//  JGJCompany
//
//  Created by yj on 2017/7/14.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJQuaSafeCheckPlanCell.h"

#import "NSString+Extend.h"

#import "UILabel+GNUtil.h"

@interface JGJQuaSafeCheckPlanCell ()

@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet UILabel *detailLable;

@end

@implementation JGJQuaSafeCheckPlanCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLable.font = [UIFont systemFontOfSize:AppFont32Size];
    
    self.titleLable.textColor = AppFont333333Color;
    
    self.detailLable.font = [UIFont systemFontOfSize:AppFont28Size];
    
    self.detailLable.textColor = AppFont999999Color;
    
    self.lineView.backgroundColor = AppFontf1f1f1Color;
    
    self.titleLable.preferredMaxLayoutWidth = TYGetUIScreenWidth - 55;
}

- (void)setPlanModel:(JGJQuaSafeCheckPlanModel *)planModel {

    _planModel = planModel;
    
    self.titleLable.text = _planModel.inspect_name;
    
    self.detailLable.text  = [NSString stringWithFormat:@"%@ | %@", _planModel.uncheck, _planModel.child_inspect_name];
    
    if (![NSString isEmpty:_planModel.change_color] && ![_planModel.change_color isEqualToString:@"0"]) {
        
        [self.detailLable markText:_planModel.change_color withColor:AppFontEB4E4EColor];
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
