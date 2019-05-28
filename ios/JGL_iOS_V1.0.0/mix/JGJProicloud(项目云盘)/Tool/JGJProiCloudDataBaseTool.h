//
//  JGJProiCloudDataBaseTool.h
//  JGJCompany
//
//  Created by yj on 2017/7/29.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGJProiCloudDataBaseTool : NSObject

+ (instancetype)shareProiCloudDataBaseTool;

/**
 *  返回第page页的收藏的通知数据:page从1开始
 */
+ (NSArray *)collecticloudList:(int)page;
/**
 *  收藏
 */
+ (BOOL)addCollecticloudListModel:(JGJProicloudListModel *)icloudListModel;

/**
 *  返回上传、或者下载已成功的所有数据
 */
+ (NSArray *)allicloudSuccessListWithProiCloudDataBaseType:(ProiCloudDataBaseType)dataBaseType;

/**
 *  取消收藏
 */
+ (BOOL)removeCollecticloudListModel:(JGJProicloudListModel *)icloudListModel;

/**
 *  删除已下载或者已上传完成的
 */

+ (BOOL)removeCollecticloudListWithBaseType:(ProiCloudDataBaseType)BaseType;

/**
 *  是否收藏
 */

+ (BOOL)isExisticloudListModell:(JGJProicloudListModel *)icloudListModel;

/**
 *  查询数据
 */

+ (JGJProicloudListModel *)inquireicloudListModell:(JGJProicloudListModel *)icloudListModel;

/**
 *  返回所有数据 ProiCloudDataBaseUpLoadType 上传列表 ProiCloudDataBaseDownLoadType下载列表
 */
+ (NSArray *)allicloudListWithIcloudListModel:(JGJProicloudListModel *)icloudListModel proiCloudDataBaseType:(ProiCloudDataBaseType)dataBaseType;

/**
 *  更新数据
 */
+ (BOOL)updateicloudListModel:(JGJProicloudListModel *)icloudListModel;

/**
 *  是否允许向数据库添加数据，主要是点击分享按钮的时候不能添加和更新数据库
 */
@property (nonatomic, assign) BOOL isUnCanAdd;
@end
