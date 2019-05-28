//
//  TYFMDB.m
//  TYDebugDemo
//
//  Created by Tony on 15/10/23.
//  Copyright © 2015年 tony. All rights reserved.
//

#import "TYFMDB.h"
#import "NSString+File.h"

//#define showFMDB YES//测试的打印

@interface TYFMDB ()
@property (nonatomic,strong) FMDatabase* dataBase;
@end

@implementation TYFMDB

//创建单例
TYSingleton_implementation(TYFMDB)

//获取database
+ (FMDatabase *)getDataBase{
    FMDatabase* database;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:TYDesFileNamePath]) { //不存在才使用原始的文件
        database = [ FMDatabase databaseWithPath:TYSaveSrcFileNamePath];
    }else{
        database = [ FMDatabase databaseWithPath:TYFMDBDataPath];
    }
    
#ifdef showFMDB
    TYLog(@"数据库文件的路径 %@,%@",TYFMDBDataPath,TYSaveSrcFileNamePath);
#endif
    if ( ![ database open ] )
    {
        return nil;
    }else{
        return database;
    }
}

//通过talbeName的表的所有值
+ (NSArray *)searchTable:(NSString *)tableName
{
    FMDatabase *database = [TYFMDB getDataBase];
    FMResultSet *resultSet = [self getResultSetByDataBase:database TableName:tableName];
    NSMutableArray *dataArray = [NSMutableArray array];
    // 逐行读取数据
    while ([resultSet next])
    {
        // 对应字段来取数据
        NSDictionary *valueDic = [resultSet resultDictionary];
        [dataArray addObject:valueDic];
#ifdef showFMDB
        NSLog( @"value: %@ , dataArray: %@",valueDic,dataArray);
#endif
    }
    
    [database close ];
    
    return [dataArray copy];
}


+ (NSArray *)searchAllNameByTable:(NSString *)tableName{
    FMDatabase *database = [TYFMDB getDataBase];
    
    if (![self dataBase:database isExitsTable:tableName]) {
        return nil;
    }
    
    NSString *searchSqlString = [NSString stringWithFormat:@"SELECT name FROM %@",tableName];
    FMResultSet* resultSet = [database executeQuery:searchSqlString];

    NSMutableArray *dataArray = [NSMutableArray array];
    // 逐行读取数据
    while ([resultSet next])
    {
        // 对应字段来取数据
        NSDictionary *valueDic = [resultSet resultDictionary];
        [dataArray addObject:valueDic[@"name"]];
#ifdef showFMDB
        NSLog( @"value: %@ , dataArray: %@",valueDic,dataArray);
#endif
    }
    
    [database close ];
    
    return [dataArray copy];
}

//获取resultSet
+ (FMResultSet *)getResultSetByDataBase:(FMDatabase *)database TableName:(NSString *)tableName{
    
    if (![self dataBase:database isExitsTable:tableName]) {
        return nil;
    }
    
    NSString *searchSqlString = [NSString stringWithFormat:@"SELECT * FROM %@",tableName];
    FMResultSet* resultSet = [database executeQuery:searchSqlString];
    return resultSet;
}


+ (FMResultSet *)getResultSetByDataBase:(FMDatabase *)database TableName:(NSString *)tableName searchString:(NSString *)searchString{
    
    if (![self dataBase:database isExitsTable:tableName]) {
        return nil;
    }
    
    NSString *searchSqlString = [NSString stringWithFormat:@"SELECT * FROM %@ %@",tableName,searchString];

    FMResultSet* resultSet = [database executeQuery:searchSqlString];
    return resultSet;
}

#pragma mark - 城市选择
+ (NSArray *)getCityResultSetByDataBase:(FMDatabase *)database pid:(NSString *)pid{
    NSString *tableName = @"jlg_city_data";
    
    if (![self dataBase:database isExitsTable:tableName]) {
        return nil;
    }
    
    
    NSString *searchSqlString = [NSString stringWithFormat:@"SELECT city_code,city_name,parent_id FROM %@ WHERE parent_id==%@",tableName,pid];
    FMResultSet* resultSet = [database executeQuery:searchSqlString];
#ifdef showFMDB
    TYLog(@"searchSqlString = %@",searchSqlString);
#endif
    NSMutableArray *dataArray = [NSMutableArray array];
    
    // 逐行读取数据
    while ([resultSet next])
    {
        JLGCityModel *jlgCityModel = [[JLGCityModel alloc] init];
        // 对应字段来取数据
        NSDictionary *valueDic = [resultSet resultDictionary];
        [jlgCityModel setValuesForKeysWithDictionary:valueDic];
        [dataArray addObject:jlgCityModel];
#ifdef showFMDB
        NSLog( @"valueDic: %@",valueDic);
#endif
    }
    return [dataArray copy];
}

+ (NSArray *)getAllProvince{
    FMDatabase *database = [TYFMDB getDataBase];
    NSArray *dataArray = [self getCityResultSetByDataBase:database pid:@"0"];
    [database close ];
    return dataArray;
}


+ (NSArray *)getCitysByProvince:(JLGCityModel *)provice{
    FMDatabase *database = [TYFMDB getDataBase];
    NSArray *dataArray = [self getCityResultSetByDataBase:database pid:provice.city_code];
    [database close ];
    return dataArray;
}

+ (NSArray *)getSubCitysByCity:(JLGCityModel *)city{
    FMDatabase *database = [TYFMDB getDataBase];
    NSArray *dataArray = [self getCityResultSetByDataBase:database pid:city.city_code];
    [database close ];
    return dataArray;
}

//通过keyID和key获取指定的城市
+ (NSArray *)searchCitybyKeyID:(NSString *)keyID byKey:(NSString *)key
{
    FMDatabase *database = [TYFMDB getDataBase];
    NSString *searchString = [NSString stringWithFormat:@"WHERE %@ like \'%@%%\' and parent_id>0",keyID,key];
    FMResultSet *resultSet = [self getResultSetByDataBase:database TableName:TYFMDBCityDataName searchString:searchString];
    NSMutableArray *dataArray = [NSMutableArray array];
    // 逐行读取数据
    while ([resultSet next])
    {
        JLGCityModel *jlgCityModel = [[JLGCityModel alloc] init];
        // 对应字段来取数据
        NSDictionary *valueDic = [resultSet resultDictionary];
        [jlgCityModel setValuesForKeysWithDictionary:valueDic];
        [dataArray addObject:jlgCityModel];
    }
    
    [database close ];
    
    return [dataArray copy];
}

//通过idString获取对应的name
+ (NSString *)searchWorklevelByID:(NSString *)idString
{
    FMDatabase *database = [TYFMDB getDataBase];
    NSString *searchString = [NSString stringWithFormat:@"WHERE id == %@",idString];
    FMResultSet *resultSet = [self getResultSetByDataBase:database TableName:TYFMDBWorkLevelName searchString:searchString];
    NSString *value;
    // 逐行读取数据
    while ([resultSet next])
    {
        // 对应字段来取数据
         value = [resultSet stringForColumn:@"name"];
    }
    
    [database close ];
    
    return value;
}

+ (NSString *)searchItemByTableName:(NSString *)tableName ByKey:(NSString *)key byValue:(NSString *)value byColume:(NSString *)colume
{
    FMDatabase *database = [TYFMDB getDataBase];
    NSString *searchString = [NSString stringWithFormat:@"WHERE %@ == %@",key,value];
    FMResultSet *resultSet = [self getResultSetByDataBase:database TableName:tableName searchString:searchString];
    NSString *valueString;
    // 逐行读取数据
    while ([resultSet next])
    {
        // 对应字段来取数据
        valueString = [resultSet stringForColumn:colume];
    }
    
    [database close];
    
    return valueString;
}

+(NSArray *)getAllListCitys{
    FMDatabase *database = [TYFMDB getDataBase];
    if ([database tableExists:TYFMDBCityDataName]) {
#ifdef showFMDB
        TYLog(@"存在表:%@",TYFMDBCityDataName);
#endif
    }else{
        TYLog(@"不存在表:%@",TYFMDBCityDataName);
        return nil;
    }
    
    NSString *searchSqlString = @"SELECT city_name,city_code,first_char,short_name,city_url FROM jlg_city_data WHERE substr(city_code,5,2)=\'00\' AND substr(city_code,3,4)!=\'0000\'";
    FMResultSet* resultSet = [database executeQuery:searchSqlString];
    NSMutableArray *dataArray = [NSMutableArray array];
    // 逐行读取数据
    while ([resultSet next])
    {
        NSMutableDictionary *valueDic = [[resultSet resultDictionary] mutableCopy];
        [dataArray addObject:valueDic];
    }
    
    [database close ];
    
    return dataArray;
}

+ (BOOL )modifyItemByTableName:(NSString *)tableName key:(NSString *)key oldValue:(NSString *)oldValue newValueArray:(NSArray *)newValueArray{
    FMDatabase *database = [TYFMDB getDataBase];
    NSString *searchString = [NSString stringWithFormat:@"WHERE %@ == %@",key,oldValue];
    
    if (![self dataBase:database isExitsTable:tableName]) {
        return NO;
    }
    
    NSString *updateString = @"";
    //将key的名字创建为数据库
    for (int index = 0 ;index < newValueArray.count; index++) {
        NSString *addStr;
        if ((index + 1) == newValueArray.count) {
            addStr = [NSString stringWithFormat:@"%@ = \'%@\'",newValueArray[index][0],newValueArray[index][1]];//最后一个
        }else{
            addStr = [NSString stringWithFormat:@"%@ = \'%@\',",newValueArray[index][0],newValueArray[index][1]];
        }
        updateString = [updateString stringByAppendingString:addStr];
    }


    NSString *searchSqlString = [NSString stringWithFormat:@"UPDATE %@ SET %@ %@",tableName,updateString,searchString];
    
    BOOL isSuccess = [database executeUpdate:searchSqlString];
    [database close];
    
    return isSuccess;
}

+ (BOOL )addItemByTableName:(NSString *)tableName newValueArray:(NSArray *)newValueArray{
    FMDatabase *database = [TYFMDB getDataBase];

    if (![self dataBase:database isExitsTable:tableName]) {
        return NO;
    }
    
    NSString *insertNameString = @"";
    NSString *insertValueString = @"";
    //将key的名字创建为数据库
    for (int index = 0 ;index < newValueArray.count; index++) {
        NSString *insertName;
        NSString *insertValue;
        
        NSArray *dataArray = newValueArray[index];
        if ((index + 1) == newValueArray.count) {
            insertName = [NSString stringWithFormat:@"%@",dataArray[0]];//最后一个
            insertValue = [NSString stringWithFormat:@"\'%@\'",dataArray[1]];//最后一个
        }else{
            insertName = [NSString stringWithFormat:@"%@,",dataArray[0]];//最后一个
            insertValue = [NSString stringWithFormat:@"\'%@\',",dataArray[1]];//最后一个
        }
        insertNameString = [insertNameString stringByAppendingString:insertName];
        insertValueString = [insertValueString stringByAppendingString:insertValue];
    }
    
    
    NSString *searchSqlString = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)",tableName,insertNameString,insertValueString];
    
    BOOL isSuccess = [database executeUpdate:searchSqlString];
    [database close];
    
    return isSuccess;
}

+ (BOOL )deleteItemByTableName:(NSString *)tableName key:(NSString *)key oldValue:(NSString *)oldValue{
    FMDatabase *database = [TYFMDB getDataBase];
    NSString *searchString = [NSString stringWithFormat:@"WHERE %@ == %@",key,oldValue];
    
    if (![self dataBase:database isExitsTable:tableName]) {
        return NO;
    }
    
    NSString *searchSqlString = [NSString stringWithFormat:@"DELETE * FROM %@ %@",tableName,searchString];
    
    BOOL isSuccess = [database executeUpdate:searchSqlString];
    [database close];
    
    return isSuccess;
}

+(NSInteger)tableCountByTableName:(NSString *)tableName{
    FMDatabase *database = [TYFMDB getDataBase];

    if (![self dataBase:database isExitsTable:tableName]) {
        return 0;
    }
    
    NSString *searchSqlString = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@",tableName];
    NSUInteger count = [database intForQuery:searchSqlString];

    [database close];
    
    return count;
}

+ (BOOL )deleteAllByTableName:(NSString *)tableName{
    FMDatabase *database = [TYFMDB getDataBase];
    
    if (![self dataBase:database isExitsTable:tableName]) {
        return NO;
    }
    
    NSString *searchSqlString = [NSString stringWithFormat:@"DELETE FROM %@",tableName];
    BOOL success =  [database executeUpdate:searchSqlString];
    
    [database close];
    
    return success;
}

+ (BOOL )dataBase:(FMDatabase *)dataBase isExitsTable:(NSString *)tableName{
    if ([dataBase tableExists:tableName]) {
#ifdef showFMDB
        TYLog(@"存在表:%@",tableName);
#endif
        return YES;
    }else{
#ifdef showFMDB
        TYLog(@"不存在表:%@",tableName);
#endif
        return NO;
    }
}
@end
