//
//  JGJAddFriendSendMsgRemarkCell.m
//  mix
//
//  Created by YJ on 17/2/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJAddFriendSendMsgRemarkCell.h"

@interface JGJAddFriendSendMsgRemarkCell ()
@property (weak, nonatomic) IBOutlet UILabel *desLable;
@property (weak, nonatomic) IBOutlet UIButton *selectedButton;
@end

@implementation JGJAddFriendSendMsgRemarkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.desLable.textColor = AppFont666666Color;
    self.desLable.font = [UIFont systemFontOfSize:AppFont30Size];
    
    self.desLable.preferredMaxLayoutWidth = TYGetUIScreenWidth - 87;
}

- (void)setSendMsgModel:(JGJAddFriendSendMsgModel *)sendMsgModel {
    _sendMsgModel = sendMsgModel;
    self.desLable.text = sendMsgModel.msg_text;
    self.selectedButton.selected = sendMsgModel.isSelected;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.contentView.backgroundColor = selected ? AppFontE6E6E6Color : [UIColor whiteColor];
    // Configure the view for the selected state
}

@end
