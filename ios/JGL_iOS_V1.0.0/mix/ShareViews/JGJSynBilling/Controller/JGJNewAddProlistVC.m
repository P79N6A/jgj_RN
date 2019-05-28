//
//  JGJNewAddProlistVC.m
//  mix
//
//  Created by celion on 16/5/24.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJNewAddProlistVC.h"
#import "JGJNewAddProlistCell.h"
#import "CFRefreshTableView.h"
#import "CustomAlertView.h"
#import "JGJCustomAlertView.h"
#define HeaderH 27
@interface JGJNewAddProlistVC () <UITableViewDataSource, UITableViewDelegate, CFRefreshStatusViewDelegate>

@property (weak, nonatomic) IBOutlet CFRefreshTableView *tableView;
@property (strong, nonatomic) NSMutableArray *selectedProlist;
@property (strong, nonatomic)  UIView *headerView;
@end

@implementation JGJNewAddProlistVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    self.title = [NSString stringWithFormat:@"选择要同步给%@的项目", self.synBillingModel.real_name];
//    [self loadNetData]; //后续用
    if (self.dataSource.count > 0) {
        [self.tableView reloadData];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JGJNewAddProlistCell *cell = [JGJNewAddProlistCell cellWithTableView:tableView];
    cell.syncProlistModel = self.dataSource[indexPath.row];
    cell.lineView.hidden = self.dataSource.count - 1 == indexPath.row;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JGJSyncProlistModel *syncProlistModel = self.dataSource[indexPath.row];
    syncProlistModel.isSelected = !syncProlistModel.isSelected;
    if (syncProlistModel.isSelected) {
        [self.selectedProlist addObject:syncProlistModel];
    } else {
        [self.selectedProlist removeObject:syncProlistModel];
    }
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return HeaderH;
}
- (void)loadNetData {
    
    NSMutableDictionary *parameters = @{@"uid" :self.synBillingModel.target_uid?:[NSNull null],
                                        @"synced" : @(0)}.mutableCopy;
    self.tableView.parameters = parameters;
    self.tableView.currentUrl = @"jlworksync/prolist";
    [self.tableView loadWithViewOfStatus:^UIView *(CFRefreshTableView *tableView, ERefreshTableViewStatus status) {
        CFRefreshStatusView *view;
        switch (status) {
                
            case RefreshTableViewStatusNormal:
                break;
            case RefreshTableViewStatusNoResult: {
                
                view = [[CFRefreshStatusView alloc] initWithImage:PNGIMAGE(@"NoDataDefault_NoManagePro") withTips:@"你还没有同步任何项目给他"];
                view.buttonTitle = @"同步项目";
            }
                break;
                
            case RefreshTableViewStatusNoNetwork:
                view = [[CFRefreshStatusView alloc] initWithImage:PNGIMAGE(@"NoDataDefault_NoManagePro") withTips:@"请检查网络链接"];
                break;
                
            case RefreshTableViewStatusLoadError:
                view = [[CFRefreshStatusView alloc] initWithImage:[UIImage imageNamed:@"NoDataDefault_NoManagePro"] withTips:@"出错了，稍后再试试吧~"];
                break;
                
            default:break;
        }
        
        if (!view) {
            view = [CFRefreshStatusView defaultViewWithStatus:status];
        }
        [self jsonWithModel];
        view.textColor = AppFontccccccColor;
        view.delegate = self;
        return view;
        
    }];
    
}

- (void)jsonWithModel {
    self.dataSource = [JGJSyncProlistModel mj_objectArrayWithKeyValuesArray:self.tableView.dataArray];
    if (self.addProlistBlock) {
        self.addProlistBlock(self.dataSource);
    }
}

#pragma mark - buttonAction
- (IBAction)synProButtonPressed:(UIBarButtonItem *)sender {
    
    if (self.selectedProlist.count == 0) {
        [TYShowMessage showPlaint:@"请选择要同步的项目!"];
        return;
    }
    [self upLoadProlistWithProlist:self.selectedProlist];
}

- (void)upLoadProlistWithProlist:(NSArray *)prolist {
    NSMutableString *upLoadProinfoStr = [NSMutableString string];
    for (JGJSyncProlistModel *syncProlistModel in prolist) {
        [upLoadProinfoStr appendFormat:@"%@,%@,%@;",self.synBillingModel.target_uid, syncProlistModel.pid,syncProlistModel.pro_name];
    }
    //    删除末尾的分号
    if (upLoadProinfoStr.length > 0 && upLoadProinfoStr != nil) {
        [upLoadProinfoStr deleteCharactersInRange:NSMakeRange(upLoadProinfoStr.length - 1, 1)];
    }
    __weak typeof(self) weakSelf = self;
    NSDictionary *parameters = @{@"pro_info" : upLoadProinfoStr ?: [NSNull null]};
     JGJCustomAlertView *customAlertView = [JGJCustomAlertView customAlertViewShowWithMessage:@"仅同步工人的工作时长"];
    customAlertView.message.font = [UIFont systemFontOfSize:AppFont34Size];
    customAlertView.onClickedBlock = ^{
    
        CustomAlertView *alertView = [CustomAlertView showWithMessage:nil leftButtonTitle:nil midButtonTitle:nil rightButtonTitle:nil];
        [alertView showProgressImageView];
        [JLGHttpRequest_AFN PostWithApi:@"jlworksync/syncpro" parameters:parameters success:^(NSDictionary *responseObject) {
            [alertView showSuccessImageView];
            alertView.onOkBlock = ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            };
            [weakSelf.tableView reloadData];
        }failure:^(NSError *error) {
            [alertView removeFromSuperview];
            [TYShowMessage showPlaint:@"同步失败!"];
        }];
    };
}

- (NSMutableArray *)selectedProlist {
    if (!_selectedProlist) {
        _selectedProlist = [NSMutableArray array];
    }
    return _selectedProlist;
}

- (UIView *)headerView {

    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        _headerView.hidden = !self.dataSource.count;
        _headerView.backgroundColor = AppFontf1f1f1Color;
        UILabel *contentLable = [[UILabel alloc] init];
        contentLable.text = @"请选择要同步的项目";
        contentLable.backgroundColor = [UIColor clearColor];
        contentLable.font = [UIFont systemFontOfSize:AppFont24Size];
        contentLable.frame = CGRectMake(12, 0, TYGetViewW(self.view), HeaderH);
        contentLable.textColor = AppFont999999Color;
        [_headerView addSubview:contentLable];
    }
    return _headerView;
}

- (void)cfreRreshStatusViewButtonPressedWithcfreRreshStatusView:(CFRefreshStatusView *)statusView {

    
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
