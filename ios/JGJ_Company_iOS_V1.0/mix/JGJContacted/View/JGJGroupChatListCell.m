//
//  JGJGroupChatListCell.m
//  mix
//
//  Created by YJ on 16/12/20.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJGroupChatListCell.h"
#import "TYAvatarGroupImageView.h"
#import "UILabel+GNUtil.h"
#import "NSString+Extend.h"
#import "JGJHeadView.h"

#import "JGJAvatarView.h"

@interface JGJGroupChatListCell ()
@property (weak, nonatomic) IBOutlet JGJAvatarView *avatarGroupImageView;
@property (weak, nonatomic) IBOutlet UILabel *groupChatNameLable;
@end
@implementation JGJGroupChatListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.groupChatNameLable.textColor = AppFont333333Color;
}
+ (CGFloat)JGJGroupChatListCellHeight {
    return 70.0;
}
- (void)setGroupListModel:(JGJMyWorkCircleProListModel *)groupListModel {
    _groupListModel = groupListModel;

//    JGJHeadView *head = [[JGJHeadView alloc]initWithFrame:CGRectMake(0, 0, 51, 51) withframe:groupListModel.members_head_pic];
//    [self.avatarGroupImageView addSubview:head];
    
    [self.avatarGroupImageView getRectImgView:groupListModel.members_head_pic];
    
    NSString *groupMemberNum = [NSString stringWithFormat:@"(%@)", _groupListModel.members_num];
    self.groupChatNameLable.text = [NSString stringWithFormat:@"%@ %@", _groupListModel.group_name?:@"", groupMemberNum];
    [self.groupChatNameLable markText:groupMemberNum withColor:AppFont999999Color];
    if (self.chatType != JGJSingleChatType) { //发起群聊能多选人数时不显示数量
        self.groupChatNameLable.text = _groupListModel.group_name?:@"";
    }
    if (![NSString isEmpty:self.searchValue]) {
        [self.groupChatNameLable markattributedTextArray:@[self.searchValue] color:AppFontEF272FColor font:self.groupChatNameLable.font isGetAllText:YES];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
