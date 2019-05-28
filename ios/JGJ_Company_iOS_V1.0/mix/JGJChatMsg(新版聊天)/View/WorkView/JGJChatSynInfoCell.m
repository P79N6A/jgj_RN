//
//  JGJChatAskSynCell.m
//  mix
//
//  Created by yj on 2018/7/31.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJChatSynInfoCell.h"

#import "JGJChatSynBottomBtnView.h"

#import "JGJCusYyLable.h"

@interface JGJChatSynInfoCell()

@property (weak, nonatomic) IBOutlet JGJCusYyLable *title;

@property (weak, nonatomic) IBOutlet JGJCusYyLable *des;

@property (weak, nonatomic) IBOutlet JGJChatSynBottomBtnView *containBtnView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containBtnViewHieght;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *desContentHeight;

@end

@implementation JGJChatSynInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.title.textColor = AppFontF8853FColor;
    
    self.des.textColor = AppFont000000Color;
    
    self.des.numberOfLines = 0;
    
    self.title.numberOfLines = 0;
    
    self.des.font = [UIFont systemFontOfSize:AppFont32Size];
    
    self.title.font = [UIFont systemFontOfSize:AppFont32Size];

    TYWeakSelf(self);
    
    self.containBtnView.actionBlock = ^(JGJChatSynBtnType type, JGJChatMsgListModel *jgjChatListModel) {
      
        [weakself btnPressedWithType:type jgjChatListModel:jgjChatListModel];
    };
}

- (void)btnPressedWithType:(JGJChatSynBtnType)type jgjChatListModel:(JGJChatMsgListModel *)jgjChatListModel {
    
    if ([self.delegate respondsToSelector:@selector(chatSynInfoWithBtnType: jgjChatListModel:)]) {
        
        [self.delegate chatSynInfoWithBtnType:type jgjChatListModel:jgjChatListModel];
    }
    
}

- (void)setMsgModel:(JGJChatMsgListModel *)msgModel {
    
    _msgModel = msgModel;
}

#pragma mark - 子类使用
- (void)subClassSetWithModel:(JGJChatMsgListModel *)jgjChatListModel{
    
    self.title.text = jgjChatListModel.title;
    
    self.des.attributedText = jgjChatListModel.htmlStr;
    self.des.userInteractionEnabled = NO;
    self.des.numberOfLines = 0;
    self.des.font = FONT(AppFont32Size);
    self.containBtnView.jgjChatListModel = jgjChatListModel;
    
    CGFloat height =  [self.des.attributedText boundingRectWithSize:CGSizeMake(TYGetUIScreenWidth - 70 - 78, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height + 15;
    
    self.desContentHeight.constant = height;
    self.titleHeight.constant = 25;
    if (jgjChatListModel.chatListType == JGJChatListDemandSyncProjectType || jgjChatListModel.chatListType == JGJChatListDemandSyncBillType || jgjChatListModel.chatListType == JGJChatListSyncProjectToYouType || jgjChatListModel.chatListType == JGJChatListSyncBillToYouType || jgjChatListModel.chatListType == JGJChatListagreeSyncBillType || jgjChatListModel.chatListType == JGJChatListAgreeSyncProjectType || jgjChatListModel.chatListType == JGJChatListAgreeSyncProjectToYouType) {
        
        self.containBtnView.hidden = NO;
        self.containBtnViewHieght.constant = 25;
    }else {
        
        self.containBtnView.hidden = YES;
        self.containBtnViewHieght.constant = 0;
    }
}

@end
