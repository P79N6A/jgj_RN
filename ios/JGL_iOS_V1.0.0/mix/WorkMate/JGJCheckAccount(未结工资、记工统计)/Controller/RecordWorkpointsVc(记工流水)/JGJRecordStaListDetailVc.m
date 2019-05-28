//
//  JGJRecordStaListDetailVc.m
//  mix
//
//  Created by yj on 2018/1/5.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJRecordStaListDetailVc.h"

#import "JGJUnWagesShortWorkCell.h"

#import "JGJRecordWorkpointsAllTypeMoneyCell.h"

#import "JGJUnWageAllMoneyCell.h"

#import "JGJCheckAccountHeaderView.h"

#import "JGJRecordWorkpointTypeCountCell.h"

#import "JGJCusActiveSheetView.h"

#import "JGJRecordStaListCell.h"

#import "JGJRecordStaFilterView.h"

#import "JGJRecordStaListHeaderView.h"

#import "MJRefresh.h"

#import "JGJRecordWorkpointsVc.h"

#import "JGJRecordTool.h"

#import "JGJComDefaultView.h"

#import "JGJAccountShowTypeVc.h"

#import "SJButton.h"

#import "JGJRecordStaDownLoadVc.h"

@interface JGJRecordStaListDetailVc () <UIDocumentInteractionControllerDelegate> {
    
    UIDocumentInteractionController *_documentInteraction;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *tipsLable;

@property (strong, nonatomic) JGJRecordWorkStaDetailModel *recordWorkStaDetailModel;

////是否显示工否则显示小时
//@property (nonatomic, assign) BOOL isShowWork;

//下载文件
@property (nonatomic, strong) JGJRecordWorkDownLoadModel *downLoadModel;

//尾部的最大距离
@property (nonatomic, assign) CGFloat maxTrail;

@property (nonatomic, assign) BOOL isDayStaType; //统计类型 天月

@property (nonatomic, strong) JGJComDefaultView *defaultView;

@property (nonatomic, strong) JGJAccountShowTypeModel *selTypeModel;

@property (nonatomic, strong) JGJAccountShowTypeModel *showTypeModel;

@property (nonatomic, strong) SJButton *titleButton;

@property (nonatomic, strong) JGJAccountShowTypeView *showTypeView;

@end

@implementation JGJRecordStaListDetailVc

@synthesize selTypeModel = _selTypeModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.filterView.is_hidden_checkStaBtn = YES;
    
    self.filterView.is_hidden_searchBtn = YES;
    
    [self setFilterButtonStatus:YES];
    
    [self initialSubView];
    
//    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    
    if (JLGisLeaderBool) {
        
        self.navigationItem.titleView = self.titleButton;
        
    }else {
        
        self.title = @"记工统计";
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.tableView.mj_header beginRefreshing];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemPressed)];
    
    //默认显示工
    self.selTypeModel = [JGJAccountShowTypeTool showTypeModel];
    
    [self.tableView reloadData];
    
    [self.navigationController.navigationBar setTintColor:AppFontEB4E4EColor];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self.showTypeView dismiss];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1 + self.recordWorkStaDetailModel.month_list.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger count = 0;
    
    if (section == 0) {
        
        count = 1;
        
    }else {
        
        count = 1;
    }
    
    return [NSString isEmpty:self.recordWorkStaDetailModel.date] ? 0 : count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            cell = [self registerRecordWorkpointsAllTypeMoneyCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
            
        }else {
            
            cell = [self registerRecordWorkpointTypeCountCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
            
        }
        
    }else {
        
        cell = [self registerRecordStaListCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = CGFLOAT_MIN;
    
    switch (indexPath.section) {
        case 0:{
            
            if (indexPath.row == 0) {
                
                height = [JGJRecordWorkpointsAllTypeMoneyCell cellHeight];
                
            }else if (indexPath.row == 1) {
                
                height = 56.0;
                
            }
            
        }
            
            break;
            
            case 1:{
                
                height = [self staListCellRowH];
                
                
            }
                break;
            
        default:{
            
             height = [self staListCellRowH];
            
        }
            break;
    }
    
    return height;
}

- (CGFloat)staListCellRowH {
    
    CGFloat cellHeight = [JGJRecordStaListCell cellHeight];
    
    if (![NSString isEmpty:self.request.accounts_type]) {
        
        NSArray *account_types = [self.request.accounts_type componentsSeparatedByString:@","];
        
        NSInteger account_type = [account_types.firstObject integerValue];
        
        if (account_types.count == 1) {
            
            cellHeight = 45;
            
            if (account_type == 1 || account_type == 5) {
                
                cellHeight = 60;
                
            }else if (account_type == 2 && JLGisLeaderBool) {
                
                cellHeight = 55;
                
            }
            
        }
        
    }
    
    return cellHeight;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return section == 0 ? CGFLOAT_MIN : 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    static NSString *resueId = @"JGJUnWagesShortWorkFooterView";
    
    UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:resueId];
    
//    UIView *bottomLineView = [UIView new];
    
    if (!footerView) {
        
        footerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:resueId];
        
//        bottomLineView.frame = CGRectMake(0, 9.5, TYGetUIScreenWidth, 0.5);
//
//        bottomLineView.backgroundColor = AppFontdbdbdbColor;
//
//        [footerView addSubview:bottomLineView];
    }
    
    footerView.contentView.backgroundColor = AppFontf1f1f1Color;
    
    footerView.hidden = self.recordWorkStaDetailModel.month_list.count == section;
    
    return [NSString isEmpty:self.recordWorkStaDetailModel.date] ? nil : footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return [NSString isEmpty:self.recordWorkStaDetailModel.date] ? CGFLOAT_MIN : 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    JGJCheckAccountHeaderView *headerView = [JGJCheckAccountHeaderView checkAccountHeaderViewWithTableView:tableView];
    
    if (section == 0) {
        
//        headerView.time = [NSString stringWithFormat:@"%@ 至 %@", self.request.start_time, self.request.end_time];
        
        headerView.time = self.recordWorkStaDetailModel.date?:@"";
        
    }else {
        
        JGJRecordWorkStaDetailListModel *listModel = self.recordWorkStaDetailModel.month_list[section - 1]
        ;

        headerView.time = listModel.date;
    }
        
    return section == 0 ? nil : headerView;
    
}

- (UITableViewCell *)registerRecordWorkpointsAllTypeMoneyCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJRecordWorkpointsAllTypeMoneyCell *cell = [JGJRecordWorkpointsAllTypeMoneyCell cellWithTableView:tableView];
    
    cell.showType = self.selTypeModel.type;
    
    cell.recordWorkStaModel = self.recordWorkStaDetailModel;
    
    return cell;
    
}

- (UITableViewCell *)registerRecordWorkpointTypeCountCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJRecordWorkpointTypeCountCell *cell = [JGJRecordWorkpointTypeCountCell cellWithTableView:tableView];
    
    cell.showType = self.selTypeModel.type;
    
    cell.recordWorkStaModel = self.recordWorkStaDetailModel;
    
    return cell;
    
}

- (UITableViewCell *)registerRecordStaListCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJRecordStaListCell *cell = [JGJRecordStaListCell cellWithTableView:tableView];
    
    JGJRecordWorkStaDetailListModel *listModel = self.recordWorkStaDetailModel.month_list[indexPath.section - 1];
    
    cell.accounts_type = self.request.accounts_type;

    cell.showType = self.selTypeModel.type;
    
    //禁止点击不显示箭头，这里都能进入流水3.4.2
//    cell.nextImageView.hidden = TYIS_IPHONE_5_OR_LESS || self.isForbidSkipWorkpoints;
    
    cell.nextImageView.hidden = TYIS_IPHONE_5_OR_LESS;
    
    cell.maxTrail = self.maxTrail;
    
    cell.staListModel = listModel;
    
    cell.isHiddenName = YES;
    
    cell.lineView.hidden = !(indexPath.section == self.recordWorkStaDetailModel.month_list.count);
    
    cell.isScreenShowLine = (indexPath.section == self.recordWorkStaDetailModel.month_list.count);
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return;
    }
    
//    同步给我的记工进入时 3.4.2注释
//    if (self.isForbidSkipWorkpoints) {
//
//        return;
//    }
    
    JGJRecordWorkpointsVc *pointsVc = [[UIStoryboard storyboardWithName:@"JGJRecordWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJRecordWorkpointsVc"];

    pointsVc.is_hidden_checkBtn = YES;
    
    JGJRecordWorkStaDetailListModel *listModel = self.recordWorkStaDetailModel.month_list[indexPath.section - 1];

    listModel.class_type = self.recordWorkStaDetailModel.class_type;
    
    if ([listModel.class_type isEqualToString:@"project"]) {
        
        //这里传的人名字
        
        if (![NSString isEmpty:listModel.class_type_target_id]) { //class_type_target_id有值就赋值target_name(这个值给的不正确)
            
            listModel.target_name = self.staListModel.name;
            
        }else {
            
            listModel.target_name = nil;
        }
        
    }
    
    if ([listModel.class_type isEqualToString:@"person"]) {
        
        //这里传的项目名字
        if (![NSString isEmpty:listModel.class_type_target_id]) {
            
            listModel.target_name = self.staListModel.name;
            
            if ([listModel.class_type_target_id isEqualToString:self.staListModel.class_type_target_id]) {
                
                listModel.target_name = self.staListModel.target_name;
            }
            
        }else {
            
            listModel.target_name = nil;
        }
        
    }

    
    listModel.isForbidSkipWorkpoints = self.staListModel.isForbidSkipWorkpoints;
    
    listModel.is_sync = self.staListModel.is_sync;
    
    listModel.accounts_type = self.request.accounts_type;
    
    pointsVc.staDetailListModel = listModel;
    
    UINavigationController * _Nullable extractedExpr = self.navigationController;
    [extractedExpr pushViewController:pointsVc animated:YES];
}

- (void)rightBarButtonItemPressed {
    
    [self showSheetView];
}

- (void)showSheetView{
    
    //    点工按“工天”显示 / 点工按
    
    self.selTypeModel = [JGJAccountShowTypeTool showTypeModel];
    
    JGJCusActiveSheetViewModel *sheetViewModel = [[JGJCusActiveSheetViewModel alloc] init];
    
    sheetViewModel.firstTitle = self.selTypeModel.title;
    
    sheetViewModel.secTitle = JGJSwitchRecordBillShowModel;
    
    sheetViewModel.flagStr = @"account_check_icon";
    
    NSArray *buttons = @[self.selTypeModel.title?:@"", JGJSwitchRecordBillShowModel, @"下载", @"取消"];
    
    __weak typeof(self) weakSelf = self;
    
    JGJCusActiveSheetView *sheetView = nil;
    
    if (JLGisLeaderBool) {
        
        buttons = @[self.selTypeModel.title?:@"", JGJSwitchRecordBillShowModel,  @"下载", @"取消"];
        
        sheetView = [[JGJCusActiveSheetView alloc]  initWithSheetViewModel:sheetViewModel sheetViewType:JGJCusActiveSheetViewRecordAccountType buttons:buttons buttonClick:^(JGJCusActiveSheetView *sheetView, NSInteger buttonIndex, NSString *title) {
            
            if (buttonIndex == 0) {
                
                JGJAccountShowTypeVc *typeVc = [[JGJAccountShowTypeVc alloc] init];
                
                typeVc.selTypeModel = weakSelf.selTypeModel;
                
                [weakSelf.navigationController pushViewController:typeVc animated:YES];
                
            }else if (buttonIndex == 1) {
                
                JGJRecordWorkDownLoadModel *downLoadModel = [JGJRecordTool downFileExistWithDownLoadModel:self.downLoadModel request:self.request];
                
                if (downLoadModel.isExistDifFile) {
                    
                    [weakSelf shareFormWithFileUrl:downLoadModel.allFilePath];
                    
                }else {
                    
                    [weakSelf loadDownLoadFile];
                }
                
            }
            
            [weakSelf.tableView reloadData];
            
        }];
        
    }else {
        
        sheetView = [[JGJCusActiveSheetView alloc]  initWithSheetViewModel:sheetViewModel sheetViewType:JGJCusActiveSheetViewRecordAccountType buttons:buttons buttonClick:^(JGJCusActiveSheetView *sheetView, NSInteger buttonIndex, NSString *title)  {
            
            if (buttonIndex == 0) {
                
                JGJAccountShowTypeVc *typeVc = [[JGJAccountShowTypeVc alloc] init];
                
                typeVc.selTypeModel = weakSelf.selTypeModel;
                
                [weakSelf.navigationController pushViewController:typeVc animated:YES];
                
            }else if (buttonIndex == 1) {
                
                JGJRecordWorkDownLoadModel *downLoadModel = [JGJRecordTool downFileExistWithDownLoadModel:self.downLoadModel request:self.request];
                
                if (downLoadModel.isExistDifFile) {
                    
                    [weakSelf shareFormWithFileUrl:downLoadModel.allFilePath];
                    
                }else {
                    
                    [weakSelf loadDownLoadFile];
                }
                
                
            }
            
            [weakSelf.tableView reloadData];
            
        }];
        
    }
    
    [sheetView showView];
}

- (void)setRecordWorkStaDetailModel:(JGJRecordWorkStaDetailModel *)recordWorkStaDetailModel {
    
    _recordWorkStaDetailModel = recordWorkStaDetailModel;
    
    self.maxTrail = [JGJRecordStaListCell maxWidthWithStaList:_recordWorkStaDetailModel.month_list];
    
    [self.tableView reloadData];
    
    //无数据用时间去判断，记了帐就会有时间
    
//    CGFloat height = [NSString isEmpty:recordWorkStaDetailModel.date] ? 0 : 40;
//
//    [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
//
//        make.height.mas_equalTo(height);
//
//    }];
    
    if ([NSString isEmpty:recordWorkStaDetailModel.date]) {
        
        self.tableView.tableFooterView = self.defaultView;
        
    }
    
}

#pragma mark - 下载统计表格
- (void)downRecordForm {
    
    //方式一：进入页面打开
    JGJRecordStaDownLoadVc *downLoadVc = [[JGJRecordStaDownLoadVc alloc] init];
    
//    self.downLoadModel.file_path = @"http://test.cdn.jgjapp.com/download/knowledges/20180715/17_1028204947.docx";
//    
//    self.downLoadModel.file_type = @"docx";
//    
//    self.downLoadModel.file_name = @"tuum啊五+20190220131651.xls";
    
    downLoadVc.downLoadModel = self.downLoadModel;
    
    [self.navigationController pushViewController:downLoadVc animated:YES];
    
//    return;
//    
//    //方式二：直接分享
//    
//    JGJRecordTool *tool = [[JGJRecordTool alloc] init];
//    
//    JGJRecordToolModel *toolModel = [JGJRecordToolModel new];
//    
////    toolModel.url = @"http://test.cdn.jgjapp.com//download//knowledges//20170910//14_1332129075.xlsx";
////
////    toolModel.type = @"xlsx";
////
////    toolModel.name = @"1.分项工程质量检验评定汇总表(一)—【吉工宝APP】";
//    
//    toolModel.url = [NSString stringWithFormat:@"%@%@", JLGHttpRequest_IP, self.downLoadModel.file_path];
//    
//    toolModel.type = self.downLoadModel.file_type?:@"";
//    
//    toolModel.name = self.downLoadModel.file_name?:@"";
//    
//    toolModel.curVc = self;
//    
//    tool.toolModel = toolModel;
//    
//    TYWeakSelf(self);
//    
//    tool.recordToolBlock = ^(BOOL isSucess, NSURL *localFilePath) {
//        
//        [TYLoadingHub hideLoadingView];
//        
//        [weakself shareFormWithFileUrl:localFilePath];
//        
//    };
    
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

- (void)initialSubView {
    
    self.filterView.backgroundColor = AppFontfdf1e0Color;
    
    self.tipsLable.textColor = AppFontF18215Color;
    
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadRecordStaNetData)];
        
    self.tipsLable.text = self.staListModel.nameDes;
}

#pragma mark - 加载记工统计
- (void)loadRecordStaNetData {
    
    NSDictionary *parameters = [self.request mj_keyValues];
    
    [JLGHttpRequest_AFN PostWithNapi:@"workday/get-month-record-statistics" parameters:parameters success:^(id responseObject) {
        
        JGJRecordWorkStaDetailModel *workStaDetailModel = [JGJRecordWorkStaDetailModel mj_objectWithKeyValues:responseObject];
                
        self.recordWorkStaDetailModel = workStaDetailModel;
        
        //顶部统计
        [workStaDetailModel handleTopContractorSta];
        
        TYWeakSelf(self);
        
        [self.filterView setFilterRecordWorkStaModel:workStaDetailModel staFilterAccountypesBlock:^(JGJRecordWorkStaModel *recordWorkStaModel, CGFloat height) {
            
            weakself.filterViewH.constant = height;
            
        }];
        
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
        
    }];
    
}

#pragma mark - 下载文件
- (void)loadDownLoadFile {
    
    NSDictionary *parameters = [self.request mj_keyValues];
    
    self.downLoadModel.uid = self.request.uid;
    
    self.downLoadModel.class_type = self.request.class_type;
    
    self.downLoadModel.class_type_id = self.request.class_type_id;
    
    self.downLoadModel.start_time = self.request.start_time;
    
    self.downLoadModel.end_time = self.request.end_time;
    
    NSMutableDictionary *muParameters = [NSMutableDictionary dictionary];
    
    [muParameters addEntriesFromDictionary:parameters];
    
    [muParameters setObject:@"1" forKey:@"is_down"];
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithNapi:@"workday/get-month-record-statistics" parameters:muParameters success:^(id responseObject) {
        
         [TYLoadingHub hideLoadingView];
        
        JGJRecordWorkDownLoadModel *downLoadModel = [JGJRecordWorkDownLoadModel mj_objectWithKeyValues:responseObject];
        
        self.downLoadModel = downLoadModel;
        
        [self downRecordForm]; //下载
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
    }];
}

- (JGJComDefaultView *)defaultView {
    
    if (!_defaultView) {
        
        _defaultView = [[JGJComDefaultView alloc] initWithFrame:self.view.bounds];
        
        JGJComDefaultViewModel *defaultViewModel = [JGJComDefaultViewModel new];
        
        defaultViewModel.lineSpace = 5;
        
        defaultViewModel.des = @"暂无记工统计数据";
        
        defaultViewModel.isHiddenButton = YES;
        
        _defaultView.defaultViewModel = defaultViewModel;
    }
    
    return _defaultView;
}

- (JGJAccountShowTypeModel *)showTypeModel {
    
    if (!_showTypeModel) {
        
        _showTypeModel = [[JGJAccountShowTypeModel alloc] init];
        
        _showTypeModel.title = [self.request.is_day isEqualToString:@"1"] ? @"按天统计" : @"按月统计";
        
        _showTypeModel.type = [self.request.is_day isEqualToString:@"1"] ? 0 : 1;;
    }
    
    return _showTypeModel;
}

- (SJButton *)titleButton {
    
    if (!_titleButton) {
        
        _titleButton = [SJButton buttonWithType:SJButtonTypeHorizontalTitleImage];
        
        _titleButton.frame = CGRectMake(0, 0, 200, JGJ_NAV_HEIGHT);
        
        [_titleButton setBackgroundColor:[UIColor clearColor] forState:SJControlStateHighlighted];
        
        [_titleButton setImage:[UIImage imageNamed:@"down_arrow_icon"] forState:SJControlStateNormal];
        
        [_titleButton setTitle:self.showTypeModel.title forState:SJControlStateNormal];
        
        [_titleButton setTitleColor:AppFont333333Color forState:SJControlStateNormal];
        
        _titleButton.font = [UIFont systemFontOfSize:JGJNavBarFont];
        
        [_titleButton addTarget:self action:@selector(titleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
//        // 设置内部的imageView的内容模式为居中
//        _titleButton.contentMode = UIViewContentModeRight;
        // 超出边框的内容不需要裁剪
        _titleButton.clipsToBounds = NO;
    
    }
    
    return _titleButton;
}

- (JGJAccountShowTypeView *)showTypeView {
    
    if (!_showTypeView) {
        
        CGRect rect = CGRectMake(0, JGJ_NAV_HEIGHT, TYGetUIScreenWidth, TYGetUIScreenHeight - JGJ_NAV_HEIGHT);
        
        _showTypeView = [[JGJAccountShowTypeView alloc] initWithFrame:rect];
        
        _showTypeView.type = JGJAccountShowTypeViewStaType;
        
        TYWeakSelf(self);
        
        _showTypeView.accountShowTypeViewBlock = ^(JGJAccountShowTypeModel *typeModel) {
            
            weakself.showTypeModel = typeModel;
            
            [weakself.titleButton setTitle:typeModel.title forState:SJControlStateNormal];
            
            weakself.titleButton.selected = NO;
            
            [weakself senderAnimation:weakself.titleButton];
            
            weakself.request.is_day = typeModel.type == 0 ? @"1" : @"0";
                        
            [weakself.tableView.mj_header beginRefreshing];
        };
    }
    
    return _showTypeView;
}

#pragma mark - buttonAction
- (void)titleButtonPressed:(UIControl *)sender {
    
    sender.selected = !sender.selected;
    
    [self senderAnimation:sender];
}

- (void)senderAnimation:(UIControl *)sender {
    
    if (sender.selected) {
        
        self.titleButton.imageView.transform = CGAffineTransformMakeRotation(-M_PI);
        
        [self.showTypeView show];
        
        _showTypeView.selTypeModel = self.showTypeModel;
        
    }else {
        
        self.titleButton.imageView.transform = CGAffineTransformMakeRotation(0);
        
        [self.showTypeView dismiss];
        
        self.titleButton.selected = NO;
    }
    
}

- (void)setParameterWithInfos:(NSArray *)infos {
    //原数据
    NSArray *oriInfos = infos;
    
    NSArray *oritimes = oriInfos[0];
    
    NSArray *oriproModels = oriInfos[1];
    
    NSArray *orimemberModels = oriInfos[2];
    
    JGJComTitleDesInfoModel *ori_st_time = oritimes[0];
    
    JGJComTitleDesInfoModel *ori_en_time = oritimes[1];
    
    JGJComTitleDesInfoModel *ori_proModel = oriproModels[0];
    
    JGJComTitleDesInfoModel *ori_memberModel = orimemberModels[0];
    
    NSString *st = ori_st_time.des;
    
    NSString *en = ori_en_time.des;
    
    self.filterView.startTimeStr = st;
    
    self.filterView.endTimeStr = en;
    
    self.request.start_time = st;
    
    self.request.end_time = en;
    
}

@end
