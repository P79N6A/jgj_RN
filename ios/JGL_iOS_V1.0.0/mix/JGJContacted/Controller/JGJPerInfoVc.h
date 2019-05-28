//
//  JGJPerInfoVc.h
//  mix
//
//  Created by yj on 16/12/19.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJChatMsgListModel.h"

typedef void(^ModifyUserInfoBlock)(JGJChatPerInfoModel *perInfoModel);

typedef void(^CallHandelPerInfoBlock)(JGJChatPerInfoModel *perInfoModel);

@interface JGJPerInfoVc : UIViewController

@property (nonatomic,strong) JGJMyWorkCircleProListModel *workProListModel;

@property (nonatomic,strong) JGJChatMsgListModel *jgjChatListModel;

@property (nonatomic, copy) ModifyUserInfoBlock modifyUserInfoBlock;

/** 添加好友时发送的验证信息 */
@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) JGJFriendListMsgType status;

//回调用户信息

@property (nonatomic, copy) CallHandelPerInfoBlock callHandelPerInfoBlock;


@end
