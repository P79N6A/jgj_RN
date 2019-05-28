//
//  JGJChatListBaseVc+SelService.h
//  mix
//
//  Created by yj on 2018/8/24.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJChatListBaseVc.h"

@interface JGJChatListBaseVc (SelService)

//点击头像跳转到他的资料
- (void)handleClickAvatarWithMsgModel:(JGJChatMsgListModel *)msgModel;

//注册修改聊天界面成员名字的通知
- (void)registerAddObserverModifyNameNotify;

@end
