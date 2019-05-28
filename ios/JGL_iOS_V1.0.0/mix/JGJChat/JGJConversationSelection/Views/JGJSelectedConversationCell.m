//
//  JGJSelectedConversationCell.m
//  mix
//
//  Created by Json on 2019/3/26.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJSelectedConversationCell.h"
#import "JGJAvatarView.h"
#import "JGJChatGroupListModel.h"
#import "UILabel+GNUtil.h"

static CGFloat const checkViewWidth = 20.0f;
static CGFloat const avatarViewLeftMargin = 5.0f;
static CGFloat const numberLabelTopMargin = 5.0f;

@interface JGJSelectedConversationCell ()
@property (weak, nonatomic) IBOutlet UIImageView *checkImgView;
@property (weak, nonatomic) IBOutlet JGJAvatarView *avatarView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarViewLeftMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numberLabelTopMargin;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end
@implementation JGJSelectedConversationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.checkImgView.image = [UIImage imageNamed:@"EllipseIcon"];
    self.lineView.backgroundColor = AppFontdbdbdbColor;
    
    self.nameLabel.textColor = AppFont333333Color;
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    
    self.numberLabel.textColor = AppFont333333Color;
    self.numberLabel.font = [UIFont systemFontOfSize:12];
    
    self.checkViewWidth.constant = 0.0;
    self.avatarViewLeftMargin.constant = 0.0;
    self.numberLabelTopMargin.constant = numberLabelTopMargin;
    
    self.avatarView.fontSizeRatio = 0.7;
    
    
    
}

- (void)setEdited:(BOOL)edited
{
    if (_edited == edited) return;
    
    _edited = edited;
    self.checkViewWidth.constant = edited ? checkViewWidth : 0;
    self.avatarViewLeftMargin.constant = edited ? avatarViewLeftMargin : 0;
    [UIView animateWithDuration:0.1 animations:^{
        [self layoutIfNeeded];
    }];

}

- (void)setConversation:(JGJChatGroupListModel *)conversation {
    _conversation = conversation;
    
    NSString *imageName = conversation.is_selected ? @"MultiSelected":@"EllipseIcon";
    self.checkImgView.image = [UIImage imageNamed:imageName];

    // 聊聊名字
    self.nameLabel.text = conversation.group_name;
    
    // 头像
    if ([conversation.class_type isEqualToString:@"work"]) {
        
        [self.avatarView getRectImgView:nil];
        [self.avatarView setImage:IMAGE(@"working_inner_type")];
        
    }else if ([conversation.class_type isEqualToString:@"activity"]) {
        
        [self.avatarView getRectImgView:nil];
        [self.avatarView setImage:IMAGE(@"messagetype_activity")];
        
    }else if ([conversation.class_type isEqualToString:@"recruit"]) {
        
        [self.avatarView getRectImgView:nil];
        [self.avatarView setImage:IMAGE(@"messagetype_recruit")];
        
    }else if ([conversation.class_type isEqualToString:@"newFriends"]) {
        
        [self.avatarView getRectImgView:nil];
        [self.avatarView setImage:IMAGE(@"contactListNewFriend")];
        
    }else {
        
        [self.avatarView setImage:nil];
        [self.avatarView getRectImgView:[conversation.local_head_pic mj_JSONObject]];
    }
    
    //成员数
    NSString *memberNumstr = [NSString stringWithFormat:@"%@人",conversation.members_num];
    if ([conversation.class_type isEqualToString:@"singleChat"] || [conversation.class_type isEqualToString:@"work"] || [conversation.class_type isEqualToString:@"activity"] || [conversation.class_type isEqualToString:@"recruit"] || [conversation.class_type isEqualToString:@"newFriends"]) {
        memberNumstr = @"";
    }
    self.numberLabel.text = memberNumstr;
    self.numberLabelTopMargin.constant = (memberNumstr.length == 0) ? 0 : numberLabelTopMargin;
    
    NSString *keyword = [NSString isEmpty:self.searchKeyword] ? @" " : self.searchKeyword;
    
    [self.nameLabel markattributedTextArray:@[keyword] color:AppFontEB4E4EColor font:self.nameLabel.font isGetAllText:YES];
}


@end
