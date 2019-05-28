//
//  JGJRecordStaSearchTool.h
//  mix
//
//  Created by yj on 2018/9/26.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JGJRecordHeader.h"

//保存页面的初始数据
@interface JGJRecordStaInitialModel : NSObject

//页面的初始数据
@property (nonatomic, copy) NSString *stTime;

@property (nonatomic, copy) NSString *endTime;

@property (nonatomic, copy) NSString *proName;

//项目id
@property (nonatomic, copy) NSString *proId;

@property (nonatomic, copy) NSString *memberName;

//姓名id
@property (nonatomic, copy) NSString *memberUid;

//选择的类型
@property (nonatomic, copy) NSString *account_types;

//选择后的数据

@property (nonatomic, copy) NSString *sel_stTime;

@property (nonatomic, copy) NSString *sel_endTime;

@property (nonatomic, copy) NSString *sel_proName;

//项目id
@property (nonatomic, copy) NSString *sel_proId;

@property (nonatomic, copy) NSString *sel_memberName;

//姓名id
@property (nonatomic, copy) NSString *sel_memberUid;

//选择的类型
@property (nonatomic, copy) NSString *sel_account_types;

//入栈的控制器
@property (nonatomic, strong) NSMutableArray *subVcs;

//锁定人员名字 3.4.1
@property (nonatomic, assign) BOOL is_lock_name;

//锁定项目名字 3.4.1
@property (nonatomic, assign) BOOL is_lock_proname;

//人员
@property (nonatomic, strong) NSArray *members;

//项目
@property (nonatomic, strong) NSArray *pros;

@end

@interface JGJRecordStaSearchTool : NSObject

@property (nonatomic, strong) JGJRecordStaInitialModel *staInitialModel;

+(void)skipVcWithVc:(UIViewController *)vc staListModel:(JGJRecordWorkStaListModel *)staListModel infos:(NSArray *)infos searchType:(JGJRecordStaSearchType)searchType staType:(JGJRecordStaType)staType request:(JGJRecordWorkStaRequestModel *)request;

+ (instancetype)shareStaSearchTool;

//其他页面跳转到统计
+(void)skipVcWithVc:(UIViewController *)vc staListModel:(JGJRecordWorkStaListModel *)staListModel user_info:(JGJSynBillingModel *)user_info;

@end
