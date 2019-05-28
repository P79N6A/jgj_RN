//
//  JGJNewNotifyTool.m
//  mix
//
//  Created by YJ on 16/8/26.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJNewNotifyTool.h"
#import "FMDB.h"
#import "NSDate+Extend.h"

#define UserUid [TYUserDefaults objectForKey:JLGPhone]
@interface JGJNewNotifyTool ()
@end

@implementation JGJNewNotifyTool

static FMDatabase *_db;
static JGJNewNotifyTool *_notifyTool;
+ (instancetype)shareNotifyTool
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _notifyTool = [[self alloc] init];
        [self updateNoticeListNetData];
    });
    return _notifyTool;
}
+ (void)initialize {

    // 1.打开数据库
    NSString *file = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"notify.sqlite"];
    _db = [FMDatabase databaseWithPath:file];
    if (![_db open]) return;
    
    // 2.创表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_collect_notify(id integer PRIMARY KEY, notify blob NOT NULL, class_type text NOT NULL, notice_id text NOT NULL, date text NOT NULL, isReaded text NOT NULL, userUid text NOT NULL);"];
}

+ (NSArray *)collectNotifies:(int)page {
    int size = 10;
    int pos = (page - 1) * size;
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT * FROM t_collect_notify ORDER BY id DESC LIMIT %d,%d;", pos, size];
    NSMutableArray *notifyModels = [NSMutableArray array];
    while (set.next) {
        JGJNewNotifyModel *notifyModel = [NSKeyedUnarchiver unarchiveObjectWithData:[set objectForColumnName:@"notify"]];
        [notifyModels addObject:notifyModel];
    }
    return notifyModels;
}

+ (NSArray *)allNotifies {
    NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM t_collect_notify WHERE userUid = %@ ORDER BY date DESC", UserUid];
    FMResultSet *set = [_db executeQuery:querySql];
    NSMutableArray *notifyModels = [NSMutableArray array];
    while (set.next) {
        JGJNewNotifyModel *notifyModel = [NSKeyedUnarchiver unarchiveObjectWithData:[set objectForColumnName:@"notify"]];
        [notifyModels addObject:notifyModel];
    }
    return notifyModels;
}

#pragma mark - 点击新通知查看时除，同步项目、加入班组外其余传给服务器 每次传入未读数据
+ (NSArray *)allReadedNofies {
     NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM t_collect_notify WHERE userUid = %@ AND isReaded = '0'", UserUid];
    FMResultSet *set = [_db executeQuery:querySql];
    NSMutableArray *readNotifyIDs = [NSMutableArray array];
    while (set.next) {
        NSArray *classtypes = @[@"syncProject",@"newBilling"];
        NSString *classType = [set objectForColumnName:@"class_type"];
        NSString *notified = [set objectForColumnName:@"notice_id"];
        if (![classtypes containsObject:classType]) {
            [readNotifyIDs addObject:notified];
        }
    }
    NSString *updateSql = [NSString stringWithFormat:@"update t_collect_notify set isReaded=1 where userUid=%@ and class_type!='syncProject'  and  class_type!='newBilling'", UserUid];
    [_db executeUpdate:updateSql];
    return readNotifyIDs;
}

+ (NSString *)allUnReadedNofies {
    NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM t_collect_notify WHERE userUid = %@ AND isReaded = '0'", UserUid];
    FMResultSet *set = [_db executeQuery:querySql];
    NSMutableArray *unReadNotifyIDs = [NSMutableArray array];
    while (set.next) {
        NSString *notified = [set objectForColumnName:@"notice_id"];
        [unReadNotifyIDs addObject:notified];
    }
    NSString *unReaded = [NSString stringWithFormat:@"%@", @(unReadNotifyIDs.count)];
    return unReaded;
}


//+ (BOOL)executeNotifyUpdateNotifyField:(NSString *)notifyField notifyValue:(NSString *)notifyValue {
//    return [_db executeUpdateWithFormat:@"%@ = %@", notifyField, notifyValue];
//}

+ (BOOL)addCollectNotifies:(JGJNewNotifyModel *)notifyModel
{
    if ([NSString isEmpty:notifyModel.date]) {
        
        notifyModel.date = @"";
    }
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:notifyModel];
   return  [_db executeUpdateWithFormat:@"INSERT INTO t_collect_notify(notify, class_type, notice_id, date,isReaded, userUid) VALUES(%@, %@, %@, %@, %@, %@);", data, notifyModel.class_type,notifyModel.notice_id, notifyModel.date, @(notifyModel.isReaded), UserUid];
}

+ (BOOL)removeCollectNotify:(JGJNewNotifyModel *)notifyModel
{
  return  [_db executeUpdateWithFormat:@"DELETE FROM t_collect_notify WHERE notice_id = %@ AND userUid = %@;", notifyModel.notice_id, UserUid];
}

////这个表格里面是否包含这个数据
//+ (BOOL)isExistNotifyModel:(JGJNewNotifyModel *)notifyModel {
//    FMResultSet *set = [_db executeQuery:@"SELECT * FROM t_collect_notify where notice_id = %@;",notifyModel.notice_id];
//    return [set next];
//}

+ (BOOL)isExistNotifyModel:(JGJNewNotifyModel *)notifyModel
{
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT count(*) AS notify_count FROM t_collect_notify WHERE notice_id = %@ AND userUid = %@;", notifyModel.notice_id, UserUid];
    [set next];
    return [set intForColumn:@"notify_count"] == 1;
}

+ (BOOL)updateNotifyModel:(JGJNewNotifyModel *)notifyModel {
    BOOL isUpdate = NO;
    if ([self removeCollectNotify:notifyModel]) {
       isUpdate = [self addCollectNotifies:notifyModel];
    }
    return isUpdate;
}

#pragma mark - 获取通知最新信息
+ (void)updateNoticeListNetData {
    NSDictionary *body = @{
                           @"ctrl" : @"notice",
                           @"action": @"noticeList"
                           };
    [JGJSocketRequest WebSocketWithParameters:body success:^(id responseObject) {
        [_notifyTool handleSuccessGetNoticeList:responseObject];
    } failure:nil];
}

#pragma mark - 成功得到通知信息后存储新数据、返回未读的数据
- (void)handleSuccessGetNoticeList:(id)responseObject {
    NSArray *arr = [JGJNewNotifyModel mj_objectArrayWithKeyValuesArray:responseObject];
    for (JGJNewNotifyModel *notifyModel in arr) {
        BOOL isExist = [JGJNewNotifyTool isExistNotifyModel:notifyModel];
        if (!isExist) {
            [JGJNewNotifyTool addCollectNotifies:notifyModel];
        }
    }
    if (_notifyTool.notifyToolBlock && arr.count > 0) {
        _notifyTool.notifyToolBlock();
    }
}
@end
