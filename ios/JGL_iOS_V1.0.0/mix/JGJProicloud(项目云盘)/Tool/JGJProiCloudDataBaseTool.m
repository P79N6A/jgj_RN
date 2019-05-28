//
//  JGJProiCloudDataBaseTool.m
//  JGJCompany
//
//  Created by yj on 2017/7/29.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJProiCloudDataBaseTool.h"

#import "FMDB.h"

#import "NSString+Extend.h"

#import "JGJProiCloudTool.h"

#define UserUid [TYUserDefaults objectForKey:JLGPhone]

static JGJProiCloudDataBaseTool *_proiCloudDataBaseTool;

@implementation JGJProiCloudDataBaseTool

static FMDatabase *_db;

+ (instancetype)shareProiCloudDataBaseTool
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        _proiCloudDataBaseTool = [[self alloc] init];
        
    });
    return _proiCloudDataBaseTool;
}

+ (void)initialize {
    
    // 1.打开数据库
    NSString *file = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"proicloud.sqlite"];
    _db = [FMDatabase databaseWithPath:file];
    if (![_db open]) return;
    
    // 2.创表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_collect_icloud(id integer PRIMARY KEY, icloud blob NOT NULL, class_type text NOT NULL, group_id text NOT NULL, finish_status text NOT NULL, file_id text NOT NULL, date text NOT NULL , is_upload text NOT NULL, userUid text NOT NULL);"];
    
    [self shareProiCloudDataBaseTool];
}

/**
 *  返回第page页的收藏的通知数据:page从1开始
 */
+ (NSArray *)collecticloudList:(int)page {

    int size = 10;
    int pos = (page - 1) * size;
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT * FROM t_collect_icloud ORDER BY id DESC LIMIT %d,%d;", pos, size];
    NSMutableArray *icloudList = [NSMutableArray array];
    while (set.next) {
        JGJProicloudListModel *icloudListModel = [NSKeyedUnarchiver unarchiveObjectWithData:[set objectForColumnName:@"icloud"]];
        [icloudList addObject:icloudListModel];
    }
    return icloudList;

}
/**
 *  收藏
 */
+ (BOOL)addCollecticloudListModel:(JGJProicloudListModel *)icloudListModel {

    if ([self isExisticloudListModell:icloudListModel] || _proiCloudDataBaseTool.isUnCanAdd) {
        
        TYLog(@"当前文件名======%@已存在", icloudListModel.file_name);
        return NO;
    }
    
    icloudListModel.isExpand = NO;
    
    NSString *uniqueId = icloudListModel.fileId?:@"";
    
    if (icloudListModel.is_upload == ProiCloudDataBaseUpLoadType) {
        
        uniqueId = icloudListModel.fileId;
        
    }else {
    
        uniqueId = icloudListModel.fileId;
    }
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:icloudListModel];
    
    BOOL isInsertSuccess = [_db executeUpdateWithFormat:@"INSERT INTO t_collect_icloud(icloud, class_type, group_id, finish_status,file_id, date, is_upload, userUid) VALUES(%@, %@, %@, %@, %@, %@, %@, %@);", data, icloudListModel.class_type,icloudListModel.group_id, @(icloudListModel.finish_status),uniqueId , icloudListModel.date,@(icloudListModel.is_upload), UserUid];
    
    return  isInsertSuccess;

}
/**
 *  取消收藏
 */
+ (BOOL)removeCollecticloudListModel:(JGJProicloudListModel *)icloudListModel {

    NSString *uniqueId = icloudListModel.fileId?:@"";
    
    if (icloudListModel.is_upload == ProiCloudDataBaseUpLoadType) {
        
        uniqueId = icloudListModel.fileId;
        
    }else {
        
        uniqueId = icloudListModel.fileId;
    }
    
    BOOL isRemoveSuccess = [_db executeUpdateWithFormat:@"DELETE FROM t_collect_icloud WHERE file_id = %@ AND userUid = %@;", uniqueId, UserUid];
    
    return  isRemoveSuccess;
}

/**
 *  删除已下载或者已上传完成的
 */

+ (BOOL)removeAllCollecticloudListWithBaseType:(ProiCloudDataBaseType)BaseType fileids:(NSString *)fileids{
    
//    NSString *batchDel = [NSString stringWithFormat:@"DELETE FROM t_collect_icloud WHERE file_id in (%@)", fileids];
    
    BOOL isRemoveSuccess = [_db executeUpdateWithFormat:@"DELETE FROM t_collect_icloud WHERE finish_status = %@ AND userUid = %@ AND is_upload = %@;", @(JGJProicloudSuccessStatusType), UserUid, @(BaseType)];
    
    return  isRemoveSuccess;
}

/**
 *  是否收藏
 */

+ (BOOL)isExisticloudListModell:(JGJProicloudListModel *)icloudListModel {

    NSString *uniqueId = icloudListModel.fileId?:@"";
    
    if (icloudListModel.is_upload == ProiCloudDataBaseUpLoadType) {
        
        uniqueId = icloudListModel.fileId;
        
    }else {
        
        uniqueId = icloudListModel.fileId;
    }
    
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT count(*) AS icloud_count FROM t_collect_icloud WHERE file_id = %@ AND userUid = %@;", uniqueId, UserUid];
    [set next];
    return [set intForColumn:@"icloud_count"] == 1;

}

+ (JGJProicloudListModel *)inquireicloudListModell:(JGJProicloudListModel *)icloudListModel {

    
    NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM t_collect_icloud WHERE userUid = %@ AND file_id = %@ AND group_id = %@", UserUid, icloudListModel.fileId, icloudListModel.group_id];
    
    FMResultSet *set = [_db executeQuery:querySql];
    
    JGJProicloudListModel *inquireIcloudListModel = nil;
    
    while (set.next) {
        
        inquireIcloudListModel = [NSKeyedUnarchiver unarchiveObjectWithData:[set objectForColumnName:@"icloud"]];

        NSString * fileUrl = FILE_PATH(icloudListModel.file_name);
        
        //当前文件已下载总大小
        int64_t totalBytes = [[NSFileManager defaultManager] attributesOfItemAtPath:fileUrl error:nil].fileSize;
        
        inquireIcloudListModel.totalBytes = totalBytes;

    }
    return inquireIcloudListModel;
    
}

/**
 *  返回所有数据
 */
+ (NSArray *)allicloudListWithIcloudListModel:(JGJProicloudListModel *)icloudListModel proiCloudDataBaseType:(ProiCloudDataBaseType)dataBaseType {

    NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM t_collect_icloud WHERE userUid = %@ AND is_upLoad = %@ AND group_id = %@ ORDER BY date DESC", UserUid, @(dataBaseType), icloudListModel.group_id];
    FMResultSet *set = [_db executeQuery:querySql];
    
    NSMutableArray *icloudModels = [NSMutableArray array];
    while (set.next) {
        JGJProicloudListModel *icloudListModel = [NSKeyedUnarchiver unarchiveObjectWithData:[set objectForColumnName:@"icloud"]];

//        //没有完成状态为开始状态
//        if (icloudListModel.finish_status != JGJProicloudSuccessStatusType) {
//            
//            icloudListModel.finish_status = JGJProicloudPauseStatusType;
//        }
        
//        NSString * fileUrl = FILE_PATH(icloudListModel.file_name);
//        
//        if (dataBaseType == ProiCloudDataBaseUpLoadType) {
//            
//            fileUrl = UPLoad_FILE_PATH(icloudListModel.file_name);
//        }
        
//        //当前文件已下载总大小
//        int64_t totalBytes = [[NSFileManager defaultManager] attributesOfItemAtPath:fileUrl error:nil].fileSize;
//        
//        icloudListModel.totalBytes = totalBytes;
        
        [icloudModels addObject:icloudListModel];
    }
    return icloudModels;

}

/**
 *  返回上传、或者下载已成功的所有数据
 */
+ (NSArray *)allicloudSuccessListWithProiCloudDataBaseType:(ProiCloudDataBaseType)dataBaseType {
    
//    NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM t_collect_icloud WHERE userUid = %@ AND is_upLoad = %@ AND finish_status = %@  ORDER BY date DESC", UserUid, @(dataBaseType), @(JGJProicloudSuccessStatusType)];

    //上传、或者下载列表的全部文件
    NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM t_collect_icloud WHERE userUid = %@ AND is_upLoad = %@  ORDER BY date DESC", UserUid, @(dataBaseType)];
    
    FMResultSet *set = [_db executeQuery:querySql];
    
    NSMutableArray *icloudModels = [NSMutableArray array];
    while (set.next) {
        JGJProicloudListModel *icloudListModel = [NSKeyedUnarchiver unarchiveObjectWithData:[set objectForColumnName:@"icloud"]];
        
        //没有完成状态为开始状态
        if (icloudListModel.finish_status != JGJProicloudSuccessStatusType) {
            
            icloudListModel.finish_status = JGJProicloudPauseStatusType;
        }
        
        NSString * fileUrl = FILE_PATH(icloudListModel.file_name);
        
        //当前文件已下载总大小
        int64_t totalBytes = [[NSFileManager defaultManager] attributesOfItemAtPath:fileUrl error:nil].fileSize;
        
        icloudListModel.totalBytes = totalBytes;
        
        [icloudModels addObject:icloudListModel];
    }
    return icloudModels;
    
}

/**
 *  更新数据
 */
+ (BOOL)updateicloudListModel:(JGJProicloudListModel *)icloudListModel {

    BOOL isUpdate = NO;
    
    if ([self removeCollecticloudListModel:icloudListModel]) {
        
        isUpdate = [self addCollecticloudListModel:icloudListModel];
    }
    return isUpdate;

}

@end
