//
//  JGJChatMsgRecruitCell.m
//  mix
//
//  Created by yj on 2018/8/1.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJChatMsgRecruitCell.h"

@interface JGJChatMsgRecruitCell()

@property (weak, nonatomic) IBOutlet JGJCusYyLable *title;

@property (weak, nonatomic) IBOutlet JGJCusYyLable *des;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkBtnH;

@end

@implementation JGJChatMsgRecruitCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.title.textColor = AppFontF8853FColor;
    
    self.des.textColor = AppFont000000Color;
    
    self.des.numberOfLines = 0;
    
    self.title.numberOfLines = 0;
    
    self.des.font = [UIFont systemFontOfSize:AppFont32Size];
    
    self.title.font = [UIFont systemFontOfSize:AppFont32Size];
}

#pragma mark - 子类使用
- (void)subClassSetWithModel:(JGJChatMsgListModel *)jgjChatListModel{
    
    self.title.text = @"优质工人推荐";
    
    self.des.text = jgjChatListModel.act_des;
    
    [self.des setContent:jgjChatListModel.act_des lineSpace:4];
    
    self.checkBtnH.constant = jgjChatListModel.isHiddenCheckBtn ? 0 : 33;
    
}

//- (vo)

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
