//
//  JGJQuaSafeTool.m
//  JGJCompany
//
//  Created by yj on 2017/7/22.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJQuaSafeTool.h"

#import "FMDB.h"

#import "NSDate+Extend.h"

#import "NSString+Extend.h"

#import "JGJWebAllSubViewController.h"

#import "JGJChatListAllVc.h"

#define UserUid [TYUserDefaults objectForKey:JLGPhone]

@implementation JGJQuaSafeToolReplyModel

MJExtensionCodingImplementation
@end

static FMDatabase *_db;

@implementation JGJQuaSafeTool

+ (void)initialize {
    
    // 1.打开数据库
    NSString *file = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"quaSafeReply.sqlite"];
    _db = [FMDatabase databaseWithPath:file];
    if (![_db open]) return;
    
    // 2.创表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_collect_quaSafe(id integer PRIMARY KEY, replyModel blob NOT NULL , userUid text NOT NULL, group_id text NOT NULL, class_type text NOT NULL, unique_id text NOT NULL);"];
}

/**
 *  收藏一个信息
 */
+ (BOOL)addCollectReplyModel:(JGJQuaSafeToolReplyModel *)replyModel {
    
    replyModel.unique_id = [self subClassTypeUniqueidWithReplyModel:replyModel];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:replyModel];
    
    BOOL isInsertSuccess = [_db executeUpdateWithFormat:@"INSERT INTO t_collect_quaSafe(replyModel, userUid, group_id, class_type, unique_id) VALUES(%@, %@, %@, %@, %@);", data, UserUid, replyModel.group_id, replyModel.class_type, replyModel.unique_id];
    
    
    return  isInsertSuccess;
}

/**
 *  取消收藏一个信息
 */
+ (BOOL)removeCollecReplyModel:(JGJQuaSafeToolReplyModel *)replyModel {

    replyModel.unique_id = [self subClassTypeUniqueidWithReplyModel:replyModel];
    
    BOOL isRemoveSuccess = [_db executeUpdateWithFormat:@"DELETE FROM t_collect_quaSafe WHERE unique_id = %@ AND group_id = %@ AND userUid = %@;", replyModel.unique_id, replyModel.group_id, UserUid];
    
    return  isRemoveSuccess;

}

/**
 *  消息是否收藏
 */

+ (BOOL)isExistReplyModel:(JGJQuaSafeToolReplyModel *)replyModel {
    
    replyModel.unique_id = [self subClassTypeUniqueidWithReplyModel:replyModel];
    
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT count(*) AS quaSafe_count FROM t_collect_quaSafe WHERE unique_id = %@ AND group_id = %@ AND userUid = %@;", replyModel.unique_id, replyModel.group_id, UserUid];
    [set next];
    return [set intForColumn:@"quaSafe_count"] == 1;
}


/**
 *  更新数据
 */
+ (BOOL)updateReplyModel:(JGJQuaSafeToolReplyModel *)replyModel {
    
    replyModel.unique_id = [self subClassTypeUniqueidWithReplyModel:replyModel];
    
    BOOL isUpdate = NO;

    if ([self removeCollecReplyModel:replyModel]) {
        
        isUpdate = [self addCollectReplyModel:replyModel];
    }
    
    return isUpdate;
}

/**
 *  获取消息
 */
+ (JGJQuaSafeToolReplyModel *)replyModel:(JGJQuaSafeToolReplyModel *)replyModel {

    replyModel.unique_id = [self subClassTypeUniqueidWithReplyModel:replyModel];
    
    NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM t_collect_quaSafe WHERE unique_id = '%@' AND group_id = %@ AND userUid = %@;", replyModel.unique_id, replyModel.group_id, UserUid];

    
    FMResultSet *set = [_db executeQuery:querySql];
    
    JGJQuaSafeToolReplyModel *searchReplyModel = nil;
    
    while (set.next) {
        
        searchReplyModel = [NSKeyedUnarchiver unarchiveObjectWithData:[set objectForColumnName:@"replyModel"]];

    }
    
    return searchReplyModel;
}

+ (BOOL)deleteTable {

    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@",@"t_collect_quaSafe"];
    
    return [_db executeUpdate:sql];
}

#pragma mark - 根据类型返回对应的子模块id
+ (NSString *)subClassTypeUniqueidWithReplyModel:(JGJQuaSafeToolReplyModel *)replyModel {

    if ([replyModel.subClassType isEqualToString:@"qualityType"] || [replyModel.subClassType isEqualToString:@"safeType"] || [replyModel.subClassType isEqualToString:@"taskType"] || [replyModel.subClassType isEqualToString:@"notifyType"]) {

        replyModel.unique_id = replyModel.subClassType;
        
    }

    return replyModel.unique_id;
}

+ (void)linkHandlerWithLinkUrl:(NSString *)linkUrl  curView:(UIView *)curView target:(UIViewController *)target {
    
    JGJWebAllSubViewController *webVc = [JGJWebAllSubViewController new];
    
    if ([linkUrl rangeOfString:JGJWebDomainURL].location != NSNotFound && [linkUrl rangeOfString:@"topdisplay=1"].location != NSNotFound) {
        
        webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeExternalThirdPartBannerType URL:linkUrl];
        
        webVc.needCloseButton = YES;
        
    }else
        
        if ([linkUrl rangeOfString:JGJWebDomainURL].location != NSNotFound) {
            
            webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:linkUrl];
        }else {
            
            if (![linkUrl containsString:@"http"]) {
                
                linkUrl = [NSString stringWithFormat:@"http://%@", linkUrl];
            }
            
            webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeExternalThirdPartBannerType URL:linkUrl];
            
            webVc.needCloseButton = YES;
        }
    
    UIViewController *curVc = [self getCurrentViewControllerWithCurView:curView];
    
    if ([curVc isKindOfClass:[JGJChatListAllVc class]]) {
        
        JGJChatListAllVc *chatVc = (JGJChatListAllVc *)curVc;
        
        chatVc.skipToNextVc(webVc);
        
        return;
    }
    
    if ([curVc isKindOfClass:[UIViewController class]]) {
        
        [curVc.navigationController pushViewController:webVc animated:YES];
        
    }else if ([target isKindOfClass:[UIViewController class]]) {
        
        [target.navigationController pushViewController:webVc animated:YES];
    }
    
}

/** 获取当前View的控制器对象 */
+(UIViewController *)getCurrentViewControllerWithCurView:(UIView *)curView{
    UIResponder *next = [curView nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}

@end
