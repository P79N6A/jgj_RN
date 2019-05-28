//
//  JGJRecordStaSearchTool.m
//  mix
//
//  Created by yj on 2018/9/26.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJRecordStaSearchTool.h"

#import "JGJRecordStaListVc.h"

#import "JGJRecordStaListMidVc.h"

#import "JGJRecordStaListDetailVc.h"

#import "NSDate+Extend.h"

static JGJRecordStaSearchTool *_searchTool;

@implementation JGJRecordStaInitialModel

- (NSMutableArray *)subVcs {
    
    if (!_subVcs) {
        
        _subVcs = [NSMutableArray array];
    }
    
    return _subVcs;
}

@end

@implementation JGJRecordStaSearchTool

+ (instancetype)shareStaSearchTool
{
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        
        _searchTool = [[self alloc] init];
        
    });
    return _searchTool;
}

+(void)skipVcWithVc:(UIViewController *)vc staListModel:(JGJRecordWorkStaListModel *)staListModel infos:(NSArray *)infos searchType:(JGJRecordStaSearchType)searchType staType:(JGJRecordStaType)staType request:(JGJRecordWorkStaRequestModel *)request{
    
    UIViewController *pushVc = nil;
    
    JGJRecordStaSearchTool *searchTool = [JGJRecordStaSearchTool shareStaSearchTool];
    
    BOOL is_firVc = [vc isMemberOfClass:NSClassFromString(@"JGJRecordStaListVc")];
    
    BOOL is_SecVc = [vc isMemberOfClass:NSClassFromString(@"JGJRecordStaListMidVc")];
    
    BOOL is_thirVc = [vc isMemberOfClass:NSClassFromString(@"JGJRecordStaListDetailVc")];
    
    switch (searchType) {
        case JGJRecordStaSearchMainType:{  //统计首页
            
            JGJRecordStaListVc *staListVc = nil;
            
            if (searchTool.staInitialModel.subVcs.count > 0) {
                
                if ([searchTool.staInitialModel.subVcs[0] isMemberOfClass:NSClassFromString(@"JGJRecordStaListVc")]){
                    
                    staListVc = searchTool.staInitialModel.subVcs[0];
                    
                    //点击确定进入首页都是项目类型
                    
                    //其他页面进入第一层数据，清除class_type_target_id
                    if (!is_firVc) {
                        
                        request.class_type_target_id = nil;
                        
                        request.class_type_id = nil;
                    }
                    
                    //            3.4.1修改
                    if (!is_firVc) {
                        
                        staListVc.staType = JGJRecordStaProjectType;
                        
                        request.class_type = @"project";
                        
                        staListVc.request = request;
                        
//                        staListVc.headerView.selType = JGJRecordSelLeftBtnType;
                        
//                        //根据之前的类型发起对应请求
//
                        if ([staListVc isMemberOfClass:NSClassFromString(@"JGJRecordStaListVc")]) {

                            [staListVc handleSearchTypeRequest];
                        }
                        
                    }
                    
                    [staListVc freshTableView];
                    
                }
            
            }
            
            
            if (!staListVc) {
                
                JGJRecordStaSearchTool *searchTool = [JGJRecordStaSearchTool shareStaSearchTool];
                
                JGJRecordStaInitialModel *staInitialModel = searchTool.staInitialModel;
                
                //锁定名字和项目只有第二层，不初始化第一层
                if (staInitialModel.is_lock_name || staInitialModel.is_lock_proname) {
                    
                    JGJRecordStaListMidVc *midVc = searchTool.staInitialModel.subVcs[0];
                    
                    if ([midVc isMemberOfClass:NSClassFromString(@"JGJRecordStaListMidVc")]) {
                        
                         [midVc freshTableView];
                    }
                    
                    return;
                }
                
                JGJRecordStaListVc *staListVc = [[UIStoryboard storyboardWithName:@"JGJRecordWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJRecordStaListVc"];
                
                pushVc = staListVc;
                
            }else {
                
                [vc.navigationController popToViewController:staListVc animated:NO];
                
            }
            
        }
            
            break;
            
        case JGJRecordStaSearchSecCheckMemberType:{  // 记工统计-按工人查看2级页面-按月份统计
            
            JGJRecordStaListVc *staListMidVc = nil;
            
            for (UIViewController *staVc in searchTool.staInitialModel.subVcs) {
                
                if ([vc isMemberOfClass:NSClassFromString(@"JGJRecordStaListMidVc")]) {
                    
                    staListMidVc = (JGJRecordStaListMidVc *)vc;
                    
                    staListMidVc.request = request;
                    
                    [staListMidVc freshTableView];
                    
                    //当前是班组长角色进入下级页面默认选中人,右边按钮
                    if (JLGisLeaderBool && staType == JGJRecordStaNormalWorkerType) {
                        
                        staListMidVc.headerView.selType = JGJRecordSelRightBtnType;
                    }
                    
                    break;
                }
                
            }
            
            if (!staListMidVc) {
                
                JGJRecordStaListMidVc *staListVc = [[UIStoryboard storyboardWithName:@"JGJRecordWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJRecordStaListMidVc"];
                
                staListMidVc.request = request;
                
                staListVc.oriDesInfos = infos.mutableCopy;
                
                staListVc.staListModel = staListModel;
                
                //当前是班组长角色进入下级页面默认选中人,右边按钮
                if (JLGisLeaderBool && staType == JGJRecordStaNormalWorkerType) {
                    
                    staListMidVc.headerView.selType = JGJRecordSelRightBtnType;
                }
                
                pushVc = staListVc;
                
            }else {
                
                NSString *navVcClass = NSStringFromClass([vc class]);
                
                NSString *staListMidVcClass = NSStringFromClass([staListMidVc class]);
                
                if (![navVcClass isEqualToString:staListMidVcClass]) {
                 
                     [vc.navigationController popToViewController:staListMidVc animated:NO];
                    
                }
                
            }
            
        }
            break;
            
        case JGJRecordStaSearchSecCheckProType:{  // 记工统计-按项目查看2级页面-按工人统计
            
            JGJRecordStaListVc *staListMidVc = nil;
            
            for (UIViewController *staVc in searchTool.staInitialModel.subVcs) {
                
                if ([vc isMemberOfClass:NSClassFromString(@"JGJRecordStaListMidVc")]) {
                    
                    staListMidVc = (JGJRecordStaListMidVc *)vc;

                    staListMidVc.request = request;
                    
                    [staListMidVc freshTableView];
                    
                    //当前是班组长角色进入下级页面默认选中人,右边按钮
                    if (JLGisLeaderBool && staType == JGJRecordStaNormalWorkerType) {
                        
                        staListMidVc.headerView.selType = JGJRecordSelRightBtnType;
                    }
                    
                    break;
                }
                
            }
            
            
            if (!staListMidVc) {
                
                JGJRecordStaListMidVc *staListVc = [[UIStoryboard storyboardWithName:@"JGJRecordWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJRecordStaListMidVc"];
                
                staListVc.request = request;
                
                staListVc.staType = JGJRecordStaNormalWorkerType;
                
                staListVc.oriDesInfos = infos.mutableCopy;
                
                staListVc.staListModel = staListModel;
                
                pushVc = staListVc;
                
            }else {
                
                [vc.navigationController popToViewController:staListMidVc animated:NO];
                
            }
            
        }
            break;
            
        case JGJRecordStaSearchMonthType:{  // 按月统计(可切换为按天统计）
            
            JGJRecordWorkStaRequestModel *coverRequest = request;
            
            if (is_SecVc) {
                
                coverRequest = [JGJRecordWorkStaRequestModel mj_objectWithKeyValues:[request mj_keyValues]];
            }
            
            pushVc = [self staDetailVcWithStaListModel:staListModel infos:infos request:coverRequest];
            
        }
            break;
            
        default:{
            
            JGJRecordStaListVc *staListVc = [[UIStoryboard storyboardWithName:@"JGJRecordWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJRecordStaListVc"];
            
            pushVc = staListVc;
        }
            break;
    }
    
    [vc.navigationController pushViewController:pushVc animated:YES];
}

+ (JGJRecordStaListDetailVc *)staDetailVcWithStaListModel:(JGJRecordWorkStaListModel *)staListModel infos:(NSArray *)infos request:(JGJRecordWorkStaRequestModel *)request{
    
    JGJRecordStaListDetailVc *detailVc = [[UIStoryboard storyboardWithName:@"JGJRecordWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJRecordStaListDetailVc"];
    
    detailVc.request = request;
    
    detailVc.staListModel = staListModel;
    
    return detailVc;
}

+(void)skipVcWithVc:(UIViewController *)vc staListModel:(JGJRecordWorkStaListModel *)staListModel user_info:(JGJSynBillingModel *)user_info{
    
    JGJRecordStaListMidVc *staListMidVc = [[UIStoryboard storyboardWithName:@"JGJRecordWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJRecordStaListMidVc"];
    
    staListMidVc.is_lock_name = staListModel.is_lock_name;
    
    staListMidVc.is_lock_proname = staListModel.is_lock_proname;
    
//    隐藏搜索查看按钮 3.4.1显示搜索按钮
    
//    staListMidVc.is_hidden_searchBtn = YES;
    
    //是否在流水禁止点击
    
    staListMidVc.isForbidSkipWorkpoints = staListModel.isForbidSkipWorkpoints;
    
    //工人管理可以到流水页面
    
    if ([vc isMemberOfClass:NSClassFromString(@"JGJSynToMyProVc")]) {
        
        staListModel.isForbidSkipWorkpoints = YES;
        
        staListModel.is_sync = @"1";
        
        staListMidVc.is_sync = @"1";
        
    }
    
    NSString *remark = JLGisLeaderBool ? @"" : @" 处";
    
    staListModel.nameDes = [NSString stringWithFormat:@"%@ %@%@的记工", JLGisLeaderBool ? @"工人" :@"我在班组长", user_info.real_name, remark];
    
    JGJRecordWorkStaRequestModel *request = [JGJRecordWorkStaRequestModel new];
    
    request.class_type = staListModel.class_type;
    
    //搜索显示统一用单例处理，避免多层传值
    JGJRecordStaSearchTool *searchTool = [JGJRecordStaSearchTool shareStaSearchTool];
    
    JGJRecordStaInitialModel *staInitialModel = [[JGJRecordStaInitialModel alloc] init];
    
    searchTool.staInitialModel = staInitialModel;
    
    //3.4.1添加是否锁定项目或者人名字
    
    staInitialModel.is_lock_proname = staListModel.is_lock_proname;
    
    staInitialModel.is_lock_name = staListModel.is_lock_name;
    
    //保存初始数据
    [self getInitialTimeWithUser_info:user_info];
    
    //初始时间一致
    staInitialModel.sel_stTime = staInitialModel.stTime;
    
    staInitialModel.sel_endTime = staInitialModel.endTime;
    
    if ([request.class_type isEqualToString:@"project"]) {
        
        staInitialModel.sel_proId = staListModel.class_type_id;
        
        staInitialModel.sel_proName = staListModel.name;
        
//        request.class_type_id = user_info.uid?:@"";
        
//        staListModel.class_type_id = request.class_type_id;
        
        staListModel.class_type = staListModel.class_type;
        
        request.class_type = @"project";
        
        request.is_day = nil;//默认月统计
        
        //同步人的项目需要被同步人的uid,其他情况传class_type_target_id
        if (![NSString isEmpty:user_info.target_uid]) {
            
            request.uid = user_info.target_uid;
            
        }else {
            
            request.class_type_target_id = staListModel.class_type_target_id;
        }
        
    }else if (JLGisLeaderBool && [request.class_type isEqualToString:@"person"]) {
        
        staInitialModel.sel_memberUid = user_info.uid;
        
        staInitialModel.sel_memberName = user_info.real_name;
        
        staInitialModel.sel_memberUid = user_info.uid;
        
        staInitialModel.sel_memberName = user_info.real_name;
        
        request.class_type_id = user_info.uid?:@"";
        
        staListModel.class_type_id = request.class_type_id;
        
        staListModel.class_type = staListModel.class_type;
        
        request.class_type = @"person";
        
        request.is_day = nil;//默认月统计
        
    }else if (!JLGisLeaderBool && [request.class_type isEqualToString:@"person"]) {
        
        staInitialModel.sel_memberUid = user_info.uid;
        
        staInitialModel.sel_memberName = user_info.real_name;
        
        request.class_type_id = user_info.uid?:@"";
        
        staListModel.class_type_id = request.class_type_id;
        
        staListModel.class_type = staListModel.class_type;
        
        request.class_type = @"person";
        
        request.is_day = nil;//默认月统计
    }
    
    request.start_time = staInitialModel.stTime;
    
    request.end_time = staInitialModel.endTime;
    
    staListMidVc.staListModel = staListModel;
    
    staListMidVc.request = request;
    
    [vc.navigationController pushViewController:staListMidVc animated:YES];
}

#pragma mark - 保存初始数据、人员和时间
+ (void)getInitialTimeWithUser_info:(JGJSynBillingModel *)user_info {
    
    //搜索显示统一用单例处理，避免多层传值
    JGJRecordStaSearchTool *searchTool = [JGJRecordStaSearchTool shareStaSearchTool];
    
    JGJRecordStaInitialModel *staInitialModel = searchTool.staInitialModel;
    
    //获取初始时间保存初始值
    NSString *format = @"yyyy-MM-dd";
    
    NSDate *date = [NSDate date];
    
    NSString *start_time = [NSDate convertSolaDateWithDate:[NSString stringWithFormat:@"%@-%@-%@", @(date.components.year), @"01", @"01"]];
    
    NSDate *start_Date = [NSDate dateFromString:start_time withDateFormat:format];
    
    start_time = [NSDate stringFromDate:start_Date format:format];
    
    NSString *end_time = [NSString stringWithFormat:@"%@-%@-%@", @(date.components.year), @(date.components.month), @(date.components.day)];
    
    NSDate *end_date = [NSDate dateFromString:end_time withDateFormat:format];
    
    end_time = [NSDate stringFromDate:end_date format:format];
    
    //判断时间问题
    
    NSInteger stYear = start_Date.components.year;
    
    NSInteger stMonth = start_Date.components.month;
    
    NSInteger stDay = start_Date.components.day;
    
    
    NSInteger enYear = end_date.components.year;
    
    NSInteger enMonth = end_date.components.month;
    
    NSInteger enDay = end_date.components.day;
    
    BOOL is_cover = (stYear > enYear) || (stYear <= enYear && stMonth > enMonth) || (stYear <= enYear && stMonth <= enMonth && stDay > enDay);
    
    if (stYear > enYear) {
        
        is_cover = YES;
        
    }else if (stYear == enYear && stMonth > enMonth) {
        
        is_cover = YES;
        
    }else if (stYear == enYear && stMonth == enMonth && stDay > enDay) {
        
        is_cover = YES;
        
    }else {
        
        is_cover = NO;
        
    }
    
    if (is_cover) {
        
        NSInteger minYear = enYear-1;
        
        start_time = [NSDate convertSolaDateWithDate:[NSString stringWithFormat:@"%@-%@-%@", @(minYear), @"01", @"01"]];
        
        if (![NSString isEmpty:start_time]) {
            
            start_Date = [NSDate dateFromString:start_time withDateFormat:format];
            
            start_time = [NSDate stringFromDate:start_Date format:format];
        }
        
    }
    
    staInitialModel.stTime = start_time;
    
    staInitialModel.endTime = end_time;
    
    staInitialModel.memberUid = user_info.uid;
    
    staInitialModel.memberName = user_info.real_name;
    
    staInitialModel.proName = AllProName;
    
    staInitialModel.proId = AllProId;
    ;
    ;
    ;
}

@end
