//
//  JGJRecordTool.h
//  mix
//
//  Created by yj on 2018/1/10.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGJRecordWorkStaRequestModel : NSObject

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *start_time;

@property (nonatomic, copy) NSString *end_time;

//    个人person(默认),项目project
@property (nonatomic, copy) NSString *class_type;

//如果是项目端，值表示项目id,如果是个人端，值表示人的uid
@property (nonatomic, copy) NSString *class_type_id;

@property (nonatomic, copy) NSString *class_type_target_id; //如果是class_type_id项目端，值表示人的id,如果是class_type_id是人的id，标识class_type_target_id项目id

//按天、按月统计
@property (nonatomic, copy) NSString *is_day;

//代理人uid自己
@property (nonatomic, copy) NSString *agency_uid;

//班组id
@property (nonatomic, copy) NSString *group_id;

//类型
@property (nonatomic, copy) NSString *accounts_type;

@end

@interface JGJRecordWorkPointRequestModel : NSObject

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *pid;

@property (nonatomic, copy) NSString *date;

//如1,2,3 类型 1：点工2：包工3：借支4：结算5：包工考勤
@property (nonatomic, copy) NSString *accounts_type;

//是否备注
@property (nonatomic, copy) NSString *is_note;

//代理班组流水传班组id
@property (nonatomic, copy) NSString *group_id;

//是否有代理班组长
@property (nonatomic, copy) NSString *is_agency;

@property (nonatomic, assign) NSInteger pagesize;

@property (nonatomic, assign) NSInteger pg;

//是否是记工变更进入
@property (nonatomic, assign) BOOL is_change_date;

@end

//下载文件路径
@interface JGJRecordWorkDownLoadModel : NSObject

@property (nonatomic, copy) NSString *file_name;

@property (nonatomic, copy) NSString *file_type;

@property (nonatomic, copy) NSString *file_path;

//用户判断筛选条件是否需要重新下载
@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *start_time;

@property (nonatomic, copy) NSString *end_time;

//    个人person(默认),项目project
@property (nonatomic, copy) NSString *class_type;

//如果是项目端，值表示项目id,如果是个人端，值表示人的uid
@property (nonatomic, copy) NSString *class_type_id;

//全路径
@property (nonatomic, strong) NSURL *allFilePath;

@property (nonatomic, assign) BOOL isExistDifFile;

@property (nonatomic, copy) NSString *pid;

@property (nonatomic, copy) NSString *date;

@end

@interface JGJRecordToolModel : NSObject

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) UIViewController *curVc;

@end

typedef void(^JGJRecordToolBlock)(BOOL isSucess, NSURL *localFilePath);

@interface JGJRecordTool : UIViewController

@property (nonatomic, strong) JGJRecordToolModel *toolModel;

@property (nonatomic, copy) JGJRecordToolBlock recordToolBlock;

//判断记工统计是否需要再次下载

+ (JGJRecordWorkDownLoadModel *)downFileExistWithDownLoadModel:(JGJRecordWorkDownLoadModel *)downLoadModel request:(JGJRecordWorkStaRequestModel *)request;

//判断记工流水是否需要再次下载

+ (JGJRecordWorkDownLoadModel *)downFileExistWithRecordDownLoadModel:(JGJRecordWorkDownLoadModel *)downLoadModel request:(JGJRecordWorkPointRequestModel *)request;

@end
