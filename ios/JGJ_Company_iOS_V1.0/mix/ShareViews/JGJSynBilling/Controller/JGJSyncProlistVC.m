//
//  JGJSyncProlistVC.m
//  mix
//
//  Created by celion on 16/5/24.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJSyncProlistVC.h"
#import "JGJNewAddProlistVC.h"
#import "CFRefreshTableView.h"
#import "JGJSyncProlistCell.h"
#import "CustomAlertView.h"
#import "JGJMorePullDownView.h"
#import "JGJSynBillEditContactsVc.h"
#import "JGJCustomPopView.h"
#import "JGJCustomAlertView.h"
@interface JGJSyncProlistVC () <UITableViewDelegate, UITableViewDataSource, CFRefreshStatusViewDelegate>
@property (weak, nonatomic) IBOutlet CFRefreshTableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *contentAddProjectView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentAddProjectViewH;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (strong, nonatomic) NSArray *dataSource;//存储已同步的项目
@property (strong, nonatomic) NSArray *prolistDataSource; //存储同步的项目
@property (strong, nonatomic) JGJMorePullDownView *jgjMorePullDownView;
@property (weak, nonatomic) IBOutlet UIButton *addProButton;
@end

@implementation JGJSyncProlistVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonSet];
    [self loadNetData];
}

- (void)commonSet {
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    self.contentAddProjectView.hidden = YES;
    self.contentAddProjectViewH.constant = 0;
    [self.addProButton.layer setLayerBorderWithColor:AppFontd7252cColor width:0.5 radius:5];
    self.contentAddProjectView.backgroundColor = AppFontfafafaColor;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView headerBegainRefreshing];
    self.title = [NSString stringWithFormat:@"同步给%@的项目", self.synBillingModel.real_name];
}

- (void)setIsHiddenMoreBtn:(BOOL)isHiddenMoreBtn {
    
    _isHiddenMoreBtn = isHiddenMoreBtn;
    if (_isHiddenMoreBtn) {
        
        self.moreButton.hidden = YES;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JGJSyncProlistCell *cell = [JGJSyncProlistCell cellWithTableView:tableView];
    cell.syncProlistModel = self.dataSource[indexPath.row];
    cell.lineView.hidden = self.dataSource.count - 1 == indexPath.row;
    __weak typeof(self) weaKself = self;
    cell.prolistSynCloseBlock = ^(JGJSyncProlistModel *syncProlistModel){
        JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
        NSString *title = [NSString stringWithFormat:@"关闭同步后，对方将不会再收到关于 %@ 项目的记工统计和报告内容", syncProlistModel.pro_name];
        desModel.popDetail = title;
        desModel.popTextAlignment = NSTextAlignmentLeft;
        desModel.lineSapcing = 3.0;
        JGJCustomPopView *alertView = [JGJCustomPopView showWithMessage:desModel];
        alertView.onOkBlock = ^{
               [weaKself closeSynProlistWithSyncProlistModel:syncProlistModel];
        };
    };
    return cell;
}

- (void)closeSynProlistWithSyncProlistModel:(JGJSyncProlistModel *)syncProlistModel {
    NSDictionary *parameters = @{@"tag_id" : syncProlistModel.tag_id ?:[NSNull null],
                                 @"sync_id" : syncProlistModel.sync_id ?:[NSNull null],
                                 @"uid" : self.synBillingModel.target_uid ?:[NSNull null]};
    [TYLoadingHub showLoadingWithMessage:nil];
    [JLGHttpRequest_AFN PostWithApi:@"jlworksync/shutsyncpro" parameters:parameters success:^(id responseObject) {
        [TYLoadingHub hideLoadingView];
        [self.tableView headerBegainRefreshing];
    } failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];
         [TYShowMessage showSuccess:@"关闭失败"];
    }];
}

- (void)loadNetData {
    
    NSMutableDictionary *parameters = @{@"uid" :self.synBillingModel.target_uid?:[NSNull null],
                                        @"synced" : @(1)}.mutableCopy;
    self.tableView.parameters = parameters;
    self.tableView.currentUrl = @"jlworksync/prolist";
    self.tableView.delegateOfTable = self;
    
    [self.tableView loadWithViewOfStatus:^UIView *(CFRefreshTableView *tableView, ERefreshTableViewStatus status) {
        CFRefreshStatusView *view;
        switch (status) {
            case RefreshTableViewStatusNormal: {
            }
                break;
            case RefreshTableViewStatusNoResult: {
                
                view = [[CFRefreshStatusView alloc] initWithImage:PNGIMAGE(@"NoDataDefault_NoManagePro") withTips:@"你还没有同步任何项目给他"];
                view.buttonTitle = @"同步项目";
            }
                break;
                
            case RefreshTableViewStatusNoNetwork: {
                view = [[CFRefreshStatusView alloc] initWithImage:PNGIMAGE(@"NoDataDefault_NoManagePro") withTips:@"请检查网络链接"];
            }
                break;
                
            case RefreshTableViewStatusLoadError: {
                view = [[CFRefreshStatusView alloc] initWithImage:[UIImage imageNamed:@"NoDataDefault_NoManagePro"] withTips:@"出错了，稍后再试试吧~"];
            }
                break;
                
            default: {
            }
                break;
        }
        
        if (!view) {
            view = [CFRefreshStatusView defaultViewWithStatus:status];
        }
        view.delegate = self;
        view.textColor = AppFontccccccColor;
         [self jsonWithModel];   
        return view;
        
    }];
    
}

- (void)jsonWithModel {
    self.dataSource = [JGJSyncProlistModel mj_objectArrayWithKeyValuesArray:self.tableView.dataArray];
    self.contentAddProjectView.hidden = self.dataSource.count == 0;
    self.contentAddProjectViewH.constant = self.dataSource.count == 0 ? 0 : 63;
}

- (IBAction)addProListButtonPressed:(UIButton *)sender {
    NSMutableDictionary *parameters = @{@"uid" :self.synBillingModel.target_uid?:[NSNull null],
                                        @"synced" : @(0)}.mutableCopy;
     [TYLoadingHub showLoadingWithMessage:nil];
    [JLGHttpRequest_AFN PostWithApi:@"jlworksync/prolist" parameters:parameters success:^(id responseObject) {
        self.prolistDataSource = [JGJSyncProlistModel mj_objectArrayWithKeyValuesArray:responseObject];
            [TYLoadingHub hideLoadingView];
    } failure:^(NSError *error) {
            [TYLoadingHub hideLoadingView];
    }];
}

- (void)setProlistDataSource:(NSArray *)prolistDataSource {
    _prolistDataSource = prolistDataSource;
    JGJNewAddProlistVC *newAddProlistVC = [[UIStoryboard storyboardWithName:@"JGJSynBilling" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJNewAddProlistVC"];
    newAddProlistVC.synBillingModel = self.synBillingModel;
    newAddProlistVC.dataSource = _prolistDataSource;
    if (_prolistDataSource.count > 0) {
        [self.navigationController pushViewController:newAddProlistVC animated:YES];
    } else {
        JGJCustomAlertView *alertView = [JGJCustomAlertView customAlertViewShowWithMessage:@"对不起，你没有可以添加的项目!"];
        alertView.message.textAlignment = NSTextAlignmentLeft;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    JGJNewAddProlistVC *newAddProlistVC = segue.destinationViewController;
//    newAddProlistVC.synBillingModel = self.synBillingModel;
}

#pragma mark - 更多
- (IBAction)MorePullDownBtnClick:(id)sender {
    __weak typeof(self) weakSelf = self;
    
    //编辑联系人
    [self.jgjMorePullDownView MorePullDownEditBlock:^{
        [weakSelf.jgjMorePullDownView hiddenMorePullDownView];
        JGJSynBillEditContactsVc *jgjSynBillEditContactsVc = [[UIStoryboard storyboardWithName:@"JGJSynBilling" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJSynBillEditContactsVc"];
        jgjSynBillEditContactsVc.synBillingModel = weakSelf.synBillingModel;
        [weakSelf.navigationController pushViewController:jgjSynBillEditContactsVc animated:YES];
    }];
    
    //删除联系人
    [self.jgjMorePullDownView MorePullDownDeleteBlock:^{
        [weakSelf.jgjMorePullDownView hiddenMorePullDownView];
        
        if (weakSelf.dataSource.count != 0) {//不能删除,需要弹框
             [JGJCustomAlertView customAlertViewShowWithMessage:@"由于现在有项目同步给此人暂时不能删除"];
        }else{//删除
            NSString *popMessage = [NSString stringWithFormat:@"确定要删除同步人 %@ 吗?",self.synBillingModel.real_name];
            JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
            desModel.popDetail = popMessage;
            desModel.popTextAlignment = NSTextAlignmentLeft;
            desModel.lineSapcing = 3.0;
            JGJCustomPopView *alertView = [JGJCustomPopView showWithMessage:desModel];
            alertView.onOkBlock = ^{
                [JLGHttpRequest_AFN PostWithApi:@"jlworksync/delusersync" parameters:@{@"uid":weakSelf.synBillingModel.target_uid} success:^(id responseObject) {
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }];
            };
        }
        
    }];
    
    //显示
    [self.jgjMorePullDownView showMorePullDownView];
}

#pragma Mark - CFRefreshStatusViewDelegate
- (void)cfreRreshStatusViewButtonPressedWithcfreRreshStatusView:(CFRefreshStatusView *)statusView {
    JGJNewAddProlistVC *newAddProlistVC = [[UIStoryboard storyboardWithName:@"JGJSynBilling" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJNewAddProlistVC"];;
    newAddProlistVC.synBillingModel = self.synBillingModel;
    [self addProListButtonPressed:nil];
}

#pragma mark - 懒加载
- (JGJMorePullDownView *)jgjMorePullDownView{
    if (!_jgjMorePullDownView) {
        _jgjMorePullDownView = [[JGJMorePullDownView alloc] initWithSubViewT:60 right:10];
    }
    
    return  _jgjMorePullDownView;
}

#pragma mark - CFRefreshStatusViewDelegate
- (void)CFRefreshTableViewLoadDataSuccess:(CFRefreshTableView *)table {
    
    
    
}

@end
