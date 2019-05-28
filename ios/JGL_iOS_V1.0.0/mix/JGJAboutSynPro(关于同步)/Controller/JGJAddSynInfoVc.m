//
//  JGJAddSynInfoVc.m
//  mix
//
//  Created by yj on 2018/4/16.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJAddSynInfoVc.h"

#import "JGJComTitleDesCell.h"

#import "JGJCustomButtonCell.h"

#import "JGJSelSynProListVc.h"

#import "JGJSelSynMemberVc.h"

#import "JGJNewNotifyTool.h"

#import "JGJCustomAlertView.h"

#import "CustomAlertView.h"

#import "JGJCustomLable.h"


@interface JGJAddSynInfoVc () <

UITableViewDelegate,

UITableViewDataSource,

JGJCustomButtonCellDelegate

>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) JGJCustomButtonModel *customButtonModel;

//同步项目列表
@property (nonatomic, strong) NSMutableArray *proList;
@end

@implementation JGJAddSynInfoVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *title = @"新增同步";
    
    switch (self.syncType) {
        case JGJSyncRecordWorkType:{
            
            title = @"新增同步记工";
        }
            
            break;
            
        case JGJSyncRecordWorkAndAccountsType:{
            
            title = @"新增同步记工记账";
        }
            
            break;
            
        default:
            break;
    }
    
    self.title = title;
    
    [self.view addSubview:self.tableView];
    
    JGJCustomLable *topDes = [[JGJCustomLable alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 77)];
    
    topDes.numberOfLines = 0;
    
    NSString *firDes = @"什么是同步对象、同步项目？";
    
    topDes.text = [NSString stringWithFormat:@"%@\n%@",firDes,@"同步对象是指，你需要把某个项目的数据给那个人看\n同步项目是指，你需要给某个人看到的那个项目"];
    
    topDes.font = [UIFont systemFontOfSize:AppFont26Size];
    
    topDes.textColor = AppFontFF6600Color;
    
    topDes.backgroundColor = AppFontFDF1E0Color;
    
    [topDes setAttributedStringText:firDes font:[UIFont boldSystemFontOfSize:AppFont26Size] lineSapcing:6];
    
    topDes.textInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        
    self.tableView.tableHeaderView = topDes;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.dataSource.count - 1 == indexPath.section ? 103 : 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return  nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    if (indexPath.section == self.dataSource.count - 1) {
        
        cell = [self handleRegisterSynButtonCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
        
    }else {
        
        JGJComTitleDesCell *desCell  = [JGJComTitleDesCell cellWithTableView:tableView];
        
        JGJComTitleDesInfoModel *infoModel = self.dataSource[indexPath.section];
        
        infoModel.isHiddenArrow = indexPath.section == 0 && self.notifyModel;
        
        desCell.infoModel = self.dataSource[indexPath.section];
     
        cell = desCell;
    }

    return cell;
    
}

- (UITableViewCell *)handleRegisterSynButtonCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJCustomButtonCell *chatButtonCell = [JGJCustomButtonCell cellWithTableView:tableView];
    
    chatButtonCell.delegate = self;
    
    chatButtonCell.customButtonModel = self.customButtonModel;
    
    return chatButtonCell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
            
        case 0:{
            
            [self tableView:tableView didSelectSynProObjectRowAtIndexPath:indexPath];
        }
            
            break;
            
        case 1:{
            
            [self tableView:tableView didSelectSynProRowAtIndexPath:indexPath];
        }
            
            break;
            
        default:
            break;
    }
}

#pragma mark - 选择同步项目
- (void)tableView:(UITableView *)tableView didSelectSynProRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJSelSynProListVc *proListVc = [[JGJSelSynProListVc alloc] init];
    
    JGJSelSynProListModel *curProModel = [JGJSelSynProListModel new];
    
    //当前选中的项目
    JGJComTitleDesInfoModel *infoModel = self.dataSource[1];
    
    curProModel.pid = infoModel.typeId;
    
    curProModel.pro_name = infoModel.des?:@"";
    
    proListVc.curProModel = curProModel;
    
    proListVc.popTargetVc = self;
    
    //保存项目列表
    proListVc.dataSource = self.proList;
    
    TYWeakSelf(self);
    
    proListVc.proListVcBlock = ^(JGJSelSynProListModel *proModel, NSMutableArray *proList) {
      
        JGJComTitleDesInfoModel *infoModel = weakself.dataSource[1];
        
        infoModel.des = proModel.pro_name;
        
        infoModel.typeId = proModel.pid;
        
        weakself.proList = proList;
        
        [weakself.tableView reloadData];
    };
    
    [self.navigationController pushViewController:proListVc animated:YES];
    
}

#pragma mark - 选择同步对象
- (void)tableView:(UITableView *)tableView didSelectSynProObjectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //系统消息有同步的人过来不能点击
    
    if (indexPath.section == 0 && self.notifyModel) {
        
        return;
    }
    
    JGJSelSynMemberVc *selMemberVc = [[JGJSelSynMemberVc alloc] init];
    
    TYWeakSelf(self);
    
    selMemberVc.hubViewType = YZGAddContactsHUBViewSynType;
    
    selMemberVc.accountingMemberVCSelectedMemberBlock = ^(JGJSynBillingModel *member) {
        
        JGJComTitleDesInfoModel *infoModel = weakself.dataSource[0];
        
        infoModel.des = member.name;
        
        infoModel.typeId = member.target_uid;
        
        [weakself.tableView reloadData];
        
    };
    
    //传入模型参数，标记已选中
    JGJSynBillingModel *seledAccountMember = [JGJSynBillingModel new];
    
    JGJComTitleDesInfoModel *infoModel = self.dataSource[0];
    
    seledAccountMember.name = infoModel.des;
        
    seledAccountMember.target_uid = infoModel.typeId;
    
    selMemberVc.seledAccountMember = seledAccountMember;
    
    [self.navigationController pushViewController:selMemberVc animated:YES];
}

#pragma mark - JGJCustomButtonCellDelegate 立即同步按钮按下
- (void)customButtonCell:(JGJCustomButtonCell *)cell ButtonCellType:(JGJCustomButtonCellType)buttonCellType {
    
    JGJComTitleDesInfoModel *proModel = self.dataSource[1];
    
    JGJComTitleDesInfoModel *memberModel = self.dataSource[0];
    
    if ([NSString isEmpty:memberModel.typeId]) {
        
        [TYShowMessage showPlaint:@"请选择同步对象"];
        
        return;
    }
    
    if ([NSString isEmpty:proModel.typeId]) {
        
        [TYShowMessage showPlaint:@"请选择同步项目"];
        
        return;
    }
    
    NSString *proInfo = [NSString stringWithFormat:@"%@,%@,%@",memberModel.typeId,proModel.typeId, proModel.des];
    
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *parameters = @{
                                 @"pro_info" : proInfo,
                                 
                                 @"sync_type" : @(self.syncType),
                                 @"msg_id":self.notifyModel.msg_id ?:@""
                                 
                                 };
    
    CustomAlertView *alertView = [CustomAlertView showWithMessage:nil leftButtonTitle:nil midButtonTitle:nil rightButtonTitle:nil];
    
    [alertView showProgressImageView];
    
    [JLGHttpRequest_AFN PostWithApi:@"jlworksync/syncpro" parameters:parameters success:^(NSArray *responseObject) {
        
        alertView.onOkBlock = ^{
            
            //选择的人和系统消息带来的是同一个人更新数据库
            if ([weakSelf.notifyModel.target_uid isEqualToString:memberModel.typeId]) {
                
                [weakSelf handleSynProUpDateDataBase];
                
            }
            
            //同步成功回调更新数据
            
            if (weakSelf.synSuccessBlock) {
                
                weakSelf.synSuccessBlock(responseObject);
            }
            
            [weakSelf popSynVc];
            
        };
        
        [alertView showSuccessImageView];
        
        [weakSelf.tableView.mj_header beginRefreshing];
        
    }failure:^(NSError *error) {
        
        [alertView removeFromSuperview];
                
    }];

}

- (void)popSynVc {
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        
        if ([vc isKindOfClass:NSClassFromString(@"JGJSynRecordParentVc")]) {
            
            [self.navigationController popToViewController:vc animated:YES];
            
            break;
        }
    }
    
}


#pragma mark - 处理同步账单成功更新数据库
- (void)handleSynProUpDateDataBase {
    
    self.notifyModel.isSuccessSyn = YES;//同步成功设置为YES
    
    [JGJNewNotifyTool updateNotifyModel:self.notifyModel];
    
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        CGRect rect = CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight - JGJ_NAV_HEIGHT);
        
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.dataSource = self;
        
        _tableView.delegate = self;
        
        _tableView.backgroundColor = AppFontf1f1f1Color;
        
        self.view.backgroundColor = AppFontf1f1f1Color;
        
    }
    
    return _tableView;
}

- (NSMutableArray *)dataSource {
    
    NSString *uid = self.notifyModel.target_uid?:@"";
    
    NSString *name = self.notifyModel.user_name?:@"";
    
    NSArray *titles = @[@"同步对象", @"同步项目", @"立即同步"];
    
    NSArray *deses = @[name,@"",@""];
    
    if (!_dataSource) {
        
        _dataSource = [NSMutableArray array];
        
        for (NSInteger index = 0; index < titles.count; index++) {
        
            JGJComTitleDesInfoModel *infoModel =  [JGJComTitleDesInfoModel new];
            
            infoModel.title = titles[index];
            
            infoModel.des = deses[index];
            
            infoModel.typeId = index == 0 ? uid : nil;
            
            
            [_dataSource addObject:infoModel];
        }
    }
    
    return _dataSource;
}

- (JGJCustomButtonModel *)customButtonModel {
    
    if (!_customButtonModel) {
        
        _customButtonModel = [JGJCustomButtonModel new];
        
        _customButtonModel.buttonTitle = @"立即同步";
        
        _customButtonModel.backColor = AppFontd7252cColor;
        
        _customButtonModel.layerColor = AppFontd7252cColor;
        
        _customButtonModel.titleColor = [UIColor whiteColor];
    }
    
    return _customButtonModel;
}

@end
