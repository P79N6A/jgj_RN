//
//  JGJMyChatGroupsVc+chatWorkReplyAction.h
//  mix
//
//  Created by yj on 2019/3/6.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJMyChatGroupsVc.h"

typedef enum : NSUInteger {
    
    JGJMyChatGroupsChatDefaultType, //默认类型
    
    JGJMyChatGroupsChatActionType, //聊天按钮行为
    
    JGJMyChatGroupsWorkReplyActionType, //工作回复按钮按下
    
    JGJMyChatGroupsSwitchGroupsActionType, //切换项目
    
    JGJMyChatGroupsQRSweepActionType, //扫一扫
    
    JGJMyChatGroupsCreatGroupActionType, //新建班组
    
} JGJMyChatGroupsActionType;

NS_ASSUME_NONNULL_BEGIN

@interface JGJMyChatGroupsVc (chatWorkReplyAction)

//按钮点击事件(扫一扫、工作回复、聊天请求)

- (void)handleButtonPressed:(JGJMyChatGroupsActionType)actionType;

//创建rightItem
- (void)creatRightItem;

@end

NS_ASSUME_NONNULL_END
