//
//  JGJCheckProListCell.m
//  mix
//
//  Created by YJ on 17/4/22.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJCheckProListCell.h"

#import "UILabel+GNUtil.h"

#import "NSString+Extend.h"

@interface JGJCheckProListCell ()
@property (weak, nonatomic) IBOutlet UILabel *proNameLable;

@property (weak, nonatomic) IBOutlet UIView *msgFlagView;

@property (weak, nonatomic) IBOutlet UIButton *selProFagBtn;

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selProFlagBtnW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hightLevelButtonW;

@property (weak, nonatomic) IBOutlet UIButton *hightLevelButton;

@property (weak, nonatomic) IBOutlet UIView *topLineView;

@property (weak, nonatomic) IBOutlet UILabel *groupDes;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *groupDesW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *groupDesTrail;


@end

@implementation JGJCheckProListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.proNameLable.font = [UIFont systemFontOfSize:AppFont30Size];
    self.proNameLable.textColor = AppFont333333Color;
    [self.msgFlagView.layer setLayerCornerRadius:TYGetViewH(self.msgFlagView) / 2.0];
    self.msgFlagView.backgroundColor = TYColorHex(0xFF0000);

    [self.selProFagBtn setImage:[UIImage imageNamed:@"proType_selected"] forState:UIControlStateSelected];
    
    self.lineView.backgroundColor = AppFontf1f1f1Color;
    
    self.topLineView.backgroundColor = AppFontf1f1f1Color;
    
    self.proNameLable.preferredMaxLayoutWidth = TYGetUIScreenWidth - 97.0;
    
    self.groupDes.textColor = AppFont999999Color;
    
    self.groupDes.font = [UIFont systemFontOfSize:AppFont26Size];
}

- (void)setProListModel:(JGJMyWorkCircleProListModel *)proListModel {

    _proListModel = proListModel;
    
    BOOL isMySelfGroup = [proListModel.myself_group isEqualToString:@"1"];
    
    NSString *myGroupFlagStr = @"";
    
    NSString *class_type = [proListModel.class_type isEqualToString:@"group"] ? @"班组" : @"项目";
    
    if (isMySelfGroup) {
        
        myGroupFlagStr = [NSString stringWithFormat:@"(我创建的)%@",class_type];
        
    }
    
    self.groupDes.text = myGroupFlagStr;
    
//    self.proNameLable.text = [NSString stringWithFormat:@"%@ %@", proListModel.group_name, myGroupFlagStr];
    
    self.proNameLable.text = proListModel.group_name;
    
    self.proNameLable.textColor = proListModel.is_selected ? AppFontEB4E4EColor : AppFont333333Color;
    
//    [self.proNameLable markText:myGroupFlagStr withFont:[UIFont systemFontOfSize:AppFont26Size] color:AppFont999999Color];
    
    self.selProFagBtn.selected = proListModel.is_selected;
    
    BOOL isUnReadedMsg = ![proListModel.unread_msg_count isEqualToString:@"0"] ;

    self.msgFlagView.hidden = !isUnReadedMsg || [NSString isEmpty:proListModel.unread_msg_count];
    
    self.hightLevelButtonW.constant = 0;
    
}

- (void)setGroupListModel:(JGJChatGroupListModel *)groupListModel {
    
    _groupListModel = groupListModel;
    
    NSString *user_id = [TYUserDefaults objectForKey:JLGUserUid];
    BOOL isMySelfGroup = [_groupListModel.creater_uid isEqualToString:user_id];
    
    NSString *class_type = [_groupListModel.class_type isEqualToString:@"group"] ? @"班组" : @"项目";
    
    NSString *myGroupFlagStr = @"";
    
    self.groupDesW.constant = 90;
    
    if (isMySelfGroup) {
        
        myGroupFlagStr = [NSString stringWithFormat:@"(我创建的%@)",class_type];
        
    }else {
        
        self.groupDesW.constant = 0;
    }
    
    self.groupDes.text = myGroupFlagStr;
    
//    self.proNameLable.text = [NSString stringWithFormat:@"%@ %@", _groupListModel.group_name, myGroupFlagStr];
    
    self.proNameLable.text = _groupListModel.group_name;
    
    self.proNameLable.textColor = _groupListModel.is_selected ? AppFontEB4E4EColor : AppFont333333Color;
    
//    [self.proNameLable markText:myGroupFlagStr withFont:[UIFont systemFontOfSize:AppFont26Size] color:AppFont999999Color];
    
    self.selProFagBtn.selected = _groupListModel.is_selected;
    
    BOOL isUnReadedMsg = ![_groupListModel.chat_unread_msg_count isEqualToString:@"0"] ;
    
    self.msgFlagView.hidden = !isUnReadedMsg || [NSString isEmpty:_groupListModel.chat_unread_msg_count];
    
    self.hightLevelButtonW.constant = 0;
    
    [self setSubViewConstantWithGroupListModel:groupListModel];
    
}

- (void)setSubViewConstantWithGroupListModel:(JGJChatGroupListModel *)groupListModel {
    
    BOOL isUnReadedMsg = ![groupListModel.chat_unread_msg_count isEqualToString:@"0"] ;
    
    BOOL is_readed_msg = !isUnReadedMsg || [NSString isEmpty:groupListModel.chat_unread_msg_count];
    
    NSString *user_id = [TYUserDefaults objectForKey:JLGUserUid];
    
    BOOL isMySelfGroup = [groupListModel.creater_uid isEqualToString:user_id];
    
    if (isMySelfGroup && is_readed_msg) { //我创建的、全部已读
        
        self.groupDesW.constant = 90;
        
        self.groupDesTrail.constant = 10;
        
    }else if (isMySelfGroup && !is_readed_msg) { //我创建的、有未读消息
        
        self.groupDesW.constant = 90;
        
        self.groupDesTrail.constant = 28;
        
    }else if (!isMySelfGroup && !is_readed_msg) { //不是我创建的、有未读消息
        
        self.groupDesW.constant = 0;
        
        self.groupDesTrail.constant = 28;
        
    }else if (!isMySelfGroup && is_readed_msg) { //不是我创建的、全部已读
        self.groupDesW.constant = 0;
        
        self.groupDesTrail.constant = 0;
    }
    
}


@end
