//
//  JGJRecordWorkpointsVc.m
//  mix
//
//  Created by yj on 2018/1/2.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJRecordWorkpointsVc.h"

#import "JGJUnWagesShortWorkCell.h"

#import "JGJRecordWorkpointsAllTypeMoneyCell.h"

#import "JGJUnWageAllMoneyCell.h"

#import "JGJCheckAccountHeaderView.h"

#import "JGJRecordWorkpointTypeCountCell.h"

#import "JGJRecordWorkPointsFilterView.h"

#import "JGJCusActiveSheetView.h"

#import "JGJBottomMulButtonView.h"

#import "JGJRecordDateSelTitleView.h"

#import "JGJRecordTool.h"

#import "FDAlertView.h"

#import "JGJSurePoorBillShowView.h"

#import "JGJRecordBillDetailViewController.h"

#import "JGJModifyBillListViewController.h"

#import "CFRefreshStatusView.h"

#import "JLGCustomViewController.h"

#import "JGJBaseMenuView.h"

#import "UIViewController+REFrostedViewController.h"

#import "JGJMemberMangerModel.h"

#import "JGJSurePoorbillViewController.h"

#import "JGJCheckStaListCell.h"

#import "JGJRecordStaListVc.h"

#import "JGJAccountShowTypeVc.h"

#import "JGJHeaderFooterPaddingView.h"

#import "JGJRecordWorkpointStaView.h"

#import "NSDate+Extend.h"

#import "JGJRefreshTableView.h"

#import "JGJRecWorkMaskView.h"

#import "UIImage+Cut.h"

#import "JGJCustomPopView.h"

#import "JGJRecordWorkPointStaHeaderView.h"

#import "JGJCusBottomSelBtnView.h"

#import "JGJCusSetTinyPopView.h"

#import "JGJRecordStaDownLoadVc.h"
#import "JGJCustomAlertView.h"
@interface JGJRecordWorkpointsVc () <UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate, UIDocumentInteractionControllerDelegate, FDAlertViewDelegate,JGJSurePoorBillShowViewDelegate,JGJRecordWorkPointStaHeaderViewDelegate>

{
    
    UIDocumentInteractionController *_documentInteraction;
    
}


@property (weak, nonatomic) IBOutlet JGJRefreshTableView *tableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewH;

@property (weak, nonatomic) IBOutlet JGJBottomMulButtonView *buttonView;

@property (weak, nonatomic) IBOutlet JGJRecordWorkPointsFilterView *filterView;

@property (strong, nonatomic) JGJRecordWorkPointRequestModel *request;

@property (strong, nonatomic) JGJRecordWorkPointRequestModel *backUprequest;

//用于统计使用
@property (strong, nonatomic) JGJRecordWorkPointModel *recordWorkPointModel;

////是否显示工否则显示小时
//@property (nonatomic, assign) BOOL isShowWork;

//是否批量删除,和批量设置点工用同一个属性

@property (nonatomic, assign) BOOL isBatchDel;

//批量删除的记账
@property (nonatomic, strong) NSMutableArray *selRecords;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewH;

//总的记账个数，用于判断是否全选
@property (nonatomic, assign) NSUInteger allCount;

//全部的项目
@property (nonatomic, strong) NSArray *allPros;

//全部的班组长
@property (nonatomic, strong) NSArray *allMembers;

@property (weak,nonatomic)  IBOutlet JGJRecordDateSelTitleView *titleView;

@property (nonatomic, strong) JGJCusActiveSheetView *sheetView;

//下载文件
@property (nonatomic, strong) JGJRecordWorkDownLoadModel *downLoadModel;

@property (nonatomic, strong) JGJBaseMenuView *baseMenuView;

//传入类型标签
@property (nonatomic, strong) NSMutableArray *tags;

//传入备注标签
@property (nonatomic, strong) NSMutableArray *remarktags;

//代理人标签
@property (nonatomic, strong) NSMutableArray *agencytags;

//选中的传入是否有代理人标签
@property (nonatomic, strong) NSMutableArray *selAgencytags;

//选中的传入类型标签
@property (nonatomic, strong) NSMutableArray *seltags;

//选中的传入备注标签
@property (nonatomic, strong) NSMutableArray *selremarktags;

//传入之前筛选的模型
@property (nonatomic, strong) NSMutableArray *desInfos;

@property (weak, nonatomic) IBOutlet UIButton *filterButton;

@property (nonatomic, strong) JGJAccountShowTypeModel *selTypeModel;

//复位状态筛选默认数据
@property (nonatomic, assign) BOOL isRest;

@property (nonatomic, strong) JGJRecordWorkpointStaView *staView;

@property (nonatomic, strong) NSMutableArray *dataSource;

//备份数据源
@property (nonatomic, strong) NSMutableArray *backUpDataSource;

//用于统计使用备份顶部统计
@property (strong, nonatomic) JGJRecordWorkPointModel *backUpRecordWorkPointModel;

//备份全部数据，点击取消的时候f还原数据用

@property (nonatomic, strong) NSMutableArray *sortBackUpDataSource;

@property (nonatomic, strong) NSMutableArray *sortDataSource;

//点工
@property (nonatomic, strong) NSMutableArray *sortTinyDataSource;

@property (nonatomic, strong) JGJPageSizeModel *pageSizeModel;

//蒙层
@property (nonatomic, strong) JGJRecWorkMaskView *maskView;

@property (nonatomic, strong) UIButton *rightButton;

//首次选中的模型
@property (nonatomic, strong) NSMutableArray *fir_sel_tagModels;

@property (nonatomic, strong) JGJRecordWorkPointStaHeaderView *staHeaderView;

//批量修改点工工资标准按钮
@property (weak, nonatomic) IBOutlet JGJCusBottomSelBtnView *batchModifyView;

@property (nonatomic, strong) JGJCusSetTinyPopView *cusSetTinyPopView;

//是否被筛选。筛选后 搜索结果无数据时，缺省文字显示为：本页暂无记工数据

@property (assign, nonatomic) BOOL isFiler;

//备份筛选状态
@property (copy, nonatomic) NSString *backUpIsFiler;

//是否选择了批量修改点工

@property (assign, nonatomic) BOOL is_sel_Batch_tiny;

@end

@implementation JGJRecordWorkpointsVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //统计进入当前页面,隐藏查看按钮
    
    if (self.staDetailListModel) {
        
        self.tags = [self tag_names];
        
        //获取初始的选中标签
        self.seltags = self.fir_sel_tagModels;

    }
    
    //记工变更进入时间不能修改
    self.titleView.is_change_date = self.is_change_date;
    
    if ([NSString isEmpty:self.staDetailListModel.date]) {
        
        JGJRecordWorkStaDetailListModel *staDetailListModel = [JGJRecordWorkStaDetailListModel new];
        
        self.staDetailListModel = staDetailListModel;
        
        NSString *date = [NSString stringFromDate:[NSDate date] withDateFormat:@"yyyy-MM"];
        
        self.titleView.date = date;
        
        self.staDetailListModel.date = date;
        
    }else {
        
        if ([self.staDetailListModel.date containsString:@"年"] && [self.staDetailListModel.date containsString:@"月"]) {
            
            NSString *format = @"yyyy-MM";
            
            NSDate *date = [NSDate dateFromString:self.staDetailListModel.date withDateFormat:@"yyyy年MM月"];
            
            NSString *dateStr = [NSString stringFromDate:date withDateFormat:format];
            
            if ([self.staDetailListModel.date containsString:@"日"]) {
                
                date = [NSDate dateFromString:self.staDetailListModel.date withDateFormat:@"yyyy年MM月dd日"];
                
                dateStr = [NSString stringFromDate:date withDateFormat:format];
                
            }
            
            self.titleView.date = dateStr;
            
        }else {
            
            self.titleView.date = self.staDetailListModel.date;
        }
        
    }
    
    //默认底部全选按钮不显示
    self.bottomViewH.constant = 0;
    
    [self hiddenBottomView];
    
    //默认不是批量删除
    self.isBatchDel = NO;
    
    self.navigationItem.title = @"记工流水";
    
    TYWeakSelf(self);
    
    if (![self checkIsRealName]) {
        
        if ([self.navigationController isKindOfClass:NSClassFromString(@"JLGCustomViewController")]) {
            
            JLGCustomViewController *customVc = (JLGCustomViewController *) self.navigationController;
            
            customVc.customVcCancelButtonBlock = ^(id response) {
                
                [weakself.navigationController popViewControllerAnimated:YES];
            };
            
            customVc.customVcBlock = ^(id response) {
                
                [TYLoadingHub showLoadingNoDataDefultWithMessage:nil];
                
                //记载记工流水数据
                [weakself loadRecordStaNetData];
                
                //加载班组人员
                [weakself loadFilterDataWithClassType:@"person"];
                
                //加载项目
                [weakself loadFilterDataWithClassType:@"project"];
            };
            
        }
        
    }else {
        
        [TYLoadingHub showLoadingNoDataDefultWithMessage:nil];
        
        //加载记工流水数据
        [self loadRecordStaNetData];
        
        //加载班组人员
        [self loadFilterDataWithClassType:@"person"];
        
        //加载项目
        [self loadFilterDataWithClassType:@"project"];
    }
    
    //回调记账数据
    [self filterRecordList];
    
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    
    [self setLeftBatButtonItem];
    
    self.filterButton.titleLabel.font = [UIFont boldSystemFontOfSize:AppFont26Size];
    
    [self handleShotScreent];
    
    //初始化数据
    
    [self tag_names];
    
//同步给我的记工不显示筛选按钮
    
    self.filterButton.hidden = self.staDetailListModel.isForbidSkipWorkpoints;

//    量修改点工底部按钮按钮按下、全选，批量设置金额

    [self batchModifyWageBottomActionBlock];
    
}

#pragma mark - 批量修改点工底部按钮按钮按下、全选，批量设置金额

- (void)batchModifyWageBottomActionBlock {
    
    TYWeakSelf(self);
    
    self.batchModifyView.rightBlock = ^(UIButton *sender) {
        
        [weakself batchModifyTinyWage];
        
    };
    
    self.batchModifyView.leftBlock = ^(UIButton *sender) {
        
        sender.selected = !sender.selected;
        
        [weakself allSelRecordWithisAllSel:sender.selected];
        
    };
    
    
}

- (void)setLeftBatButtonItem {
    
    SEL getLeftButton = NSSelectorFromString(@"getLeftNoTargetButton");
    IMP imp = [self.navigationController methodForSelector:getLeftButton];
    UIButton* (*func)(id, SEL) = (void *)imp;
    UIButton *leftButton = func(self.navigationController, getLeftButton);
    
    [leftButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
}

- (void)backButtonPressed {
    
    if (self.navigationController.viewControllers.count > 0 && self.isMarkBillMoreDay) {
        
        [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
        
    }else {
        
        [self.navigationController popViewControllerAnimated:YES];
    }

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
        
    if (self.isFresh) {
        
        [TYLoadingHub showLoadingNoDataDefultWithMessage:nil];
        
        [self beginFresh];
    }
    
//    //统计请求
//    [self recordFlowtotalRequest];
    
    self.selTypeModel = [JGJAccountShowTypeTool showTypeModel];
    
//    if (self.recordWorkPointModel) {
//
//        self.staView.recordWorkPointModel = self.recordWorkPointModel;
//
//    }
    
    [self.tableView reloadData];
    
    [self.navigationController.navigationBar setTintColor:AppFontEB4E4EColor];
    
//    JGJRecordWorkStaModel *workStaModel = self.staHeaderView.recordWorkStaModel;
//
//    self.staHeaderView.recordWorkStaModel = workStaModel;
    
}

- (void)beginFresh {
    
    self.request.pg = 1;
    
    //加载记工流水数据
    [self loadRecordStaNetData];
    
}

- (void)setStaDetailListModel:(JGJRecordWorkStaDetailListModel *)staDetailListModel {
    
    _staDetailListModel = staDetailListModel;
}

//回调记账数据
- (void)filterRecordList {
    
    TYWeakSelf(self);
    
    //底部按钮全选和删除
    self.buttonView.bottomMulButtonViewBlock = ^(JGJBottomMulButtonType buttonType, BOOL isAllSelButton) {
        
        switch (buttonType) {
                
            case JGJBottomAllSelButtonType:{
                
                [weakself allSelRecordWithisAllSel:isAllSelButton];
            }
                break;
                
            case JGJBottomDelButtonType:{
                
                if (self.selRecords.count > 0) {
                    
                    [self showRecordPopView:YES];
                    
                }else {
                    
                    [TYShowMessage showPlaint:@"请选择需要删除的记录"];
                }
                
            }
                break;
                
            default:
                break;
        }
    };

    //时间筛选
    self.titleView.recordDateSelTitleViewBlock = ^(NSString *date) {
        
        
        weakself.request.date = date;
        
        //获取最新的时间用于是不是同一次筛选
        weakself.downLoadModel.date = date;
        
        weakself.staDetailListModel.date = date;
        
//初始数据
        //筛选前的数据
         weakself.dataSource = [NSMutableArray array];
        
        weakself.request.pg = 1;
        
        [TYLoadingHub showLoadingNoDataDefultWithMessage:nil];
        
        if (weakself.backUprequest ) {
            
            if (weakself.sortBackUpDataSource.count > 0) {
                
                [weakself.sortBackUpDataSource removeAllObjects];
                
            }
            
            weakself.backUprequest = nil;
            
            [weakself restoreAllData];
        }
        
        //加载数据
        [weakself loadRecordStaNetData];
        
    };
}

#pragma mark - 记账弹框
- (void)showRecordPopView:(BOOL)isBatchDel {
    
    TYWeakSelf(self);
    
    JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];

    NSString *changeColor1 = [NSString stringWithFormat:@"%@笔", self.recordWorkPointModel.total_num?:@"0"];
    
    NSString *changeColor2 = [NSString stringWithFormat:@"%@笔", @(self.selRecords.count)];
    
    desModel.changeContents = @[changeColor1,changeColor2];
    
    desModel.changeContentColor = AppFontEB4E4EColor;
    
    NSString *popDetail = [NSString stringWithFormat:@"本页共 %@笔 记工，即将删除选中的 %@笔。\n数据一经删除将无法恢复。请谨慎操作哦！", self.recordWorkPointModel.total_num?:@"0", @(self.selRecords.count)];
    
    if (!isBatchDel) {
        
        popDetail = @"数据一经删除将无法恢复。请谨慎操作哦！";
    }
    
    desModel.popDetail = popDetail;
    
    desModel.leftTilte = @"取消";
    
    desModel.rightTilte = @"确认删除";

    desModel.popTextAlignment = NSTextAlignmentLeft;
    
    JGJCustomPopView *alertView = [JGJCustomPopView showWithMessage:desModel];
    
    alertView.messageLable.textAlignment = NSTextAlignmentLeft;

    alertView.onOkBlock = ^{

        [weakself batchDelRequestWithSelRecords:self.selRecords];

    };
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
//    return self.recordWorkPointModel.workday.count;
    
    return self.sortDataSource.count + 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    if (section == 0) {
        
        BOOL isHiddenStaBtn = self.is_hidden_checkBtn || self.is_change_date;
        
        return isHiddenStaBtn ? 1 : 2;
        
    }else {
        
        NSArray *workdays = self.sortDataSource[section - 1];
        
        return workdays.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            UITableViewCell *cell = [self registerRecordWorkpointTypeCountCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
            
            return cell;
            
        }else {
            
            UITableViewCell *cell = [self registerCheckStaListCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
            
            return cell;
            
        }
        
    }else {
      
        UITableViewCell *cell = [self registerUnWagesShortWorkCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
        
        return cell;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            return [JGJRecordWorkpointsAllTypeMoneyCell cellHeight];
            
        }else {
            
            return [JGJCheckStaListCell cellHeight];
        }
    
    }else {
        
        return 80.0;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return CGFLOAT_MIN;
    }
    
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
        
    JGJHeaderFooterPaddingView *paddingView = [JGJHeaderFooterPaddingView headerFooterPaddingViewWithTableView:tableView];

    CGFloat originalY = section == 0 ? 0 : 9.5;
    
    BOOL isHidden = self.sortDataSource.count - 1 == section - 1;

    [paddingView setUpdateLineViewLayoutWithTop:originalY left:0 right:0 isHidden:isHidden];
    
    return paddingView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    CGFloat height = self.sortDataSource.count - 1 == (section - 1) ? 0.5 : 10;

    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return [[UIView alloc] init];
    }
    
    JGJCheckAccountHeaderView *headerView = [JGJCheckAccountHeaderView checkAccountHeaderViewWithTableView:tableView];
    
    NSArray *workdays = self.sortDataSource[section - 1];
    
    if (workdays.count > 0) {

        JGJRecordWorkPointWorkdayListModel *workdayListModel = workdays[0];
        
        headerView.time = [NSString stringWithFormat:@"%@ (%@)", workdayListModel.date, workdayListModel.date_turn];
        
    }
        
    return headerView;
    
}

- (UITableViewCell *)registerCheckStaListCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJCheckStaListCell *cell = [JGJCheckStaListCell cellWithTableView:tableView];
        
    return cell;
    
}

- (UITableViewCell *)registerRecordWorkpointTypeCountCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJRecordWorkpointsAllTypeMoneyCell *cell = [JGJRecordWorkpointsAllTypeMoneyCell cellWithTableView:tableView];
    
    cell.bottomLineView.hidden = YES;
    
    cell.showType = self.selTypeModel.type;
    
    cell.recordWorkStaModel = self.recordWorkPointModel;
    
    return cell;
    
}

- (UITableViewCell *)registerUnWagesShortWorkCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJUnWagesShortWorkCell *cell = [JGJUnWagesShortWorkCell cellWithTableView:tableView];
    
    cell.rightUtilityButtons = !_isBatchDel ? [self rightButtons] : nil;
    
    cell.delegate = self;

    //批量删除标记
    cell.isBatchDel = self.isBatchDel;

    //工时、工天显示
    cell.showType = self.selTypeModel.type;
    
    NSInteger section = indexPath.section - 1;

    NSArray *workdays = self.sortDataSource[section];
    
    JGJRecordWorkPointListModel *listModel = workdays[indexPath.row];
    
    cell.listModel = listModel;
    
    cell.isHiddenLineView = (workdays.count - 1 == indexPath.row) && (self.sortDataSource.count != section);
    
    cell.isScreenShowLine = self.sortDataSource.count == section;
    
    cell.nextImageView.hidden = [self.staDetailListModel.is_sync isEqualToString:@"1"];
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        
//    JGJRecordWorkPointWorkdayListModel *workdayListModel = self.recordWorkPointModel.workday[indexPath.section];
//    
//    JGJRecordWorkPointListModel *listModel = workdayListModel.list[indexPath.row];
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 1) {
            
            //记工变更进入不能点击
            if (self.is_change_date || self.is_hidden_checkBtn) {
                
                return ;
            }
            
            [self checkStaListVc];
        }
        
        return;
    }
    
    if ([self.staDetailListModel.is_sync isEqualToString:@"1"]) {
        
        return;
    }
    
    NSArray *workdays = self.sortDataSource[indexPath.section - 1];
    
    JGJRecordWorkPointListModel *listModel = workdays[indexPath.row];
    
    if (listModel.amounts_diff && !self.isBatchDel) {
        
        //差账
        [self existDiffRecordWithListModel:listModel];
        
    } else if (self.isBatchDel) {
        
        listModel.isSel = !listModel.isSel;
        
        if (listModel.isSel) {
            
            [self.selRecords addObject:listModel];
            
        }else {
            
            [self.selRecords removeObject:listModel];
        }
        
        JGJUnWagesShortWorkCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        cell.listModel = listModel;
        
        [self.tableView beginUpdates];
        
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        [self.tableView endUpdates];
        
//        [self.tableView reloadData];
        
        [self bottomBtnSelStaus];
        
    }else {
        
        //查看记账
        
        [self checkRecordWithListModel:listModel];
    }
    
}

- (void)bottomBtnSelStaus {
    
    BOOL isAllSel = self.selRecords.count == self.allCount;
    
    //是否全选标识
    self.buttonView.isAllSelStatus = isAllSel;
    
    //标记数量
    self.buttonView.selRecordCount = self.selRecords.count;
    
    self.batchModifyView.leftBtn.selected = isAllSel;
    
    [self batchModifyLeftBtnStatus:isAllSel];
    
    if (self.isBatchDel) {
        
    }
    self.batchModifyView.rightTitle = @"批量修改点工工资标准";
    
    if (self.selRecords.count > 0) {
        
        self.batchModifyView.rightTitle = [NSString stringWithFormat:@"批量修改点工工资标准(%@)", @(self.selRecords.count)];
        
    }
    
}

#pragma mark - 查看更多统计
- (void)checkStaListVc {
 
    JGJRecordStaListVc *staListVc = [[UIStoryboard storyboardWithName:@"JGJRecordWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJRecordStaListVc"];
    
    staListVc.proListModel = self.proListModel;
    
    staListVc.stTime = self.request.date;
    
    [self.navigationController pushViewController:staListVc animated:YES];
    
}

#pragma mark - 存在差账弹框
- (void)existDiffRecordWithListModel:(JGJRecordWorkPointListModel *)dayListModel {
    
//    TYLog(@"记账id=====%@ 项目id====== %@", dayListModel.recordId, dayListModel.pid);
    
//    [TYShowMessage showPlaint:@"差账弹框"];
    JGJPoorBillListDetailModel *model = [[JGJPoorBillListDetailModel alloc]init];
    model.id = dayListModel.recordId;
    model.accounts_type = dayListModel.accounts_type;
    [JGJSurePoorBillShowView showPoorBillAndModel:model AndDelegate:self andindexPath:nil andHidenismine:YES];
}

#pragma mark - 查看记账
- (void)checkRecordWithListModel:(JGJRecordWorkPointListModel *)dayListModel {
    
    MateWorkitemsItems *mateWorkitemsItem = [self TransformModel:dayListModel];
    
    if (![NSString isEmpty:self.proListModel.group_id]) {
        
        mateWorkitemsItem.group_id = self.proListModel.group_id;
        
        mateWorkitemsItem.agency_uid = [TYUserDefaults objectForKey:JLGUserUid];
        
    }
    
    JGJRecordBillDetailViewController *recordBillVC = [[UIStoryboard storyboardWithName:@"JGJRecordBillDetailVC" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJRecordBillDetailVC"];
    recordBillVC.mateWorkitemsItems = mateWorkitemsItem;
    [self.navigationController pushViewController:recordBillVC animated:YES];
    
}
- (MateWorkitemsItems *)TransformModel:(JGJRecordWorkPointListModel *)wageBestDetailWorkday{
    
    MateWorkitemsItems *mateWorkitemsItem = [MateWorkitemsItems new];
    mateWorkitemsItem.accounts_type.code = [wageBestDetailWorkday.accounts_type integerValue];
    mateWorkitemsItem.id =  [wageBestDetailWorkday.recordId?:@"0" longLongValue];
    mateWorkitemsItem.record_id = wageBestDetailWorkday.recordId ? :@"0";
    return mateWorkitemsItem;
}
- (void)rightBarButtonItemPressed {
    
    [self showSheetView];
}

- (void)showSheetView{
    
    self.selTypeModel = [JGJAccountShowTypeTool showTypeModel];
    
    NSArray *buttons = @[self.selTypeModel.title?:@"", JGJSwitchRecordBillShowModel, @"下载记工考勤表", @"批量修改点工工资标准",@"批量删除", @"取消"];
    
    JGJCusActiveSheetViewModel *sheetViewModel = [[JGJCusActiveSheetViewModel alloc] init];
    
    sheetViewModel.firstTitle = self.selTypeModel.title;
    
    sheetViewModel.secTitle = JGJSwitchRecordBillShowModel;
    
    sheetViewModel.flagStr = @"account_check_icon";
    
    __weak typeof(self) weakSelf = self;
    
    JGJCusActiveSheetView *sheetView = [[JGJCusActiveSheetView alloc]  initWithSheetViewModel:sheetViewModel sheetViewType:JGJCusActiveSheetViewRecordAccountType buttons:buttons buttonClick:^(JGJCusActiveSheetView *sheetView, NSInteger buttonIndex, NSString *title) {
        
        if (!weakSelf.tableView.mj_footer){
            
            weakSelf.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:weakSelf refreshingAction:@selector(onFooterRereshing)];
            
        }
        
        if (buttonIndex == 0) {
            
            JGJAccountShowTypeVc *typeVc = [[JGJAccountShowTypeVc alloc] init];
            
            typeVc.selTypeModel = weakSelf.selTypeModel;
            
            [weakSelf.navigationController pushViewController:typeVc animated:YES];
            
        }else if (buttonIndex == 1) {
            
            if (weakSelf.sortDataSource.count > 0) {
                
                JGJRecordWorkDownLoadModel *downLoadModel = [JGJRecordTool downFileExistWithRecordDownLoadModel:weakSelf.downLoadModel request:weakSelf.request];
                
                if (downLoadModel.isExistDifFile) {
                    
                    [weakSelf shareFormWithFileUrl:downLoadModel.allFilePath];
                    
                }else {
                    
                    [weakSelf loadDownLoadFile];
                }
                
            }else {
                
                [TYShowMessage showPlaint:@"没有可下载的数据"];
            }
            
        }else if (buttonIndex == 2) {
            
            weakSelf.is_sel_Batch_tiny = YES;
            
            //拷贝帅选状态
            weakSelf.backUpIsFiler = weakSelf.isFiler ? @"1" : @"0";
            
            weakSelf.backUpRecordWorkPointModel = [JGJRecordWorkPointModel mj_objectWithKeyValues:[weakSelf.recordWorkPointModel mj_keyValues]];
            
            weakSelf.backUpDataSource = weakSelf.dataSource.mutableCopy;
            
            weakSelf.backUprequest = [JGJRecordWorkPointRequestModel mj_objectWithKeyValues:[weakSelf.request mj_keyValues]];
            
            weakSelf.sortBackUpDataSource = weakSelf.sortDataSource.mutableCopy;
            
            weakSelf.filterButton.hidden = YES;
            
            weakSelf.request.pg = 1;
            
            weakSelf.request.is_note = @"0";
            
            weakSelf.request.is_agency = @"0";
            
            weakSelf.request.accounts_type = @"1";
            
            weakSelf.request.pid = nil;
            
            weakSelf.request.uid = nil;
            
            [weakSelf loadRecordStaNetData];
            
            weakSelf.batchModifyView.hidden = NO;
            
            weakSelf.buttonView.hidden = YES;
            
            weakSelf.batchModifyView.rightTitle = @"批量修改点工工资标准";
            
            [weakSelf bacthModifyWageAction];
            
        }
        
        else if (buttonIndex == 3) {
            
            if (weakSelf.sortDataSource.count > 0) {
                
                weakSelf.batchModifyView.hidden = YES;

                weakSelf.buttonView.hidden = NO;
                
                weakSelf.sortBackUpDataSource = weakSelf.sortDataSource.mutableCopy;

                [weakSelf batchDel]; //批量删除;
                
            }else {
                
                [TYShowMessage showPlaint:@"没有可删除的数据"];
            }
            
            
        }else if (buttonIndex == 4) { //取消按钮
            
            //还原数据
            if (weakSelf.sortBackUpDataSource.count > 0) {
                
                weakSelf.sortDataSource = weakSelf.sortBackUpDataSource;
                
                weakSelf.allCount = weakSelf.dataSource.count;
            }
            
            
        }
        
        [weakSelf.tableView reloadData];
        
    }];
    
    self.sheetView = sheetView;
    
    //移除筛选界面
    [self.filterView removeFilterView];
    
    [sheetView showView];
}

#pragma mark - 确认记工列表页面
- (void)surePoorbillVc {
    
    JGJSurePoorbillViewController *poorBillVC = [[UIStoryboard storyboardWithName:@"JGJSurePoorbillVC" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJSurePoorbillVC"];
    
//    poorBillVC.currectTime = self.contractYzgGetBillModel.date?:@"";
    
//    poorBillVC.uid = [NSString stringWithFormat:@"%ld",(long)self.contractYzgGetBillModel.uid];
//
//    //包工类型
//    poorBillVC.accounts_type = @"2";
    
    [self.navigationController pushViewController:poorBillVC animated:YES];
}

#pragma mark - 回复全部数据
- (void)restoreAllData {
    
    [self cancelRightBarButtonItemPresssed];
}

- (void)cancelRightBarButtonItemPresssed {
    
    self.sortDataSource = self.sortBackUpDataSource;
    
    //还原初始状态(点击了批量修改点工，右上角取消还原)
    if (self.backUprequest) {
        
        self.request = [JGJRecordWorkPointRequestModel mj_objectWithKeyValues:[self.backUprequest mj_keyValues]];
        
        self.dataSource = self.backUpDataSource.mutableCopy;
        
        self.allCount = self.dataSource.count;
        
        self.recordWorkPointModel = [JGJRecordWorkPointModel mj_objectWithKeyValues:[self.backUpRecordWorkPointModel mj_keyValues]];
        
        [self.tableView reloadData];
        
//       筛选按钮状态
        
        [self setFilterButtonStatus:self.isFiler];
        
    }
    
    self.isBatchDel = NO;
    
    if (self.is_sel_Batch_tiny) {
        
        //显示搜索按钮，批量修改点工的时候隐藏。点击取消的时候显示
        self.filterButton.hidden = NO;
    }
    
    self.is_sel_Batch_tiny = NO;
    
    if (self.selRecords.count > 0) {
        
       [self.selRecords removeAllObjects];
        
    }
    
    [self hiddenBottomView];
    
    if (!self.tableView.mj_footer){
        
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(onFooterRereshing)];
        
    }
}

- (void)hiddenBottomView {
    
    self.batchModifyView.hidden = YES;
    
    self.buttonView.hidden = YES;
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
    
    return YES;
}

#pragma mark - 设置滑动的偏移量
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.x > [cell rightUtilityButtonsWidth]) {
        
        scrollView.contentOffset = CGPointMake([cell rightUtilityButtonsWidth], 0);
    }
}

- (void)swipeableTableViewCell:(JGJUnWagesShortWorkCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {

    switch (index) {
            
        case 0:{
            
            //修改记账
            
            [self modifyRecrodWithCell:cell];
        }
            
            break;
            
        case 1:{
            
            [self delActionWithCell:cell];
        }
            
            break;
            
        default:
            break;
    }
    
}

#pragma makr - 修改记账
- (void)modifyRecrodWithCell:(JGJUnWagesShortWorkCell *)cell {
 
    TYLog(@"修改了记账记账类型---- %@ -------%@", cell.listModel.accounts_type, cell.listModel.recordId);
    
    [self modifyAccountWithlistModel:cell.listModel];
    
}

#pragma makr - 删除
- (void)delActionWithCell:(JGJUnWagesShortWorkCell *)cell {
    
    [self.selRecords removeAllObjects];
    
    [self.selRecords addObject:cell.listModel?:@""];
    
    [self showRecordPopView:NO];
}

#pragma mark - 删除按钮
- (NSArray *)rightButtons {

    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     AppFontC7C6CBColor title:@"修改"];

    [rightUtilityButtons sw_addUtilityButtonWithColor:
     AppFontEA4E3DColor title:@"删除"];
    return rightUtilityButtons;
}


- (void)setSortDataSource:(NSMutableArray *)sortDataSource {

    _sortDataSource = sortDataSource;

    [self.tableView reloadData];

    self.allCount = self.dataSource.count;

    //是否显示缺省页页面
    [self showDefaultNodataArray:sortDataSource];

    if (!self.is_sel_Batch_tiny) {
        
//        //还原页面状态
//        self.isBatchDel = NO;
        
    }
    
}

#pragma mark - 下载账单表格
- (void)downRecordForm {
    
    //方式一：进入页面打开
    
    JGJRecordStaDownLoadVc *downLoadVc = [[JGJRecordStaDownLoadVc alloc] init];
    
    downLoadVc.downLoadModel = self.downLoadModel;
    
    [self.navigationController pushViewController:downLoadVc animated:YES];
    
    return;
    
    JGJRecordTool *tool = [[JGJRecordTool alloc] init];
    
    JGJRecordToolModel *toolModel = [JGJRecordToolModel new];
    
    toolModel.url = [NSString stringWithFormat:@"%@%@", JLGHttpRequest_IP, self.downLoadModel.file_path];

    toolModel.type = self.downLoadModel.file_type?:@"";

    toolModel.name = self.downLoadModel.file_name?:@"";
    
    toolModel.curVc = self;
    
    tool.toolModel = toolModel;
    
    TYWeakSelf(self);
    
    tool.recordToolBlock = ^(BOOL isSucess, NSURL *localFilePath) {
      
        [TYLoadingHub hideLoadingView];
        
        [weakself shareFormWithFileUrl:localFilePath];
        
    };
    
}

- (void)shareFormWithFileUrl:(NSURL *)fileUrl {
    
    _documentInteraction = [UIDocumentInteractionController interactionControllerWithURL:fileUrl];
    
    _documentInteraction.delegate = self; // UIDocumentInteractionControllerDelegate
    
    [_documentInteraction presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
}

- (void)documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController *)controller
{
    _documentInteraction = nil;
}


#pragma mark - 批量删除
- (void)batchDel {
    
    self.isBatchDel = !self.isBatchDel;
    
}

#pragma mark - 批量修改工资状态处理

- (void)bacthModifyWageAction {
    
    self.isBatchDel = !self.isBatchDel;
    
}

- (void)setIsBatchDel:(BOOL)isBatchDel {
    
    _isBatchDel = isBatchDel;
    
    self.buttonView.hidden = !_isBatchDel;
    
    self.bottomViewH.constant = _isBatchDel ? 64 : 0;
    
    self.tableViewH.constant = TYGetUIScreenHeight - 50 - (_isBatchDel ? self.bottomViewH.constant : 0) - JGJ_NAV_HEIGHT;
    
    if (self.sortDataSource.count == 0) {
        
        self.buttonView.hidden = YES;
        
        self.bottomViewH.constant = 0;
        
        self.tableViewH.constant = TYGetUIScreenHeight - 50 - JGJ_NAV_HEIGHT;
    }
    
    [self.tableView.mj_footer endRefreshing];
    
    [self.tableView reloadData];
    
    [self setNavRightBtnStatus:_isBatchDel];
    
//按钮是否全选中的状态设置
    
    [self bottomBtnSelStaus];
    
    [self.tableView reloadData];
    
}

#pragma mark - 设置导航栏顶部右上角按钮状态

- (void)setNavRightBtnStatus:(BOOL)isBatch {
    
    if (isBatch) {
        
        self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 60)];
        
        self.rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        [self.rightButton setTitle:@"取消" forState:UIControlStateNormal];
        
        [self.rightButton setTitleColor:AppFontEB4E4EColor forState:UIControlStateNormal];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
        
        [self.rightButton addTarget:self action:@selector(cancelRightBarButtonItemPresssed) forControlEvents:UIControlEventTouchUpInside];
        
        
    }else {
        
        self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 60)];
        
        self.rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        //        [self.rightButton setImage:[UIImage imageNamed:@"more_write"] forState:UIControlStateNormal];
        
        [self.rightButton setTitle:@"更多" forState:UIControlStateNormal];
        
        [self.rightButton setTitleColor:AppFontEB4E4EColor forState:UIControlStateNormal];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
        
        [self.rightButton addTarget:self action:@selector(rightBarButtonItemPressed) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    for (JGJRecordWorkPointListModel *listModel in self.selRecords) {
        
        listModel.isSel = NO;
    }
    
    //筛选之后删除所有选中数据
    if (self.selRecords.count > 0) {
        
        [self.selRecords removeAllObjects];
    }
    
}

#pragma mark - 全选记账
- (void)allSelRecordWithisAllSel:(BOOL)isAllSel {

    [self.selRecords removeAllObjects];
    
    for (NSArray *list in self.sortDataSource) {
        
        for (JGJRecordWorkPointListModel *listModel in list) {
            
            listModel.isSel = isAllSel;
            
            if (isAllSel) {
                
                [self.selRecords addObject:listModel];
            }
        }
    }
    
    //全选本页状态
    
    self.buttonView.selRecordCount = isAllSel ? self.allCount : 0;
    
    //全选点工本页状态
    self.batchModifyView.leftBtn.selected = isAllSel;
    
    [self batchModifyLeftBtnStatus:isAllSel];
    
    self.batchModifyView.rightTitle = @"批量修改点工工资标准";
    
    if (self.selRecords.count > 0) {
        
       self.batchModifyView.rightTitle = [NSString stringWithFormat:@"批量修改点工工资标准(%@)", @(self.selRecords.count)];
        
    }
    
    [self.tableView reloadData];
}

#pragma mark - 加载记工统计
- (void)loadRecordStaNetData {
    
    BOOL isFilter = ![NSString isEmpty:self.request.accounts_type] ||
    
                    (![NSString isEmpty:self.request.pid] && ![self.request.pid isEqualToString:@"0"])|| ![NSString isEmpty:self.request.uid] ||
    
    [self.request.is_note isEqualToString:@"1"] ||
    
    [self.request.is_agency isEqualToString:@"1"];
    
    //记工变更到记工流水，重置为初始状态状态的项目id
    if (self.staDetailListModel.is_change_date) {
        
        self.request.pid = self.staDetailListModel.pid;
    }
    
    NSDictionary *parameters = [self.request mj_keyValues];
    
    if ([NSString isEmpty:self.request.accounts_type]) {
        
        [parameters setValue:@"1,2,3,4,5" forKey:@"accounts_type"];
    }
    
    if (![NSString isEmpty:self.backUpIsFiler]) {
        
        isFilter = [self.backUpIsFiler isEqualToString:@"1"];
        
         [self setFilterButtonStatus:isFilter];
        
    }else {
        
        //筛选按钮状态
        [self setFilterButtonStatus:isFilter];
        
    }
    
    self.isFiler = isFilter;
    
    self.backUpIsFiler = nil;
    
    [JLGHttpRequest_AFN PostWithNapi:@"workday/get-work-record-flow" parameters:parameters success:^(id responseObject) {
        
        NSArray *dataSurce = [JGJRecordWorkPointListModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        if (self.request.pg == 1) {
            
            JGJRecordWorkPointModel *recordWorkPointModel = [JGJRecordWorkPointModel mj_objectWithKeyValues:responseObject];
            
            self.recordWorkPointModel = recordWorkPointModel;
            
            [self handleTopContractorSta:recordWorkPointModel];
            
            //筛选前的数据
            if (!_dataSource || self.request.pg == 1) {
                
                self.sortDataSource = [NSMutableArray array];
                
                self.dataSource = [NSMutableArray array];
                
            }
        }
        
        if (dataSurce.count > 0) {
            
            [self.dataSource addObjectsFromArray:dataSurce];
            self.request.pg++;
            
        }
//        else if (_isBatchDel) {// 无点工数据 且选择了批量修改点工
//            
//            JGJCustomAlertView *alertView = [JGJCustomAlertView customAlertViewShowWithMessage:@"没有需要修改的点工记录"];
//            alertView.message.textAlignment = NSTextAlignmentCenter;
//            alertView.message.font = [UIFont systemFontOfSize:AppFont30Size];
//            [alertView.confirmButton setTitle:@"我知道了" forState:UIControlStateNormal];
//            [alertView.confirmButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
//            alertView.confirmButton.backgroundColor = AppFontEB4E4EColor;
//            __weak typeof(self) weakSelf = self;
//            
//            alertView.onClickedBlock = ^{
//                
//                [weakSelf restoreAllData];
//            };
//            
//            alertView.touchDismissBlock = ^{
//                
//                [weakSelf restoreAllData];
//            };
//        }
        
         [self sortDataSource:self.dataSource];
        
        //底部按钮状态
        [self bottomBtnSelStaus];
        
        if (dataSurce.count >= self.request.pagesize) {
            
            if (!self.tableView.mj_footer){
                
                self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(onFooterRereshing)];
            
            }
            
        }else {
            
            self.tableView.mj_footer = nil;
            
        }
        
        [self.tableView.mj_footer endRefreshing];

        [TYLoadingHub hideLoadingView];
        
        [TYShowMessage hideHUD];
        [self.tableView reloadData];

        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
    }];
    
}

#pragma mark - 顶部统计点工和包工记工天相加
- (void)handleTopContractorSta:(JGJRecordWorkPointModel *)recordWorkPointModel {
    
    //包工记工天
    
    //时单位
    CGFloat manhour = [recordWorkPointModel.attendance_type.manhour doubleValue];
    
    CGFloat working_hours = [recordWorkPointModel.attendance_type.working_hours doubleValue];
    
    
    CGFloat overtime = [recordWorkPointModel.attendance_type.overtime doubleValue];
    
    CGFloat overtime_hours = [recordWorkPointModel.attendance_type.overtime_hours doubleValue];
    
    //点工上班
    CGFloat workmanhour = [recordWorkPointModel.work_type.manhour doubleValue];
    
    CGFloat work_working_hours = [recordWorkPointModel.work_type.working_hours doubleValue];
    
    //点工加班
    
    CGFloat work_overtime = [recordWorkPointModel.work_type.overtime doubleValue];
    
    CGFloat work_overtime_hours = [recordWorkPointModel.work_type.overtime_hours doubleValue];
    
    //上班
    
    manhour += workmanhour;
    
    working_hours += work_working_hours;
    
    //加班
    overtime += work_overtime;
    
    overtime_hours += work_overtime_hours;
    
    //上班
    
    NSString *manhourStr = [NSString stringWithFormat:@"%.2lf", manhour];
    
    manhourStr = [manhourStr stringByReplacingOccurrencesOfString:@".00" withString:@""];
    
    NSString *working_hoursStr = [NSString stringWithFormat:@"%.2lf", working_hours];
    
    working_hoursStr = [working_hoursStr stringByReplacingOccurrencesOfString:@".00" withString:@""];
    
    //加班
    NSString *overtimeStr = [NSString stringWithFormat:@"%.2lf", overtime];
    
    overtimeStr = [overtimeStr stringByReplacingOccurrencesOfString:@".00" withString:@""];
    
    NSString *overtime_hoursStr = [NSString stringWithFormat:@"%.2lf", overtime_hours];
    
    overtime_hoursStr = [overtime_hoursStr stringByReplacingOccurrencesOfString:@".00" withString:@""];
    
    recordWorkPointModel.work_type.manhour = [self removeFloatAllZeroByString:manhourStr];
    
    recordWorkPointModel.work_type.working_hours = [self removeFloatAllZeroByString:working_hoursStr];
    
    recordWorkPointModel.work_type.overtime = [self removeFloatAllZeroByString:overtimeStr];
    
    recordWorkPointModel.work_type.overtime_hours = [self removeFloatAllZeroByString:overtime_hoursStr];
    
}

- (NSString*)removeFloatAllZeroByString:(NSString *)number{
    
    NSString * outNumber = [NSString stringWithFormat:@"%@",@(number.floatValue)];
    
    return outNumber;
}

- (void)onFooterRereshing {
    
    [self loadRecordStaNetData];
    
}

#pragma mark - 当月统计
- (void)recordFlowtotalRequest {
    
    NSDictionary *parameters = [self.request mj_keyValues];
    
    if ([NSString isEmpty:self.request.accounts_type]) {
        
        [parameters setValue:@"1,2,3,4,5" forKey:@"accounts_type"];
    }
    
    [JLGHttpRequest_AFN PostWithNapi:@"workday/get-work-record-flow-total" parameters:parameters success:^(id responseObject) {
        
        self.recordWorkPointModel = [JGJRecordWorkPointModel mj_objectWithKeyValues:responseObject];
        
//        self.staView.recordWorkPointModel = self.recordWorkPointModel;
        
    } failure:^(NSError *error) {
        
    }];
    
}


- (void)sortDataSource:(NSArray *)dataSource{
    
    JGJRecordWorkPointListModel *listModel = nil;
    
    if (dataSource.count > 0) {
        
        listModel = dataSource.firstObject;
    }
    
    if (!self.pageSizeModel) {
        
        JGJPageSizeModel *pageSizeModel = [[JGJPageSizeModel alloc] init];
        
        self.pageSizeModel = pageSizeModel;
    }
    
    self.sortDataSource = [self.pageSizeModel sortDataSource:dataSource];
    
}

#pragma mark - FDAlertViewDelegate
- (void)alertView:(FDAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1 && self.selRecords.count > 0) {
        
        [self batchDelRequestWithSelRecords:self.selRecords];
        
        //一个数据本地删除
        if (self.selRecords.count == 1) {
            
            [self.dataSource removeObject:self.selRecords.lastObject];
            
            if (self.dataSource.count > 0) {
                
                JGJPageSizeModel *pageSizeModel = [[JGJPageSizeModel alloc] init];
                
                self.sortDataSource = [pageSizeModel sortDataSource:self.dataSource];
                
            }
            
        }
    }
    
    alertView.delegate = nil;
    
    alertView = nil;
}

- (void)batchDelRequestWithSelRecords:(NSArray *)selRecords {
    
    NSMutableArray *selRecordIds = [NSMutableArray new];
    
    [selRecords enumerateObjectsUsingBlock:^(JGJRecordWorkPointListModel *listModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [selRecordIds addObject:listModel.recordId];
        
    }];
    
    NSString *delIDs = [selRecordIds componentsJoinedByString:@","];
    
    NSDictionary *parameters = @{@"id":delIDs?:@""};
    
    if (![NSString isEmpty:self.proListModel.group_id]) {
        
        parameters = @{@"id":delIDs?:@"",
                       @"group_id" : self.proListModel.group_id,
                       @"agency_uid" : [TYUserDefaults objectForKey:JLGUserUid]
                       };
    }
    
    [TYShowMessage showHUDWithMessage:@""];
    
    [JLGHttpRequest_AFN PostWithApi:@"jlworkday/delinfo" parameters:parameters success:^(id responseObject) {

        [TYLoadingHub hideLoadingView];
        
        [TYShowMessage showSuccess:@"删除成功！"];
        
        self.dataSource = [NSMutableArray new];
        
        self.request.pg = 1;
        
        [self loadRecordStaNetData];
    
        //取消批量删除，还原开始的状态
        self.isBatchDel = NO;
        
        [self.selRecords removeAllObjects];
        
        [TYNotificationCenter postNotificationName:JGJRefreshHomeCalendarBillData object:nil];
        for (UIViewController *vc in self.navigationController.viewControllers) {
            
            if ([vc isKindOfClass:NSClassFromString(@"JGJRecordStaListVc")]) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"recordBillChangeSuccess" object:nil];
                
                break;
                
            }
            
        }

    }failure:^(NSError *error) {

        [TYLoadingHub hideLoadingView];

    }];
    
}

#pragma mark - 是否显示缺省页面
- (void)showDefaultNodataArray:(NSArray *)dataArray {
    
    if (dataArray.count == 0) {
        
        NSString *flag = self.isFiler ? @"页" : @"月";
        
        NSString *des = [NSString stringWithFormat:@"本%@暂无记工数据", flag];
        
        CFRefreshStatusView *statusView = [[CFRefreshStatusView alloc] initWithImage:PNGIMAGE(@"NoDataDefault_NoManagePro") withTips:des];
        
        statusView.frame = self.tableView.bounds;
        
        statusView.height = TYGetUIScreenHeight - self.staHeaderView.height;
        
        self.tableView.tableFooterView = statusView;
        
    }else {
        
        self.tableView.tableFooterView = nil;
    }
        
    self.bottomViewH.constant = dataArray.count != 0 ? 64 : 0;
}

#pragma mark - 获取筛选数据项目、人员
- (void)loadFilterDataWithClassType:(NSString *)class_type {
    
    NSDictionary *parameters = @{@"class_type" : class_type?:@"person"};
    
    if (![NSString isEmpty:self.proListModel.group_id]) {
        
        parameters = @{
                       @"class_type" : class_type?:@"person",
                       @"group_id":self.proListModel.group_id
                       };
        
    }
    [JLGHttpRequest_AFN PostWithApi:@"v2/workday/getTargetNameList" parameters:parameters success:^(id responseObject) {
        
        if ([class_type isEqualToString:@"person"]) {
            
            self.allMembers = [JGJSynBillingModel mj_objectArrayWithKeyValuesArray:responseObject];
            
            self.filterView.allMembers = self.allMembers;
            
        } else {
            
            self.allPros = [JGJRecordWorkPointFilterModel mj_objectArrayWithKeyValuesArray:responseObject];
            
            NSMutableArray *sortAllPro = [NSMutableArray new];
            
            if (self.allPros.count > 2) {
                
                sortAllPro = [JGJRecordWorkPointFilterModel sortProModels:[self.allPros subarrayWithRange:NSMakeRange(2, self.allPros.count-2)].mutableCopy];
                
                NSMutableArray *allPros = [self.allPros subarrayWithRange:NSMakeRange(0, 2)].mutableCopy;
                
                [allPros addObjectsFromArray:sortAllPro];
                
                self.allPros = allPros;
            }

            self.filterView.allPros = self.allPros;
        }
        
    }failure:^(NSError *error) {
        
      
        
    }];
}

#pragma mark - 下载文件
- (void)loadDownLoadFile {
    
    NSDictionary *parameters = [self.request mj_keyValues];
    
    self.downLoadModel.uid = self.request.uid;
    
    self.downLoadModel.pid = self.request.pid;
    
    self.downLoadModel.date = self.request.date;
    
    NSMutableDictionary *muParameters = [NSMutableDictionary dictionary];
    
    [muParameters addEntriesFromDictionary:parameters];
    
    [muParameters setObject:@"1" forKey:@"is_down"];
    
    
    [JLGHttpRequest_AFN PostWithNapi:@"workday/get-work-record-flow" parameters:muParameters success:^(id responseObject) {
        
        JGJRecordWorkDownLoadModel *downLoadModel = [JGJRecordWorkDownLoadModel mj_objectWithKeyValues:responseObject];
        
        self.downLoadModel = downLoadModel;
        
        [self downRecordForm]; //下载
        
    } failure:^(NSError *error) {
        
//        [TYLoadingHub hideLoadingView];
        
    }];
}

#pragma mark - JGJRecordWorkPointStaHeaderViewDelegate

- (void)recordWorkPointStaHeaderView:(JGJRecordWorkPointStaHeaderView *)headerView {
    
    //记工变更进入不能点击
    if (self.is_change_date || self.is_hidden_checkBtn) {
        
        return ;
    }
    
    [self checkStaListVc];
    
}

- (JGJRecordWorkPointRequestModel *)request {
    
    if (!_request) {
        
        _request = [JGJRecordWorkPointRequestModel new];
        
        _request.pg = 1;
        
        _request.pagesize = 20;
        
        if (self.is_change_date) {
            
            _request.is_change_date = 1;
        }
        
        //代理班组流水
        _request.group_id = self.proListModel.group_id;
        
        if ([self.staDetailListModel.class_type isEqualToString:@"person"]) {
            
            _request.uid = self.staDetailListModel.class_type_id; //记工统计进入，人筛选，就是人员的id
            
            _request.pid = self.staDetailListModel.class_type_target_id;;
            
        }else if ([self.staDetailListModel.class_type isEqualToString:@"project"]) {
            
            _request.pid = self.staDetailListModel.class_type_id; //记工统计进入，项目筛选，就是项目的id
            _request.uid = self.staDetailListModel.class_type_target_id;
            
            
            //是否是同步类型
            
            _request.is_sync = self.staDetailListModel.is_sync;
            
        }else {
            
            _request.uid = self.staDetailListModel.class_type_id;
            
            _request.pid = self.staDetailListModel.pid;
            
        }
        
        //3.3.7添加统计带入的类型
        _request.accounts_type = self.staDetailListModel.accounts_type;
    
        _request.date = self.staDetailListModel.date;
        
        if ([self.staDetailListModel.date containsString:@"年"] && [self.staDetailListModel.date containsString:@"月"]) {
            
            NSDate *date = [NSDate dateFromString:self.staDetailListModel.date withDateFormat:@"yyyy年MM月"];
            
            _request.date = [NSDate stringFromDate:date format:@"yyyy-MM"];
            
            NSString *dateStr = self.staDetailListModel.date;
            
            if ([dateStr containsString:@"年"] && [dateStr containsString:@"月"] && [dateStr containsString:@"日"]) {
                
                date = [NSDate dateFromString:dateStr withDateFormat:@"yyyy年MM月dd日"];
                
                _request.date = [NSDate stringFromDate:date format:@"yyyy-MM"];
            }
            
        }else {
            
            _request.date = self.staDetailListModel.date;
        }
        
    }
    
    return _request;
}

- (NSMutableArray *)selRecords {
    
    if (!_selRecords) {
        
        _selRecords = [NSMutableArray new];
    }
    
    return _selRecords;
}

#pragma mark - YQ差账功能

#pragma mark - 点击差账弹框跳转到修改界面
-(void)JGJSurePoorBillShowClickLookDetailBtnAndIndexpath:(NSIndexPath *)indexpath andTPLmodel:(YZGGetBillModel *)model
{
    [JGJSurePoorBillShowView removeView];

    JGJModifyBillListViewController *ModifyBillListVC = [[UIStoryboard storyboardWithName:@"JGJModifyBillListViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJModifyBillListVC"];
    
    ModifyBillListVC.billModify = YES;
    MateWorkitemsItems *mateWorkModel = [[MateWorkitemsItems alloc]init];
    
    if (![NSString isEmpty:self.proListModel.group_id]) {
        
        mateWorkModel.group_id = self.proListModel.group_id;
        
        mateWorkModel.agency_uid = [TYUserDefaults objectForKey:JLGUserUid];
    }
    
    mateWorkModel.accounts_type.code =  model.accounts_type.code;
    mateWorkModel.id = [model.id?:@"0" longLongValue];
    ModifyBillListVC.mateWorkitemsItems = mateWorkModel;
    [self.navigationController pushViewController:ModifyBillListVC animated:YES];
    
}

- (void)modifyAccountWithlistModel:(JGJRecordWorkPointListModel *)listModel {
    
    [JGJSurePoorBillShowView removeView];
    
    JGJModifyBillListViewController *ModifyBillListVC = [[UIStoryboard storyboardWithName:@"JGJModifyBillListViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJModifyBillListVC"];
    
    ModifyBillListVC.billModify = YES;
    
    MateWorkitemsItems *mateWorkModel = [self TransformModel:listModel];

    if (![NSString isEmpty:self.proListModel.group_id]) {
        
        mateWorkModel.group_id = self.proListModel.group_id;
        
        mateWorkModel.agency_uid = [TYUserDefaults objectForKey:JLGUserUid];
    }
    
    ModifyBillListVC.mateWorkitemsItems = mateWorkModel;
    
    [self.navigationController pushViewController:ModifyBillListVC animated:YES];
}

-(void)JGJSurePoorBillShowClickAgreePoorBillBtnAndIndexpath:(NSIndexPath *)indexpath andTPLmodel:(YZGGetBillModel *)model
{
    [JGJSurePoorBillShowView removeView];
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/workday/confirmAccount" parameters:@{@"id":model.id?:@""} success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];

        [self loadRecordStaNetData];
        
    }failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
    }];
    
}

-(BOOL)checkIsRealName{
    SEL checkIsRealName = NSSelectorFromString(@"checkIsRealName");
    IMP imp = [self.navigationController methodForSelector:checkIsRealName];
    BOOL (*func)(id, SEL) = (void *)imp;
    if (!func(self.navigationController, checkIsRealName)) {
        return NO;
    }else{
        return YES;
    }
}

#pragma mark - 筛选条件改变颜色
- (void)setFilterButtonStatus:(BOOL)isNormal {
    
    UIColor *color = !isNormal ? AppFont333333Color :AppFontEB4E4EColor;
    
    [self.filterButton setImage:[UIImage imageNamed:!isNormal ? @"un_filter_icon" : @"filtered_icon" ] forState:UIControlStateNormal];
    
    [self.filterButton setTitleColor:color forState:UIControlStateNormal];
    
    [self.filterButton.layer setLayerBorderWithColor:color width:1 radius:3];
    
}

- (void)setBottomBtnStatus:(BOOL)isHidden {
    

    
}

- (IBAction)filterButtonPressed:(UIButton *)sender {
    
  //是否代班项目
    _baseMenuView = [[JGJBaseMenuView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight) proListModel:self.proListModel];
    
    //传入之前筛选的模型
    _baseMenuView.recordTags = self.tags;
    
    _baseMenuView.notetags = self.remarktags;
    
    //代理人
    _baseMenuView.agencytags = self.agencytags;
    
    //选中的标签
    _baseMenuView.selrecordTtags = self.seltags;
    
    //选中的备注
    _baseMenuView.selnotetags = self.selremarktags;
    
    //代理人
    _baseMenuView.selAgencytags = self.selAgencytags;
    
    _baseMenuView.isRest = self.isRest;
    
    _baseMenuView.proInfos = self.isRest ? nil : self.desInfos;
    
    _baseMenuView.allPros = self.allPros;
    
    _baseMenuView.allMembers = self.allMembers;
    
    self.staDetailListModel.is_change_date = self.is_change_date;
    
    //记工统计进入当前页面默认选中的数据
    _baseMenuView.staListModel = self.staDetailListModel;
    
    [_baseMenuView pushView];
    
    TYWeakSelf(self);
    
    _baseMenuView.baseMenuViewBlock = ^(JGJSynBillingModel *memberModel, JGJRecordWorkPointFilterModel *proModel, NSArray *tagModels, NSArray *remark_tagModels, NSArray *desInfo, BOOL isRest, NSArray *seltagModels, NSArray *selremark_tagModels, NSArray *agentags, NSArray *selAgentags) {
        
        weakself.isRest = isRest;
        
        //等于0是复位状态,清楚项目和人员信息。使用初始化状态
        if (isRest) {
            
            weakself.desInfos = nil;
            
            //重置请求全部
            
            weakself.request = nil;
            
            [weakself setFilterButtonStatus:NO];
            
            return ;
        }
        
        NSString *date = [NSDate coverYearMonthWithDateStr:weakself.staDetailListModel.date];
        
        weakself.titleView.date = date;
        
        weakself.request.date = date;
        
        NSMutableArray *accounts_types = [NSMutableArray array];
        
        for (NSInteger index = 0; index < tagModels.count; index++) {
            
            JGJMemberImpressTagViewModel *tagModel = tagModels[index];
            
            if (tagModel.selected) {
        
                [accounts_types addObject:tagModel.tagId];
                
            }
        
        }
        
        NSString *accounts_type = [accounts_types componentsJoinedByString:@","];
        
        //记账的类型
        weakself.request.accounts_type = accounts_type;
        
        NSMutableArray *noteIds = [NSMutableArray array];
        
        for (NSInteger index = 0; index < remark_tagModels.count; index++) {
            
            JGJMemberImpressTagViewModel *tagModel = remark_tagModels[index];
            
            if (tagModel.selected) {
        
                [noteIds addObject:tagModel.tagId];
                
            }
        
        }
        
        NSString *noteId = [noteIds componentsJoinedByString:@","];
        
        //是否有备注
        
        if ([noteId containsString:@"1"]) {
            
            weakself.request.is_note = @"1";
            
        }else {
            
            weakself.request.is_note = nil;
        }
        
        if ([noteId containsString:@"2"]) {
            
            weakself.request.is_agency = @"1";
            
        }else {
            
            weakself.request.is_agency = nil;
        }
        
        weakself.request.uid = memberModel.class_type_id;
        
        weakself.request.pid = proModel.class_type_id;
        
        //获取最新的id用于是不是同一次筛选
        weakself.downLoadModel.uid = memberModel.class_type_id;
        
        weakself.downLoadModel.pid = proModel.class_type_id;
        
//        [TYLoadingHub showLoadingNoDataDefultWithMessage:nil];
        
        //筛选后从第一页开始
        weakself.request.pg = 1;
        
        //清空数据源
        weakself.dataSource = [NSMutableArray array];
        
        //加载数据
        [weakself loadRecordStaNetData];
        
        //保存之前筛选的模型
        
        weakself.desInfos = desInfo.mutableCopy;
        
        weakself.tags = tagModels.mutableCopy;
        
        weakself.remarktags = remark_tagModels.mutableCopy;
        
        weakself.seltags = seltagModels.mutableCopy;
        
        weakself.selremarktags = selremark_tagModels.mutableCopy;
        
        weakself.selAgencytags = selAgentags.mutableCopy;
        
        weakself.agencytags = agentags.mutableCopy;
        
    };
}

#pragma mark - 处理截屏

- (void)handleShotScreent {
    
    if (!JGJWorkPointMaskBool) {

        [self.maskView cutView:self.filterButton convertView:self.view];
    }

}

- (JGJRecWorkMaskView *)maskView {
    
    if (!_maskView) {
        
        _maskView = [[JGJRecWorkMaskView alloc] initWithFrame:self.view.bounds];
    }
    
    return _maskView;
}

- (NSMutableArray *)tag_names {

    NSArray *tag_list = @[@"点工",@"包工记账",@"借支",@"结算",@"包工记工天"];

    NSMutableArray *tagModels = [NSMutableArray array];

    self.fir_sel_tagModels = [NSMutableArray array];
    
    //记账类型带入的初始类型

    self.fir_sel_tagModels = [NSMutableArray array];
    
    for (NSInteger index = 0; index < tag_list.count; index++) {
        
        JGJMemberImpressTagViewModel *tagModel = [JGJMemberImpressTagViewModel new];
        
        tagModel.tag_name = tag_list[index];
        
        tagModel.tagId = [NSString stringWithFormat:@"%@", @(index+1)];
        
        if ([self.staDetailListModel.accounts_type containsString:tagModel.tagId]) {
            
            tagModel.selected = YES;
            
            [self.fir_sel_tagModels addObject:tagModel];
        }
        
        [tagModels addObject:tagModel];
    }

    return tagModels;
}

- (void)batchModifyLeftBtnStatus:(BOOL)isSel {
    
    if (isSel) {
        
        [self.batchModifyView.leftBtn setTitle:@"取消全选" forState:UIControlStateNormal];
        
    }else {
        
        [self.batchModifyView.leftBtn setTitle:@"全选本页" forState:UIControlStateNormal];
    }
    
}

#pragma mark - 批量修改点工

- (void)batchModifyTinyWage{
    
    if (self.selRecords.count == 0) {
        
        [TYShowMessage showPlaint:@"请选择要修改的点工记账记录"];
        
        return;
    }
    
    JGJCusSetTinyPopView *cusSetTinyPopView = [[JGJCusSetTinyPopView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight)];
    
    NSString *cnt = [NSString stringWithFormat:@"%@", @(self.selRecords.count)];
    
    cusSetTinyPopView.selCntsDes.text = [NSString stringWithFormat:@"本次共选中 %@笔 点工", cnt];
    
    [cusSetTinyPopView.selCntsDes markText:cnt withColor:AppFontEB4E4EColor];
    
    cusSetTinyPopView.des.text = @"选中点工记账，表示对未设置工资标准的点工，新设置工资标准；对已设置工资标准的点工，表示修改该笔账的工资标准。";
    
    cusSetTinyPopView.contentDetailViewH.constant = 235;
    
    cusSetTinyPopView.money.placeholder = [NSString stringWithFormat:@"请输入与%@协商的金额", JLGisLeaderBool ? @"工人" : @"班组长"];
    
    self.cusSetTinyPopView = cusSetTinyPopView;
    
    TYWeakSelf(self);
    
    self.cusSetTinyPopView.confirmBlock = ^(JGJCusSetTinyPopView *popView) {
        
        double salary = [weakself.cusSetTinyPopView.money.text doubleValue];
        
        if ([NSString isFloatZero:salary] || [NSString isEmpty:weakself.cusSetTinyPopView.money.text]) {
            
            [TYShowMessage showPlaint:@"请设置工资金额"];
            
            return;
        }
        
        [weakself requestSetBatchSalaryTpl];
        
    };
    
}

- (void)requestSetBatchSalaryTpl {
    
    NSMutableArray *record_ids = [[NSMutableArray alloc] init];
    
    for (JGJRecordWorkPointListModel *listModel in self.selRecords) {
        
        if (![NSString isEmpty:listModel.recordId]) {
            
            [record_ids addObject:listModel.recordId];
        }
    }
    
    NSString *record_id = [record_ids componentsJoinedByString:@","];
    
    JGJSetBatchSalaryTplRequestModel *requestModel = [[JGJSetBatchSalaryTplRequestModel alloc] init];
    
    requestModel.salary = self.cusSetTinyPopView.money.text;
    
    requestModel.record_id = record_id;
    
    TYWeakSelf(self);
    
    [requestModel requstSetBatchSalaryTplSuccess:^(id responseObject) {
        
        [TYShowMessage showSuccess:@"工资标准修改成功！"];
        
        [weakself.selRecords removeAllObjects];
        
        //还原开始的状态
         weakself.isBatchDel = NO;
        
        weakself.filterButton.hidden = NO;
        
        //隐藏底部按钮
        
        [weakself hiddenBottomView];
        
        //刷新数据
        
        if (self.backUprequest) {
            
            self.request = [JGJRecordWorkPointRequestModel mj_objectWithKeyValues:[self.backUprequest mj_keyValues]];
        }
        
        [weakself beginFresh];
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

@end
