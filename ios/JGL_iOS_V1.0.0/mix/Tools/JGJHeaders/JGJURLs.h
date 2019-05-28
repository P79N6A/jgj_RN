//
//  JGJURLs.h
//  mix
//
//  Created by yj on 2018/9/5.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#ifndef JGJURLs_h
#define JGJURLs_h

//修改用户备注

#define JGJModifyCommentNameURL     @"user/modify-comment-name"

//退出班组
#define JGJQuitMembersURL           @"group/quit-members"

//添加成员

#define JGJAddMembersURL            @"group/add-members"


//项目成员chat/get-chat-member-info

#define JGJGetMembersListURL        @"group/get-members-list"

//删除成员
#define JGJGroupDelMemberURL        @"group/del-member"

//关闭班组
#define JGJCloseGroupURL           @"group/close-group"

//删除班组
#define JGJDelGroupURL           @"group/del-group"

//管理员列表
#define JGJAdminListURL           @"chat/get-admin-list"

//设置管理员
#define JGJHandleAdminURL           @"chat/handle-admin"

//转让管理权限
#define JGJSwitchManagerURL           @"group/switch-manager"

//设置修改
#define JGJGroupModifyURL           @"group/group-modify"

//设置详情
#define JGJGetGroupInfoURL           @"group/get-group-info"

//管理员列表
#define JGJOperMembersListURL           @"chat/oper-members-list"

//好友列表
#define JGJGetFriendsListURL           @"chat/get-friends-list"

//创建群聊
#define JGJCreateChatURL                          @"group/create-chat"

//删除好友
#define JGJGroupDelFriendURL        @"group/del-friend"

//删除成员
#define JGJGroupDelMembersURL     @"group/del-members"

//删除成员
#define JGJGroupDelSourceMembersURL     @"group/del-source-member"

//添加数据来源人
#define JGJGroupAddSourceMemberURL    @"group/add-source-member"

//扫码加入班组查看信息
#define JGJCreateQrcodeURL                      @"group/create-qrcode"

//获取同步项目列表

#define JGJGroupSyncproFromSourceListURL          @"group/syncpro-from-source-list"

//移除同步源
#define JGJGroupRemoveSyncSourceURL             @"group/remove-sync-source"

//关闭同步项目
#define JGJGroupCloseSyncURL                    @"group/closeSync"

//通讯录接口
#define JGJChatGetMemberTelephoneURL      @"chat/get-member-telephone"

//面对面建群
#define JGJGroupFaceToFaceURL              @"group/face-to-face"


//消息接收人

#define JGJGroupMembersByMessage       @"chat/get-group-members-by-message"

//通知、日志详情已读未读

#define JGJNotifyReadedMembersByMessage       @"chat/get-type-members-by-message"

//新朋友
#define JGJChatAddFriendsListURL        @"chat/add-friends-list"

//黑名单
#define JGJChatGetBlackListURL          @"chat/get-black-list"

//获取临时好友
#define JGJGetTemporaryFriendList       @"chat/get-temporary-friend-list"

#endif /* JGJURLs_h */
