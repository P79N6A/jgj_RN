//
//  JGJknowledgeDownloadTool.m
//  mix
//
//  Created by yj on 2018/7/16.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJknowledgeDownloadTool.h"

#import "FMDB.h"

#import "NSString+File.h"

#define UserUid [TYUserDefaults objectForKey:JLGPhone]

@implementation JGJknowledgeDownloadTool

static FMDatabase *_db;

static JGJknowledgeDownloadTool *_tool;

+ (void)initialize {
    
    // 1.打开数据库
    NSString *file = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"knowledgeDownload.sqlite"];
    _db = [FMDatabase databaseWithPath:file];
    if (![_db open]) return;
    
    // 2.创表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_collect_knowledge(id integer PRIMARY KEY, knowBaseModel blob NOT NULL, knowBaseId text NOT NULL, date text NOT NULL, userUid text NOT NULL);"];
}

+ (NSArray *)allknowBaseModels {
    
    NSString *querySql = @"SELECT * FROM t_collect_knowledge ORDER BY date DESC";
    
    FMResultSet *set = [_db executeQuery:querySql];
    
    NSMutableArray *allModels = [NSMutableArray array];
    
    while (set.next) {
        
        JGJKnowBaseModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:[set objectForColumnName:@"knowBaseModel"]];
        
        [allModels addObject:model];
        
    }
    
    return allModels;
}

+ (BOOL)addCollectKnowBaseModel:(JGJKnowBaseModel *)model
{

    if ([self isExistKnowBaseModel:model]) {
        
        //已存在
        
        TYLog(@"已存在 ==== %@", model.file_name);
        return NO;
    }
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
    
    BOOL isSuccess = [_db executeUpdateWithFormat:@"INSERT INTO t_collect_knowledge(knowBaseModel, knowBaseId, date, userUid) VALUES(%@, %@, %@, %@);", data, model.knowBaseId, model.downloaddate,  UserUid];
    
    TYLog(@"已添加 ==== %@ isSuccess=====%@", model.file_name, @(isSuccess));
    
    return  isSuccess;
    
}

+ (BOOL)removeCollectKnowBaseModel:(JGJKnowBaseModel *)model
{
    BOOL isSuccess = [_db executeUpdateWithFormat:@"DELETE FROM t_collect_knowledge WHERE knowBaseId = %@ AND userUid = %@;", model.knowBaseId, UserUid];
    
    if (isSuccess) {
        
        NSString *saveFileName = [NSString stringWithFormat:@"Documents/%@.%@",model.file_name, model.file_type];
        
        NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:saveFileName];
        
        [NSString removeFileByPath:filePath];
        
    }

    return  isSuccess;
}

#pragma mark - 统计数量取的名字是notify_count
+ (BOOL)isExistKnowBaseModel:(JGJKnowBaseModel *)model
{
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT count(*) AS knowBase_count FROM t_collect_knowledge WHERE knowBaseId = %@ AND userUid = %@;", model.knowBaseId, UserUid];
    [set next];
    return [set intForColumn:@"knowBase_count"] == 1;
}

@end
