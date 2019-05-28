//
//  JGJChatMsgDBManger.m
//  mix
//
//  Created by yj on 2018/8/14.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJChatMsgDBManger.h"

#import "JGJChatMsgListModel+JGJWCDB.h"

#import "JGJChatGroupListModel+JGJGroupListWCTTableCoding.h"

#import "JGJIndexDataModel+JGJIndexDataModel.h"

#import "JGJChatMsgDBManger+JGJClearCacheDB.h"

#import "JGJChatMsgDBManger+JGJGroupDB.h"


//消息表
static NSString *const JGJ_Chat_Msg_Table = @"JGJ_Chat_Msg_Table";

static NSString *const JGJ_Chat_Group_Table = @"JGJ_Chat_Group_Table";

static NSString *const JGJ_Chat_Index_Table = @"JGJ_Chat_Index_Table";

//缓存表
static NSString *const JGJ_Chat_Cache_Table = @"JGJ_Chat_Cache_Table";

static JGJChatMsgDBManger *msgDBManger = nil;

@interface JGJChatMsgDBManger()

@property (nonatomic,strong) WCTDatabase *dataBase;

@property (nonatomic,strong) WCTTable    *table;

@property (nonatomic,strong) WCTTable    *group_table;

@property (nonatomic,strong) WCTTable    *index_table;

@property (nonatomic,strong) WCTTable    *cache_table;

/**
 * 排重,有消息id
 *
 **/
@property (nonatomic, strong) NSMutableSet *existMsgIdsSet;

/**
 * 排重,没有消息id
 *
 **/
@property (nonatomic, strong) NSMutableSet *unExistMsgIdsSet;

@end

@implementation JGJChatMsgDBManger

+(JGJChatMsgDBManger *)shareManager {
    
    static dispatch_once_t once;
    
    if (msgDBManger) {
        
        return msgDBManger;
    }
    
    dispatch_once(&once, ^{
        
        msgDBManger = [[JGJChatMsgDBManger alloc]init];
        
        [msgDBManger creatDB];
        
    });
    
    return msgDBManger;

}

+ (void)shareManagerGroupTable:(WCTTable *)table msgDBManger:(JGJChatMsgDBManger *)msgDBManger {
    
    
}

+ (void)shareManagerIndexTable:(WCTTable *)table msgDBManger:(JGJChatMsgDBManger *)msgDBManger {
    
    
}

+ (void)shareManagerCacheTable:(WCTTable *)table msgDBManger:(JGJChatMsgDBManger *)msgDBManger {
    

}

+ (void)initialize {
    
    if (msgDBManger == nil) {
        
        msgDBManger = [[JGJChatMsgDBManger alloc]init];
        
        [msgDBManger creatDB];
        
        if (msgDBManger) {
            
            //聊聊
            [self shareManagerGroupTable:msgDBManger.group_table msgDBManger:msgDBManger];
            
            //首页
            [self shareManagerIndexTable:msgDBManger.index_table msgDBManger:msgDBManger];
            
            //消息缓存表
            [self shareManagerCacheTable:msgDBManger.cache_table msgDBManger:msgDBManger];
        }
        
    }
}

- (BOOL)creatDB
{

    TYLog(@"DBPath:%@",JGJ_Chat_FilePath);
    
    self.dataBase = [[WCTDatabase alloc]initWithPath:JGJ_Chat_FilePath];
    
    BOOL result   = [self.dataBase createTableAndIndexesOfName:JGJ_Chat_Msg_Table withClass:JGJChatMsgListModel.class];
    
    self.table    = [self.dataBase getTableOfName:JGJ_Chat_Msg_Table withClass:JGJChatMsgListModel.class];
    
    BOOL group_result   = [self.dataBase createTableAndIndexesOfName:JGJ_Chat_Group_Table withClass:JGJChatGroupListModel.class];
    
    self.group_table    = [self.dataBase getTableOfName:JGJ_Chat_Group_Table withClass:JGJChatGroupListModel.class];
    
    BOOL index_result   = [self.dataBase createTableAndIndexesOfName:JGJ_Chat_Index_Table withClass:JGJIndexDataModel.class];

    self.index_table    = [self.dataBase getTableOfName:JGJ_Chat_Index_Table withClass:JGJIndexDataModel.class];
    
    BOOL cache_result   = [self.dataBase createTableAndIndexesOfName:JGJ_Chat_Cache_Table withClass:JGJChatClearCacheModel.class];
    
    self.cache_table    = [self.dataBase getTableOfName:JGJ_Chat_Cache_Table withClass:JGJChatClearCacheModel.class];
    
    assert(result);
    
    if ([self.dataBase canOpen]) {
        
        TYLog(@"能打开数据库");
    }else{
        
        TYLog(@"不能打开数据库");
    }
    if ([self.dataBase isOpened]) {
        
        TYLog(@"打开中");
    }else{
        
        TYLog(@"没打开");
    }
    return result;
}

+ (BOOL)insertToChatMsgTableWithJGJChatMsgListModel:(JGJChatMsgListModel *)msgListModel propertyListType:(JGJChatMsgDBUpdateType)type {
    
    //自己发的消息send_time是空的话一定要赋值当前时间
    if ([NSString isEmpty:msgListModel.send_time] && ![NSString isEmpty:msgListModel.local_id]) {
        
        msgListModel.send_time = [self localTime];
    }
    
    if ([self isEmptyMsgModel:msgListModel]) {
        
        return NO;
    }
    
    BOOL is_success = NO;
    
    if ([self isExistMsgModel:msgListModel]) {
        
        is_success = [self updateMsgModelTableWithJGJChatMsgListModel:msgListModel propertyListType:type];
        
    }else {
        
        //3.4.1添加不存在消息id就添加
        
        if (![self isExistMsgIdModel:msgListModel]) {
            
            is_success = [msgDBManger.table insertObject:msgListModel];
        }
        
    }
    
    return is_success;

}


//发消息之前先插入消息，根据local_id判断

+ (BOOL)insertToSendMessageMsgTableWithJGJChatMsgListModel:(JGJChatMsgListModel *)msgListModel propertyListType:(JGJChatMsgDBUpdateType)type {
    
    if ([self isEmptyMsgModel:msgListModel]) {
        
        return NO;
    }
    
    BOOL is_success = NO;
    
    WCTPropertyList propertyList = {JGJChatMsgListModel.msg_id,JGJChatMsgListModel.wcdb_msg_id,JGJChatMsgListModel.send_time,JGJChatMsgListModel.sendType, JGJChatMsgListModel.unread_members_num};
    
    //有消息表示更新数据状态是成功，没有消息id就是开始存
    
    if (![NSString isEmpty:msgListModel.msg_id]) {
        
        msgListModel.sendType = JGJChatListSendSuccess;
        
    }else {
        
        msgListModel.sendType = JGJChatListSendStart;
    }
    
    msgListModel.wcdb_msg_id = [msgListModel.msg_id integerValue];
    
    if ([self isExistMsgLocalIdModelWithMsgModel:msgListModel] && ![NSString isEmpty:msgListModel.msg_text]) {
        
        is_success = [msgDBManger.table updateRowsOnProperties:propertyList withObject:msgListModel where:JGJChatMsgListModel.local_id == msgListModel.local_id && [self comConWithChatMsgModel:msgListModel] && JGJChatMsgListModel.msg_text == msgListModel.msg_text && JGJChatMsgListModel.msg_sender == msgListModel.msg_sender];
        
    }else if ([self isExistMsgLocalIdModelWithMsgModel:msgListModel]) {
        
        is_success = [msgDBManger.table updateRowsOnProperties:propertyList withObject:msgListModel where:JGJChatMsgListModel.local_id == msgListModel.local_id && [self comConWithChatMsgModel:msgListModel] && JGJChatMsgListModel.msg_sender == msgListModel.msg_sender];
        
    }
    
    else {
        
        is_success = [msgDBManger.table insertObject:msgListModel];
    }
    
    return is_success;
    
}

/**
 * 发消息图片之前先插入消息，根据local_id判断.存在就更新当前数据
 *
 **/
+ (BOOL)insertToSendPicMessageTableWithJGJChatMsgListModel:(JGJChatMsgListModel *)msgListModel propertyListType:(JGJChatMsgDBUpdateType)type {
    
    
    if ([self isEmptyMsgModel:msgListModel]) {
        
        return NO;
    }
    
    BOOL is_success = NO;
    
    WCTPropertyList propertyList = {JGJChatMsgListModel.msg_id,JGJChatMsgListModel.wcdb_msg_id,JGJChatMsgListModel.send_time,JGJChatMsgListModel.sendType, JGJChatMsgListModel.unread_members_num};
    
    msgListModel.sendType = JGJChatListSendSuccess;
    
    msgListModel.wcdb_msg_id = [msgListModel.msg_id integerValue];
    
    if ([self isExistMsgLocalIdModelWithMsgModel:msgListModel] && ![NSString isEmpty:msgListModel.msg_text]) {
        
        is_success = [msgDBManger.table updateRowsOnProperties:propertyList withObject:msgListModel where:JGJChatMsgListModel.local_id == msgListModel.local_id && [self comConWithChatMsgModel:msgListModel] && JGJChatMsgListModel.msg_text == msgListModel.msg_text && JGJChatMsgListModel.msg_sender == msgListModel.msg_sender];
        
    }else if ([self isExistMsgLocalIdModelWithMsgModel:msgListModel]) {
        
        is_success = [msgDBManger.table updateRowsOnProperties:propertyList withObject:msgListModel where:JGJChatMsgListModel.local_id == msgListModel.local_id && [self comConWithChatMsgModel:msgListModel] && JGJChatMsgListModel.msg_sender == msgListModel.msg_sender];
        
    }
    
    else {
        
        is_success = [msgDBManger.table insertObject:msgListModel];
    }
    
    return is_success;
}

+(BOOL)delSendFailureMsgWithJGJChatMsgListModel:(JGJChatMsgListModel *)msgListModel{
    
    if ([self isEmptyMsgModel:msgListModel]) {
        
        return NO;
    }
    
    BOOL is_success = NO;
    
    if ([self isExistMsgLocalIdModelWithMsgModel:msgListModel] && ![NSString isEmpty:msgListModel.msg_text]) {
        
        is_success = [msgDBManger.table deleteObjectsWhere:JGJChatMsgListModel.local_id == msgListModel.local_id && [self comConWithChatMsgModel:msgListModel] && JGJChatMsgListModel.msg_sender == msgListModel.msg_sender && JGJChatMsgListModel.msg_text == msgListModel.msg_text];
        
    }else if ([self isExistMsgLocalIdModelWithMsgModel:msgListModel]) {
        
        is_success = [msgDBManger.table deleteObjectsWhere:JGJChatMsgListModel.local_id == msgListModel.local_id && [self comConWithChatMsgModel:msgListModel] && JGJChatMsgListModel.msg_sender == msgListModel.msg_sender];
        
    }
    
    return is_success;
}

/**
 * 漫游插入消息
 *
 **/
+ (BOOL)insertAllPropertyChatMsgListModel:(JGJChatMsgListModel *)msgListModel {
    
    BOOL is_success = NO;
    
    if ([self isEmptyMsgModel:msgListModel]) {
        
        return NO;
    }
    
    if (![self isExistMsgIdModel:msgListModel]) {
        
        is_success = [msgDBManger.table insertObject:msgListModel];
    }
    
    return is_success;
}

/**
 * 插入漫游消息,最新消息
 *
 **/
+ (BOOL)insertToRoamMsgWithMsgModel:(JGJChatMsgListModel *)msgModel propertyListType:(JGJChatMsgDBUpdateType)type {
    
    //自己发的消息send_time是空的话一定要赋值当前时间
    if ([NSString isEmpty:msgModel.send_time] && ![NSString isEmpty:msgModel.local_id]) {
        
        msgModel.send_time = [self localTime];
    }
    
    if ([self isEmptyMsgModel:msgModel]) {
        
        return NO;
    }
    
    if ([self isExistMsgIdModel:msgModel]) {

        return [self updateMsgModelTableWithJGJChatMsgListModel:msgModel propertyListType:type];

    }else {

        return [msgDBManger.table insertObject:msgModel];
    }

}



+(NSArray *)sortActivity_RecruitMsgList:(NSArray *)msgList {
    
    NSArray *sortArray = [msgList sortedArrayUsingComparator:^NSComparisonResult(JGJChatMsgListModel  *obj1, JGJChatMsgListModel  *obj2) {
        
        if (![NSString isEmpty:obj1.send_time] && ![NSString isEmpty:obj2.send_time]) {
            
            NSComparisonResult result = [obj1.send_time compare:obj2.send_time];
        }
        
        return NSOrderedAscending;
    }];
    
    return sortArray;
}

+ (NSMutableArray *)sortChatMsgModelToMsg_idAscendingWithMsgArr:(NSMutableArray *)msg_arr {
    
    NSArray *sortArray = [msg_arr sortedArrayUsingComparator:^NSComparisonResult(JGJChatMsgListModel  *obj1, JGJChatMsgListModel  *obj2) {
        
        if (![NSString isEmpty:obj1.msg_id] && ![NSString isEmpty:obj2.msg_id]) {
            
            NSComparisonResult result = [obj1.msg_id compare:obj2.msg_id];
        }
        
        return NSOrderedAscending;
    }];
    
    return sortArray.mutableCopy;
}
+ (BOOL)insertBatchMsgModels:(NSArray *)msgModels propertyListType:(JGJChatMsgDBUpdateType)type {
    
    if (msgModels.count == 0) {
        
        return NO;
    }
    
    WCTPropertyList propertyList = [self propertyListWithPropertyListType:type];
    
    BOOL is_success = [msgDBManger.table insertObjects:msgModels];
    
    return is_success;
    
}

//发消息判断是否存在已有的loca_id
+ (BOOL)isExistMsgLocalIdModelWithMsgModel:(JGJChatMsgListModel *)msgModel {
    
    BOOL is_exist = NO;
    
    if (![NSString isEmpty:msgModel.local_id] && ![msgModel.local_id isEqualToString:@"0"]) {
        
        msgModel = [msgDBManger.table getOneObjectWhere:JGJChatMsgListModel.local_id == msgModel.local_id && [self comConWithChatMsgModel:msgModel] && JGJChatMsgListModel.msg_sender == msgModel.msg_sender];
        
        is_exist = ![NSString isEmpty:msgModel.local_id] || msgModel.local_id.length >= 10;
        
    }
    
    return is_exist;
}

+ (BOOL)deleteChatMsgListDataWithModel:(JGJChatMsgListModel *)msgListModel {
    
    if ([self isEmptyMsgModel:msgListModel]) {
        
        return NO;
    }

    return [msgDBManger.table deleteObjectsWhere:JGJChatMsgListModel.msg_id == msgListModel.msg_id && [self comConWithChatMsgModel:msgListModel]];
}

+ (BOOL)updateMsgModelTableWithJGJChatMsgListModel:(JGJChatMsgListModel *)msgListModel propertyListType:(JGJChatMsgDBUpdateType)type {
    
    if ([self isEmptyMsgModel:msgListModel]) {
        
        return NO;
    }
    
    WCTPropertyList propertyList = [self propertyListWithPropertyListType:type];
    
    BOOL is_success = NO;
    
    if (![NSString isEmpty:msgListModel.local_id] && ![msgListModel.msg_type isEqualToString:@"recall"]) {

        propertyList = {JGJChatMsgListModel.sendType, JGJChatMsgListModel.unread_members_num};
        
        //语音的话添加更新语音长度
        
        if (![NSString isEmpty:msgListModel.msg_type]) {
            
            if ([msgListModel.msg_type isEqualToString:@"voice"]) {
                
                propertyList = {JGJChatMsgListModel.sendType, JGJChatMsgListModel.unread_members_num,JGJChatMsgListModel.voice_long};
                
            }
            
        }
        
        is_success = [msgDBManger.table updateRowsOnProperties:propertyList withObject:msgListModel where:JGJChatMsgListModel.local_id == msgListModel.local_id && [self comConWithChatMsgModel:msgListModel]];

    }else if (![NSString isEmpty:msgListModel.msg_id]) {
        
        //这里主要更新离线的撤回的消息
        
        if ([msgListModel.msg_type isEqualToString:@"recall"]) {
            
            propertyList = [self propertyListWithPropertyListType:JGJChatMsgDBUpdateRecallPropertyType];
            
        }

        is_success = [msgDBManger.table updateRowsOnProperties:propertyList withObject:msgListModel where:JGJChatMsgListModel.msg_id == msgListModel.msg_id && [self comConWithChatMsgModel:msgListModel]];

    }
        
    return is_success;
}

+ (BOOL)updateMsgModelTableWithWorkTypeJGJChatMsgListModel:(JGJChatMsgListModel *)msgListModel {
    
    if ([self isEmptyMsgModel:msgListModel]) {
        
        return NO;
    }
    
    return [msgDBManger.table updateRowsOnProperties:{JGJChatMsgListModel.msg_type,JGJChatMsgListModel.msg_text,JGJChatMsgListModel.title} withObject:msgListModel where:JGJChatMsgListModel.msg_id == msgListModel.msg_id && [self comConWithChatMsgModel:msgListModel]];
}

+(BOOL)isExistMsgModel:(JGJChatMsgListModel *)msgModel {
    
    if ([self isEmptyMsgModel:msgModel]) {
        
        return NO;
    }
    
    NSString *user_id = [TYUserDefaults objectForKey:JLGUserUid];
    
    JGJChatMsgListModel *existModel = nil;
    
    BOOL is_exist = NO;
    
    if (![NSString isEmpty:msgModel.local_id] && ![msgModel.local_id isEqualToString:@"0"]) {

        existModel = [msgDBManger.table getOneObjectWhere:JGJChatMsgListModel.local_id == msgModel.local_id && [self comConWithChatMsgModel:msgModel]];

        is_exist = ![NSString isEmpty:existModel.local_id];

    }else if (![NSString isEmpty:msgModel.msg_id]) {

        existModel = [msgDBManger.table getOneObjectWhere:JGJChatMsgListModel.msg_id == msgModel.msg_id && JGJChatMsgListModel.user_unique == user_id];

        is_exist = ![NSString isEmpty:existModel.msg_id];
    }

    return is_exist;
    
}

+(BOOL)isExistMsgIdModel:(JGJChatMsgListModel *)msgModel {
    
    if ([self isEmptyMsgModel:msgModel]) {
        
        return NO;
    }
    
    JGJChatMsgListModel *existModel = [msgDBManger.table getOneObjectWhere:JGJChatMsgListModel.msg_id == msgModel.msg_id];
    
    BOOL is_exist = ![NSString isEmpty:existModel.msg_id];
    
    return is_exist;
    
}

+ (NSArray *)getChatMsgListModelWithMsgOrder {
    
   return [msgDBManger.table getObjectsOrderBy:JGJChatMsgListModel.wcdb_msg_id.order()];
   
}

+ (NSArray *)getMsgModelsWithChatMsgListModel:(JGJChatMsgListModel *)msgListModel{
    
    if ([self isEmptyMsgModel:msgListModel]) {
        
        return nil;
    }
    
    NSInteger length = JGJChatPageSize;
    
    //pagesize+1的目的是等于当前时间，如果不加1处理在分页时相同的时间，会排除一些数据
    
    if (![NSString isEmpty:msgListModel.send_time]) {
        
        length = JGJChatPageSize + 1;
        
    }
    
    NSString *send_time = [NSString isEmpty:msgListModel.send_time] ? [self localTime] : msgListModel.send_time;
    
    NSArray *msgModels = nil;
    
    NSInteger wcdb_msg_id = msgListModel.wcdb_msg_id;
    
    msgModels = [msgDBManger.table getObjectsWhere:[self sortConWithChatMsgModel:msgListModel] &&  JGJChatMsgListModel.send_time <= send_time orderBy:JGJChatMsgListModel.send_time.order(WCTOrderedDescending) limit:length];
    
    msgModels = [self sortMsgSendTimeList:msgModels];
    
    return msgModels;
    
    //下面这种msg_id是唯一的，失败时就会出现问题
    
    //    WCTSelect *select = [[[[[msgDBManger.dataBase prepareSelectObjectsOnResults:JGJChatMsgListModel.AllProperties
    //                                                                      fromTable:JGJ_Chat_Msg_Table] where:[self sortConWithChatMsgModel:msgListModel] &&  JGJChatMsgListModel.send_time < send_time] groupBy:{JGJChatMsgListModel.wcdb_msg_id}] orderBy:{JGJChatMsgListModel.send_time.order(WCTOrderedDescending),JGJChatMsgListModel.wcdb_msg_id.order(WCTOrderedDescending)}] limit:JGJChatPageSize];
    
    //    msgModels = select.allObjects;
    //
    //    return [self sortMsgList:msgModels];
    
}

/**
 获取某两条消息之间的所有消息,包含起始消息(fromMessage),不包含终止消息(toMessage)
 @param fromMessage id较小的消息
 @param toMessage id较大的消息
 @return 返回的消息数组
 */
+ (NSArray *)getMessagesFromMessage:(JGJChatMsgListModel *)fromMessage toMessage:(JGJChatMsgListModel *)toMessage
{
    NSArray *msgModels;
    if ([self isEmptyMsgModel:fromMessage] || [self isEmptyMsgModel:toMessage]) {
        return msgModels;
    }
    NSString *fromMsgId = fromMessage.msg_id;
    NSString *toMsgId = toMessage.msg_id;
    
    msgModels = [msgDBManger.table getObjectsWhere:[self sortConWithChatMsgModel:fromMessage] &&  JGJChatMsgListModel.msg_id >= fromMsgId && JGJChatMsgListModel.msg_id <= toMsgId orderBy:JGJChatMsgListModel.msg_id.order(WCTOrderedDescending)];
    
    msgModels = [self sortMsgSendTimeList:msgModels];
    
    return msgModels;
}


+ (NSArray *)getWorkMsgModelsWithChatMsgListModel:(JGJChatMsgListModel *)msgListModel {
    
    if ([self isEmptyMsgModel:msgListModel]) {
        
        return nil;
    }

    NSString *send_time = [NSString isEmpty:msgListModel.send_time] ? [self localTime] : msgListModel.send_time;
    
    NSArray *msgModels = nil;
    
    NSInteger wcdb_msg_id = msgListModel.wcdb_msg_id;
    NSString *user_id = [TYUserDefaults objectForKey:JLGUserUid];

    WCTCondition condition = JGJChatMsgListModel.msg_total_type == msgListModel.msg_total_type && JGJChatMsgListModel.user_unique == user_id && JGJChatMsgListModel.msg_type != @"demandSyncBill" && JGJChatMsgListModel.msg_type != @"syncBillToYou" && JGJChatMsgListModel.msg_type != @"agreeSyncBill" && JGJChatMsgListModel.msg_type != @"refuseSyncBill" && JGJChatMsgListModel.msg_type != @"cancellSyncBill" && JGJChatMsgListModel.msg_type != @"evaluate" && JGJChatMsgListModel.origin_class_type != @"group" && JGJChatMsgListModel.class_type != @"group" && JGJChatMsgListModel.msg_type != @"present_integral" && JGJChatMsgListModel.msg_type != @"evaluate" && JGJChatMsgListModel.can_recive_client != @"person";
    
    WCTSelect *select = [[[[[msgDBManger.dataBase prepareSelectObjectsOnResults:JGJChatMsgListModel.AllProperties
                                                                      fromTable:JGJ_Chat_Msg_Table] where:condition && JGJChatMsgListModel.send_time < send_time] groupBy:{JGJChatMsgListModel.wcdb_msg_id}] orderBy:{JGJChatMsgListModel.send_time.order(WCTOrderedDescending),JGJChatMsgListModel.wcdb_msg_id.order(WCTOrderedDescending)}] limit:JGJChatPageSize];
    
    msgModels = select.allObjects;
    
    return [self sortWorkMsgList:msgModels];
}

+(JGJChatMsgListModel *)maxMsgListModelWithChatMsgListModel:(JGJChatMsgListModel *)msgListModel {

    if ([self isEmptyMsgModel:msgListModel]) {
        
        return nil;
    }
    
    NSArray *maxMsgs = [msgDBManger.table getObjectsWhere:[self comConWithChatMsgModel:msgListModel] orderBy:JGJChatMsgListModel.wcdb_msg_id.order(WCTOrderedDescending) limit:1];

    JGJChatMsgListModel *maxMsgModel = nil;
    
    if (maxMsgs.count > 0) {
        
        maxMsgModel = maxMsgs.firstObject;
    }
    
    return maxMsgModel;
    
}

+(JGJChatMsgListModel *)maxMsgListModelWithWorkChatMsgListModel:(JGJChatMsgListModel *)msgListModel {
    
    if ([self isEmptyMsgModel:msgListModel]) {
        
        return nil;
    }
    
    NSArray *maxMsgs = [msgDBManger.table getObjectsWhere:[self comConWithChatMsgModel:msgListModel] orderBy:JGJChatMsgListModel.send_time.order(WCTOrderedDescending) limit:1];
    
    JGJChatMsgListModel *maxMsgModel = nil;
    
    if (maxMsgs.count > 0) {
        
        maxMsgModel = maxMsgs.firstObject;
    }
    
    return maxMsgModel;
    
}

+(JGJChatMsgListModel *)maxMsgModelWithMyMsgModel:(JGJChatMsgListModel *)msgListModel {
    
    if ([self isEmptyMsgModel:msgListModel]) {
        
        return nil;
    }
    
    NSString *myUid = [TYUserDefaults objectForKey:JLGUserUid];
    
    JGJChatMsgListModel *maxMsgModel = [msgDBManger.table getObjectsWhere:[self comConWithChatMsgModel:msgListModel] && JGJChatMsgListModel.msg_sender == myUid orderBy:JGJChatMsgListModel.local_id.order(WCTOrderedDescending)].firstObject;
    
    return maxMsgModel;
    
}


+(JGJChatMsgListModel *)maxGroupListModelWithChatMsgListModel:(JGJChatMsgListModel *)msgListModel {
    
    if ([self isEmptyMsgModel:msgListModel]) {
        
        return nil;
    }
    
    NSString *user_id = [TYUserDefaults objectForKey:JLGUserUid];
    WCTCondition condition;
    
    // 普通消息类型 查询最新消息 用group_id + class_type联合查询,其他类型 只需要用大类型msg_total_type来查询
    if (msgListModel.msg_total_type == JGJChatNormalMsgType) {
        
        condition = JGJChatMsgListModel.group_id == msgListModel.group_id && JGJChatMsgListModel.class_type == msgListModel.class_type  && JGJChatMsgListModel.user_unique == user_id;
        
    }else {
        
        condition = JGJChatMsgListModel.msg_total_type == msgListModel.msg_total_type && JGJChatMsgListModel.user_unique == user_id;
    }
    JGJChatMsgListModel *maxMsgModel = [msgDBManger.table getObjectsWhere:condition orderBy:JGJChatMsgListModel.wcdb_msg_id.order(WCTOrderedDescending)].firstObject;
    
    return maxMsgModel;
    
}

/**
 * 获取当前组指定的msg_id
 *
 **/
+(JGJChatMsgListModel *)msgModel:(JGJChatMsgListModel *)msgModel {
    
    if ([self isEmptyMsgModel:msgModel]) {
        
        return nil;
    }
    
    JGJChatMsgListModel *existMsgModel = nil;
    
    existMsgModel = [msgDBManger.table getObjectsWhere:[self comConWithChatMsgModel:msgModel] && JGJChatMsgListModel.msg_id == msgModel.msg_id].firstObject;
    
    return existMsgModel;
}

/**
 * 获取当前组指定的msg_id
 *
 **/
+(JGJChatMsgListModel *)getMaxUserMsgModel:(JGJChatMsgListModel *)msgModel {
    
    if ([self isEmptyMsgModel:msgModel]) {
        
        return nil;
    }
    
    JGJChatMsgListModel *existMsgModel = nil;
    
    existMsgModel = [msgDBManger.table getObjectsWhere:[self comConWithChatMsgModel:msgModel] && JGJChatMsgListModel.msg_sender == msgModel.msg_sender].lastObject;
    
    return existMsgModel;
}

/**
 * 当前组消息的未读数返回数量
 *
 **/
+(NSString *)msgUnreadedNumWithMyMsgModel:(JGJChatMsgListModel *)msgListModel {
    
    if ([self isEmptyMsgModel:msgListModel]) {
        
        return @"0";
    }
    
    NSInteger msg_id = msgListModel.wcdb_msg_id == 0 ? 0 : msgListModel.wcdb_msg_id;
    
    NSArray *msgModels = [msgDBManger.table getObjectsWhere:[self comConWithChatMsgModel:msgListModel] &&  JGJChatMsgListModel.wcdb_msg_id > msg_id];
    
    NSString *unreadNum = [NSString stringWithFormat:@"%@", @(msgModels.count)];
    
    return unreadNum;
    
}

+ (BOOL)updateMsgRowPropertyWithJGJChatMsgListModel:(JGJChatMsgListModel *)msgListModel propertyListType:(JGJChatMsgDBUpdateType)type {
    
    if ([self isEmptyMsgModel:msgListModel]) {
        
        return NO;
    }
    
    BOOL is_success = NO;
    
    WCTPropertyList propertyList = [self propertyListWithPropertyListType:type];
    
    is_success = [msgDBManger.table updateRowsOnProperties:propertyList withObject:msgListModel where:[self comConWithChatMsgModel:msgListModel] and JGJChatMsgListModel.msg_id == msgListModel.msg_id];
    
    return is_success;
    
}

/**
 * 更新当前组消息的未读成员数
 *
 **/
+ (BOOL)updateUnreadMembersNumPropertyWithJGJChatMsgListModel:(JGJChatMsgListModel *)msgListModel propertyListType:(JGJChatMsgDBUpdateType)type {
    
    if ([self isEmptyMsgModel:msgListModel]) {
        
        return NO;
    }
    
    BOOL is_success = NO;
    
    WCTPropertyList propertyList = [self propertyListWithPropertyListType:type];
    
    is_success = [msgDBManger.table updateRowsOnProperties:propertyList withObject:msgListModel where:[self comConWithChatMsgModel:msgListModel] && JGJChatMsgListModel.unread_members_num >= msgListModel.unread_members_num];
    
    return is_success;
}

/**
 * 更新当前组消息的状态，更新失败状态，离开聊天页面正在发送的，且服务器还未返回的标记失败
 *
 **/
+ (BOOL)updateUnreadMsgSendTypePropertyWithJGJChatMsgListModel:(JGJChatMsgListModel *)msgListModel propertyListType:(JGJChatMsgDBUpdateType)type {
    
    if ([self isEmptyMsgModel:msgListModel]) {
        
        return NO;
    }
    
    BOOL is_success = NO;
    
    WCTPropertyList propertyList = [self propertyListWithPropertyListType:type];
    
    is_success = [msgDBManger.table updateRowsOnProperties:propertyList withObject:msgListModel where:[self comConWithChatMsgModel:msgListModel] && JGJChatMsgListModel.sendType == JGJChatListSendStart || JGJChatMsgListModel.sendType == JGJChatListSending];
    
    return is_success;
    
}

/**
 * 更新当前组消息
 *
 **/
+ (BOOL)updateGroupMsgRowPropertyWithJGJChatMsgListModel:(JGJChatMsgListModel *)msgListModel propertyListType:(JGJChatMsgDBUpdateType)type {
    
    if ([self isEmptyMsgModel:msgListModel]) {
        
        return NO;
    }
    
    BOOL is_success = NO;
    
    WCTPropertyList propertyList = [self propertyListWithPropertyListType:type];
    
    is_success = [msgDBManger.table updateRowsOnProperties:propertyList withObject:msgListModel where:[self comConWithChatMsgModel:msgListModel]];
    
    return is_success;
}

/**
 * 更新当前消息用户的姓名
 *
 **/
+ (BOOL)updateUserInfoRowPropertyWithJGJChatMsgListModel:(JGJChatMsgListModel *)msgListModel propertyListType:(JGJChatMsgDBUpdateType)type {
    
    if ([self isEmptyMsgModel:msgListModel]) {
        
        return NO;
    }
    
    BOOL is_success = NO;
    
    NSString *user_id = [TYUserDefaults objectForKey:JLGUserUid];
    
    WCTCondition condition ;
    
    condition = JGJChatMsgListModel.group_id == msgListModel.group_id && JGJChatMsgListModel.class_type == msgListModel.class_type && JGJChatMsgListModel.user_unique == user_id && JGJChatMsgListModel.msg_sender == msgListModel.msg_sender;
    
    WCTPropertyList propertyList = [self propertyListWithPropertyListType:type];
    
    is_success = [msgDBManger.table updateRowsOnProperties:propertyList withObject:msgListModel where:condition];
    
    return is_success;
    
}

/**
 * 删除当前组消息根据消息id或者msg删除
 *
 **/
+(BOOL)delMsgModel:(JGJChatMsgListModel *)msgModel {
    
    if ([self isEmptyMsgModel:msgModel]) {
        
        return NO;
    }
    
    BOOL is_success = [msgDBManger.table deleteObjectsWhere:[self comConWithChatMsgModel:msgModel] && JGJChatMsgListModel.msg_id == msgModel.msg_id || JGJChatMsgListModel.local_id == msgModel.local_id];
    
    return is_success;
    
}

/**
 * 删除当前组消息
 *
 **/
+(BOOL)delGroupMsgModel:(JGJChatMsgListModel *)msgModel {
    
    if ([self isEmptyMsgModel:msgModel]) {
        
        return NO;
    }
    
    BOOL is_success = [msgDBManger.table deleteObjectsWhere:[self comConWithChatMsgModel:msgModel]];
    
    // 删除对应的聊聊列表最新消息
    JGJChatGroupListModel *groupModel = [JGJChatMsgDBManger getChatGroupListModelWithGroup_id:msgModel.group_id classType:msgModel.class_type];
    groupModel.last_send_uid = @"";
    groupModel.last_msg_type = @"";
    groupModel.last_msg_send_time = @"";
    groupModel.last_send_name = @"";
    groupModel.sys_msg_type = @"";
    groupModel.max_asked_msg_id = @"";
    groupModel.msg_text = @"";
    groupModel.at_message = @"";
    groupModel.last_msg_content = @"";
    groupModel.chat_unread_msg_count = @"0";
    
    BOOL deleteLastMessageSuccess = [JGJChatMsgDBManger updateNew_Chat_MsgToGroupTableWithGroupListModel:groupModel];
    return is_success;
    
}

+(NSArray *)sortMsgList:(NSArray *)msgList {
        
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"wcdb_msg_id" ascending:YES];
    
    NSArray *sortArray = [msgList sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    return sortArray;
}

/**
 * 初始化排重数据
 *
 **/
+(void)initialRepetMutableSet {
    
    NSMutableSet *existMsgIdsSet = [[NSMutableSet alloc] init];
    
    msgDBManger.existMsgIdsSet = existMsgIdsSet;
    
    NSMutableSet *unExistMsgIdsSet = [[NSMutableSet alloc] init];
    
    msgDBManger.unExistMsgIdsSet = unExistMsgIdsSet;
    
}

#pragma mark - 时间排序

+(NSArray *)sortMsgSendTimeList:(NSArray *)msgList {
    
    NSMutableSet *existMsgIdsSet = msgDBManger.existMsgIdsSet;
    
    NSMutableSet *unExistMsgIdsSet = msgDBManger.unExistMsgIdsSet;
    
    NSMutableArray *msgs = [[NSMutableArray alloc] init];
    
    for (JGJChatMsgListModel *msgModel in msgList) {
        
        //存在的消息id，排重
        
        NSString *msg_id = msgModel.msg_id;
        
        if (![NSString isEmpty:msg_id]) {
            
            if (![existMsgIdsSet containsObject:msg_id]) {
                
                [msgs addObject:msgModel];
                
                [existMsgIdsSet addObject:msg_id];
                
            }else {
                
                TYLog(@"same_msg_id ====%@", msgModel.msg_id);
            }
            
        }else {
            
            //失败的文字排重
            
            if ([msgModel.msg_type isEqualToString:@"text"]) {
                
                NSString *unique = [NSString stringWithFormat:@"%@%@",msgModel.msg_sender?:@"", msgModel.local_id?:@""];
                
                if (![NSString isEmpty:unique]) {
                    
                    if (![unExistMsgIdsSet containsObject:unique]) {
                        
                        [msgs addObject:msgModel];
                        
                        [unExistMsgIdsSet addObject:unique];
                        
                    }else {
                        
                        TYLog(@"same_msg_id text====%@", unique);
                    }
                    
                }
                
            }
            
            
            //图片排重
            
            if ([msgModel.msg_type isEqualToString:@"pic"]) {
                
                NSString *unique = [NSString stringWithFormat:@"%@%@",msgModel.send_time?:@"", msgModel.assetlocalIdentifier?:@""];
                
                if (![NSString isEmpty:unique]) {
                    
                    if (![unExistMsgIdsSet containsObject:unique]) {
                        
                        [msgs addObject:msgModel];
                        
                        [unExistMsgIdsSet addObject:unique];
                        
                    }else {
                        
                        TYLog(@"same_msg_id pic====%@", unique);
                    }
                    
                }
                
            }
            
            
        }
        
        
    }
    
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"send_time" ascending:YES];
    
    NSArray *sortArray = [msgs sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    return sortArray;
    
}

#pragma mark - 失败的消息没有消息id,排重处理

- (void)unExistMsgIdWithMsgModel:(JGJChatMsgListModel *)msgModel {
    
    NSMutableSet *unExistMsgIdsSet = [[NSMutableSet alloc] init];
    
    //图片排重
    
    if ([msgModel.msg_type isEqualToString:@"pic"]) {
        
        NSString *unique = [NSString stringWithFormat:@"%@%@",msgModel.send_time, msgModel.assetlocalIdentifier];
        
        if ([unExistMsgIdsSet containsObject:unique]) {
            
            [unExistMsgIdsSet addObject:unique];
            
        }
        
    }
    
    
}

+(NSArray *)sortWorkMsgList:(NSArray *)msgList {
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"send_time" ascending:YES];
    
    NSArray *sortArray = [msgList sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    return sortArray;
}

+(WCTPropertyList)propertyListWithPropertyListType:(JGJChatMsgDBUpdateType)type {

    WCTPropertyList PropertyList = {JGJChatMsgListModel.msg_text, JGJChatMsgListModel.unread_members_num, JGJChatMsgListModel.readed_members_num, JGJChatMsgListModel.sendType,JGJChatMsgListModel.voice_long};

    switch (type) {
            
        case JGJChatMsgDBUpdateAllPropertyType:{

                PropertyList = {JGJChatMsgListModel.msg_text, JGJChatMsgListModel.unread_members_num, JGJChatMsgListModel.readed_members_num, JGJChatMsgListModel.sendType, JGJChatMsgListModel.group_name,JGJChatMsgListModel.user_unique,JGJChatMsgListModel.voice_long};
        }

            break;

        case JGJChatMsgDBUpdateContentPropertyType:{

            PropertyList = {JGJChatMsgListModel.msg_text, JGJChatMsgListModel.msg_type};
        }

            break;

        case JGJChatMsgDBUpdateServicePicPropertyType:{

            PropertyList = {JGJChatMsgListModel.server_head_pic};
        }

            break;
            
        case JGJChatMsgDBUpdateUnreadMembersNumPropertyType:{
            
             PropertyList = {JGJChatMsgListModel.unread_members_num};
        }
            
             break;
            
        case JGJChatMsgDBUpdateIsReadedPropertyType:{
            
            PropertyList = {JGJChatMsgListModel.is_readed};
        }
            
            break;
            
        case JGJChatMsgDBUpdateIsReceivedPropertyType:{
            
            PropertyList = {JGJChatMsgListModel.is_received};
        }
            
            break;
            
        case JGJChatMsgDBUpdateSendMsgStatusPropertyType:{
            
            PropertyList = {JGJChatMsgListModel.sendType};
        }
            
            break;
            
        case JGJChatMsgDBUpdateIsPlayVoicePropertyType:{
            
            PropertyList = {JGJChatMsgListModel.isplayed};
        }
            
            break;
            
        case JGJChatMsgDBUpdateUserInfoPropertyType:{
            
            PropertyList = {JGJChatMsgListModel.wcdb_user_info};
        }
            
            break;
            
        case JGJChatMsgDBUpdateAtMessagePropertyType:{
            
            PropertyList = {JGJChatMsgListModel.at_message};
        }
            
            break;
            
        case JGJChatMsgDBUpdateRecallPropertyType:{
            
            PropertyList = {JGJChatMsgListModel.msg_text, JGJChatMsgListModel.msg_type};
        }
            break;
            
            
        case JGJChatMsgDBUpdateSendMsgSuccessPropertyType:{
            
            PropertyList = {JGJChatMsgListModel.sendType, JGJChatMsgListModel.send_time, JGJChatMsgListModel.msg_id,JGJChatMsgListModel.wcdb_msg_id,JGJChatMsgListModel.unread_members_num};
        }
            
            break;
            

        default:{
            //打开要报错
//            PropertyList = JGJChatMsgListModel.AllProperties;
        }
            break;
    }

    return PropertyList;

}

+(WCTCondition)comConWithChatMsgModel:(JGJChatMsgListModel *)msgModel {
    
    NSString *user_id = [TYUserDefaults objectForKey:JLGUserUid];
    
    WCTCondition condition ;
    
    if (msgModel.msg_total_type == JGJChatNormalMsgType || msgModel.msg_total_type == JGJChatMsgSystemType) {
        
        condition = JGJChatMsgListModel.group_id == msgModel.group_id && JGJChatMsgListModel.class_type == msgModel.class_type  && JGJChatMsgListModel.work_message != 1 && JGJChatMsgListModel.user_unique == user_id;
        
    }else {
        
        condition = JGJChatMsgListModel.msg_total_type == msgModel.msg_total_type && JGJChatMsgListModel.user_unique == user_id;
    }
    
    return condition;
}

//排序的条件普通消息加上质量、安全、日志、通知
+(WCTCondition)sortConWithChatMsgModel:(JGJChatMsgListModel *)msgModel {
    
    NSString *user_id = [TYUserDefaults objectForKey:JLGUserUid];

    NSInteger work_message = msgModel.work_message;
    
    WCTCondition condition = JGJChatMsgListModel.group_id == msgModel.group_id && JGJChatMsgListModel.class_type == msgModel.class_type && JGJChatMsgListModel.work_message != 1 && JGJChatMsgListModel.user_unique == user_id;
    
    return condition;
}

+(BOOL)isEmptyMsgModel:(JGJChatMsgListModel *)msgModel {
    
    BOOL isEmpty = NO;
    
    if ([NSString isEmpty:msgModel.class_type] || [NSString isEmpty:msgModel.group_id]) {
        
        isEmpty = YES;
    }
    
    return isEmpty;
}

+ (NSString *)localID{
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970]*1000;
    
    NSString *timeID = [NSString stringWithFormat:@"%.lf", time];
    
    return timeID;
    
}

#pragma mark - 加入时间用
+ (NSString *)localTime{
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    
    NSString *timeID = [NSString stringWithFormat:@"%.lf", time];
    
    return timeID;
}

+ (JGJChatMsgListModel *)containSpecialWordsWithMsgModel:(JGJChatMsgListModel *)msgModel {
    
    NSString *coverwords = nil;
    
    NSArray *coverwordArr = [@"汇款、金额、钱、转账、回款、红包、中奖" componentsSeparatedByString:@"、"];
    
    BOOL is_contain = NO;
    
    for (NSString *word in coverwordArr) {
        
        if ([msgModel.msg_text containsString:word]) {
            
            is_contain = YES;
                        
            break;
        }
        
    }
    
    JGJChatMsgListModel *coverMsgModel = nil;
    
    if (is_contain) {
        
        coverMsgModel = [[JGJChatMsgListModel alloc] init];
        
        coverMsgModel.msg_text = JGJSpecialWords;
        
        coverMsgModel.sys_msg_type = @"system";
        
        coverMsgModel.msg_id = msgModel.msg_id;
        
        //主要是用这个人的uid,判断每条消息都有一个uid,也可以用自己的uid

        JGJChatUserInfoModel *user_info = [[JGJChatUserInfoModel alloc] init];
        
        user_info.uid = [TYUserDefaults objectForKey:JLGUserUid];
        
        coverMsgModel.user_info = user_info;
        
        //同一个组
        coverMsgModel.class_type = msgModel.class_type;
        
        coverMsgModel.group_id = msgModel.group_id;
        
    }
    
    return coverMsgModel;
}

#pragma mark - 招工包含的特殊文字

+ (JGJChatMsgListModel *)jobContainSpecialWordsWithMsgModel:(JGJChatMsgListModel *)msgModel {
    
    NSString *coverwords = nil;
    
    NSArray *coverwordArr = [@"找工作、招聘、招工、找活、包工" componentsSeparatedByString:@"、"];
    
    BOOL is_contain = NO;
    
    for (NSString *word in coverwordArr) {
        
        if ([msgModel.msg_text containsString:word]) {
            
            is_contain = YES;
            
            break;
        }
        
    }
    
    JGJChatMsgListModel *coverMsgModel = nil;
    
    if (is_contain) {
        
        coverMsgModel = [[JGJChatMsgListModel alloc] init];
        
        coverMsgModel.msg_text = JGJSpecialJobWords;
        
        coverMsgModel.sys_msg_type = @"system";
        
        coverMsgModel.msg_id = msgModel.msg_id;
        
        //主要是用这个人的uid,判断每条消息都有一个uid,也可以用自己的uid
        
        JGJChatUserInfoModel *user_info = [[JGJChatUserInfoModel alloc] init];
        
        user_info.uid = [TYUserDefaults objectForKey:JLGUserUid];
        
        coverMsgModel.user_info = user_info;
        
        //同一个组
        coverMsgModel.class_type = msgModel.class_type;
        
        coverMsgModel.group_id = msgModel.group_id;
        
    }
    
    return coverMsgModel;
}

/**
 * 聊天消息从数据库获取
 *
 **/
+ (NSArray *)getChatMsgModel:(JGJChatMsgListModel *)msgModel {
    
    if ([self isEmptyMsgModel:msgModel] || [NSString isEmpty:msgModel.msg_id]) {
        
        return nil;
    }
    
    NSArray *msgModels = [msgDBManger.table getObjectsWhere:[self sortConWithChatMsgModel:msgModel] &&  JGJChatMsgListModel.wcdb_msg_id > msgModel.wcdb_msg_id orderBy:{JGJChatMsgListModel.send_time.order(WCTOrderedDescending),JGJChatMsgListModel.wcdb_msg_id.order(WCTOrderedDescending)}];
    
//    msgModels = [self sortMsgList:msgModels];
    
    return msgModels;
}

/**
 * 更新发送消息的msg_id,和未读消息人数
 *
 **/
+(BOOL)updateSendMessageWithMsgModel:(JGJChatMsgListModel *)msgModel {
    
    BOOL is_success = NO;
    
    if ([self isEmptyMsgModel:msgModel] || [NSString isEmpty:msgModel.msg_id]) {
        
        return is_success;
    }
    
    msgModel.sendType = JGJChatListSendSuccess;
    
    if ([self isExistMsgLocalIdModelWithMsgModel:msgModel]) {
        
        WCTPropertyList propertyList = {JGJChatMsgListModel.msg_id, JGJChatMsgListModel.unread_members_num, JGJChatMsgListModel.sendType};
        
        is_success = [msgDBManger.table updateRowsOnProperties:propertyList withObject:msgModel where:JGJChatMsgListModel.local_id == msgModel.local_id && [self comConWithChatMsgModel:msgModel]];
    }
    
    return is_success;
}

/**
 * 更新撤回消息
 *
 **/

+ (BOOL)updateRecallWithMsgModel:(JGJChatMsgListModel *)msgModel propertyListType:(JGJChatMsgDBUpdateType)type {
    
    BOOL is_success = NO;
    
    if ([self isEmptyMsgModel:msgModel] || [NSString isEmpty:msgModel.msg_id]) {
        
        return is_success;
    }
    
    NSString *user_id = [TYUserDefaults objectForKey:JLGUserUid];
    
    WCTPropertyList propertyList = {JGJChatMsgListModel.msg_text,JGJChatMsgListModel.msg_type};
    
    WCTCondition condition = JGJChatMsgListModel.group_id == msgModel.group_id && JGJChatMsgListModel.class_type == msgModel.class_type && JGJChatMsgListModel.msg_id == msgModel.msg_id && JGJChatMsgListModel.user_unique == user_id;
    
    is_success = [msgDBManger.table updateRowsOnProperties:propertyList withObject:msgModel where:condition ];
    
    return is_success;
    
}

/**
 * 筛选掉个人端班组信息
 *
 **/

+(NSArray *)filterGroupMsgs:(NSArray *)msgs {
    
    NSArray *filterMsg_types = @[@"group",@"evaluate",@"demandSyncBill",@"syncBillToYou",@"agreeSyncBill",@"refuseSyncBill",@"cancellSyncBill"];
    
    NSMutableArray *filters = [[NSMutableArray alloc] init];
    
    BOOL is_can = NO;
    
    for (NSInteger index = 0; index < msgs.count; index++) {
        
        JGJChatMsgListModel *msgModel = msgs[index];
        
        is_can = NO;
        
        if (![NSString isEmpty:msgModel.msg_type]) {
            
            if ([filterMsg_types containsObject:msgModel.msg_type]) {
                
               is_can = YES;
                
            }
        }
        
        if (![NSString isEmpty:msgModel.class_type]) {
            
            if ([filterMsg_types containsObject:msgModel.class_type]) {
                
                is_can = YES;
                
            }
        }
        
        if (![NSString isEmpty:msgModel.origin_class_type]) {
            
            if ([filterMsg_types containsObject:msgModel.origin_class_type]) {
                
                is_can = YES;
                
            }
        }
        
        //能添加
        
        if (!is_can) {
            
            [filters addObject:msgModel];
            
        }
        
    }
    
    return filters;
    
}

/**
 * 更新发送消息的msg_id,和未读消息人数
 *
 **/
+(BOOL)updateSendMessageUnreadNumWithMsgModel:(JGJChatMsgListModel *)msgModel {
    
    if ([NSString isEmpty:msgModel.msg_id]) {
        
        return NO;
    }
    
    WCTPropertyList propertyList = [self propertyListWithPropertyListType:JGJChatMsgDBUpdateUnreadMembersNumPropertyType];
    
    WCTCondition condition = JGJChatMsgListModel.msg_id == msgModel.msg_id;
    
    BOOL is_success = [msgDBManger.table updateRowsOnProperties:propertyList withObject:msgModel where:condition];
    
    return is_success;
    
}

/**
 * 点击用户头像到他的资料更新用户信息头像
 *
 **/
+ (BOOL)updateUserInfoWithMsgModel:(JGJChatMsgListModel *)msgModel{
    
    WCTPropertyList PropertyList = {JGJChatMsgListModel.modify_head_pic};
    
    JGJChatMsgListModel *oldMsgModel = [self getMaxUserMsgModel:msgModel];
    
    NSString *headPic = msgModel.modify_head_pic;
    
    BOOL is_success = NO;
    
    TYLog(@"111===headPic---%@   /n oldheadPic---%@", headPic, oldMsgModel.user_info.head_pic);
    
    if (![NSString isEmpty:headPic]) {
        
        if (![headPic isEqualToString:oldMsgModel.user_info.head_pic]) {
            
            is_success =  [msgDBManger.table updateRowsOnProperties:PropertyList withObject:msgModel where:JGJChatMsgListModel.msg_sender == msgModel.msg_sender];
            
        }else {
            
            TYLog(@"headPic---%@   /n oldheadPic---%@", headPic, oldMsgModel.user_info.head_pic);
            
        }
        
    }
    
    
    
    return is_success;
}

/**
 * 插入图片消息信息
 *
 **/

+ (BOOL)insertToSendPicMsgTableWithMsgListModel:(JGJChatMsgListModel *)msgListModel{
    
    BOOL is_success = NO;
    
    //插入的时候当前存入时间为准
    
    //    msgListModel.send_time = [JGJChatMsgDBManger localTime];
    
    if (![self isExistMsgLocalIdModelWithMsgModel:msgListModel]) {
        
        is_success = [msgDBManger.table insertObject:msgListModel];
        
    }
    
    return is_success;
    
}

/**
 * 更新发送图片消息的msg_id,和未读消息人数
 *
 **/

+(BOOL)updateSendPicMsgWithMsgModel:(JGJChatMsgListModel *)msgModel {
    
    BOOL is_success = NO;
    
    NSString *local_id = msgModel.local_id;
    
    if ([NSString isEmpty:local_id] || [NSString isEmpty:msgModel.group_id] || [NSString isEmpty:msgModel.class_type] || [NSString isEmpty:msgModel.msg_id]) {
        
        return NO;
    }
    
    if ([local_id isEqualToString:@"0"]) {
        
        return NO;
    }
    
    if ([self isExistMsgLocalIdModelWithMsgModel:msgModel]) {
        
        msgModel.wcdb_msg_id = [msgModel.msg_id longLongValue];
        
        WCTPropertyList propertyList = {JGJChatMsgListModel.sendType, JGJChatMsgListModel.msg_src,JGJChatMsgListModel.msg_id,JGJChatMsgListModel.wcdb_msg_id, JGJChatMsgListModel.send_time};
        
        is_success = [msgDBManger.table updateRowsOnProperties:propertyList withObject:msgModel where:JGJChatMsgListModel.local_id == msgModel.local_id && [self comConWithChatMsgModel:msgModel] && JGJChatMsgListModel.msg_type == msgModel.msg_type];
        
    }
    
    if (is_success) {
        
        TYLog(@"更新图片消息assetlocalIdentifier---------%@ -----%@ ------%@---%@----%@---%@----%@--%@",msgModel.assetlocalIdentifier, msgModel.group_id, msgModel.class_type, msgModel.msg_src, @(msgModel.unread_members_num), msgModel.msg_type,msgModel.msg_id,msgModel.send_time);
        
    }
    
    return is_success;
    
}

@end
