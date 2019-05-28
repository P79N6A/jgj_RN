//
//  JGJQuickCreatChatCell.m
//  mix
//
//  Created by yj on 2018/12/12.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJQuickCreatChatCell.h"

@interface JGJQuickCreatChatCell()

@property (weak, nonatomic) IBOutlet UILabel *group_name;

@property (weak, nonatomic) IBOutlet UIButton *joinBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineLeading;

@end

@implementation JGJQuickCreatChatCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.joinBtn.layer setLayerBorderWithColor:AppFontEB4E4EColor width:0.5 radius:2.5];
    
    self.group_name.font = [UIFont boldSystemFontOfSize:AppFont30Size];
    
    self.group_name.textColor = AppFont000000Color;
    
}

- (void)setChatListModel:(JGJQuickCreatChatListModel *)chatListModel {
    
    _chatListModel = chatListModel;
    
    self.group_name.text = [NSString stringWithFormat:@"%@(%@)",chatListModel.group_name,chatListModel.members_num?:@""];
    
    if (chatListModel.is_exist) {
        
        self.joinBtn.backgroundColor = AppFontccccccColor;
        
        [self.joinBtn setImage:nil forState:UIControlStateNormal];
        
        [self.joinBtn setTitle:@"已加入" forState:UIControlStateNormal];
        
        [self.joinBtn setTitleColor:AppFont666666Color forState:UIControlStateNormal];
        
        [self.joinBtn.layer setLayerBorderWithColor:AppFontccccccColor width:0.5 radius:2.5];
        
    }else {
        
        self.joinBtn.backgroundColor = AppFontffffffColor;
        
        [self.joinBtn setImage:[UIImage imageNamed:@"add_conRecom_icon"] forState:UIControlStateNormal];
        
        [self.joinBtn setTitle:@"加入群聊" forState:UIControlStateNormal];
        
        [self.joinBtn setTitleColor:AppFontEB4E4EColor forState:UIControlStateNormal];
        
        [self.joinBtn.layer setLayerBorderWithColor:AppFontEB4E4EColor width:0.5 radius:2.5];
    }
}


- (IBAction)joinBtnPressed:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(quickCreatChatCell:chatListModel:)]) {
        
        [self.delegate quickCreatChatCell:self chatListModel:self.chatListModel];
        
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
