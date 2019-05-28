//
//  JGJChatListTool.h
//  mix
//
//  Created by Tony on 2016/9/5.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JGJChatMsgListModel.h"

@interface JGJChatListTool : NSObject

/**
 *  删除本地缓存
 */
+ (void)deleteSqlite;

///**
// *  获取未读的相关信息
// */
//+(NSArray <JGJMyWorkCircleProListModel*>*)getUnreadedData;

/**
 *  获取满足条件的初始10条消息
 *
 *  @param workProListModel workProListModel的model
 *  @param msg_id           消息id
 *  @param msg_type         消息类型
 */
+ (NSArray *)getOrigiChatMessage:(JGJMyWorkCircleProListModel *)workProListModel msgID:(NSString *)msg_id msgType:(NSString *)msg_type;

/**
 *  获取满足条件的初始10条消息
 *
 *  @param workProListModel workProListModel的model
 *  @param msg_id           消息id
 *  @param merge_msg_id     合并后最大的id
 *  @param msg_type         消息类型
 */
+ (NSArray *)getOrigiMergeChatMessage:(JGJMyWorkCircleProListModel *)workProListModel msgID:(NSString *)msg_id msgType:(NSString *)msg_type;

/**
 *  获取满足条件的上10条消息
 *
 *  @param workProListModel workProListModel的model
 *  @param msg_id           消息id
 *  @param msg_type         消息类型
 */
+ (NSArray *)getUpChatMessage:(JGJMyWorkCircleProListModel *)workProListModel msgID:(NSString *)msg_id msgType:(NSString *)msg_type;

/**
 *  获取满足条件的下10条消息
 *
 *  @param workProListModel workProListModel的model
 *  @param msg_id           消息id
 *  @param msg_type         消息类型
 */
+ (NSArray *)getNextChatMessage:(JGJMyWorkCircleProListModel *)workProListModel msgID:(NSString *)msg_id msgType:(NSString *)msg_type;
    
/**
 *  获取最新的一条信息的ID
 */
+ (JGJChatMsgListModel *)getMaxChatMessage:(JGJMyWorkCircleProListModel *)workProListModel;

/**
 *  添加消息,如果存在则更新，如果不存在则添加
 */
+ (BOOL)addOrUpdateChatMessage:(JGJMyWorkCircleProListModel *)workProListModel chatMsgListModel:(JGJChatMsgListModel *)chatMsgListModel;

/**
 *  删除消息
 */
+ (BOOL)deleteChatMessage:(JGJChatMsgListModel *)chatMsgListModel workProListModel:(JGJMyWorkCircleProListModel *)workProListModel;

/**
 *  本地的ID,根据时间计算
 */
+ (NSString *)localID;

/**
 *  删除当前联系人时，删除当前聊天的所有消息
 */
+ (BOOL)deleteAllChatMessage:(JGJChatMsgListModel *)chatMsgListModel workProListModel:(JGJMyWorkCircleProListModel *)workProListModel;

/**
 *  更新单条信息 2.1.2-yj
 */
+ (BOOL)updateChatMessage:(JGJChatMsgListModel *)chatMsgListModel;

/**
* 获取当前聊天界面所有消息,用于替换消息 2.1.2-yj
*/
+ (NSArray *)currentChatAllMsgsWithProListModel:(JGJMyWorkCircleProListModel *)proListModel;

/**
 * 修改昵称修改数据库，和聊天的临时数据
 */

+ (void)handleModifyTempDataArry:(NSArray *)dataSourceArray modifyChatModel:(JGJChatMsgListModel *)modifyChatModel;
@end
