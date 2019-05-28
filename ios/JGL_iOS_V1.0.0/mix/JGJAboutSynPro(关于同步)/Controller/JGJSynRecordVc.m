//
//  JGJSynRecordVc.m
//  mix
//
//  Created by yj on 2018/4/13.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJSynRecordVc.h"

#import "JGJSynRecordCell.h"

#import "JGJSynRecordHeaderView.h"

#import "JGJSelSynTypeView.h"

#import "JGJAddSynInfoVc.h"

#import "JGSelSynTypeVc.h"

#import "JGJCustomPopView.h"

#import "JGJCustomLable.h"

#import "JGJCommonButton.h"

@interface JGJSynRecordVc () <

    UITableViewDelegate,

    UITableViewDataSource,

    JGJSynRecordCellDelegate,

    JGJSelSynTypeViewDelegate,

    JGJSynRecordHeaderViewDelegate
>

@property (nonatomic, strong) JGJRefreshTableView *tableView;

@property (nonatomic, strong) JGJSelSynTypeView *synTypeView;

@property (nonatomic, strong) NSMutableArray *dataSource;

/** 默认页样式根据首次进入页面有无数据样式会变, 首次进入没有数据选择类型 ,有数据到无数据,缺省页*/
@property (nonatomic, assign) BOOL isDefaultType;

@end

@implementation JGJSynRecordVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = AppFontf1f1f1Color;
    
    [self.view addSubview:self.tableView];
    
    [self loadSynedList];
    
}

- (void)setRightItem {
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"新增同步" style:UIBarButtonItemStylePlain target:self action:@selector(addSynItemPressed)];
    
    JGJCommonButton *rightItemBtn = [[JGJCommonButton alloc] init];
    
    rightItemBtn.buttonTitle = @"新增同步";
    
    rightItemBtn.type = JGJCommonCreatProType;
    
    [rightItemBtn addTarget:self action:@selector(addSynItemPressed) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemBtn];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    JGJSynedProModel *synProModel = self.dataSource[section];
    
    return !synProModel.isExpand ? synProModel.synced_list.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJSynRecordCell *cell = [JGJSynRecordCell cellWithTableView:tableView];
    
    cell.delegate = self;
    
    JGJSynedProModel *synedProModel = self.dataSource[indexPath.section];
    
    cell.proListModel = synedProModel.synced_list[indexPath.row];
    
    cell.synedProModel = synedProModel;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return  nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    JGJSynedProModel *synPro = self.dataSource[section];
    
    return synPro.synced_list.count == 0 ? CGFLOAT_MIN : 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    JGJSynRecordHeaderView *headerView = [JGJSynRecordHeaderView synRecordHeaderViewWithTableView:tableView];
    
    JGJSynedProModel *synedProModel = self.dataSource[section];
    
    headerView.synedProModel = synedProModel;
    
    headerView.delegate = self;
    
    return headerView;
}

#pragma mark - 点击展开按钮
- (void)synRecordHeaderView:(JGJSynRecordHeaderView *)headerView {
    
    [self.tableView reloadData];
    
}

#pragma mark - 新增同步
- (void)addSynItemPressed {
        
    JGSelSynTypeVc *synTypeVc = [[JGSelSynTypeVc alloc] init];
    
    [self.navigationController pushViewController:synTypeVc animated:YES];
    
    TYWeakSelf(self);
    
    synTypeVc.synSuccessBlock = ^(NSDictionary *res) {
        
        [weakself loadSynedList];
    };
    
}

- (void)freshTable {
    
    [self.tableView.mj_header beginRefreshing];
    
}

#pragma mark - 取消同步按钮按下
-(void)synRecordCellCancelButtonPressedWithCell:(JGJSynRecordCell *)cell {
    
    JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
    
    desModel.popDetail = @"确定要取消该项目的同步吗？";
    
    desModel.leftTilte = @"取消";
    
    desModel.rightTilte = @"确定";
    
    JGJCustomPopView *alertView = [JGJCustomPopView showWithMessage:desModel];
    
    __weak typeof(self) weakSelf = self;
    
    alertView.onOkBlock = ^{
        
        [weakSelf shutSynProWithCell:cell];
    };

}

- (void)shutSynProWithCell:(JGJSynRecordCell *)cell {
    
    NSDictionary *parameters = @{
                                 @"tag_id" : cell.proListModel.tag_id ?:@"0",
                                 
                                 @"sync_id" : cell.proListModel.sync_id ?:@"",
                                 
                                 @"uid" : cell.synedProModel.user_info.uid ?:@""
                                 
                                 };
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithApi:@"jlworksync/shutsyncpro" parameters:parameters success:^(id responseObject) {
        [TYLoadingHub hideLoadingView];
        
//        [self.tableView.mj_header beginRefreshing];
        
        [TYLoadingHub hideLoadingView];
        
        [cell.synedProModel.synced_list removeObject:cell.proListModel];
    
        NSInteger synced_num = [cell.synedProModel.synced_num integerValue];
        
        if (synced_num > 0) {
            
            synced_num--;
            
            cell.synedProModel.synced_num = [NSString stringWithFormat:@"%@", @(synced_num)];
            
        }
        
        if (cell.synedProModel.synced_list.count == 0) {
            
            [self.dataSource removeObject:cell.synedProModel];
            
        }
        
        if (self.dataSource.count == 0) {
            
            self.tableView.tableHeaderView = [self setHeaderDefaultView];
        
            [self listDefaultHeight];
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
        [TYShowMessage showSuccess:@"关闭失败"];
        
    }];
    
}

- (void)listDefaultHeight{
    
    self.tableView.y = 10;
    
    self.tableView.height = TYGetUIScreenHeight - JGJ_NAV_HEIGHT - 45 - 10;
}

- (void)selSynTypeView:(JGJSelSynTypeView *)typeView buttonType:(JGJSelSynButtonType)buttonType {
    
    switch (buttonType) {
            
        case JGJSelSynRecordWorkAccountButtonType:
            
            break;
            
        case JGJSelSynRecordWorkButtonType:
            
            break;
            
        default:
            break;
    }
    
}

- (void)loadSynedList {
    
    JGJRequestBaseModel *request = [[JGJRequestBaseModel alloc] init];
    
    request.requestApi = @"sync/synced-to-target-list";
    
    self.tableView.request = request;
    
    TYWeakSelf(self);
    
    [self.tableView loadWithViewOfStatus:^UIView *(JGJRefreshTableView *tableView, JGJRefreshTableViewStatus status) {
        
        weakself.dataSource = [JGJSynedProModel mj_objectArrayWithKeyValuesArray:tableView.dataArray];
        
        if (weakself.dataSource.count > 0) {
            
            _isDefaultType = YES;
            
            [weakself.synTypeView removeFromSuperview];
            
            [weakself setRightItem];
            
            weakself.tableView.scrollEnabled = YES;
            
            weakself.title = @"同步记工";
            
            weakself.tableView.tableHeaderView = [weakself setHeaderDesInfo];
            
        }
        
        CGRect rect = CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight - JGJ_NAV_HEIGHT - 45);
        
        self.tableView.frame = rect;
        
        UIView *headerView = nil;
        
        switch (status) {
                
            case JGJRefreshTableViewStatusNoResult:{
                
//                if (!_isDefaultType) {
//
//                    weakself.tableView.scrollEnabled = NO;
//
//                    headerView = weakself.synTypeView;
//
//                    weakself.title = @"选择同步类型";
//
//                }else {
//
//                    headerView = [weakself setHeaderDefaultView];
//
//                    weakself.title = @"同步记工";
//
//                }
                                
                [weakself listDefaultHeight];
                
                headerView = [weakself setHeaderDefaultView];
                
                weakself.title = @"同步记工";
                
            }
                
                break;
                
            default:
                break;
        }
        
        return headerView;
        
    }];
}

#pragma mark -设置缺省页
- (UIView *)setHeaderDefaultView {
    
    JGJComDefaultView *defaultView = [[JGJComDefaultView alloc] initWithFrame:CGRectMake(0, 10, TYGetUIScreenWidth, TYGetUIScreenHeight - 10)];
    
    JGJComDefaultViewModel *defaultViewModel = [JGJComDefaultViewModel new];
    
    defaultViewModel.lineSpace = 5;
    
    defaultViewModel.des = @"暂无同步给他人的数据\n若需同步数据，请点击右上角的\"新增同步\"";
    
    defaultViewModel.isHiddenButton = YES;
    
    defaultView.defaultViewModel = defaultViewModel;
    
    [self setRightItem];
    
    return defaultView;
}

#pragma mark -设置顶部信息
- (UIView *)setHeaderDesInfo {
    
    JGJCustomLable *cusLable = [[JGJCustomLable alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 36)];
    
    cusLable.textInsets  = UIEdgeInsetsMake(0, 10, 0, 0);
    
    cusLable.text = @"已同步的项目";
    
    cusLable.font = [UIFont systemFontOfSize:AppFont30Size];
    
    cusLable.textColor = AppFont333333Color;
    
    cusLable.backgroundColor = AppFontEBEBEBColor;

    return cusLable;
}

- (void)setDataSource:(NSMutableArray *)dataSource {
    
    _dataSource = dataSource;
    
//    JGJSynedProModel *firstProModel = dataSource.firstObject;
    
//    firstProModel.isExpand = YES;
    
}

- (void)selSynTypeView:(JGJSelSynTypeView *)typeView syncType:(JGJSyncType)syncType {
    
    JGJAddSynInfoVc *synInfoVc = [[JGJAddSynInfoVc alloc] init];
    
    synInfoVc.syncType = syncType;
    
    synInfoVc.synSuccessBlock = self.synSuccessBlock;
    
    [self.navigationController pushViewController:synInfoVc animated:YES];
    
    TYWeakSelf(self);
    
    synInfoVc.synSuccessBlock = ^(NSDictionary *res) {
        
        [weakself loadSynedList];
        
    };
    
    
}

- (JGJRefreshTableView *)tableView {
    
    if (!_tableView) {
        
        CGRect rect = CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight - JGJ_NAV_HEIGHT - 45);
        
        _tableView = [[JGJRefreshTableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.dataSource = self;
        
        _tableView.delegate = self;
        
        _tableView.backgroundColor = AppFontf1f1f1Color;
        
    }
    
    return _tableView;
}

- (JGJSelSynTypeView *)synTypeView {
    
    if (!_synTypeView) {
        
        _synTypeView = [[JGJSelSynTypeView alloc] initWithFrame:self.view.bounds];
        
        _synTypeView.delegate = self;
    
    }
    
    return _synTypeView;
}

- (void)dealloc {
    
    TYLog(@"dealloc");
}

@end
