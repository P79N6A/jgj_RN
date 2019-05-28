//
//  JGJMemberAppraiseListCell.m
//  mix
//
//  Created by yj on 2018/4/18.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJMemberAppraiseListCell.h"

#import "UIButton+JGJUIButton.h"

#import "UILabel+GNUtil.h"

@interface JGJMemberAppraiseListCell ()

@property (weak, nonatomic) IBOutlet UIButton *headButton;

@property (weak, nonatomic) IBOutlet UILabel *nameDesLable;

@property (weak, nonatomic) IBOutlet UILabel *desLable;

@end

@implementation JGJMemberAppraiseListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.nameDesLable.textColor = AppFont666666Color;
    
    self.nameDesLable.font = [UIFont systemFontOfSize:AppFont28Size];
    
    self.desLable.textColor = AppFont333333Color;
    
    self.desLable.font = [UIFont systemFontOfSize:AppFont28Size];
    
    [self.headButton.layer setLayerCornerRadius:5.0];
    
    self.desLable.preferredMaxLayoutWidth = TYGetUIScreenWidth - 65;
}

- (void)setEvaModel:(JGJMemberEvaListModel *)evaModel {
    
    _evaModel = evaModel;
    
    [self.headButton setMemberPicButtonWithHeadPicStr:evaModel.user_info.head_pic memberName:evaModel.user_info.real_name memberPicBackColor:evaModel.user_info.modelBackGroundColor membertelephone:evaModel.user_info.telephone];
    
    self.headButton.titleLabel.font = [UIFont systemFontOfSize:AppFont30Size];
    
    self.nameDesLable.text = [NSString stringWithFormat:@"%@  %@", evaModel.user_info.real_name, evaModel.pub_date];
    
    if (![NSString isEmpty:evaModel.pub_date]) {
        
        [self.nameDesLable markText:evaModel.pub_date withFont:[UIFont systemFontOfSize:AppFont24Size] color:AppFont999999Color];
    }
    
    self.desLable.text = evaModel.content;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
