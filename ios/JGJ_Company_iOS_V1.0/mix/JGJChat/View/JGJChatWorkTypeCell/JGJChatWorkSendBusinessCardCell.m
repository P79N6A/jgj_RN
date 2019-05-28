//
//  JGJChatWorkSendBusinessCardCell.m
//  mix
//
//  Created by ccclear on 2019/3/28.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJChatWorkSendBusinessCardCell.h"
#import "NSString+Extend.h"
#import "UIButton+JGJUIButton.h"
#import "UILabel+GNUtil.h"

@interface JGJChatWorkSendBusinessCardCell ()
@property (weak, nonatomic) IBOutlet UIView *businessCardInfoView;
@property (weak, nonatomic) IBOutlet UIButton *sendBusinessCard;
@property (weak, nonatomic) IBOutlet UIButton *userImage;// 名片头像
@property (weak, nonatomic) IBOutlet UILabel *userName;// 名片姓名
@property (weak, nonatomic) IBOutlet UILabel *userInfoLabel;// 个人信息
@property (weak, nonatomic) IBOutlet UILabel *userAbilityInfo;// 个人能力
@property (weak, nonatomic) IBOutlet UIImageView *isRealNameSymbol;// 是否实名
@property (weak, nonatomic) IBOutlet UIImageView *isVerbSymbol;// 是否认证
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *businesCardInfoViewH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verbInfoViewTopConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verbInfoViewH;

@property (weak, nonatomic) IBOutlet UIView *verbInfoView;

@end
@implementation JGJChatWorkSendBusinessCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    _businessCardInfoView.clipsToBounds = YES;
    _businessCardInfoView.layer.cornerRadius = 10;
    
    _sendBusinessCard.clipsToBounds = YES;
    _sendBusinessCard.layer.cornerRadius = 2;
    
    self.sendBusinessCard.userInteractionEnabled = YES;
    [self.sendBusinessCard addTarget:self action:@selector(sendBusinessClick) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)setChatListModel:(JGJChatMsgListModel *)chatListModel {
    
    _chatListModel = chatListModel;
    // 姓名
    _userName.text = _chatListModel.recruitMsgModel.real_name;
    
    // 头像
    UIColor *backGroundColor = [NSString modelBackGroundColor:_chatListModel.recruitMsgModel.real_name];
    [self.userImage setMemberPicButtonWithHeadPicStr:_chatListModel.recruitMsgModel.head_pic memberName:_chatListModel.recruitMsgModel.real_name?:@"" memberPicBackColor:backGroundColor];
    
    // 判断是否实名 是否认证
    if ([self.chatListModel.recruitMsgModel.verified isEqualToString:@"3"]) {// 已实名认证
        
        self.isRealNameSymbol.hidden = NO;
        self.isRealNameSymbol.image = IMAGE(@"chat_noun_logo");
        if (self.chatListModel.recruitMsgModel.group_verified || self.chatListModel.recruitMsgModel.person_verified) {// 已认证
            
            self.isVerbSymbol.hidden = NO;
            self.isVerbSymbol.image = IMAGE(@"chat_verb_logo");
            
        }else {
            
            self.isVerbSymbol.hidden = YES;
        }
    }else {
        
        self.isVerbSymbol.hidden = YES;
        if (self.chatListModel.recruitMsgModel.group_verified || self.chatListModel.recruitMsgModel.person_verified) {// 已认证
            
            self.isRealNameSymbol.hidden = NO;
            self.isRealNameSymbol.image = IMAGE(@"chat_verb_logo");
            
        }else {
            
            self.isRealNameSymbol.hidden = YES;
        }
        
    }
    
    
    // 信息
    self.userInfoLabel.text = [NSString stringWithFormat:@"%@ 工龄 %@ 年 队伍 %@人",self.chatListModel.recruitMsgModel.nationality,self.chatListModel.recruitMsgModel.work_year,self.chatListModel.recruitMsgModel.scale];
    [self.userInfoLabel markattributedTextArray:@[self.chatListModel.recruitMsgModel.work_year,self.chatListModel.recruitMsgModel.scale] color:AppFontEB4E4EColor];
    
    // 工种
    NSSet *set = [NSSet setWithObjects:self.chatListModel.recruitMsgModel.worker_info.work_type,self.chatListModel.recruitMsgModel.foreman_info.work_type, nil];
    NSMutableArray *arr = [NSMutableArray array];
    
    for (NSArray *setArr in set.allObjects) {
    
        if (setArr.count > 0) {
            
            [arr addObjectsFromArray:setArr];
        }
        
    }
    if (arr.count > 0) {
        
        self.userAbilityInfo.text = [arr componentsJoinedByString:@"|"];
    }
    
    // 验证是否实名 隐藏和显示底部信息
    if ([self.chatListModel.recruitMsgModel.verified isEqualToString:@"3"]) {// 已实名认证
        
        self.verbInfoView.hidden = YES;
        self.verbInfoViewH.constant = 0;
        self.verbInfoViewTopConstraint.constant = 0;
        if (_chatListModel.is_send_success) {
            
            self.businessCardInfoView.hidden = YES;
            self.businesCardInfoViewH.constant = 0;
            
        }else {
            
            self.businessCardInfoView.hidden = NO;
            self.businesCardInfoViewH.constant = 103;
        }
        
    }else {
        
        self.verbInfoView.hidden = NO;
        self.verbInfoViewH.constant = 45;
        
        if (_chatListModel.is_send_success) {
            
            self.businessCardInfoView.hidden = YES;
            self.businesCardInfoViewH.constant = 0;
            self.verbInfoViewTopConstraint.constant = 11;
            
        }else {
            
            self.businessCardInfoView.hidden = NO;
            self.businesCardInfoViewH.constant = 103;
            self.verbInfoViewTopConstraint.constant = 46;
        }
    }
    
    
}

- (void)sendBusinessClick {
    
    if ([self.delegate respondsToSelector:@selector(sendBusinessCardMsgWithChatListModel:cell:)]) {
        
        [self.delegate sendBusinessCardMsgWithChatListModel:self.chatListModel cell:self];
    }
}
- (IBAction)gotoRealNameAuthentication:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(gotoRealNameAuthenticationWithChatListModel:cell:)]) {
        
        [self.delegate gotoRealNameAuthenticationWithChatListModel:self.chatListModel cell:self];
    }
}

@end
