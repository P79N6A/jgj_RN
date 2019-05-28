//
//  JGJChatListTool.m
//  mix
//
//  Created by Tony on 2016/9/5.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatListTool.h"
#import "FMDB.h"
#import "NSString+Extend.h"
#import "AudioRecordingServices.h"

//每页显示多少个
#define kChatListPageSize 10

#ifdef DEBUG
#define JGJChatListToolLog(...) do { } while (0);//NSLog(@"\n\nTony调试\n函数:%s 行号:%d\n打印信息:%@\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define JGJChatListToolLog(...) do { } while (0);
#endif

@implementation JGJChatListTool
static FMDatabase *_db;
static NSString *_audioCacheFile;

- (FMDatabase *)getDb{
    return _db;
}

+ (void)deleteSqlite {
    // 1.打开数据库
    NSString *file = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"jgj_chatlist_data.sqlite"];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    BOOL bRet = [fileMgr fileExistsAtPath:file];
    if (bRet) {
        NSError *err;
        [fileMgr removeItemAtPath:file error:&err];
    }
}

+ (void)initialize {
    
    // 1.打开数据库
    NSString *file = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"jgj_chatlist_data.sqlite"];
    
    _db = [FMDatabase databaseWithPath:file];
    if (![_db open]) return;
    
    // 2.创表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS jgj_chatlist_data (id integer PRIMARY KEY,group_id integer, msg_id integer, msg_type text,belongType int,data blob,local_id text,is_readed text,token text,class_type text);"];
    
    if (!_audioCacheFile) {
        _audioCacheFile = [AudioRecordingServices getCacheDirectory];
    }
    //[_db close];
}

+ (NSArray *)getOrigiChatMessage:(JGJMyWorkCircleProListModel *)workProListModel msgID:(NSString *)msg_id msgType:(NSString *)msg_type{
    
    FMResultSet *set;
    if ([msg_type isEqualToString:@"all"]) {
        set = [_db executeQueryWithFormat:@"SELECT * FROM jgj_chatlist_data WHERE class_type = %@ AND group_id = %@ AND token = %@ AND msg_id<=%@ ORDER BY msg_id DESC,msg_id LIMIT 0,10;",workProListModel.class_type,workProListModel.group_id,workProListModel.token,msg_id];
        
        JGJChatListToolLog(@"getOrigiChatMessage :%@",[NSString stringWithFormat:@"SELECT * FROM jgj_chatlist_data WHERE class_type = %@ AND group_id = %@ AND token = %@ AND msg_id<=%@ ORDER BY msg_id DESC,msg_id LIMIT 0,10;",workProListModel.class_type,workProListModel.group_id,workProListModel.token,msg_id]);
    }else{
        set = [_db executeQueryWithFormat:@"SELECT * FROM jgj_chatlist_data WHERE class_type = %@ AND group_id = %@ AND msg_type = %@ AND token = %@ AND msg_id<=%@ ORDER BY msg_id DESC,msg_id LIMIT 0,10;",workProListModel.class_type,workProListModel.group_id,msg_type,workProListModel.token,msg_id];
        JGJChatListToolLog(@"getOrigiChatMessage :%@",[NSString stringWithFormat:@"SELECT * FROM jgj_chatlist_data WHERE class_type = %@ AND group_id = %@ AND msg_type = %@ AND token = %@ AND msg_id<=%@ ORDER BY msg_id DESC,msg_id LIMIT 0,10;",workProListModel.class_type,workProListModel.group_id,msg_type,workProListModel.token,msg_id]);
    }
    
    
    NSMutableArray *chatListModels = [NSMutableArray array];
    while (set.next) {
        if (![[set objectForColumnName:@"data"] isEqual:[NSNull null]]) {
            JGJChatMsgListModel *chatMsgListModel = [NSKeyedUnarchiver unarchiveObjectWithData:[set objectForColumnName:@"data"]];
            
            //如果是音频文件，就转换一次，因为每次启动的时候，路径都会变化
            if (chatMsgListModel.voice_filePath) {
                NSString *voice_filePath = chatMsgListModel.voice_filePath;
                NSArray *fileNameArr = [voice_filePath componentsSeparatedByString:@"/"];
                
                chatMsgListModel.voice_filePath = [_audioCacheFile stringByAppendingString:[NSString stringWithFormat:@"/%@",[fileNameArr lastObject]]];
            }

            [chatListModels addObject:chatMsgListModel];
        }
        
    }
    
    //[_db close];
    return [[chatListModels reverseObjectEnumerator] allObjects];
}

+ (NSArray *)getOrigiMergeChatMessage:(JGJMyWorkCircleProListModel *)workProListModel msgID:(NSString *)msg_id msgType:(NSString *)msg_type{
    
    FMResultSet *set;
    if ([msg_type isEqualToString:@"all"]) {
        set = [_db executeQueryWithFormat:@"SELECT * FROM jgj_chatlist_data WHERE class_type = %@ AND group_id = %@ AND token = %@ AND msg_id<=%@ AND msg_id >%@ ORDER BY msg_id DESC,msg_id LIMIT 0,10;",workProListModel.class_type,workProListModel.group_id,workProListModel.token,msg_id,workProListModel.merge_last_msg_id];
        
        JGJChatListToolLog(@"getOrigiChatMessage :%@",[NSString stringWithFormat:@"SELECT * FROM jgj_chatlist_data WHERE class_type = %@ AND group_id = %@ AND token = %@ AND msg_id<=%@ AND msg_id >%@ ORDER BY msg_id DESC,msg_id LIMIT 0,10;",workProListModel.class_type,workProListModel.group_id,workProListModel.token,msg_id,workProListModel.merge_last_msg_id]);
    }else{
        set = [_db executeQueryWithFormat:@"SELECT * FROM jgj_chatlist_data WHERE class_type = %@ AND group_id = %@ AND msg_type = %@ AND token = %@ AND msg_id<=%@ AND msg_id >%@ ORDER BY msg_id DESC,msg_id LIMIT 0,10;",workProListModel.class_type,workProListModel.group_id,msg_type,workProListModel.token,msg_id,workProListModel.merge_last_msg_id];
        JGJChatListToolLog(@"getOrigiChatMessage :%@",[NSString stringWithFormat:@"SELECT * FROM jgj_chatlist_data WHERE class_type = %@ AND group_id = %@ AND msg_type = %@ AND token = %@ AND msg_id<=%@ AND msg_id >%@ ORDER BY msg_id DESC,msg_id LIMIT 0,10;",workProListModel.class_type,workProListModel.group_id,msg_type,workProListModel.token,msg_id,workProListModel.merge_last_msg_id]);
    }
    
    
    NSMutableArray *chatListModels = [NSMutableArray array];
    while (set.next) {
        if (![[set objectForColumnName:@"data"] isEqual:[NSNull null]]) {
            JGJChatMsgListModel *chatMsgListModel = [NSKeyedUnarchiver unarchiveObjectWithData:[set objectForColumnName:@"data"]];
            
            //如果是音频文件，就转换一次，因为每次启动的时候，路径都会变化
            if (chatMsgListModel.voice_filePath) {
                NSString *voice_filePath = chatMsgListModel.voice_filePath;
                NSArray *fileNameArr = [voice_filePath componentsSeparatedByString:@"/"];
                
                chatMsgListModel.voice_filePath = [_audioCacheFile stringByAppendingString:[NSString stringWithFormat:@"/%@",[fileNameArr lastObject]]];
            }
            
            [chatListModels addObject:chatMsgListModel];
        }
        
    }
    
    //[_db close];
    return [[chatListModels reverseObjectEnumerator] allObjects];
}

+ (NSArray *)getUpChatMessage:(JGJMyWorkCircleProListModel *)workProListModel msgID:(NSString *)msg_id msgType:(NSString *)msg_type{
    
    FMResultSet *set;
    if ([msg_type isEqualToString:@"all"]) {
        set = [_db executeQueryWithFormat:@"SELECT * FROM jgj_chatlist_data WHERE class_type = %@ AND group_id = %@ AND token = %@ AND msg_id<%@ AND msg_id >%@ ORDER BY msg_id DESC,msg_id LIMIT 0,10;",workProListModel.class_type,workProListModel.group_id,workProListModel.token,msg_id,workProListModel.merge_last_msg_id];
        JGJChatListToolLog(@"getUpChatMessage :%@",[NSString stringWithFormat:@"SELECT * FROM jgj_chatlist_data WHERE class_type = %@ AND group_id = %@ AND token = %@ AND msg_id<%@ AND msg_id >%@ ORDER BY msg_id DESC,msg_id LIMIT 0,10;",workProListModel.class_type,workProListModel.group_id,workProListModel.token,msg_id,workProListModel.merge_last_msg_id]);
    }else{
        set = [_db executeQueryWithFormat:@"SELECT * FROM jgj_chatlist_data WHERE class_type = %@ AND group_id = %@ AND msg_type = %@ AND token = %@ AND msg_id<%@ AND msg_id >%@ ORDER BY msg_id DESC,msg_id LIMIT 0,10;",workProListModel.class_type,workProListModel.group_id,msg_type,workProListModel.token,msg_id,workProListModel.merge_last_msg_id];
        JGJChatListToolLog(@"getUpChatMessage :%@",[NSString stringWithFormat:@"SELECT * FROM jgj_chatlist_data WHERE class_type = %@ AND group_id = %@ AND msg_type = %@ AND token = %@ AND msg_id<%@ AND msg_id >%@ ORDER BY msg_id DESC,msg_id LIMIT 0,10;",workProListModel.class_type,workProListModel.group_id,msg_type,workProListModel.token,msg_id,workProListModel.merge_last_msg_id]);
    }
    
    NSMutableArray *chatListModels = [NSMutableArray array];
    while (set.next) {
        if (![[set objectForColumnName:@"data"] isEqual:[NSNull null]]) {
            JGJChatMsgListModel *chatMsgListModel = [NSKeyedUnarchiver unarchiveObjectWithData:[set objectForColumnName:@"data"]];
            [chatListModels addObject:chatMsgListModel];
        }
    }
    
    //[_db close];
    return [[chatListModels reverseObjectEnumerator] allObjects];
}

+ (NSArray *)getNextChatMessage:(JGJMyWorkCircleProListModel *)workProListModel msgID:(NSString *)msg_id msgType:(NSString *)msg_type{
    FMResultSet *set;
    if ([msg_type isEqualToString:@"all"]) {
        set = [_db executeQueryWithFormat:@"SELECT * FROM jgj_chatlist_data WHERE class_type = %@ AND group_id = %@ AND token = %@ AND msg_id<%@ ORDER BY msg_id DESC,msg_id LIMIT 0,10;",workProListModel.class_type,workProListModel.group_id,workProListModel.token,msg_id];
        JGJChatListToolLog(@"getNextChatMessage :%@",[NSString stringWithFormat:@"SELECT * FROM jgj_chatlist_data WHERE class_type = %@ AND group_id = %@ AND token = %@ AND msg_id<%@ ORDER BY msg_id DESC,msg_id LIMIT 0,10;",workProListModel.class_type,workProListModel.group_id,workProListModel.token,msg_id]);
    }else{
        set = [_db executeQueryWithFormat:@"SELECT * FROM jgj_chatlist_data WHERE class_type = %@ AND group_id = %@ AND msg_type = %@ AND token = %@ AND msg_id<%@ ORDER BY msg_id DESC,msg_id LIMIT 0,10;",workProListModel.class_type,workProListModel.group_id,msg_type,workProListModel.token,msg_id];
        JGJChatListToolLog(@"getNextChatMessage :%@",[NSString stringWithFormat:@"SELECT * FROM jgj_chatlist_data WHERE class_type = %@ AND group_id = %@ AND msg_type = %@ AND token = %@ AND msg_id<%@ ORDER BY msg_id DESC,msg_id LIMIT 0,10;",workProListModel.class_type,workProListModel.group_id,msg_type,workProListModel.token,msg_id]);
    }
    
    NSMutableArray *chatListModels = [NSMutableArray array];
    while (set.next) {
        if (![[set objectForColumnName:@"data"] isEqual:[NSNull null]]) {
            JGJChatMsgListModel *chatMsgListModel = [NSKeyedUnarchiver unarchiveObjectWithData:[set objectForColumnName:@"data"]];
            [chatListModels addObject:chatMsgListModel];
        }
    }
    
    //[_db close];
    return [[chatListModels reverseObjectEnumerator] allObjects];
}

+ (JGJChatMsgListModel *)getMaxChatMessage:(JGJMyWorkCircleProListModel *)workProListModel{
    //    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT * FROM jgj_chatlist_data WHERE msg_id=( select max(msg_id) FROM  jgj_chatlist_data) AND group_id = %@ AND token = %@ AND class_type = %@;",workProListModel.group_id,workProListModel.token,workProListModel.class_type];
    
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT * FROM jgj_chatlist_data WHERE msg_id=( select max(msg_id) FROM  jgj_chatlist_data WHERE group_id = %@) AND token = %@ AND class_type = %@;",workProListModel.group_id,workProListModel.token,workProListModel.class_type];
    
    JGJChatListToolLog(@"getMaxChatMessage :%@",[NSString stringWithFormat:@"SELECT * FROM jgj_chatlist_data WHERE msg_id=( select max(msg_id) FROM  jgj_chatlist_data WHERE group_id = %@) AND token = %@ AND class_type = %@;",workProListModel.group_id,workProListModel.token,workProListModel.class_type]);
    
//    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT max(msg_id) FROM jgj_chatlist_data WHERE group_id = %@ AND token = %@ AND class_type = %@;",workProListModel.group_id,workProListModel.token,workProListModel.class_type];
//    
//    JGJChatListToolLog(@"getMaxChatMessage :%@",[NSString stringWithFormat:@"SELECT max(msg_id) FROM jgj_chatlist_data WHERE group_id = %@ AND token = %@ AND class_type = %@;",workProListModel.group_id,workProListModel.token,workProListModel.class_type]);
    
    JGJChatMsgListModel *chatMsgListModel;
    if (set.next) {
        if (![[set objectForColumnName:@"data"] isEqual:[NSNull null]]) {
            chatMsgListModel = [NSKeyedUnarchiver unarchiveObjectWithData:[set objectForColumnName:@"data"]];
        }
    }
    
    //[_db close];
    return  chatMsgListModel;
}

+ (BOOL)addOrUpdateChatMessage:(JGJMyWorkCircleProListModel *)workProListModel chatMsgListModel:(JGJChatMsgListModel *)chatMsgListModel
{
    //全部不用保存
    
    return NO;

    //示例数据不用保存
    if (workProListModel.workCircleProType == WorkCircleExampleProType) {
        return NO;
    }
    
    //不存在msg_id不用保存
    if ([NSString isEmpty:chatMsgListModel.msg_id]) {
        return NO;
    }
    
    BOOL isExist = [JGJChatListTool isExistListModel:chatMsgListModel workProListModel:workProListModel];
    
    if (isExist) {//如果存在就不添加
        
        return [JGJChatListTool updateChatMessage:chatMsgListModel];
    }
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:chatMsgListModel];
    
    BOOL isAdd = [_db executeUpdateWithFormat:@"INSERT INTO jgj_chatlist_data (group_id, msg_id, msg_type, belongType, data,local_id,is_readed,token,class_type) VALUES (%@,%@, %@, %@,%@, %@, %@, %@, %@);",chatMsgListModel.group_id,chatMsgListModel.msg_id, chatMsgListModel.msg_type, @(chatMsgListModel.belongType),data,chatMsgListModel.local_id,chatMsgListModel.is_readed,chatMsgListModel.token,workProListModel.class_type];
    
    JGJChatListToolLog(@"addOrUpdateChatMessage :%@",[NSString stringWithFormat:@"INSERT INTO jgj_chatlist_data (group_id, msg_id, msg_type, belongType, data,local_id,is_readed,token,class_type) VALUES (%@,%@, %@, %@,%@, %@, %@, %@, %@);",chatMsgListModel.group_id,chatMsgListModel.msg_id, chatMsgListModel.msg_type, @(chatMsgListModel.belongType),data,chatMsgListModel.local_id,chatMsgListModel.is_readed,chatMsgListModel.token,workProListModel.class_type]);
    
    
    //[_db close];
    return  isAdd;
}

+ (BOOL)deleteChatMessage:(JGJChatMsgListModel *)chatMsgListModel workProListModel:(JGJMyWorkCircleProListModel *)workProListModel
{
    BOOL isDelete = [_db executeUpdateWithFormat:@"DELETE FROM jgj_chatlist_data WHERE group_id = %@ AND msg_id = %@ AND token = %@ AND class_type = %@;", chatMsgListModel.group_id,chatMsgListModel.msg_id,chatMsgListModel.token,workProListModel.class_type];
    
    //[_db close];
    return  isDelete;
}

+ (BOOL)isExistListModel:(JGJChatMsgListModel *)chatMsgListModel workProListModel:(JGJMyWorkCircleProListModel *)workProListModel
{
    FMResultSet *resultSet = [_db executeQueryWithFormat:@"SELECT * FROM jgj_chatlist_data WHERE group_id = %@ AND msg_id = %@ AND token = %@ AND class_type = %@", chatMsgListModel.group_id,chatMsgListModel.msg_id,chatMsgListModel.token,workProListModel.class_type];
    //[_db close];
    
    return [resultSet next];
}

+ (BOOL)updateChatMessage:(JGJChatMsgListModel *)chatMsgListModel
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:chatMsgListModel];
    
    BOOL isUpdate = [_db executeUpdateWithFormat:@"UPDATE jgj_chatlist_data SET data = %@,msg_type = %@,belongType = %@ ,local_id = %@ ,is_readed = %@ WHERE group_id = %@ AND msg_id = %@ AND token = %@ AND class_type = %@;",data,chatMsgListModel.msg_type,@(chatMsgListModel.belongType),chatMsgListModel.local_id,chatMsgListModel.is_readed,chatMsgListModel.group_id,chatMsgListModel.msg_id,chatMsgListModel.token,chatMsgListModel.class_type];
    
    //[_db close];
    return isUpdate;
}

+ (NSString *)localID{
    //取毫秒
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970]*1000;
    NSString *timeID = [NSString stringWithFormat:@"%.lf", time];
    
    return timeID;
}

+ (BOOL)deleteAllChatMessage:(JGJChatMsgListModel *)chatMsgListModel workProListModel:(JGJMyWorkCircleProListModel *)workProListModel {
    
    BOOL isDelete = [_db executeUpdateWithFormat:@"DELETE FROM jgj_chatlist_data WHERE group_id = %@ AND class_type = %@;", chatMsgListModel.group_id, workProListModel.class_type];
    return  isDelete;
}

+ (NSArray *)currentChatAllMsgsWithProListModel:(JGJMyWorkCircleProListModel *)proListModel {
    FMResultSet *set;
    
    set = [_db executeQueryWithFormat:@"SELECT * FROM jgj_chatlist_data WHERE class_type = %@ AND group_id = %@ AND token = %@;",proListModel.class_type,proListModel.group_id,proListModel.token];
    NSMutableArray *chatListModels = [NSMutableArray array];
    while (set.next) {
        JGJChatMsgListModel *chatMsgListModel = [NSKeyedUnarchiver unarchiveObjectWithData:[set objectForColumnName:@"data"]];
        [chatListModels addObject:chatMsgListModel];
    }
    return [[chatListModels reverseObjectEnumerator] allObjects];
}

+ (NSArray *)collectChatMsgModel:(JGJMyWorkCircleProListModel *)workProListModel page:(int)page {
    int size = 10;
    int pos = (page - 1) * size;
    TYLog(@"QQQQQ === %@ ==== %@ === %@", workProListModel.class_type, workProListModel.group_id, workProListModel.token);
    NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM jgj_chatlist_data WHERE class_type = %@ AND group_id = %@ AND token = %@ ORDER BY id DESC LIMIT %d,%d;", workProListModel.class_type,workProListModel.group_id,workProListModel.token, pos, size];
//    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT * FROM jgj_chatlist_data WHERE class_type = %@ AND group_id = %@ AND token = %@ ORDER BY id DESC LIMIT %d,%d;",workProListModel.class_type,workProListModel.group_id,workProListModel.token, pos, size];
    FMResultSet *set = [_db executeQuery:querySql];
//    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT * FROM t_collect_notify ORDER BY id DESC LIMIT %d,%d;", pos, size];
    NSMutableArray *chatListModels = [NSMutableArray array];
    while (set.next) {
        if (![[set objectForColumnName:@"data"] isEqual:[NSNull null]]) {
            JGJChatMsgListModel *chatMsgListModel = [NSKeyedUnarchiver unarchiveObjectWithData:[set objectForColumnName:@"data"]];
            [chatListModels addObject:chatMsgListModel];
        }
    }
    
    //[_db close];
    return [[chatListModels reverseObjectEnumerator] allObjects];
}

#pragma mark - 修改昵称修改数据库，和聊天的临时数据
+ (void)handleModifyTempDataArry:(NSArray *)dataSourceArray modifyChatModel:(JGJChatMsgListModel *)modifyChatModel {

    if ([NSString isEmpty:modifyChatModel.user_name]) {
        
        return;
    }

    JGJMyWorkCircleProListModel *proModel = [JGJMyWorkCircleProListModel new];
    proModel.class_type = modifyChatModel.class_type;
    proModel.group_id = modifyChatModel.group_id;
    NSArray *allMsgs = [JGJChatListTool currentChatAllMsgsWithProListModel:proModel];
    for (JGJChatMsgListModel *chatMsgModel in allMsgs) {
        
        if ([chatMsgModel.uid isEqualToString:modifyChatModel.uid]) {
            
            chatMsgModel.user_name = modifyChatModel.user_name;
            chatMsgModel.real_name = modifyChatModel.user_name;
            
            //修改数据库
            [JGJChatListTool updateChatMessage:chatMsgModel];
            
        }
        
    }
    
    //修改临时数据
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@", modifyChatModel.uid];
    NSArray *chatModels = [dataSourceArray filteredArrayUsingPredicate:predicate];
    
    for (JGJChatMsgListModel *chatMsgModel in chatModels) {
        
        chatMsgModel.user_name = modifyChatModel.user_name;
        chatMsgModel.real_name = modifyChatModel.user_name;
        
    }
    
}

@end
