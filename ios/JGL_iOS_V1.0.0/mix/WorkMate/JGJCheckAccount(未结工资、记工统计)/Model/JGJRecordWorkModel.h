//
//  JGJRecordWorkModel.h
//  mix
//
//  Created by yj on 2018/1/8.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RecordMemberDes JLGisLeaderBool ? @"全部工人" : @"全部班组长"

#define AgencyDes @"全部工人"

@interface JGJRecordWorkModel : NSObject

@end

//点工
@interface JGJRecordWorkTypeModel : JGJRecordWorkModel

@property (nonatomic, copy) NSString *manhour; //时单位

@property (nonatomic, copy) NSString *working_hours; //工单位

@property (nonatomic, copy) NSString *overtime; //加班 时单位

@property (nonatomic, copy) NSString *overtime_hours; //加班 工单位

@property (nonatomic, copy) NSString *amounts;

@end

//包工、借支、结算
@interface JGJRecordContractTypeModel : JGJRecordWorkModel

@property (nonatomic, copy) NSString *total;

@property (nonatomic, copy) NSString *amounts;

@end

//记工统计列表
@interface JGJRecordWorkStaListModel : JGJRecordWorkModel

@property (nonatomic, strong) JGJRecordWorkTypeModel *work_type; //点工

@property (nonatomic, strong) JGJRecordContractTypeModel *contract_type; //包工

@property (nonatomic, strong) JGJRecordContractTypeModel *expend_type; //借支

@property (nonatomic, strong) JGJRecordContractTypeModel *balance_type; //结算

@property (nonatomic, strong) JGJRecordContractTypeModel *unbalance_type; //未结

@property (nonatomic, strong) JGJRecordContractTypeModel *contract_type_one; //包工承包

@property (nonatomic, strong) JGJRecordContractTypeModel *contract_type_two; //包工分包

@property (nonatomic, copy) NSString *contractor_type; //1，//承包 2:分包

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *date;

@property (nonatomic, copy) NSString *nameDes; //名字描述

@property (nonatomic, copy) NSString *class_type_id; //如果是项目端，值表示项目id,如果是个人端，值表示人的uid

//3.3.7添加
@property (nonatomic, copy) NSString *class_type_target_id; //如果是class_type_id项目端，值表示人的id,如果是class_type_id是人的id，标识class_type_target_id项目id

//3.3.7添加和class_type_target_id同
@property (nonatomic, copy) NSString *target_name;

@property (nonatomic, copy) NSString *balance_amount;

//统计类型班组长或者项目(person、project)
@property (nonatomic, copy) NSString *class_type;

//项目名 一人记多天进入流水使用
@property (nonatomic, copy) NSString *proName;

//项目id 一人记多天进入流水使用
@property (nonatomic, copy) NSString *pid;

//是否是记工变更进入记工流水
@property (nonatomic, assign) BOOL is_change_date;


//锁定人员名字 3.4.1
@property (nonatomic, assign) BOOL is_lock_name;

//锁定项目名字 3.4.1
@property (nonatomic, assign) BOOL is_lock_proname;

//统计进入是否在流水禁止点击。当前只有同步给我的记工禁止点击

@property (assign, nonatomic) BOOL isForbidSkipWorkpoints;

//是否是同步带过来的数据
@property (nonatomic, copy) NSString *is_sync;

//统计cell高度
@property (nonatomic, assign) CGFloat height;

//设置统计样式顶部距离
@property (nonatomic, assign) BOOL is_change_workTop;

@end

//记工统计
@interface JGJRecordWorkStaModel : JGJRecordWorkModel

@property (nonatomic, copy) NSString *class_type;

@property (nonatomic, copy) NSString *balance_amount;

@property (nonatomic, strong) JGJRecordWorkTypeModel *work_type; //点工

@property (nonatomic, strong) JGJRecordWorkTypeModel *attendance_type;//包工考勤

@property (nonatomic, strong) JGJRecordContractTypeModel *contract_type; //包工

@property (nonatomic, strong) JGJRecordContractTypeModel *expend_type; //借支

@property (nonatomic, strong) JGJRecordContractTypeModel *contract_type_one; //包工承包

@property (nonatomic, strong) JGJRecordContractTypeModel *contract_type_two; //包工分包

@property (nonatomic, strong) JGJRecordContractTypeModel *balance_type; //结算

@property (nonatomic, strong) NSArray <JGJRecordWorkStaListModel *> *list;

//记工统计月统计使用
@property (nonatomic, strong) NSArray <JGJRecordWorkStaListModel *> *month_list;

//是否显示工否则显示小时
@property (nonatomic, assign) BOOL isShowWork;

//是否筛选
@property (nonatomic, assign) BOOL isFilter;

//开始时间
@property (copy, nonatomic) NSString *startTime;

//结束时间
@property (copy, nonatomic) NSString *endTime;

//农历开始时间
@property (copy, nonatomic) NSString *lunarStTime;

//农历结束时间
@property (copy, nonatomic) NSString *lunarEnTime;

//当月统计总笔数
@property (copy, nonatomic) NSString *total_num;

//筛选的用户姓名
@property (copy, nonatomic) NSString *name;

//筛选的项目名字
@property (copy, nonatomic) NSString *pro_name;

//筛选的记工分类
@property (copy, nonatomic) NSString *accounts_type_name;

//主要是有无￥
@property (copy, nonatomic) NSString *moneyFlag;

//记工流水顶部样式
- (NSMutableArray *)setStaPopViewCellModel;

// 顶部统计点工和包工记工天相加

- (void)handleTopContractorSta;

@end

//记工统计详情列表
@interface JGJRecordWorkStaDetailListModel : JGJRecordWorkStaListModel

//统计详情页使用
//@property (nonatomic, copy) NSString *date;

//@property (nonatomic, strong) JGJRecordWorkStaListModel *month;

//3.3.7记账类型，到流水页面添加
@property (nonatomic, copy) NSString *accounts_type;

//是否是记工变更进入
@property (nonatomic, assign) BOOL is_change_date;

@end

//记工统计详情
@interface JGJRecordWorkStaDetailModel : JGJRecordWorkStaModel

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *role;

//@property (nonatomic, strong) NSArray <JGJRecordWorkStaDetailListModel *> *month_list;

@property (nonatomic, copy) NSString *date;


@end


//记工模板
@interface JGJRecordWorkSetFormModel : NSObject

@property (nonatomic, copy) NSString *s_tpl;

@property (nonatomic, copy) NSString *w_h_tpl;

@property (nonatomic, copy) NSString *o_h_tpl; //点工  小时单位
@property (nonatomic, assign) NSInteger hour_type;
@property (nonatomic, assign) CGFloat o_s_tpl;

@end

//记工流水

@interface JGJRecordWorkPointListModel : NSObject

@property (nonatomic, copy) NSString *recordId; //记账id

@property (nonatomic, copy) NSString *date;

//农历日期
@property (nonatomic, copy) NSString *date_turn;

@property (nonatomic, copy) NSString *accounts_type; //工种 1：点工；2：包工；3：借支；4：结算

@property (nonatomic, copy) NSString *contractor_type; //1，//承包 2:分包

@property (nonatomic, copy) NSString *manhour; //点工  小时单位

@property (nonatomic, copy) NSString *working_hours; //点工  工单位

@property (nonatomic, copy) NSString *uid; //对方uid

@property (nonatomic, copy) NSString *overtime_hours; //加班 工单位

@property (nonatomic, copy) NSString *overtime; //加班  小时单位

@property (nonatomic, copy) NSString *amounts; //金额

@property (nonatomic, copy) NSString *pid; //项目id

@property (nonatomic, copy) NSString *proname; ////项目名称

@property (nonatomic, copy) NSString *worker_name; //工人名称

@property (nonatomic, copy) NSString *foreman_name; //工头名称

//模板
@property (nonatomic, strong) JGJRecordWorkSetFormModel *set_tpl;

@property (nonatomic, assign) BOOL amounts_diff; //差账标识

@property (nonatomic, assign) BOOL isSel; //是否选中

@property (nonatomic, assign) BOOL is_notes; //是否有备注

@property (nonatomic, copy) NSString *fuid; //对方的uid

@property (nonatomic, assign) CGFloat set_my_amounts_tpl;// 自己对对方设置的工资金额

@end

@interface JGJRecordWorkPointWorkdayListModel : NSObject

@property (nonatomic, copy) NSString *date;

@property (nonatomic, copy) NSString *date_turn;

@property (nonatomic, strong) NSArray <JGJRecordWorkPointListModel *>*list;

@end

@interface JGJRecordWorkPointModel : JGJRecordWorkStaModel

@property (nonatomic, strong) NSArray <JGJRecordWorkPointWorkdayListModel *>*workday;

@end


//未结工资

@interface JGJRecordUnWageListModel : JGJRecordWorkModel

@property (nonatomic, strong) JGJSynBillingModel *user_info;

@property (nonatomic, copy) NSString *amounts;

//批量未结算是否选中
@property (nonatomic, assign) BOOL isSel;

@end

@interface JGJRecordUnWageModel : JGJRecordWorkModel

@property (nonatomic, strong) NSArray <JGJRecordUnWageListModel *>*list;

@property (nonatomic, copy) NSString *amounts;

@property (nonatomic, copy) NSString *allnum;  //未结工资数量

@property (nonatomic, copy) NSString *total_amount;  //总金额

@property (nonatomic, copy) NSString *un_salary_tpl; //未设置金额模板数

@end

//未结工资点工

@interface JGJUnsetSalaryTplByUidListModel : JGJRecordWorkModel

@property (nonatomic, strong) NSArray <JGJRecordWorkPointListModel *>*date_list;

@property (nonatomic, copy) NSString *date;

@end

//记工流水 项目和人员
@interface JGJRecordWorkPointFilterModel : JGJSynBillingModel

//首字母
@property (nonatomic, copy) NSString *firLetter;

//是否选中
@property (nonatomic, assign) BOOL isSel;

//项目排序
+ (NSMutableArray *)sortProModels:(NSMutableArray *)sortProModels;

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

@interface JGJPageSizeModel : NSObject

@property (nonatomic, copy) NSString *date;

@property (nonatomic, assign) NSInteger location;

@property (nonatomic, assign) NSInteger length;

//存储分页模型数组
@property (nonatomic, strong) NSArray *lastSortDataSource;

//返回排序后的分段数据
- (NSMutableArray *)sortDataSource:(NSArray *)dataSource;

//返回倒序后的分段数据
- (NSMutableArray *)sortDesDataSource:(NSArray *)dataSource;
@end

@interface JGJHomeWorkRecordTotalModel : NSObject

@property (nonatomic, strong) JGJRecordWorkTypeModel *month;

@property (nonatomic, strong) JGJRecordWorkTypeModel *today;

@end

@interface JGJCheckStaPopViewCellModel : NSObject

//点工(1) 、包工考勤(2) 、包工记账(3)、借支(4)、结算(5)
@property (nonatomic, assign) NSInteger otherType;

@property (nonatomic, copy) NSString *money;

@property (nonatomic, copy) NSString *typeTitle;

@property (nonatomic, copy) NSString *firTitle;

@property (nonatomic, copy) NSString *firDes;

@property (nonatomic, strong) UIColor *firChangeColor;

@property (nonatomic, copy) NSString *firChangeStr;

@property (nonatomic, copy) NSString *secTitle;

@property (nonatomic, copy) NSString *secDes;

@property (nonatomic, strong) UIColor *secChangeColor;

@property (nonatomic, copy) NSString *secChangeStr;

@end
