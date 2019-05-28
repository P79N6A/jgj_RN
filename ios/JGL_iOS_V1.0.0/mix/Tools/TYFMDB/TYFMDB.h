//
//  TYFMDB.h
//  TYDebugDemo
//
//  Created by Tony on 15/10/23.
//  Copyright © 2015年 tony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "TYSingleton.h"
#import "JLGCityModel.h"
#import "TYSaveFilePath.h"

//db文件名
#define dataBaseName @"JLG_Baseinfo.db"
//db路径
#define TYFMDBDataPath TYDesFileNamePath

//表名
#define TYFMDBCityDataName    @"jlg_city_data"
//计价方式
#define TYFMDBCooperateName   @"jlg_cooperate_type"
//项目类型
#define TYFMDBProjectName     @"jlg_project_type"
//热门城市
#define TYFMDBHotCityName     @"jlg_hot_city"
//熟练度
#define TYFMDBWorkLevelName   @"jlg_work_level"
//工种
#define TYFMDBWorkTypeName    @"jlg_work_type"
//福利
#define TYFMDBWelfaresName    @"jlg_welfares"
//工作状态
#define TYFMDBWorkStatusName  @"jlg_work_status"
//记工记账:工作时间
#define TYFMDBWorkTimeName    @"yzg_work_time"
//记工记账:加班时间
#define TYFMDBWorkOverTimeName @"yzg_work_overtime"
//记工记账:筛选合作工种
#define TYFMDBYZGCooperateTypeName @"yzg_cooperate_type"


//城市选择
#define TYFMDBCityName       @"city_name"
#define TYFMDBParentId       @"parent_id"
#define TYFMDBCityCode       @"city_code"

@interface TYFMDB : NSObject
//创建单例
TYSingleton_interface(TYFMDB)

/**
 *  通过talbeName的表的所有值
 *
 *  @param tableName 表名
 *
 *  @return 返回结果
 */
+ (NSArray *)searchTable:(NSString *)tableName;

/**
 *  通过talbeName的表的所有name值
 *
 *  @param tableName 表名
 *
 *  @return 返回结果
 */
+ (NSArray *)searchAllNameByTable:(NSString *)tableName;

/**
 *  获取所有的一级城市
 *
 *  @return 一级城市对应的数组
 */
+ (NSArray *)getAllProvince;

/**
 *  获取所有的二级城市
 *
 *  @return 二级城市对应的数组
 */
+ (NSArray *)getCitysByProvince:(JLGCityModel *)provice;

/**
 *  获取所有的三级城市
 *
 *  @return 三级城市对应的数组
 */
+ (NSArray *)getSubCitysByCity:(JLGCityModel *)city;

/**
 *  通过keyID和key获取指定的城市
 *
 *  @param keyID     需要查找的数据的keyID
 *  @param key       需要查找的数据的key
 *
 *  @return 返回查找完的数据数组
 */
+ (NSArray *)searchCitybyKeyID:(NSString *)keyID byKey:(NSString *)key;

/**
 *  通过idString获取对应的name
 *
 *  @param idString 数据库对应的id值
 *
 *  @return 查出的name
 */
+ (NSString *)searchWorklevelByID:(NSString *)idString;

/**
 *  获取查出的数据
 *
 *  @param tableName 表名
 *  @param key key
 *  @param value key对应的value
 *  @param colume 通过colume查出数据的值
 *
 *  @return 查出的name
 */
+ (NSString *)searchItemByTableName:(NSString *)tableName ByKey:(NSString *)key byValue:(NSString *)value byColume:(NSString *)colume;

//获取热门城市
+(NSArray *)getAllListCitys;

/**
 *  修改查出的数据
 *
 *  @param tableName 表名
 *  @param key key
 *  @param oldValue key对应的value
 *  @param newValue 需要修改成的value
 *
 *  @return 是否修改成功
 */
+ (BOOL )modifyItemByTableName:(NSString *)tableName key:(NSString *)key oldValue:(NSString *)oldValue newValueArray:(NSArray *)newValueArray;

/**
 *  插入数据
 *
 *  @param tableName 表名
 *  @param key key
 *  @param oldValue key对应的value
 *  @param newValue 需要修改成的value
 *
 *  @return 是否修改成功
 */
+ (BOOL )addItemByTableName:(NSString *)tableName newValueArray:(NSArray *)newValueArray;
/**
 *  删除查出的数据
 *
 *  @param tableName 表名
 *  @param key key
 *  @param value key对应的value
 *  @param colume 通过colume查出数据的值
 *
 *  @return 是否修改成功
 */
+ (BOOL )deleteItemByTableName:(NSString *)tableName key:(NSString *)key oldValue:(NSString *)oldValue;

/**
 *  查找表的元素数量
 *
 *  @param tableName 表名
 *
 *  @return 查出的数量
 */
+(NSInteger)tableCountByTableName:(NSString *)tableName;


/**
 *  清空表数据
 *
 *  @param tableName 表名
 *
 *  @return 是否成功
 */
+(BOOL)deleteAllByTableName:(NSString *)tableName;

/**
 *  通过talbeName的表的所有值
 *
 *  @param tableName 表名
 *
 *  @param sqlite 查询语句
 *  @return 返回结果
 */
+ (NSArray *)searchCalendarTable:(NSString *)tableName sqlite:(NSString *)sqlite ;
@end
