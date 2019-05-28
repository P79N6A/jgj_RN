//
//  JGJBaseMyMsgView.m
//  mix
//
//  Created by yj on 2018/7/30.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJBaseMyMsgView.h"

#import "UIView+GNUtil.h"

@implementation JGJBaseMyMsgView

#pragma mark - 子类使用
- (void)setSubViewsUIFrame:(JGJChatMsgListModel *)jgjChatListModel{
    
    CGFloat padding = ChatPadding;
    
    self.headBtn.frame = CGRectMake(TYGetUIScreenWidth - ChatHeadWH - padding, padding, ChatHeadWH, ChatHeadWH);
    
    CGFloat topTimeViewW = 200;
    
    self.topTimeView.frame = CGRectMake(TYGetUIScreenWidth - topTimeViewW - ChatHeadWH - padding * 2, TYGetMinY(self.headBtn), topTimeViewW, 14);
    
    self.containView.frame = CGRectMake(TYGetUIScreenWidth - ChatHeadWH - padding - jgjChatListModel.cellWidth - 4 , PopViewY, jgjChatListModel.cellWidth, jgjChatListModel.workCellHeight - 38);
    
    self.popImageView.frame = CGRectMake(0 , 0, jgjChatListModel.cellWidth, jgjChatListModel.workCellHeight - 38);
    
    self.contentLabel.frame = CGRectMake(self.popImageView.x + 10, TYGetMinY(self.popImageView) + 3, jgjChatListModel.cellWidth - 30, jgjChatListModel.workCellHeight - 45);

    self.headBtn.titleLabel.font = [UIFont systemFontOfSize:AppFont24Size];
    
    CGFloat statusViewWH = 18.0;
    
    self.indicatorView.frame = CGRectMake(TYGetMinX(self.containView) - 3 * padding, (jgjChatListModel.workCellHeight) / 2.0, statusViewWH, statusViewWH);
    
    self.sendFailureImageView.frame = self.indicatorView.frame;
    
}

@end
