//
//  JGJChatWorkOtherBusinessCardCell.m
//  mix
//
//  Created by ccclear on 2019/3/28.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJChatWorkOtherBusinessCardCell.h"
#import "NSString+Extend.h"
#import "UIButton+JGJUIButton.h"
#import "UILabel+GNUtil.h"
@interface JGJChatWorkOtherBusinessCardCell ()
@property (weak, nonatomic) IBOutlet UIButton *userHeadLogo;

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *firstTag;
@property (weak, nonatomic) IBOutlet UIImageView *sencondTag;
@property (weak, nonatomic) IBOutlet UILabel *userInfoLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userInfoHeight;


@property (weak, nonatomic) IBOutlet UILabel *userAbilityInfo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userAbilityInfoTop;

@end
@implementation JGJChatWorkOtherBusinessCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setChatListModel:(JGJChatMsgListModel *)chatListModel {
    
    _chatListModel = chatListModel;
    // 姓名
    _userName.text = _chatListModel.recruitMsgModel.real_name;
    // 头像
    UIColor *backGroundColor = [NSString modelBackGroundColor:_chatListModel.recruitMsgModel.real_name];
    [self.userHeadLogo setMemberPicButtonWithHeadPicStr:_chatListModel.recruitMsgModel.head_pic memberName:_chatListModel.recruitMsgModel.real_name?:@"" memberPicBackColor:backGroundColor];
    
    // 判断是否实名 是否认证
    if ([self.chatListModel.recruitMsgModel.verified isEqualToString:@"3"]) {// 已实名
        
        self.firstTag.hidden = NO;
        self.firstTag.image = IMAGE(@"chat_noun_logo");
        if (self.chatListModel.recruitMsgModel.group_verified || self.chatListModel.recruitMsgModel.person_verified) {// 已认证
            
            self.sencondTag.hidden = NO;
            self.sencondTag.image = IMAGE(@"chat_verb_logo");
            
        }else {
            
            self.sencondTag.hidden = YES;
        }
    }else {
        
        self.sencondTag.hidden = YES;
        if (self.chatListModel.recruitMsgModel.group_verified || self.chatListModel.recruitMsgModel.person_verified) {// 已认证
            
            self.firstTag.hidden = NO;
            self.firstTag.image = IMAGE(@"chat_verb_logo");
            
        }else {
            
            self.firstTag.hidden = YES;
        }
        
    }
    
    // 信息
    NSMutableString *userInfoString = [NSMutableString string];
    JGJChatRecruitMsgModel *model = self.chatListModel.recruitMsgModel;
    NSMutableArray *textArray = [NSMutableArray array];
    if (![NSString isEmpty:model.nationality]) {
        [userInfoString appendFormat:@"%@",model.nationality];
    }
    if (![NSString isEmpty:model.work_year] && [model.work_year integerValue] > 0) {
        if ([NSString isEmpty:userInfoString]) {
            [userInfoString appendFormat:@"工龄 %@ 年",model.work_year];
        } else {
            [userInfoString appendFormat:@" 工龄 %@ 年",model.work_year];
        }
        [textArray addObject:model.work_year];
    } else {
        [textArray addObject:@" "];
    }
    if (![NSString isEmpty:model.scale] && [model.scale integerValue] > 0) {
        if ([NSString isEmpty:userInfoString]) {
            [userInfoString appendFormat:@"队伍 %@ 人",model.scale];
        } else {
            [userInfoString appendFormat:@" 队伍 %@ 人",model.scale];
        }
        
        [textArray addObject:model.scale];
    } else {
        [textArray addObject:@" "];
    }
    
    if ([NSString isEmpty:userInfoString]) {
        
        self.userInfoHeight.constant = 0;
        self.userAbilityInfoTop.constant = 0;
        
    }else {
        
        self.userInfoHeight.constant = 11;
        self.userAbilityInfoTop.constant = 8;
    }
    self.userInfoLabel.text = userInfoString;
    [self.userInfoLabel markattributedTextArray:textArray color:AppFontEB4E4EColor font:self.userInfoLabel.font isGetAllText:YES];
    
    // 工种
    NSMutableArray *arr = [NSMutableArray array];
    NSMutableArray *setArr = [NSMutableArray array];
    [arr addObjectsFromArray:self.chatListModel.recruitMsgModel.worker_info.work_type];
    [arr addObjectsFromArray:self.chatListModel.recruitMsgModel.foreman_info.work_type];
    for (NSString *type in arr) {
        
        if (![setArr containsObject:type]) {
            
            [setArr addObject:type];
        }
    }
    
    if (setArr.count > 0) {
        
        self.userAbilityInfo.text = [setArr componentsJoinedByString:@"|"];
    }
}

@end
