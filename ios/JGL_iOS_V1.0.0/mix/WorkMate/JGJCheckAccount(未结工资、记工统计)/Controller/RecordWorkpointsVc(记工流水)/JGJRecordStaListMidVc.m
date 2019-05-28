//
//  JGJRecordStaListMidVc.m
//  mix
//
//  Created by yj on 2018/9/26.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJRecordStaListMidVc.h"

#import "JGJRecordWorkpointsVc.h"

#import "JGJRecordStaListCell.h"

@interface JGJRecordStaListMidVc ()

//初始请求参数
@property (nonatomic, strong) JGJRecordWorkStaRequestModel *initialRequest;

//第二层参数
@property (strong, nonatomic) JGJRecordStaInitialModel *secStaInitialModel;

@end

@implementation JGJRecordStaListMidVc

@synthesize staType = _staType;

//@synthesize recordWorkStaModel = _recordWorkStaModel;

- (void)viewDidLoad {
    
    self.filterView.is_hidden_checkStaBtn = YES;
        
    self.request.class_type_id = self.staListModel.class_type_id;
    
    self.request.class_type = self.staListModel.class_type;
    
    if (JLGisLeaderBool) {
        
        if ([self.request.class_type isEqualToString:@"project"]) {
            
            self.staType = JGJRecordStaNormalWorkerType;
            
            self.headerView.selType = JGJRecordSelRightBtnType;
            
            [self loadRecordStaNetData]; //3.4.2添加
            
        }else {
            
            self.staType = JGJRecordStaMonthType;
            
            self.headerView.selType = JGJRecordSelLeftBtnType;
            
            [self loadRecordStaNetData]; //3.4.2添加
        }
        
    }else if (!JLGisLeaderBool && [self.request.class_type isEqualToString:@"person"]) { //工人角色，按班组长查看进入是月统计
        
        self.staType = JGJRecordStaMonthType;
        
        [self loadRecordStaNetData]; //3.4.2添加
    }
    
    [super viewDidLoad];
    
    BOOL is_firVc = [self isMemberOfClass:NSClassFromString(@"JGJRecordStaListVc")];

    BOOL is_SecVc = [self isMemberOfClass:NSClassFromString(@"JGJRecordStaListMidVc")];

    BOOL is_thirVc = [self isMemberOfClass:NSClassFromString(@"JGJRecordStaListDetailVc")];

    if (is_SecVc) {

        JGJRecordWorkStaRequestModel *initialRequest = [JGJRecordWorkStaRequestModel mj_objectWithKeyValues:[self.request mj_keyValues]];

        self.initialRequest = initialRequest;
        
        [self setFilterButtonStatus:YES];

    }
    
}

#pragma mark - 显示之类保存的数据
- (void)subWillViewWillAppear:(BOOL)animated {
    
    BOOL is_SecVc = [self isMemberOfClass:NSClassFromString(@"JGJRecordStaListMidVc")];
    
    if (is_SecVc) {
        
        JGJRecordWorkStaRequestModel *initialRequest = [JGJRecordWorkStaRequestModel mj_objectWithKeyValues:[self.initialRequest mj_keyValues]];
        
        self.request = initialRequest;
        
//        //显示的时候初始值处理
        [self setInitialSecRequst];
        
    }
 
}

- (void)filterSelIndex:(NSInteger)selIndex {
    
    if (JLGisLeaderBool) {
        
        switch (selIndex) {
            case 0:{
                
                self.staType = JGJRecordStaMonthType;
            }
                break;
                
            case 1:{

                self.staType = [self.request.class_type isEqualToString:@"project"] ? JGJRecordStaNormalWorkerType : JGJRecordStaProjectType;
            }
                break;
                
            default:
                break;
        }
        
    }else {
        
        switch (selIndex) {
            case 0:{
                
                self.staType = JGJRecordStaMonthType;
            }
                break;
                
            case 1:{
                
                self.staType = JGJRecordStaProjectType;
            }
                break;
                
            default:
                break;
        }
        
    }
    
    [self freshTableView];
}

//子类重写参数
- (NSDictionary *)requestParameter {
    
    NSDictionary *parameters = [self.request mj_keyValues];
    
//    保存第二层的模型
    
    [self saveSecStaInitialModel];
    
    return parameters;
}

- (void)saveSecStaInitialModel {
    
    JGJRecordStaSearchTool *searchTool = [JGJRecordStaSearchTool shareStaSearchTool];
    
    JGJRecordStaInitialModel *staInitialModel = searchTool.staInitialModel;
    
    JGJRecordStaInitialModel *secStaInitialModel = [[JGJRecordStaInitialModel alloc] init];
    
    secStaInitialModel.sel_stTime = self.request.start_time;
    
    secStaInitialModel.sel_endTime = self.request.end_time;
    
    secStaInitialModel.sel_proName = staInitialModel.sel_proName;
    
    secStaInitialModel.sel_proId = staInitialModel.sel_proId;
    
    secStaInitialModel.sel_memberUid = staInitialModel.sel_memberUid;
    
    secStaInitialModel.sel_memberName = staInitialModel.sel_memberName;
    
    //记账类型
    secStaInitialModel.sel_account_types = staInitialModel.sel_account_types;
    
    self.secStaInitialModel = secStaInitialModel;
    
}

- (NSString *)requestApi {
    
    NSString *api = @"workday/get-work-record-statistics";
    
    if (self.staType == JGJRecordStaMonthType) {     //月统计
        
        api = @"workday/get-month-record-statistics";
        
    }

    else if (self.staType == JGJRecordStaNormalWorkerType || self.staType == JGJRecordStaProjectType || self.staType == JGJRecordStaWorkLeaderType) {
        
        api = @"workday/get-person-record-statistics";
        
    }
    
    return api;
}

- (void)registerSubClassWithTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return;
    }
    
    switch (self.staType) {
            
        case JGJRecordStaMonthType:{
            
//            //同步项目进来等类型不能进入流水 同步给我的记工进入时 3.4.2注释都能进入流水
            
//            if (self.isForbidSkipWorkpoints) {
//                
//                return;
//            }
            
            JGJRecordWorkpointsVc *pointsVc = [[UIStoryboard storyboardWithName:@"JGJRecordWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJRecordWorkpointsVc"];
            
            pointsVc.is_hidden_checkBtn = YES;
            
            //这里的问题是date被改成uid了,
            JGJRecordStaListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
            //3.4bugly报错 -[JGJRecordWorkpointsAllTypeMoneyCell des]: unrecognized selector。添加判断
            if ([cell isMemberOfClass:NSClassFromString(@"JGJRecordStaListCell")]) {
                
                if (![NSString isEmpty:cell.des] && self.staType == JGJRecordStaMonthType) {
                    
                    self.staListModel.date = cell.des;
                    
                }
                
            }
            
            JGJRecordWorkStaDetailListModel *listModel = [JGJRecordWorkStaDetailListModel mj_objectWithKeyValues:[self.staListModel mj_keyValues]];

            //月统计不传人的uid
            
            if ([self.staListModel.is_sync isEqualToString:@"1"]) {
                
                listModel.class_type_target_id = @"";
                
            }
            
            listModel.class_type = self.staListModel.class_type;
            
            listModel.accounts_type = self.request.accounts_type;
            
            //第二层进去只传项目或者人的时候，这里的name 和 target_name后台返回的是一个 3.3.7
            
            if ([NSString isEmpty:listModel.class_type_target_id]) {
                
                listModel.target_name = nil;
                
            }
            
            pointsVc.staDetailListModel = listModel;
            
            [self.navigationController pushViewController:pointsVc animated:YES];
        }

            break;
            
        case JGJRecordStaNormalWorkerType:{
            
            //第二级班组长，按工人统计点击进入月统计
            [self registerStaDetailWithTableView:tableView didSelectRowAtIndexPath:indexPath];
            
        }
            break;
        
        case JGJRecordStaProjectType:{
            
            //第二级班组长，按项目统计点击进入月统计
            [self registerStaDetailWithTableView:tableView didSelectRowAtIndexPath:indexPath];
            
        }
            break;
        
        default:
            break;
    }
}

- (NSString *)registerNameShowTypeWithStaListModel:(JGJRecordWorkStaListModel *)staListModel{
    
    NSString *des = staListModel.name;
    
    switch (self.staType) {
            
        case JGJRecordStaMonthType:{
            
            des = staListModel.date;
        }
            
            break;
            
        default:
            break;
    }
    
    return des;
}

- (void)setStaType:(JGJRecordStaType)staType {
    
    _staType = staType;
    
    switch (_staType) {
        case JGJRecordStaSearchMainType:{  //统计首页
            

            
        }
            
            break;
            
        case JGJRecordStaSearchSecCheckMemberType:{  // 记工统计-按工人查看2级页面-按月份统计
            

        }
            break;
            
        case JGJRecordStaSearchSecCheckProType:{  // 记工统计-按项目查看2级页面-按工人统计
            
            self.headerView.selType = JGJRecordSelRightBtnType;
            
        }
            break;
            
        case JGJRecordStaSearchMonthType:{  // 按月统计(可切换为按天统计）
            
            
        }
            break;
            
        default:{
            

        }
            break;
    }
    
}

#pragma mark - 加载记工统计
- (void)loadRecordStaNetData {
    
    NSDictionary *parameters = [self requestParameter];
    
    [TYLoadingHub showLoadingNoDataDefultWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithNapi:[self requestApi] parameters:parameters success:^(id responseObject) {
        
        JGJRecordWorkStaModel *recordWorkStaModel = [JGJRecordWorkStaModel mj_objectWithKeyValues:responseObject];
        
        //统计顶部数据
        
        [recordWorkStaModel handleTopContractorSta];
        
        self.recordWorkStaModel = recordWorkStaModel;
        
        //顶部筛选高度调整
        
        TYWeakSelf(self);
        
        [self.filterView setFilterRecordWorkStaModel:recordWorkStaModel staFilterAccountypesBlock:^(JGJRecordWorkStaModel *recordWorkStaModel, CGFloat height) {
            
            weakself.filterViewH.constant = height;
            
        }];
        
        [self showDefaultNodataArray:self.recordWorkStaModel.list];
        
        self.maxTrail = [JGJRecordStaListCell maxWidthWithStaList:self.recordWorkStaModel.list];
        
        [self.tableView reloadData];
        
        //        [self.tableView.mj_header endRefreshing];
        
        [TYLoadingHub hideLoadingView];
        
    } failure:^(NSError *error) {
        
        //        [self.tableView.mj_header endRefreshing];
        
        [TYLoadingHub hideLoadingView];
        
    }];
    
}

- (void)setInitialSecRequst {
    
    JGJRecordStaSearchTool *searchTool = [JGJRecordStaSearchTool shareStaSearchTool];
    
//    searchTool.staInitialModel = self.secStaInitialModel;
    
    JGJRecordStaInitialModel *staInitialModel = searchTool.staInitialModel;

    //复制选择的数据

    staInitialModel.sel_stTime = self.request.start_time;

    staInitialModel.sel_endTime = self.request.end_time;

    staInitialModel.sel_proName = self.secStaInitialModel.sel_proName;

    staInitialModel.sel_proId = self.secStaInitialModel.sel_proId;

    staInitialModel.sel_memberUid = self.secStaInitialModel.sel_memberUid;

    staInitialModel.sel_memberName = self.secStaInitialModel.sel_memberName;

    //记账类型
    staInitialModel.sel_account_types = self.secStaInitialModel.sel_account_types;
    
    
}

//- (void)setRecordWorkStaModel:(JGJRecordWorkStaModel *)recordWorkStaModel {
//
//    _recordWorkStaModel = recordWorkStaModel;
//
//    [self showDefaultNodataArray:_recordWorkStaModel.list];
//
//    self.maxTrail = [JGJRecordStaListCell maxWidthWithStaList:_recordWorkStaModel.list];
//
//    [self.tableView reloadData];
//
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
