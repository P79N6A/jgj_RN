//
//  JGJChatListRecordVc.m
//  mix
//
//  Created by Tony on 2016/8/30.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatListRecordVc.h"
#import "MJRefresh.h"
#import "NSDate+Extend.h"
#import "LZChatRefreshHeader.h"
#import "UITableViewCell+Extend.h"
#import "JGJChatListRecordCell.h"
#import "JGJChatListRecordHeaderCell.h"
#import "JGJChatListRecordFooterCell.h"
#import "YZGMateReleaseBillViewController.h"
#import "JGJChatListRecordModel.h"
#import "JGJMorePeopleViewController.h"
#import "JGJQRecordViewController.h"
#import "JGJChatNoDataDefaultView.h"

#import "JGJHelpCenterTitleView.h"

#import "JGJCusActiveSheetView.h"

#import "JGJMarkBillViewController.h"

#import "JGJCustomLable.h"

#import "JGJAccountShowTypeVc.h"

#import "JGJRecordTool.h"

#import "JGJRecordWorkModel.h"

#import "JGJTabComHeaderFooterView.h"

#import "UILabel+GNUtil.h"

#import "JGJSurePoorbillViewController.h"

#import "YZGSelectedRoleViewController.h"

#import "JGJCustomPopView.h"

#import "JGJRecordStaDownLoadVc.h"

#define PgSize 30

static const CGFloat kJGJChatListRecordHeaderH = 30.0;

static const CGFloat kJGJChatListRecordHeaderCellH = 30.0;

static const CGFloat kJGJChatListRecordCellH = 50.0;

@interface JGJChatListRecordVc ()
<
UITableViewDelegate,

UITableViewDataSource,

UIDocumentInteractionControllerDelegate

>

{
    
    UIDocumentInteractionController *_documentInteraction;
}

@property (nonatomic,strong) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSMutableArray <JGJChatListRecordModel *>*dataSourceArr;

@property (nonatomic,assign) NSInteger pageNum;

@property (nonatomic,copy) NSString *postApiStr;

@property (weak, nonatomic) IBOutlet UIButton *recordButton;

@property (nonatomic, strong) JGJChatNoDataDefaultView *chatNoDataDefaultView;

//工时和工切换
@property (nonatomic, assign) BOOL isShowWork;

@property (nonatomic, strong) JGJAccountShowTypeModel *selTypeModel;

@property (weak, nonatomic) IBOutlet UILabel *desLable;

@property (weak, nonatomic) IBOutlet UIView *lineView;

//下载文件
@property (nonatomic, strong) JGJRecordWorkDownLoadModel *downLoadModel;

@property (strong, nonatomic) JGJRecordWorkPointRequestModel *request;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *desH;

@property (strong, nonatomic) JGJTabComHeaderFooterViewModel *headerModel;

@property (weak, nonatomic) IBOutlet UILabel *confirmInfo;


@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (weak, nonatomic) IBOutlet UIView *topView;

//是否隐藏确认按钮
@property (assign, nonatomic) BOOL isHiddenConfrmBtn;

@end

@implementation JGJChatListRecordVc
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self commonInit];
    
    JGJHelpCenterTitleView *titleView = [JGJHelpCenterTitleView helpCenterTitleView];
    
    titleView.proListModel = self.workProListModel;
    
    titleView.titleViewType = JGJHelpCenterTitleViewRecordBillingType;
    
    titleView.title = @"出勤公示";
    
    self.navigationItem.titleView = titleView;
    
    [self.recordButton.layer setLayerCornerRadius:JGJCornerRadius];
    
    if (self.workProListModel.isClosedTeamVc) {
        self.recordButton.hidden = YES;
        self.recordConstance.constant = 0;
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemPressed)];
    
    self.isShowWork = JGJIsShowWorkBool;
    
    [TYLoadingHub showLoadingNoDataDefultWithMessage:nil];
    
    self.desLable.textColor = AppFontf18215Color;
    
    self.desLable.backgroundColor = AppFontfdf1e0Color;
    
    self.lineView.backgroundColor = AppFontdbdbdbColor;
    
    self.desLable.text = @"此处只显示班组长对工人的记工";
    
    self.desLable.font = [UIFont boldSystemFontOfSize:AppFont26Size];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(confirmTapAction)];
    
    [self.topView addGestureRecognizer:tap];
    
    self.confirmInfo.textColor = AppFont333333Color;
    
    self.view.backgroundColor = AppFontf1f1f1Color;
    
    self.topView.hidden = YES;
}

- (void)commonInit{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    
    [self.confirmBtn.layer setLayerBorderWithColor:AppFontF18215Color width:0.5 radius:3];
    
    self.confirmBtn.titleLabel.font = [UIFont boldSystemFontOfSize:AppFont26Size];
    
    //    [self loadNewData];
}

- (IBAction)recordButtonClicked:(UIButton *)sender {
    
    if (self.workProListModel.isClosedTeamVc) {
        
        NSString *showPlaint = [self.workProListModel.class_type isEqualToString:@"team"] ? @"项目已关闭，不能执行此操作":@"班组已关闭，不能执行此操作";
        
        [TYShowMessage showPlaint:showPlaint];
        
        return;
    }
    
    JGJMyWorkCircleProListModel *workProListModel = self.workProListModel;
    
    
    if ([workProListModel.myself_group isEqualToString:@"1"]) {
        
        JgjRecordlistModel *listModel = [JgjRecordlistModel new];
        JGJMorePeopleViewController *morePepleRecordVc = [[JGJMorePeopleViewController alloc]init];
        listModel.group_id = workProListModel.group_id;
        listModel.members_num = workProListModel.members_num;
        listModel.pro_id   = workProListModel.pro_id;
        listModel.pro_name = workProListModel.pro_name;
        listModel.group_name = workProListModel.group_name;
        morePepleRecordVc.recordSelectPro = listModel;
        morePepleRecordVc.isMinGroup = YES;
        
        [self.navigationController pushViewController:morePepleRecordVc animated:YES];
    }else {
        
        
        JGJMarkBillViewController *singleRecorVc = [[UIStoryboard storyboardWithName:@"JGJMarkBillVC" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJMarkBillVC"];
        singleRecorVc.selectedDate = [NSDate date];
        
        singleRecorVc.roleType = 2;
        
        if ([workProListModel.group_info.myself_group isEqualToString:@"1"]) {
            
            singleRecorVc.roleType = 1;
        }
        
        singleRecorVc.getTpl = YES;
        
        singleRecorVc.ChatType = YES;
        
        singleRecorVc.workProListModel = workProListModel;
        
        TYLog(@"-----------%@", [workProListModel mj_keyValues]);
        
        [self.navigationController pushViewController:singleRecorVc animated:YES];
        
    }
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.selTypeModel = [JGJAccountShowTypeTool showTypeModel];
    
    [self loadNewData];
}

- (void)loadNewData{
    self.pageNum = 1;
    [self JLGHttpRequest:YES];
}

- (void)loadMoreData{
    [self.tableView.mj_footer beginRefreshing];
    [self JLGHttpRequest:NO];
}

- (void)setWorkProListModel:(JGJMyWorkCircleProListModel *)workProListModel{
    _workProListModel = workProListModel;
    //    [self loadNewData];
}

- (void)JLGHttpRequest:(BOOL )newData{
    
    //    self.postApiStr = _workProListModel.workCircleProType == WorkCircleExampleProType?@"v2/workday/sampleworkdaylist":@"v2/workday/groupworkdaylist";
    
    self.postApiStr = @"workday/group-workday-list";
    
    if (_workProListModel.workCircleProType == WorkCircleExampleProType) {
        self.tableView.mj_footer = nil;
    }
    
    [JLGHttpRequest_AFN PostWithNapi:self.postApiStr parameters:@{@"group_id":self.chatListRequestModel.group_id?:@"",@"pg":@(self.pageNum),@"pagesize":@(PgSize)} success:^(id responseObject) {
        
        if ([responseObject isKindOfClass:[NSArray class]]) {
            
            return ;
        }
        
        NSMutableArray <JGJChatListRecordModel *>*dataArr = [JGJChatListRecordModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        if (dataArr.count > 0) {
            ++self.pageNum;
            newData?[self.dataSourceArr removeAllObjects]:nil;
            self.dataSourceArr = [self.dataSourceArr arrayByAddingObjectsFromArray:dataArr].mutableCopy;
            [self.tableView reloadData];
        }
        
        if (dataArr.count < PgSize) {
            
            self.tableView.mj_footer = nil;
        }
        
        NSString *num = [NSString stringWithFormat:@"%@", responseObject[@"num"]];
        
        self.confirmInfo.text = [NSString stringWithFormat:@"你在该班组有 %@ 笔记工还没有确认", num?:@"0"];
        
        BOOL isHidden = [num isEqualToString:@"0"];
        
        self.isHiddenConfrmBtn = isHidden;
        
        self.confirmInfo.hidden = isHidden;
        
        self.confirmBtn.hidden = isHidden;
        
        self.desH.constant = isHidden ? 43 : 63;
        
        self.topView.hidden = NO;
        
        [self.confirmInfo markText:num withColor:AppFontF18215Color];
        
        [self noDataDefaultView];
        
        [TYLoadingHub hideLoadingView];
        
        [self.tableView.mj_footer endRefreshing];
        
    }failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
        [self.tableView.mj_footer endRefreshing];
        
    }];
}

#pragma mark - 添加没有数据的时候的默认界面
- (void )noDataDefaultView{
    [self noDataDefaultView:self.dataSourceArr.count];
    
    if (self.workProListModel.isClosedTeamVc) {
        
        UIImageView *clocedImageView = [[UIImageView alloc] init];
        
        NSString *closeType = @"Chat_closedGroup";
        
        if ([self.workProListModel.class_type isEqualToString:@"team"]) {
            
            closeType = @"pro_closedFlag_icon";
        }
        
        clocedImageView.image = [UIImage imageNamed:closeType];
        
        [self.view addSubview:clocedImageView];
        
        [clocedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.center.mas_equalTo(self.view);
            make.width.mas_equalTo(126);
            make.height.mas_equalTo(70);
        }];
        
    }
}

- (void )noDataDefaultView:(NSInteger )dataCout{
    if (!self.chatNoDataDefaultView) {
        self.chatNoDataDefaultView = [[JGJChatNoDataDefaultView alloc] init];
        self.chatNoDataDefaultView.backgroundColor = self.tableView.backgroundColor;
        self.chatNoDataDefaultView.userInteractionEnabled = NO;
        self.chatNoDataDefaultView.helpBtn.hidden = YES;
    }
    
    BOOL needAdd = [self.chatNoDataDefaultView needAddViewWithListType:JGJChatListRecord];
    
    if (!dataCout && needAdd) {
        
        CGFloat bottom = TYIST_IPHONE_X ? 98 : 64;
        
        [self.view addSubview:_chatNoDataDefaultView];
        [self.chatNoDataDefaultView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.view).offset(-bottom);
            make.top.mas_equalTo(self.view).offset(60);
        }];
        [self.view layoutIfNeeded];
        
        self.chatNoDataDefaultView.chatListType = JGJChatListRecord;
    }else{
        if (self.chatNoDataDefaultView) {
            [self.chatNoDataDefaultView removeFromSuperview];
            self.chatNoDataDefaultView = nil;
        }
    }
}


#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger count = self.dataSourceArr.count;
    return count;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    JGJChatListRecordModel *chatListRecordModel = self.dataSourceArr[section];
    NSInteger count = chatListRecordModel.list.count + 1;//加头
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kJGJChatListRecordHeaderH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellHeight = 0.0;
    
    if (indexPath.row == 0) {
        //头
        cellHeight = kJGJChatListRecordHeaderCellH;
    }else{
        cellHeight = kJGJChatListRecordCellH;
    }
    
    return cellHeight;
}

// 定义头标题的视图，添加点击事件
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    JGJTabComHeaderFooterView *headerView = [[JGJTabComHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, kJGJChatListRecordHeaderH)];
    
    JGJChatListRecordModel *chatListRecordModel = self.dataSourceArr[section];
    
    self.headerModel.title = [NSString stringWithFormat:@"%@(%@)", chatListRecordModel.date,chatListRecordModel.date_turn];
    
    NSString *count = [NSString stringWithFormat:@"%@", chatListRecordModel.mem_cnt?:@""];
    
    self.headerModel.des = [NSString stringWithFormat:@"当日记工人数：%@", count];
    
    self.headerModel.changeColorStr = count;
    
    headerView.infoModel = self.headerModel;
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [UITableViewCell getNilViewCell:tableView indexPath:indexPath];
    
    if (indexPath.section > (self.dataSourceArr.count - 1)) {
        return cell;
    }
    
    JGJChatListRecordModel *chatListRecordModel = self.dataSourceArr[indexPath.section];
    
    if (indexPath.row == 0) {
        //头
        cell = [JGJChatListRecordHeaderCell cellWithTableView:tableView];
    }else{
        if (indexPath.row > chatListRecordModel.list.count) {
            return cell;
        }
        
        ChatListRecord_List *listRecordModel = (ChatListRecord_List *)chatListRecordModel.list[indexPath.row - 1];
        JGJChatListRecordCell *recordCell = [JGJChatListRecordCell cellWithTableView:tableView];
        
        recordCell.showType = self.selTypeModel.type;
        
        recordCell.chatListRecordModel = listRecordModel;
        
        cell = recordCell;
    }
    
    return cell;
}


- (NSString *)convertDate:(NSString *)dateStr{
    NSString *convertDateStr;
    NSDate *date = [NSDate dateFromString:dateStr withDateFormat:@"yyyyMMdd"];
    if ([date isThisYear]) {//是今年
        convertDateStr = [NSDate stringFromDate:date format:@"MM月dd日"];
    }else{//不是今年
        convertDateStr = [NSDate stringFromDate:date format:@"yyyy年MM月dd日"];
    }
    return convertDateStr;
}

- (NSMutableArray *)dataSourceArr
{
    if (!_dataSourceArr) {
        _dataSourceArr = [[NSMutableArray alloc] init];
    }
    return _dataSourceArr;
}

- (JGJChatRootRequestModel *)chatListRequestModel
{
    if (!_chatListRequestModel) {
        _chatListRequestModel = [[JGJChatRootRequestModel alloc] init];
    }
    return _chatListRequestModel;
}

- (void)rightBarButtonItemPressed {
    
    [self showSheetView];
}

- (void)showSheetView{
    
    NSArray *buttons = @[self.selTypeModel.title?:@"",JGJSwitchRecordBillShowModel, @"下载最近30天考勤表", @"取消"];
    
    JGJCusActiveSheetViewModel *sheetViewModel = [[JGJCusActiveSheetViewModel alloc] init];
    
    sheetViewModel.firstTitle = self.selTypeModel.title;
    
    sheetViewModel.secTitle = JGJSwitchRecordBillShowModel;
    
    sheetViewModel.flagStr = @"account_check_icon";
    
    __weak typeof(self) weakSelf = self;
    
    JGJCusActiveSheetView *sheetView = [[JGJCusActiveSheetView alloc]  initWithSheetViewModel:sheetViewModel sheetViewType:JGJCusActiveSheetViewRecordAccountType buttons:buttons buttonClick:^(JGJCusActiveSheetView *sheetView, NSInteger buttonIndex, NSString *title) {
        
        if (buttonIndex == 0) {
            
            JGJAccountShowTypeVc *typeVc = [[JGJAccountShowTypeVc alloc] init];
            
            typeVc.selTypeModel = weakSelf.selTypeModel;
            
            [weakSelf.navigationController pushViewController:typeVc animated:YES];
            
        }else if (buttonIndex == 1) {
            
            if (self.dataSourceArr.count > 0) {
                
                JGJRecordWorkDownLoadModel *downLoadModel = [JGJRecordTool downFileExistWithRecordDownLoadModel:self.downLoadModel request:self.request];
                
                if (downLoadModel.isExistDifFile) {
                    
                    [weakSelf shareFormWithFileUrl:downLoadModel.allFilePath];
                    
                }else {
                    
                    [weakSelf loadDownLoadFile];
                }
                
            }else {
                
                NSString *messsge = @"没有自己的出勤记录";
                
                if (JLGisLeaderBool) {
                    
                    messsge = @"没有可下载的数据";
                }
                
                [TYShowMessage showPlaint:messsge];
            }
        }
        
        [weakSelf.tableView reloadData];
    }];
    
    [sheetView showView];
}

#pragma mark - 下载文件
- (void)loadDownLoadFile {
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithNapi:self.postApiStr parameters:@{@"group_id":self.chatListRequestModel.group_id?:@"",@"pg":@(self.pageNum),@"pagesize":@(PgSize), @"is_down" : @"1"} success:^(id responseObject) {
        
        JGJRecordWorkDownLoadModel *downLoadModel = [JGJRecordWorkDownLoadModel mj_objectWithKeyValues:responseObject];
        
        self.downLoadModel = downLoadModel;
        
        [self downRecordForm]; //下载
        
        [TYLoadingHub hideLoadingView];
        
    }failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
    }];
}

- (void)confirmTapAction {
    
    if (self.isHiddenConfrmBtn) {
        
        return;
    }
    
    if (JLGisLeaderBool) {
        
        JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
        
        desModel.popDetail = @"你当前是【班组长】\n如要确认记账，请切换成【工人】身份。";
        
        desModel.leftTilte = @"不切换";
        
        desModel.rightTilte = @"切换成【工人】";
        
        desModel.lineSapcing = 5;
        
        desModel.changeContents = @[@"【班组长】", @"【工人】"];
        
        desModel.changeContentColor = AppFont000000Color;
        desModel.messageFont = [UIFont systemFontOfSize:AppFont30Size];
        JGJCustomPopView *alertView = [JGJCustomPopView showWithMessage:desModel];
        
        alertView.messageLable.textAlignment = NSTextAlignmentLeft;
        alertView.backgroundColor = [AppFont000000Color colorWithAlphaComponent:0.75];
        
        __weak typeof(self) weakSelf = self;
        
        alertView.onOkBlock = ^{
            
            [weakSelf changeRoleWithType:1];
        };
        
        return;
        
    }
    
    JGJSurePoorbillViewController *poorBillVC = [[UIStoryboard storyboardWithName:@"JGJSurePoorbillVC" bundle:nil]instantiateViewControllerWithIdentifier:@"JGJSurePoorbillVC"];
    
    poorBillVC.group_id = self.workProListModel.group_id;
    
    poorBillVC.pro_id = self.workProListModel.pro_id;
    
    [self.navigationController pushViewController:poorBillVC animated:YES];
}

#pragma mark - 下载账单表格
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
    
    return;
    
    JGJRecordTool *tool = [[JGJRecordTool alloc] init];
    
    JGJRecordToolModel *toolModel = [JGJRecordToolModel new];
    
    //    toolModel.url = @"http://test.cdn.jgjapp.com//download//knowledges//20170910//14_1332129075.xlsx";
    //
    //    toolModel.type = @"xlsx";
    //
    //    toolModel.name = @"1.分项工程质量检验评定汇总表(一)—【吉工宝APP】";
    
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

#pragma mark - 切换身份
- (void)changeRoleWithType:(NSInteger)type {
    
    [JGJComTool changeRoleWithType:type successBlock:^{
        
    }];
}

- (JGJRecordWorkPointRequestModel *)request {
    
    if (!_request) {
        
        _request = [JGJRecordWorkPointRequestModel new];
        
    }
    
    return _request;
}

- (JGJTabComHeaderFooterViewModel *)headerModel {
    
    if (!_headerModel) {
        
        _headerModel = [[JGJTabComHeaderFooterViewModel alloc] init];
    }
    
    return _headerModel;
}

@end
