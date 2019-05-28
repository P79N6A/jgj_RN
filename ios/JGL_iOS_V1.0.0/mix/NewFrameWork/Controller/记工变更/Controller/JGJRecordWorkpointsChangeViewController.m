//
//  JGJRecordWorkpointsChangeViewController.m
//  mix
//
//  Created by Tony on 2018/8/2.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJRecordWorkpointsChangeViewController.h"
#import "JGJRecordWorkpointsChangeListTimeCell.h"
#import "JGJAgentMonitorInfoCell.h"
#import "JGJAgentMonitorMyInfoCell.h"

#import "JGJRecordWorkpointsChangeModel.h"
#import "JGJRecordWorkpointsChangeViewController+JGJCreateTimeModel.h"
#import "JGJRecordWorkpointsVc.h"
#import "JGJRecordBillDetailViewController.h"

#import "NSDate+Extend.h"
#import "JGJCusActiveSheetView.h"
#import "JGJAccountShowTypeVc.h"

#import "JGJNotepadListEmptyView.h"
#import "JGJPerInfoVc.h"

@interface JGJRecordWorkpointsChangeViewController ()<UITableViewDelegate,UITableViewDataSource,JGJRecordWorkpointsChangeNewlyIncreasedViewDelegate>
{
    JGJRecordWorkpointsChangeListTimeCell *_timeCell;
    JGJAgentMonitorInfoCell *_amOtherCell;// 别人信息
    JGJAgentMonitorMyInfoCell *_amMyCell;// 自己信息
    
    NSInteger _page;
    
}

@property (nonatomic, strong) UITableView *changeListTable;
@property (nonatomic, strong) JGJAccountShowTypeModel *selTypeModel;
@property (nonatomic, strong) JGJNotepadListEmptyView *emptyView;
@end

@implementation JGJRecordWorkpointsChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"记工变更";
    self.view.backgroundColor = AppFontf1f1f1Color;
    [self initializeAppearance];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recordBillChangeSuccess) name:@"recordBillChangeSuccess" object:nil];
}

- (void)recordBillChangeSuccess {
    
    [_changeListTable.mj_header beginRefreshing];
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
//    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more_red"] style:UIBarButtonItemStylePlain target:self action:@selector(modifyWorkTime)];
    
//        self.navigationItem.rightBarButtonItem = rightBarItem;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(modifyWorkTime)];
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;

    
    [self getWorkDayChangeListWithPage:1];
    
    //默认显示方式
    self.selTypeModel = [JGJAccountShowTypeTool showTypeModel];
    [self.changeListTable reloadData];
}

- (void)modifyWorkTime
{
    [self showSheetView];
    
}
- (void)showSheetView{
    
    self.selTypeModel = [JGJAccountShowTypeTool showTypeModel];
    
    JGJCusActiveSheetViewModel *sheetViewModel = [[JGJCusActiveSheetViewModel alloc] init];
    
    sheetViewModel.firstTitle = self.selTypeModel.title;
    
    sheetViewModel.secTitle = JGJSwitchRecordBillShowModel;
    
    sheetViewModel.flagStr = @"account_check_icon";
    
    NSArray *buttons = @[self.selTypeModel.title?:@"",JGJSwitchRecordBillShowModel,@"取消"];
    
    __weak typeof(self) weakSelf = self;
    
    JGJCusActiveSheetView *sheetView = [[JGJCusActiveSheetView alloc]  initWithSheetViewModel:sheetViewModel sheetViewType:JGJCusActiveSheetViewRecordAccountType buttons:buttons buttonClick:^(JGJCusActiveSheetView *sheetView, NSInteger buttonIndex, NSString *title) {
        
        if (buttonIndex == 0) {
            
            JGJAccountShowTypeVc *typeVc = [[JGJAccountShowTypeVc alloc] init];

            typeVc.selTypeModel = weakSelf.selTypeModel;

            [weakSelf.navigationController pushViewController:typeVc animated:YES];
        }
        
    }];
    
    
    [sheetView showView];
}

- (void)getWorkDayChangeListWithPage:(NSInteger)page {
    
    NSDictionary *dic = @{@"pg":@(page),
                          @"pagesize":@"5",
                          @"group_id":_group_id ? :@""
                          };
    [JLGHttpRequest_AFN PostWithNapi:@"workday/get-workday-change-list" parameters:dic success:^(id responseObject) {
        
        NSArray *arr = [JGJRecordWorkpointsChangeModel mj_objectArrayWithKeyValuesArray:responseObject];
        
        if (page == 1) {
            
            [self.changeListArr removeAllObjects];
            self.changeListArr = [JGJRecordWorkpointsChangeModel mj_objectArrayWithKeyValuesArray:responseObject];
            
            
        }else {
            
            NSArray *msgs = [JGJRecordWorkpointsChangeModel mj_objectArrayWithKeyValuesArray:responseObject];
            self.changeListArr = [msgs arrayByAddingObjectsFromArray:self.changeListArr].mutableCopy;
            
            
        }
        
        if (arr.count < 5) {

            self.changeListTable.mj_footer = nil;
            self.changeListTable.contentInset = UIEdgeInsetsMake(0, 0, 8, 0);
            
        }else {

            if (self.changeListTable.mj_footer == nil) {

                __weak typeof(self) weakSelf = self;
                __strong typeof(self) strongSelf = self;
                _changeListTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{

                    strongSelf -> _page ++;
                    [weakSelf getWorkDayChangeListWithPage:strongSelf -> _page];
                }];
            }

        }
        
        if (self.changeListArr.count == 0) {
            
            [self.emptyView setEmptyImage:@"NoDataDefault_NoManagePro" emptyText:@"暂无记工变更记录\n班组长和代班长新记的账、修改的账、删除的账，可以在记工变更页面查看详情"];
            self.emptyView.backgroundColor = [UIColor whiteColor];
            self.emptyView.frame = _changeListTable.bounds;
            self.emptyView.recordLabel.font = [UIFont systemFontOfSize:AppFont30Size];
            self.emptyView.recordLabel.textColor = AppFontccccccColor;
            _changeListTable.tableHeaderView = _emptyView;
            
        }else {
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, CGFLOAT_MIN)];
            _changeListTable.tableHeaderView = view;
        }
        
        [self deailTimeGroupWithSource];
        [_changeListTable reloadData];
        
        [_changeListTable.mj_header endRefreshing];
        [_changeListTable.mj_footer endRefreshing];
        
        if (page == 1) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.changeListArr.count > 0) {
                    
                    [_changeListTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.changeListArr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                }
                
            });
        }else {
            
            //处理下拉刷新偏移问题
            CGSize beforeContentSize = _changeListTable.contentSize;
            [self handleTableViewOffset:beforeContentSize];
        }
        
        
    } failure:^(NSError *error) {
        
        [_changeListTable.mj_header endRefreshing];
        [_changeListTable.mj_footer endRefreshing];
    }];
}

#pragma mark - 处理tableView下拉刷新偏移问题
- (void)handleTableViewOffset:(CGSize)beforeContentSize {
    
    //先刷新获取最新的大小
    [_changeListTable reloadData];
    
    CGSize afterContentSize = _changeListTable.contentSize;
    
    CGPoint afterContentOffset = _changeListTable.contentOffset;
    
    CGPoint newContentOffset = CGPointMake(afterContentOffset.x, afterContentOffset.y + afterContentSize.height - beforeContentSize.height);
    [_changeListTable setContentOffset:newContentOffset animated:NO] ;
    
}

- (void)initializeAppearance {
    
    [self.view addSubview:self.changeListTable];
    [self setUpLayout];
}

- (void)setUpLayout {
    
    [_changeListTable mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.left.right.bottom.mas_equalTo(0);
    }];
}

- (void)setProListModel:(JGJMyWorkCircleProListModel *)proListModel {
    
    _proListModel = proListModel;
}

#pragma mark - UITableViewCell/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.changeListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    JGJRecordWorkpointsChangeModel *changeInfoModel = self.changeListArr[indexPath.row];
    __weak typeof(self) weakSelf = self;
    if ([changeInfoModel.record_type integerValue] == 0) {// 时间类型
        
        _timeCell = [JGJRecordWorkpointsChangeListTimeCell cellWithTableViewNotXib:tableView];
        _timeCell.changeInfoModel = changeInfoModel;
        return _timeCell;
        
    }else {
        
        // 区分自己还是别人
        if (changeInfoModel.isMySelfOprationRecord) {// 自己
            
            _amMyCell = [JGJAgentMonitorMyInfoCell cellWithTableViewNotXib:tableView];
            _amMyCell.indexPath = indexPath;
            _amMyCell.selTypeModel = self.selTypeModel;
            _amMyCell.changeInfoModel = changeInfoModel;
            _amMyCell.newlyIncreasedView.newlyIncreasedDelegate = self;
            _amMyCell.myBubbleView.headerPickClick = ^(NSIndexPath *indexPach) {
              
                TYLog(@"点击头像 = %@",indexPach);
                JGJRecordWorkpointsChangeModel *changeInfoModel = weakSelf.changeListArr[indexPath.row];
                JGJPerInfoVc *perInfoVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJPerInfoVc"];
                
                perInfoVc.jgjChatListModel.uid = changeInfoModel.uid;
                
                perInfoVc.jgjChatListModel.group_id = changeInfoModel.uid;
                
                perInfoVc.jgjChatListModel.class_type = @"singleChat";
                
                [weakSelf.navigationController pushViewController:perInfoVc animated:YES];
            };
            return _amMyCell;
            
        }else {
            
            _amOtherCell = [JGJAgentMonitorInfoCell cellWithTableViewNotXib:tableView];
            _amOtherCell.indexPath = indexPath;
            _amOtherCell.selTypeModel = self.selTypeModel;
            _amOtherCell.changeInfoModel = changeInfoModel;
            _amOtherCell.newlyIncreasedView.newlyIncreasedDelegate = self;
            _amOtherCell.otherBubbleView.headerPickClick = ^(NSIndexPath *indexPach) {
              
                TYLog(@"点击头像 = %@",indexPach);
                JGJRecordWorkpointsChangeModel *changeInfoModel = weakSelf.changeListArr[indexPath.row];
                JGJPerInfoVc *perInfoVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJPerInfoVc"];
                
                perInfoVc.jgjChatListModel.uid = changeInfoModel.uid;
                
                perInfoVc.jgjChatListModel.group_id = changeInfoModel.uid;
                
                perInfoVc.jgjChatListModel.class_type = @"singleChat";
                
                [weakSelf.navigationController pushViewController:perInfoVc animated:YES];
            };
            return _amOtherCell;
        }
        
    }
    
    return nil;
    
}

- (void)didSelectedNewlyIncreasedCellWithIndexPath:(NSIndexPath *)indexPath addInfoModel:(JGJAdd_infoChangeModel *)addInfoModel{
    
    JGJRecordWorkStaDetailListModel *staDetailListModel = [[JGJRecordWorkStaDetailListModel alloc] init];
    staDetailListModel.date = addInfoModel.date;

    JGJRecordWorkpointsVc *recordWorkpointsVc = [[UIStoryboard storyboardWithName:@"JGJRecordWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJRecordWorkpointsVc"];

    //项目类型
    staDetailListModel.proName = self.proListModel.group_info.all_pro_name;
    
    staDetailListModel.pid = self.proListModel.group_info.pro_id;

    staDetailListModel.is_change_date = YES;

    recordWorkpointsVc.staDetailListModel = staDetailListModel;

    recordWorkpointsVc.proListModel = self.proListModel.group_info;
    
    recordWorkpointsVc.is_change_date = YES;
    
    [self.navigationController pushViewController:recordWorkpointsVc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJRecordWorkpointsChangeModel *changeInfoModel = self.changeListArr[indexPath.row];
    
    return changeInfoModel.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJRecordWorkpointsChangeModel *changeInfoModel = self.changeListArr[indexPath.row];
    
    if ([changeInfoModel.record_type integerValue] == 1) {// 新增类型 -> 记工流水
        
        
    }else if ([changeInfoModel.record_type integerValue] == 2) {// 修改 -> 记账详情
        
        MateWorkitemsItems *mateWorkitemsItem = [MateWorkitemsItems new];
        mateWorkitemsItem.accounts_type.code = [changeInfoModel.record_info.accounts_type integerValue];
        mateWorkitemsItem.id =  [changeInfoModel.record_id?:@"0" longLongValue];
        mateWorkitemsItem.record_id = changeInfoModel.record_id ? :@"0";
        mateWorkitemsItem.role = 2;
        mateWorkitemsItem.group_id = changeInfoModel.group_id;

        if ([changeInfoModel.role integerValue] == 3) {// 代班长记的账
            
            mateWorkitemsItem.agency_uid = changeInfoModel.uid;
        }
        
        JGJRecordBillDetailViewController *recordBillVC = [[UIStoryboard storyboardWithName:@"JGJRecordBillDetailVC" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJRecordBillDetailVC"];
        recordBillVC.mateWorkitemsItems = mateWorkitemsItem;
        [self.navigationController pushViewController:recordBillVC animated:YES];
    }

}

- (UITableView *)changeListTable {
    
    if (!_changeListTable) {
        
        _changeListTable = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _changeListTable.backgroundColor = AppFontf1f1f1Color;
        _changeListTable.delegate = self;
        _changeListTable.dataSource = self;
        _changeListTable.showsVerticalScrollIndicator = NO;
        _changeListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _changeListTable.tableFooterView = [[UIView alloc] init];
        _changeListTable.estimatedRowHeight = 0;
        _changeListTable.estimatedSectionFooterHeight = 0;
        _changeListTable.estimatedSectionHeaderHeight = 0;
        __weak typeof(self) weakSelf = self;
        __strong typeof(self) strongSelf = self;
        _changeListTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            strongSelf -> _page ++;
            [weakSelf getWorkDayChangeListWithPage:strongSelf -> _page];
        }];
        
        
        _changeListTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            
            strongSelf -> _page = 1;
            [weakSelf getWorkDayChangeListWithPage:strongSelf -> _page];
        }];
        
    }
    return _changeListTable;
}

- (NSMutableArray *)changeListArr {
    
    if (!_changeListArr) {
        
        _changeListArr = [NSMutableArray array];
    }
    return _changeListArr;
}

- (JGJNotepadListEmptyView *)emptyView {
    
    if (!_emptyView) {
        
        _emptyView = [[JGJNotepadListEmptyView alloc] init];
    }
    return _emptyView;
}

@end
