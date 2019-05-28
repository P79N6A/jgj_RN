//
//  JGJChatMsgDBManger+JGJGroupDB.h
//  mix
//
//  Created by yj on 2018/8/15.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJChatMsgDBManger.h"
#import "JGJChatGroupListModel.h"
#import "JGJChatMsgListModel.h"
@interface JGJChatMsgDBManger (JGJGroupDB)

// 插入单条数据
+ (BOOL)insertToChatGroupListTableWithJGJChatMsgListModel:(JGJChatGroupListModel *)model;

// 插入聊聊列表数据但不更新最后发送的消息
+ (BOOL)insertToChatGroupListTableWithJGJChatMsgListModelNotUpdateNewestChatMsg:(JGJChatGroupListModel *)model;
+ (BOOL)insertToChatGroupListTableWithJGJChatMsgListWork_ActivityModelNotUpdateNewestChatMsg:(JGJChatGroupListModel *)model;
+ (BOOL)insertToChatGroupListTableWithNewestJGJChatMsgListModel:(JGJChatGroupListModel *)model;
// 发送\收到消息成功后，更新聊聊列表数据
+ (BOOL)insertToChatGroupListTableAfterSendMessageSuccessWithGroupListModel:(JGJChatGroupListModel *)model;
+ (BOOL)updateChatGroupListTableAfterSendMessageSuccessWithGroupListModel:(JGJChatGroupListModel *)model;

/**
 *
 *更新聊聊列表的 活动 招聘类消息
 *
 */
+ (BOOL)updateChatGroupListTableNotWithNewestActivity_RecruitChatMsgModel:(JGJChatGroupListModel *)model;

/**
 *
 *更新聊聊列表的 工作类型消息未读数
 *
 */
+ (BOOL)updateChatGroupListTableTheUnread_work_countWithGroupListModel:(JGJChatGroupListModel *)model group_id:(NSString *)group_id class_type:(NSString *)class_type;

+ (BOOL)updateChatGroupListTableTheUnread_work_countWithGroupListModel:(JGJChatGroupListModel *)model group_id:(NSString *)group_id class_type:(NSString *)class_type chatListType:(JGJChatListType)chatListType;

/**
 *
 *更新聊聊列表的 工作回复消息数
 *
 */
+ (BOOL)updateChatGroupListTableTheWork_Replay_countWithCount:(NSString *)count group_id:(NSString *)group_id class_type:(NSString *)class_type;

// 更新数据
+ (BOOL)updateChatGroupListTableWithJGJChatMsgListModel:(JGJChatGroupListModel *)model;
/**
 *
 *  更新  max_readed_msg_id数据
 *
 **/
+ (BOOL)updateMax_Readed_Msg_IdInGroupTableWithGroup_id:(NSString *)group_id class_type:(NSString *)class_type msg_id:(NSString *)msg_id;

/**
 *
 *  更新  max_asked_msg_id数据
 *
 **/
+ (BOOL)updateMax_Asked_Msg_IdInGroupTableWithGroup_id:(NSString *)group_id class_type:(NSString *)class_type msg_id:(NSString *)msg_id;
/**
 *
 *  更新未读数 chat_msg_unread_count数据
 *
 **/
+ (BOOL)updateChat_msg_unread_countToGroupTableWithUnreadCount:(NSString *)unreadCount group_id:(NSString *)group_id class_type:(NSString *)class_type;

/**
 *
 *  更新列表置顶 is_top数据
 *
 **/
+ (BOOL)updateIs_topToGroupTableWithIsTop:(BOOL)is_top group_id:(NSString *)group_id class_type:(NSString *)class_type;

/**
 *
 *  更新列表的最后一条消息发送时间，用于聊聊列表排序
 *
 **/
+ (BOOL)updateList_sort_timeWithChatGroupListModel:(JGJChatGroupListModel *)groupModel;

/**
 *
 *  清除@消息的 提示字段be_at_uid
 *
 **/
+ (BOOL)updateAt_MessageToGroupTable:(NSString *)at_message group_id:(NSString *)group_id class_type:(NSString *)class_type;

/**
 *
 *  更新列表置顶 is_delete数据
 *
 **/
+ (BOOL)updateIs_deleteToGroupTableWithIsDelete:(JGJChatGroupListModel *)groupModel group_id:(NSString *)group_id class_type:(NSString *)class_type;

/**
 *
 *  更新列表的最新消息
 *
 **/
+ (BOOL)updateNew_Chat_MsgToGroupTableWithGroupListModel:(JGJChatGroupListModel *)groupModel;
/**
 *
 *  更新列表的最新消息,不带未读数
 *
 **/
+ (BOOL)updateNew_Chat_Msg_No_Chat_Unread_Msg_CountToGroupTableWithGroupListModel:(JGJChatGroupListModel *)groupModel;
// 删除列表数据
+ (BOOL)deleteChatGroupListDataWithModel:(JGJChatGroupListModel *)model;

+ (BOOL)deleteAllChatGroupListData;
// 查询数据
+ (JGJChatGroupListModel *)getChatGroupListModelWithGroup_id:(NSString *)group_id classType:(NSString *)class_type;
// 获取创建时间最新的项目
+ (JGJChatGroupListModel *)getNewestCreatTimeChatGroupListModel;

/**
 *
 *  根据group_id 和 class_type获取项目名称
 *
 **/
+ (NSString *)getTheProjectNameWithGroup_id:(NSString *)group_id class_type:(NSString *)class_type;

/**
 获取当前项目和班组未关闭列表
 **/
+ (NSArray<JGJChatGroupListModel *>*)getCurrentGroupOrTeamProjecyList;

/**
 获取当前项目和班组已关闭列表
 **/
+ (NSArray<JGJChatGroupListModel *>*)getCurrentGroupOrTeamProjecyClosedList;

/**
 获取当前未关闭的和未删除 项目 班组 单聊 群聊 时间倒序
 **/
+ (NSArray<JGJChatGroupListModel *>*)getCurrentGroupAndTeamAndGroupChatAndSingleChatList;

/*
 *获取群聊
 */
+ (NSArray<JGJChatGroupListModel *> *)getGroupChats;

/*
 *获取班组或者项目组未关闭的
 */
+ (NSArray<JGJChatGroupListModel *> *)getTeamChats;

// 查询某个消息组是否存在
+ (BOOL)queryGroupIsExistWithModel:(JGJChatGroupListModel *)model;

// 查询所有班组列表
+ (NSArray<JGJChatGroupListModel *> *)getAllGroupListModel;

// 未读消息所有合
+ (NSInteger)getAllUnreadMsgCount;
// 未读消息所有合 出去 工作消息，招聘消息  活动消息
+ (NSInteger)getAllUnreadMsgCountWithOutWork_activity_Recruit;
// 获取我的项目班组，除去首页项目的所有未读数(包括消息和质量，安全等)
+ (NSInteger)getHomeAllUnreadMsgCount;
// 获取所有项目的质量，安全 日志等的未读数(不统计聊聊列表的消息未读数)
+ (NSInteger)getRowCountWithResultList;

// 清空某个消息组的未读数
+ (BOOL)cleadGroupUnReadMsgCountWithModel:(JGJChatGroupListModel*)model;

/*
 *创建项目、班组群聊成功 插入数据库 isHomeVc创建成功是否切换到首页(班组、项目组需要)
 */
+ (void)insertGroupDBWithGroupModel:(JGJChatGroupListModel *)groupModel isHomeVc:(BOOL)isHomeVc ;

/*
 *快速加群，获取地方群和工种群
 */
+ (JGJChatGroupListModel *)getChatGroupListModel:(JGJChatGroupListModel *)groupListModel;

/*
 *更新延展的字段，3.4.2找工作、包工的提示信息
 */

+ (BOOL)updateExtentMsgWithChatGroupListModel:(JGJChatGroupListModel *)groupListModel;

/*
 *快速加群更新字段
 */
+ (BOOL)updateQuickJoinGroupExtentTypeWithChatGroupListModel:(JGJChatGroupListModel *)groupListModel;

@end
