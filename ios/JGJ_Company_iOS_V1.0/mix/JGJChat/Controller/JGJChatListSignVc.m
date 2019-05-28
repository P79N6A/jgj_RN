//
//  JGJChatListSignVc.m
//  JGJCompany
//
//  Created by Tony on 16/9/26.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatListSignVc.h"
#import "NSString+JSON.h"
#import "JGJChatListSignSubVc.h"
#import "JGJChatSignCreatorCell.h"
#import "JGJChatListSignVc.h"

#import "JGJHelpCenterTitleView.h"

#import "JLGAppDelegate.h"

#import "NSArray+JGJDateSort.h"

#import "CFRefreshStatusView.h"

#import "JGJRecordTool.h"

#import "YZGDatePickerView.h"

#import "JGJRecordStaDownLoadVc.h"

@interface JGJChatListSignVc ()<UIDocumentInteractionControllerDelegate, YZGDatePickerViewDelegate>{
    
    UIDocumentInteractionController *_documentInteraction;
}

@property (weak, nonatomic) IBOutlet UIButton *signButton;

@property (strong, nonatomic) JGJSignRequestModel *signRequest;

@property (strong, nonatomic) NSMutableArray *dataSource;

//下载文件
@property (nonatomic, strong) JGJRecordWorkDownLoadModel *downLoadModel;

@property (nonatomic, strong) YZGDatePickerView *yzgDatePickerView;

@property (nonatomic, strong) NSDate *send_stime;

@end

@implementation JGJChatListSignVc

@synthesize chatSignModel = _chatSignModel;
- (void)dataInit{
    [super dataInit];
    
    self.signButton.backgroundColor = AppFontEB4E4EColor;
    
    [self.signButton.layer setLayerCornerRadius:JGJCornerRadius];
    
    JGJHelpCenterTitleView *titleView = [JGJHelpCenterTitleView helpCenterTitleView];
    
    titleView.proListModel = self.workProListModel;
    
    titleView.titleViewType = JGJHelpCenterTitleViewSignType;
    
    titleView.title = @"签到";
    
    self.navigationItem.titleView = titleView;
    
    self.msgType = @"signIn";
    
    self.signHeaderType = SignHeaderTypeSignVc;
    
    self.parameters = [NSMutableDictionary dictionary];
    
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    
    self.tableView.mj_header = [LZChatRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadSignListData)];
    
    if (self.workProListModel.isClosedTeamVc) {
        
        self.signButton.hidden = YES;
        
        self.SignConstance.constant = 0;
        
    }
    
    [self.tableView.mj_header beginRefreshing];
    
    BOOL is_sign_vc = [self isMemberOfClass:NSClassFromString(@"JGJChatListSignVc")];
    
    if (([self.workProListModel.myself_group isEqualToString:@"1"] || self.workProListModel.can_at_all) && is_sign_vc) {
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"下载签到表" style:UIBarButtonItemStylePlain target:self action:@selector(showDownLoadFileDate)];
        
    }
    
}

- (void)setChatSignModel:(JGJChatSignModel *)chatSignModel{
    _chatSignModel = chatSignModel;
    
    self.tableView.tableHeaderView.hidden = NO;
    if (_chatSignModel.list.count != 0) {
        JGJChatSignCreatorCell *chatSignBottomCell = [JGJChatSignCreatorCell cellWithTableView:self.tableView];
        chatSignBottomCell.chatSignModel = _chatSignModel;
        
        self.tableView.tableHeaderView = chatSignBottomCell.contentView;
        self.tableView.tableHeaderView.backgroundColor = [UIColor whiteColor];
        
        //添加单击手势
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableHeaderViewDidSelect:)];
        [self.tableView.tableHeaderView addGestureRecognizer:singleTap];
        
    }
}
- (void)loadSignListData{
    
    self.signRequest.pg = 1;
    
    NSDictionary *parameters = [self.signRequest mj_keyValues];
    
    [JLGHttpRequest_AFN PostWithNapi:[self requestApi] parameters:parameters success:^(id responseObject) {
        
        [self.dataSource removeAllObjects];
        
        JGJChatSignModel *chatSignModel = [JGJChatSignModel mj_objectWithKeyValues:responseObject[@"myself"]];
        
        NSMutableArray *list = responseObject[@"list"];
        
        //添加缺省页
        [self showDefaultNodataArray:list];
        
        chatSignModel.list = list;
        
        self.chatSignModel = chatSignModel;
        
        if (list.count >= JGJPageSize) {
            
            self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreSignListData)];
            
            self.signRequest.pg++;
        }
        
        [self sortDataSource:list];
        
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
        
    }];
    
}

#pragma mark - 是否显示缺省页面
- (void)showDefaultNodataArray:(NSArray *)dataArray {
    
    if (dataArray.count == 0) {
        
        CFRefreshStatusView *statusView = [[CFRefreshStatusView alloc] initWithImage:PNGIMAGE(@"NoDataDefault_NoManagePro") withTips:@"暂无记录哦~"];
        
        statusView.frame = self.tableView.bounds;
        
        self.tableView.tableHeaderView = statusView;
        
    }else {
        
        self.tableView.tableHeaderView.frame = CGRectZero;
        
    }
    
}

- (NSString *)requestApi {
    
    return @"sign/sign-list";
}

- (void)sortDataSource:(NSArray *)dataSource {
    
    [self.dataSource addObjectsFromArray:dataSource];
    
    NSArray *sortArr = [ChatSign_List mj_objectArrayWithKeyValuesArray:[self.dataSource  sortDataSource]];
    
    self.chatSignModel.list = sortArr.mutableCopy;
    
    [self.tableView reloadData];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
}

- (void)subClassWillAppear{
    self.tableView.tableHeaderView.hidden = YES;
    [self.chatSignModel.list removeAllObjects];
    [self.tableView reloadData];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)loadMoreSignListData{
    
    NSDictionary *parameters = [self.signRequest mj_keyValues];
    
    [JLGHttpRequest_AFN PostWithNapi:[self requestApi] parameters:parameters success:^(id responseObject) {
        
        if (self.dataSource.count > 0) {
            
            JGJChatSignModel *chatSignModel = [JGJChatSignModel mj_objectWithKeyValues:responseObject[@"myself"]];
            
            NSMutableArray *list = responseObject[@"list"];
            
            chatSignModel.list = list;
            
            self.chatSignModel = chatSignModel;
            
            [self sortDataSource:list];
            
            if (list.count < JGJPageSize) {
                
                self.tableView.mj_footer = nil;
                
            }
            
            if (list.count >= JGJPageSize) {
                
                self.signRequest.pg++;
                
            }
            
        }
        
        [self.tableView.mj_footer endRefreshing];
        
    } failure:^(NSError *error) {
        
        [self.tableView.mj_footer endRefreshing];
        
    }];
}

- (void)setChatListRequestModel:(JGJChatRootRequestModel *)chatListRequestModel{
    
    [super setChatListRequestModel:chatListRequestModel];
    
    self.chatListRequestModel.msg_type = self.msgType;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    NSInteger sectionCount = self.chatSignModel.list.count;
    
    return sectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger rowCount = 0;
    ChatSign_List *chatSign_List = (ChatSign_List *)self.chatSignModel.list[section];
    rowCount = chatSign_List.sign_list.count;
    
    return rowCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellHeight = 78.0;
    
    return cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat sectionHeaderHeight = 0.0;
    sectionHeaderHeight = self.chatSignModel.list.count == 0?0.0:32.0;
    
    return sectionHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *noDataView = [[UIView alloc] initWithFrame:TYSetRect(0, 0, TYGetUIScreenWidth, 7.0)];
    noDataView.backgroundColor = self.tableView.backgroundColor;
    
    if (self.chatSignModel.list.count == 0) {
        return noDataView;
    }
    
    static NSString *kChatListSignVcHeaderID  = @"JGJChatListSignVcHeader";
    
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kChatListSignVcHeaderID];
    
    NSInteger displayNum = tableView.numberOfSections;
    
    ChatSign_List *chatSign_List = [ChatSign_List new];
    if (displayNum >= section) {
        if (self.chatSignModel.list.count - 1 < section) {
            return noDataView;
        }
        
        //获取数据源
        chatSign_List = (ChatSign_List *)self.chatSignModel.list[section];
    }else{
        //显示空白
        return noDataView;
    }
    
    if(!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:kChatListSignVcHeaderID];
        headerView.frame = TYSetRect(0, 0, TYGetUIScreenWidth, 35.0);
    }
    
    JGJChatSignHeaderCell *signHeaderCell = [JGJChatSignHeaderCell cellWithTableView:tableView];
    
    signHeaderCell.frame = headerView.bounds;
    [signHeaderCell setModel:chatSign_List signType:self.signHeaderType];
    [headerView addSubview:signHeaderCell];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [UITableViewCell getNilViewCell:tableView indexPath:indexPath];
    
    if (tableView.numberOfSections - 1 < indexPath.section) {
        return cell;
    }
    
    //获取数据源
    ChatSign_List *chatSign_List = (ChatSign_List *)self.chatSignModel.list[indexPath.section];
    
    if (chatSign_List.sign_list.count - 1 < indexPath.row) {
        return cell;
    }
    
    ChatSign_Sign_List *sign_List = (ChatSign_Sign_List *)chatSign_List.sign_list[indexPath.row];
    
    JGJChatSignCreatorCell *chatSignCreatorCell = [JGJChatSignCreatorCell cellWithTableView:tableView];
    
    chatSignCreatorCell.chatSign_Sign_List = sign_List;
    
    [chatSignCreatorCell setIsHiddenLineView:chatSign_List.sign_list.count - 1 == indexPath.row];
    
    cell = chatSignCreatorCell;
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.workProListModel.workCircleProType == WorkCircleExampleProType) {
        [TYShowMessage showPlaint:@"这是示范数据，点击无效\n快去组建或进入新项目组操作吧!"];
        return ;
    }
    
    if (self.chatSignModel.list.count - 1 < indexPath.section) {
        return ;
    }
    
    //获取数据源
    ChatSign_List *chatSign_List = (ChatSign_List *)self.chatSignModel.list[indexPath.section];
    
    if (chatSign_List.sign_list.count - 1 < indexPath.row) {
        
        return ;
    }
    
    ChatSign_Sign_List *sign_sign_List = (ChatSign_Sign_List *)chatSign_List.sign_list[indexPath.row];
    
    JGJChatListSignSubVc *chatListSignSubVc = [[UIStoryboard storyboardWithName:@"JGJChat" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJChatListSignSubVc"];
    
    self.signRequest.uid = sign_sign_List.sign_user_info.uid;
    
    chatListSignSubVc.mber_id = sign_sign_List.sign_user_info.uid;
    
    chatListSignSubVc.indexPath = indexPath;
    
    chatListSignSubVc.real_name = sign_sign_List.sign_user_info.real_name;
    
    chatListSignSubVc.workProListModel = self.workProListModel;
    
    chatListSignSubVc.chatListRequestModel = self.chatListRequestModel;
    
    if (self.skipToNextVc) {
        
        self.skipToNextVc(chatListSignSubVc);
        
    }
    
}

- (void)tableHeaderViewDidSelect:(UITapGestureRecognizer *)tapGestureRecognizer{
    if (self.workProListModel.workCircleProType == WorkCircleExampleProType) {
        [TYShowMessage showPlaint:@"这是示范数据，点击无效\n快去组建或进入新项目组操作吧!"];
        return ;
    }
    
    //今天没有签到
    if ([self.chatSignModel.today_sign_record_num integerValue] == 0) {
        
        return;
    }
    
    JGJChatListSignSubVc *chatListSignSubVc = [[UIStoryboard storyboardWithName:@"JGJChat" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJChatListSignSubVc"];
    
    chatListSignSubVc.mber_id = self.chatSignModel.user_info.uid;
    
    chatListSignSubVc.indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    chatListSignSubVc.real_name = self.chatSignModel.user_info.real_name;
    
    chatListSignSubVc.workProListModel = self.workProListModel;
    
    chatListSignSubVc.chatListRequestModel = self.chatListRequestModel;
    
    if (self.skipToNextVc) {
        
        self.skipToNextVc(chatListSignSubVc);
        
    }
    
}

#pragma mark 不需要使用父类的方法
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{}


- (IBAction)signButtonClicked:(UIButton *)sender {
    
    if (self.workProListModel.isClosedTeamVc) {
        
        NSString *showPlaint = [self.workProListModel.class_type isEqualToString:@"team"] ? @"项目已关闭，不能执行此操作":@"班组已关闭，不能执行此操作";
        
        [TYShowMessage showPlaint:showPlaint];
        
        return;
    }
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusNotDetermined || status == kCLAuthorizationStatusRestricted) {
        
        BOOL locationEnable = [CLLocationManager locationServicesEnabled];
        NSString *message;
        if (locationEnable) {
            message = @"签到需要获取你的位置信息，打开手机定位可完成签到。请到设置 > 隐私 > 定位服务中开启【吉工宝】定位服务。";
        } else {
            message = @"签到需要获取你的位置信息，前往 设置 > 隐私 > 定位服务 打开位置信息，才可完成签到。";
        }
        JLGAppDelegate *appDelegate = (JLGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        [appDelegate unOpenLocalTilte:@"定位服务已关闭" message:message];
        
        return;
    }
    
    JGJChatSignVc *signVc= [[UIStoryboard storyboardWithName:@"JGJChat" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJChatSignVc"];
    
    //当前使用签到
    signVc.signVcType = JGJChatSignVcUseType;
    
    signVc.workProListModel = self.workProListModel;
    signVc.chatListType = JGJChatListSign;
    
    //添加签到数据
    //    JGJChatListSignVc *chatListSignVc = (JGJChatListSignVc *)[self getChildVcWithType:JGJChatListSign];
    //    signVc.chatSignModel = chatListSignVc.chatSignModel;
    
    //    nextVc = signVc;
    
    [self.navigationController pushViewController:signVc animated:YES];
    
}

- (void)showDownLoadFileDate {
    
    [self.yzgDatePickerView setDate:self.send_stime ?:[NSDate date]];
    
    [self.yzgDatePickerView showDatePicker];
}

#pragma mark - 下载文件
- (void)loadDownLoadFile {
    
    NSDictionary *parameters = [self.signRequest mj_keyValues];
    
    NSMutableDictionary *muParameters = [NSMutableDictionary dictionary];
    
    [muParameters addEntriesFromDictionary:parameters];
    
    //这里设置起止时间一样后台处理即可
    if (self.send_stime) {
        
        NSString *time = [NSString stringFromDate:self.send_stime withDateFormat:@"yyyy-MM"];
        
        if (![NSString isEmpty:time]) {
            
            [muParameters setValue:time forKey:@"export_time"];
            
        }
    }
    
    [JLGHttpRequest_AFN PostWithNapi:@"sign/sign-export" parameters:muParameters success:^(id responseObject) {
        
        JGJRecordWorkDownLoadModel *downLoadModel = [JGJRecordWorkDownLoadModel mj_objectWithKeyValues:responseObject];
        
        self.downLoadModel = downLoadModel;
        
        NSString *filePath = self.downLoadModel.file_path;
        
        if (![NSString isEmpty:filePath]) {
            
            [self downRecordForm]; //下载
            
        }else {
            
            [TYShowMessage showPlaint:@"你选择的月份没有签到数据可下载"];
            
        }
        
    } failure:^(NSError *error) {
        
        [TYShowMessage showPlaint:@"下载失败"];
        
//        [TYLoadingHub hideLoadingView];
        
    }];
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
    
////    //测试数据开始---
//    toolModel.url = @"http://test.cdn.jgjapp.com//download//knowledges//20180715//17_1028204947.docx";
//
//    toolModel.type = @".docx";
//
//    toolModel.name = @"1.分项工程质量检验评定汇总表(一)—【吉工宝APP】";
//
////    //测试数据结束---
    
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

#pragma mark - YZGDatePickerViewDelegate

- (void)YZGDataPickerSelect:(NSDate *)date
{
    self.send_stime = date;
    
    [self loadDownLoadFile];
    
}

- (JGJChatSignModel *)chatSignModel
{
    if (!_chatSignModel) {
        
        _chatSignModel = [[JGJChatSignModel alloc] init];
        
    }
    return _chatSignModel;
}

- (JGJSignRequestModel *)signRequest {
    
    if (!_signRequest) {
        
        _signRequest = [[JGJSignRequestModel alloc] init];
        
        _signRequest.class_type = self.workProListModel.class_type;
        
        _signRequest.group_id = self.workProListModel.group_id;
        
        _signRequest.pg = 1;
        
        _signRequest.pagesize = JGJPageSize;
    }
    
    return _signRequest;
}

- (NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        
        _dataSource = [NSMutableArray new];
    }
    
    return _dataSource;
}

#pragma mark - 懒加载
- (YZGDatePickerView *)yzgDatePickerView
{
    if (!_yzgDatePickerView) {
        
        _yzgDatePickerView = [[YZGDatePickerView alloc] initWithFrame:TYGetUIScreenRect];
        
        _yzgDatePickerView.delegate = self;
        
    }
    return _yzgDatePickerView;
}

@end

