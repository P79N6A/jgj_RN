//
//  JGJChatWorkAuthTypeCell.m
//  mix
//
//  Created by ccclear on 2019/3/29.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJChatWorkAuthTypeCell.h"
#import "UILabel+GNUtil.h"
@interface JGJChatWorkAuthTypeCell ()

@property (weak, nonatomic) IBOutlet UILabel *userAuthInfo;

@end
@implementation JGJChatWorkAuthTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _userAuthInfo.textColor = AppFont666666Color;
}

- (void)setChatListModel:(JGJChatMsgListModel *)chatListModel {
    
    _chatListModel = chatListModel;
    
    _userAuthInfo.text = [NSString stringWithFormat:@"%@ 未实名认证",_chatListModel.user_name?:nil];
    
    [_userAuthInfo markattributedTextArray:@[_chatListModel.user_name ?: @""] color:AppFontFF6600Color];
    
}
@end
