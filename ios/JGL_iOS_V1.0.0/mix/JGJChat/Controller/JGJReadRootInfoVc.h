//
//  JGJReadInfoVc.h
//  mix
//
//  Created by Tony on 2016/9/2.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJChatMsgListModel.h"

@interface JGJReadRootInfoVc : UIViewController

//通知日志、已读、未读成员

@property (nonatomic, assign) BOOL is_readed_notify;

//到当前页面取数据，之前处理的是读了就取数据。这样不好
@property (nonatomic,strong) JGJMyWorkCircleProListModel *workProListModel;

@property (nonatomic,strong) JGJChatMsgListModel *chatMsgListModel;

#pragma mark - 子类使用
- (void)subSetReadInfo:(ChatMsgList_Read_info *)readInfo;
@end
