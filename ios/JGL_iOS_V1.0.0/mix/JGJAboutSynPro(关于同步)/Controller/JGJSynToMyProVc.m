//
//  JGJSynToMyProVc.m
//  mix
//
//  Created by yj on 2018/4/17.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJSynToMyProVc.h"

#import "JGJComDefaultView.h"

#import "JGJSynToMyProListCell.h"

#import "JGJRecordStaListDetailVc.h"

#import "JGJSelSynMemberVc.h"

#import "JGJCustomPopView.h"

#import "JGJAboutSynRequestModel.h"

#import "JGJRecordHeader.h"

#import "NSArray+JGJDateSort.h"

#import "JGJSynRecordHeaderView.h"

#import "JGJCusBottomButtonView.h"

@interface JGJSynToMyProVc () <

UITableViewDelegate,

UITableViewDataSource

>

@property (nonatomic, strong) JGJComDefaultView *defaultView;

@property (nonatomic, strong) JGJRefreshTableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) JGJCusBottomButtonView *buttonView;

@end

@implementation JGJSynToMyProVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = AppFontf1f1f1Color;
    
    [self loadSynedList];
    
    self.title = @"同步给我的记工";
    
    [self.view addSubview:self.tableView];
}

- (void)hiddenRightItem {
    
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)addRightItem {
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editItemPressed:)];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    JGJSynedProModel *synProModel = self.dataSource[section];
    
    return synProModel.synced_list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJSynToMyProListCell *cell = [JGJSynToMyProListCell cellWithTableView:tableView];
    
    TYWeakSelf(self);
    
    cell.isDelStatus = self.isDelStatus;
    
    cell.synToMyProListCellBlock = ^(JGJSynedProListModel *proModel) {
      
        [weakself delSynProWithProModel:proModel];
    };
    
    JGJSynedProModel *synedProModel = self.dataSource[indexPath.section];
    
    cell.proListModel = synedProModel.synced_list[indexPath.row];
    
    cell.lineView.hidden = synedProModel.synced_list.count - 1 == indexPath.row;
        
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footer = [[UIView alloc] init];
    
    footer.backgroundColor = AppFontf1f1f1Color;
    
    return  footer;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    JGJSynedProModel *synPro = self.dataSource[section];
    
    return synPro.synced_list.count == 0 ? CGFLOAT_MIN : 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    JGJSynRecordHeaderView *headerView = [JGJSynRecordHeaderView synRecordHeaderViewWithTableView:tableView];
    
    JGJSynedProModel *synedProModel = self.dataSource[section];
    
    synedProModel.is_syn_me = YES;
    
    headerView.synedProModel = synedProModel;
    
    headerView.expandButton.hidden = YES;
    
    headerView.desLable.hidden = YES;
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isDelStatus) {
        
        return;
    }
    
    [self staListDetailVcWithIndexPath:indexPath];
}



#pragma mark - 项目统计
- (void)staListDetailVcWithIndexPath:(NSIndexPath *)indexPath {
    
//    JGJRecordStaListDetailVc *detailVc = [[UIStoryboard storyboardWithName:@"JGJRecordWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJRecordStaListDetailVc"];
    
    JGJSynedProModel *synedProModel = self.dataSource[indexPath.section];
        
    JGJSynedProListModel *proModel = synedProModel.synced_list[indexPath.row];
    
    JGJRecordWorkStaListModel *staListModel = [JGJRecordWorkStaListModel new];
    
    staListModel.nameDes = proModel.pro_name?:@"";
    
    staListModel.name = proModel.pro_name?:@"";
    
//    JGJRecordWorkStaRequestModel *request = [JGJRecordWorkStaRequestModel new];
//
//    request.class_type_id = proModel.pid;
//
//    request.uid = proModel.uid;
//
//    request.class_type_target_id = proModel.uid;
    
    staListModel.class_type_id = proModel.pid;
    
    staListModel.class_type = @"project";
    
    staListModel.class_type_target_id = proModel.uid;
    
    JGJSynBillingModel *user_info = [JGJSynBillingModel new];
    
//同步人的uid
    user_info.target_uid = proModel.uid;
    
//    request.class_type = @"project";
//    
//    detailVc.staListModel = staListModel;
//    
//    request.is_day = nil;//默认月统计
//    
//    detailVc.request = request;
//    
//    detailVc.request.class_type_id = staListModel.class_type_id;
//    
//    //禁止跳转到记工流水
//    detailVc.isForbidSkipWorkpoints = YES;
    
//    [self.navigationController pushViewController:detailVc animated:YES];
    
    staListModel.is_lock_proname = YES;
    
    staListModel.is_lock_name = NO;
    
    [JGJRecordStaSearchTool skipVcWithVc:self staListModel:staListModel user_info:user_info];
}

#pragma mark - 删除项目列表
- (void)delSynProWithProModel:(JGJSynedProListModel *)proListModel {
    
    [self synRecordCellCancelButtonPressedWithProListModel:proListModel];
    
}

#pragma mark - 编辑按钮按下
- (void)editItemPressed:(UIBarButtonItem *)item {
    
    self.isDelStatus = ! self.isDelStatus;
    
}

#pragma mark - 邀请人员同步项目
- (void)requireMemberSynPro {
    
    JGJSelSynMemberVc *selMemberVc = [[JGJSelSynMemberVc alloc] init];
    
    selMemberVc.hubViewType = YZGAddContactsHUBViewSynToMeType;
    
    [self.navigationController pushViewController:selMemberVc animated:YES];
}

- (void)setIsDelStatus:(BOOL)isDelStatus {
    
    _isDelStatus = isDelStatus;
    
    self.navigationItem.rightBarButtonItem.title = _isDelStatus ? @"取消" : @"编辑";
    
    [self.tableView reloadData];
}

- (void)loadSynedList {
    
    JGJRequestBaseModel *request = [[JGJRequestBaseModel alloc] init];
    
    request.requestApi = @"sync/synced-to-me-list";
    
    self.tableView.request = request;
    
    TYWeakSelf(self);
    
    [self.tableView loadWithViewOfStatus:^UIView *(JGJRefreshTableView *tableView, JGJRefreshTableViewStatus status) {
        
//        weakself.dataSource = [JGJSynedProListModel mj_objectArrayWithKeyValuesArray:tableView.dataArray];
        
        NSArray *dataSource = [tableView.dataArray groupBySortDataSourceWithGroupKey:@"uid" subListKey:@"synced_list" headerKeys:@[@"uid",@"real_name"]];
        
         weakself.dataSource = [JGJSynedProModel mj_objectArrayWithKeyValuesArray:dataSource];
        
        if (weakself.dataSource.count > 0 && !weakself.navigationItem.rightBarButtonItem) {
            
            [weakself addRightItem];
        }
        
        if (weakself.dataSource.count > 0 && !_buttonView) {
            
            [weakself.view addSubview:self.buttonView];
            
            weakself.buttonView.hidden = NO;
            
        }else if (weakself.dataSource.count == 0) {
            
            _buttonView.hidden = YES;
            
            _buttonView.frame = CGRectZero;
            
            weakself.defaultView.hidden = NO;
            
            weakself.defaultView.frame = TYGetUIScreenMain.bounds;
        }
        
        if (weakself.dataSource.count > 0) {
            
            CGRect rect = CGRectMake(0, 10, TYGetUIScreenWidth, TYGetUIScreenHeight - JGJ_NAV_HEIGHT - 45 - _buttonView.height - 10);
            
            weakself.tableView.frame = rect;
            
            [weakself.tableView reset];
            
            weakself.defaultView.hidden = YES;
            
            weakself.buttonView.hidden = NO;
            
            CGFloat height = [JGJCusBottomButtonView cusBottomButtonViewHeight];
            
            CGFloat buttonViewY = TYGetUIScreenHeight - JGJ_NAV_HEIGHT - height - JGJ_IphoneX_BarHeight - 45;
            
            weakself.buttonView.frame = CGRectMake(0, buttonViewY, TYGetUIScreenWidth, height);
        }
        
        JGJComDefaultView *defaultView = nil;
        
        switch (status) {
                
            case JGJRefreshTableViewStatusNoResult:{
                
                defaultView = weakself.defaultView;
                
                [weakself hiddenRightItem];
                
                _defaultView.comDefaultViewBlock = ^{
                    
                    [weakself requireMemberSynPro];
                };
                
            }
                
                break;
                
            default:
                break;
        }
        
        return defaultView;
        
    }];
    
}

#pragma mark - 取消同步按钮按下
-(void)synRecordCellCancelButtonPressedWithProListModel:(JGJSynedProListModel *)proListModel {
    
    JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
    
    desModel.popDetail = @"是否取消该数据的同步？";
    
    desModel.leftTilte = @"取消";
    
    desModel.rightTilte = @"确定";
    
    JGJCustomPopView *alertView = [JGJCustomPopView showWithMessage:desModel];
    
    __weak typeof(self) weakSelf = self;
    
    alertView.onOkBlock = ^{
        
        [weakSelf shutSynProWithProListModel:proListModel];
        
    };
    
}

- (void)shutSynProWithProListModel:(JGJSynedProListModel *)proListModel {
    
    NSString *uid = [TYUserDefaults objectForKey:JLGUserUid];
    
    NSDictionary *parameters = @{
                                 @"tag_id" : proListModel.tag_id ?:@"0",
                                 
                                 @"sync_id" : proListModel.sync_id ?:@"",
                                 
                                 @"uid" : uid ?:@""
                                 
                                 };
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithApi:@"jlworksync/shutsyncpro" parameters:parameters success:^(id responseObject) {
        [TYLoadingHub hideLoadingView];
        
        [self.tableView.mj_header beginRefreshing];
        
        [TYLoadingHub hideLoadingView];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
        [TYShowMessage showSuccess:@"关闭失败"];
        
    }];
    
}

- (JGJComDefaultView *)defaultView {
    
    if (!_defaultView) {
        
        _defaultView = [[JGJComDefaultView alloc] initWithFrame:CGRectMake(0, 10, TYGetUIScreenWidth, TYGetUIScreenHeight - 10)];
        
        JGJComDefaultViewModel *defaultViewModel = [[JGJComDefaultViewModel alloc] init];
        
        defaultViewModel.lineSpace = 15;
        
        defaultViewModel.des = @"当前还没有人向你同步记账数据\n你可以联系其他班组长，要求他向你同步";
        
        defaultViewModel.offsetCenterY = 55;
    
        _defaultView.defaultViewModel = defaultViewModel; 
        
    }
    
    return _defaultView;
}

- (JGJRefreshTableView *)tableView {
    
    if (!_tableView) {
        
        CGRect rect = CGRectMake(0, 10, TYGetUIScreenWidth, TYGetUIScreenHeight - JGJ_NAV_HEIGHT - 45 - 10);
        
        _tableView = [[JGJRefreshTableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.dataSource = self;
        
        _tableView.delegate = self;
        
        _tableView.backgroundColor = AppFontf1f1f1Color;
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 10)];
        
        headerView.backgroundColor = AppFontf1f1f1Color;
        
        _tableView.tableHeaderView = headerView;
        
    }
    
    return _tableView;
}

- (JGJCusBottomButtonView *)buttonView {
    
    if (!_buttonView) {
        
        CGFloat height = [JGJCusBottomButtonView cusBottomButtonViewHeight];
        
        CGFloat buttonViewY = TYGetUIScreenHeight - JGJ_NAV_HEIGHT - height - JGJ_IphoneX_BarHeight - 45;
        
        _buttonView = [[JGJCusBottomButtonView alloc] initWithFrame:CGRectMake(0, buttonViewY, TYGetUIScreenWidth, height)];
        
        [_buttonView.actionButton setTitle:@"邀请他人向我同步" forState:UIControlStateNormal];
        
        TYWeakSelf(self);
        
        _buttonView.handleCusBottomButtonViewBlock = ^(JGJCusBottomButtonView *view) {
          
            [weakself requireMemberSynPro];
        };
        
    }
    return _buttonView;
}

@end
