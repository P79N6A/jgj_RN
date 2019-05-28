//
//  JGJContactedListVc.h
//  JGJCompany
//
//  Created by YJ on 16/12/18.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJContactedListVc : UIViewController
@property (assign, nonatomic) BOOL isCheckFreshFriend; //是否点击查看了新朋友

@property (strong, nonatomic, readonly) JGJActiveGroupModel *activeGroupModel;

//首页加载的时候获取聊聊列表
- (void)freshActiveGroupList;

////临时好友数据
//- (void)loadGetTemporaryFriendList;

@property (strong, nonatomic) UIView *freshFriendFlagView; //新朋友标记

@end
