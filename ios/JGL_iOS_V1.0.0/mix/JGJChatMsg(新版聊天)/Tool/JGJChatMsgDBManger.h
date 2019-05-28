//
//  JGJChatMsgDBManger.h
//  mix
//
//  Created by yj on 2018/8/14.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define JGJChatPageSize 30

#define JGJ_Chat_FilePath [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/chatdatabase/"] stringByAppendingPathComponent:@"jgj_chat_msg.db"]

//聊天特殊文字
#define JGJSpecialWords @"在聊天过程中，涉及合同汇款、转账 、资金、中奖、回款等信息，请以视频或电话核实对方身份，以避免被骗导致钱款损失。"

//招工特殊文字，当前只有群聊

#define JGJSpecialJobWords @"在聊天过程中，涉及到找工作、招聘、招工、找活、包工等信息，请以视频或电话核实对方身份以防被骗，吉工家招聘平台有更多实名发布的真实可靠的招工找活信息。"
typedef enum : NSUInteger {
    
    JGJChatMsgDBUpdateAllPropertyType, //全部属性
    
    JGJChatMsgDBUpdateContentPropertyType, //更新消息
    
    JGJChatMsgDBUpdateServicePicPropertyType, //更新图片
    
    JGJChatMsgDBUpdateUnreadMembersNumPropertyType, //更新未读数
    
    JGJChatMsgDBUpdateIsReadedPropertyType, //更新是否已读状态
    
    JGJChatMsgDBUpdateIsReceivedPropertyType, //更新是否确认已收到
    
    JGJChatMsgDBUpdateSendMsgStatusPropertyType, //更新发送消息状态
    
    JGJChatMsgDBUpdateIsPlayVoicePropertyType, //更新播放语音状态
    
    JGJChatMsgDBUpdateUserInfoPropertyType, //主要更新用户信息
    
    JGJChatMsgDBUpdateAtMessagePropertyType, //更新@标识
    
    JGJChatMsgDBUpdateRecallPropertyType, //更新撤回标识
    
    JGJChatMsgDBInsertMsgType, //插入普通消息
    
    JGJChatMsgDBUpdateSendMsgSuccessPropertyType //更新发送消息成功，更新msg_id send_time
    
} JGJChatMsgDBUpdateType;

@interface JGJChatMsgDBManger : NSObject

+(JGJChatMsgDBManger *)shareManager;

/**
 * 插入消息,接收和自己发送的消息
 *
 **/
+ (BOOL)insertToChatMsgTableWithJGJChatMsgListModel:(JGJChatMsgListModel *)msgListModel propertyListType:(JGJChatMsgDBUpdateType)type;
/**
 * 插入消息
 *
 **/
+ (BOOL)insertAllPropertyChatMsgListModel:(JGJChatMsgListModel *)msgListModel;

/**
 * 插入漫游消息,最新消息
 *
 **/
+ (BOOL)insertToRoamMsgWithMsgModel:(JGJChatMsgListModel *)MsgModel propertyListType:(JGJChatMsgDBUpdateType)type;

/**
 * 批量插入消息
 *
 **/
+ (BOOL)insertBatchMsgModels:(NSArray *)msgModels propertyListType:(JGJChatMsgDBUpdateType)type;

/**
 * msg_id排序获取全部数据
 *
 **/
+ (NSArray *)getChatMsgListModelWithMsgOrder;

/**
 分页获取参考消息之前的消息
 @param msgListModel 传入的参考消息
 @return 返回的消息数组
 */
+ (NSArray *)getMsgModelsWithChatMsgListModel:(JGJChatMsgListModel *)msgListModel;

/**
 获取某两条消息之间的所有消息,包含起始消息(fromMessage),不包含终止消息(toMessage)
 @param fromMessage id较小的消息
 @param toMessage id较大的消息
 @return 返回的消息数组
 */
+ (NSArray *)getMessagesFromMessage:(JGJChatMsgListModel *)fromMessage toMessage:(JGJChatMsgListModel *)toMessage;

/**
 * 获取工作 招聘 活动类型消息
 * msg_id排序获取分页数据
 *
 **/
+ (NSArray *)getWorkMsgModelsWithChatMsgListModel:(JGJChatMsgListModel *)msgListModel;

/**
 * 当前组最大的msgid
 *
 **/
+(JGJChatMsgListModel *)maxMsgListModelWithChatMsgListModel:(JGJChatMsgListModel *)msgListModel;

/**
 * 当前工作消息组最新的消息
 *
 **/
+(JGJChatMsgListModel *)maxMsgListModelWithWorkChatMsgListModel:(JGJChatMsgListModel *)msgListModel;


/**
 * 获取当前组指定的msg_id
 *
 **/
+(JGJChatMsgListModel *)msgModel:(JGJChatMsgListModel *)msgModel;

/**
 * 获取当前组指定的msg_id
 *
 **/
+(JGJChatMsgListModel *)getMaxUserMsgModel:(JGJChatMsgListModel *)msgModel;

/**
 * 更新消息
 *
 **/
+ (BOOL)updateMsgModelTableWithJGJChatMsgListModel:(JGJChatMsgListModel *)msgListModel propertyListType:(JGJChatMsgDBUpdateType)type;

/**
 *
 * 更新工作消息 消息表
 *
 **/
+ (BOOL)updateMsgModelTableWithWorkTypeJGJChatMsgListModel:(JGJChatMsgListModel *)msgListModel;

/**
 * 更新当前组消息的row属性(is_readed 、is_received等)
 *
 **/
+ (BOOL)updateMsgRowPropertyWithJGJChatMsgListModel:(JGJChatMsgListModel *)msgListModel propertyListType:(JGJChatMsgDBUpdateType)type;

/**
 * 更新当前消息用户的姓名
 *
 **/
+ (BOOL)updateUserInfoRowPropertyWithJGJChatMsgListModel:(JGJChatMsgListModel *)msgListModel propertyListType:(JGJChatMsgDBUpdateType)type;

/**
 * 更新当前组消息的未读成员数
 *
 **/
+ (BOOL)updateUnreadMembersNumPropertyWithJGJChatMsgListModel:(JGJChatMsgListModel *)msgListModel propertyListType:(JGJChatMsgDBUpdateType)type;

/**
 * 更新当前组消息的状态，更新失败状态，离开聊天页面正在发送的，且服务器还未返回的标记失败
 *
 **/
+ (BOOL)updateUnreadMsgSendTypePropertyWithJGJChatMsgListModel:(JGJChatMsgListModel *)msgListModel propertyListType:(JGJChatMsgDBUpdateType)type;

/**
 * 更新当前组消息
 *
 **/
+ (BOOL)updateGroupMsgRowPropertyWithJGJChatMsgListModel:(JGJChatMsgListModel *)msgListModel propertyListType:(JGJChatMsgDBUpdateType)type;

/**
 * 获取我的最大的消息信息，用于聊天的时候发送，先展示我的信息。不需要等服务器返回才显示头像或者姓名
 *
 **/
+(JGJChatMsgListModel *)maxMsgModelWithMyMsgModel:(JGJChatMsgListModel *)msgListModel;

/**
 * 用于聊聊列表获取最大的消息信息
 * work_message 不加条件判断
 **/
+(JGJChatMsgListModel *)maxGroupListModelWithChatMsgListModel:(JGJChatMsgListModel *)msgListModel;

/**
 * 当前组消息的未读数返回数量
 *
 **/
+(NSString *)msgUnreadedNumWithMyMsgModel:(JGJChatMsgListModel *)msgListModel;

/**
 * 当前消息是否已存在只要有消息id或者local_id
 *
 **/
+(BOOL)isExistMsgModel:(JGJChatMsgListModel *)msgModel;

/**
 * 当前消息是否已存在只要有消息id
 *
 **/
+(BOOL)isExistMsgIdModel:(JGJChatMsgListModel *)msgModel;

/**
 * 当前消息是否已存在只要有消息bill_id
 *
 **/
+(BOOL)isExistMsgBill_IdModel:(JGJChatMsgListModel *)msgModel;

/**
 * 删除当前组消息根据消息id或者msg删除
 *
 **/
+(BOOL)delMsgModel:(JGJChatMsgListModel *)msgModel;

/**
 * 删除当前组消息
 *
 **/
+(BOOL)delGroupMsgModel:(JGJChatMsgListModel *)msgModel;

/**
 * 消息排序
 *
 **/
+(NSArray *)sortMsgList:(NSArray *)msgList;

/**
 * 时间戳13位
 *
 **/
+ (NSString *)localID;

/**
 * 时间戳10位
 *
 **/
+ (NSString *)localTime;

/**
 * 是否包含特殊词汇
 *在聊天过程中，如果聊天内容包含“汇款、金额、钱、转账、回款、红包、中奖”这些词时，系统在聊天面板立即推送一条防骗提示“在聊天过程中，涉及合同汇款、转账 、资金、中奖、回款等信息，请以视频或电话核实对方身份，以避免被骗导致钱款损失。”
 **/
+ (JGJChatMsgListModel *)containSpecialWordsWithMsgModel:(JGJChatMsgListModel *)msgModel;

/**
 *在聊天过程中，涉及到招工找活方面的关键词“找工作、招聘、招工、找活、包工”，系统在聊天面板立即推送一条防骗提示”
 **/

+ (JGJChatMsgListModel *)jobContainSpecialWordsWithMsgModel:(JGJChatMsgListModel *)msgModel;

/**
 * 聊天消息从数据库获取
 *
 **/
+ (NSArray *)getChatMsgModel:(JGJChatMsgListModel *)msgModel;

+ (NSArray *)sortActivity_RecruitMsgList:(NSArray *)msgList;
/**
 * 将msg_id升序排
 *
 **/
+ (NSMutableArray *)sortChatMsgModelToMsg_idAscendingWithMsgArr:(NSMutableArray *)msg_arr;

+ (BOOL)deleteAllChatMsgListData;

/**
 * 点击用户头像到他的资料更新用户信息头像
 *
 **/
+ (BOOL)updateUserInfoWithMsgModel:(JGJChatMsgListModel *)msgModel;

/**
 * 更新发送消息的msg_id,和未读消息人数
 *
 **/
+(BOOL)updateSendMessageUnreadNumWithMsgModel:(JGJChatMsgListModel *)msgModel;

//发消息之前先插入消息，根据local_id判断

+ (BOOL)insertToSendMessageMsgTableWithJGJChatMsgListModel:(JGJChatMsgListModel *)msgListModel propertyListType:(JGJChatMsgDBUpdateType)type;

/**
 * 删除发送失败的消息
 *
 **/
+(BOOL)delSendFailureMsgWithJGJChatMsgListModel:(JGJChatMsgListModel *)msgListModel;


/**
 * 插入图片消息信息
 *
 **/

+ (BOOL)insertToSendPicMsgTableWithMsgListModel:(JGJChatMsgListModel *)msgListModel;

/**
 * 更新发送图片消息的msg_id,和未读消息人数
 *
 **/

+(BOOL)updateSendPicMsgWithMsgModel:(JGJChatMsgListModel *)msgModel;


/**
 * 初始化排重数据
 *
 **/
+(void)initialRepetMutableSet;

/**
 * 发消息之前先插入消息，根据local_id判断.存在就更新当前数据
 *
 **/

+ (BOOL)insertToSendMessageMsgTableWithJGJChatMsgListModel:(JGJChatMsgListModel *)msgListModel propertyListType:(JGJChatMsgDBUpdateType)type;

/**
 * 更新撤回消息
 *
 **/

+ (BOOL)updateRecallWithMsgModel:(JGJChatMsgListModel *)msgModel propertyListType:(JGJChatMsgDBUpdateType)type;

/**
 * 排重,有消息id
 *
 **/
@property (nonatomic, strong, readonly) NSMutableSet *existMsgIdsSet;

/**
 * 排重,没有消息id
 *
 **/
@property (nonatomic, strong, readonly) NSMutableSet *unExistMsgIdsSet;

@end
