//
//  JGJWorkReplyViewController.m
//  JGJCompany
//
//  Created by Tony on 2017/11/16.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJWorkReplyViewController.h"

#import "JGJSystemNoticeTableViewCell.h"

#import "JGJNoDataTableViewCell.h"

#import "JGJPerInfoVc.h"

#import "JGJCustomProInfoAlertVIew.h"

#import "JGJDetailViewController.h"

#import "JGJTaskViewController.h"

#import "JGJQualityDetailVc.h"

#import "JGJWebAllSubViewController.h"

#import "MJRefresh.h"

#import "JGJLableSize.h"

#import "CFRefreshStatusView.h"

#import "JGJCustomPopView.h"

#define pageSize 20 //分页的每页条数

@interface JGJWorkReplyViewController ()
<
UITableViewDelegate,

UITableViewDataSource,

JGJSystemNoticeTableViewCellDelegate
>
@property (strong ,nonatomic)NSMutableArray <JGJAllNoticeModel *>*dataArr;

@property (assign ,nonatomic)int pageNum;

@property (assign, nonatomic) BOOL isChecked;//查看标记

@end

@implementation JGJWorkReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadSelfView];
    
    [self.tableView.mj_header beginRefreshing];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //    [self JGJHttpRequst];
    
}

- (void)loadRightButton
{
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(cleanAll)];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:AppFontEB4E4EColor];
    self.navigationItem.rightBarButtonItem = barButton;
    
}
-(void)loadSelfView{
    self.title = @"工作回复";
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.backgroundColor = AppFontf1f1f1Color;
    
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(JGJHttpRequst)];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(JGJHttpLoadMoreRequst)];
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.dataArr.count) {
        JGJNoDataTableViewCell *cell = [JGJNoDataTableViewCell cellWithTableView:tableView];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        return cell;
        
    }else{
        
        JGJSystemNoticeTableViewCell *cell = [JGJSystemNoticeTableViewCell cellWithTableView:tableView];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.delegate = self;
        
        cell.headBtn.tag = indexPath.section;
        
        cell.namelable.tag = indexPath.section;
        
        cell.model = self.dataArr[indexPath.section];
        
        if (indexPath.section >= self.dataArr.count - 1) {
            
            cell.departLine.backgroundColor = AppFontf1f1f1Color;
            
        }
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.dataArr.count) {
        
        return TYGetUIScreenHeight - 64;
    }
    if ([[self.dataArr[indexPath.section] msg_src] count] <= 0) {
        return  120 + [self rowHeightWithContent:[self.dataArr[indexPath.section] reply_text] ];
    }
    return 151 + [self rowHeightWithContent:[self.dataArr[indexPath.section] reply_text] ];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    JGJAllNoticeModel *noticeModel = self.dataArr[section];
    
    CGFloat height = noticeModel.is_checked ? 25 : 10;
    
    if (section == 0) {
        
        height = CGFLOAT_MIN;
    }
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, height)];
    
    headView.backgroundColor = AppFontf1f1f1Color;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:headView.bounds];
    
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [headView addSubview:imageView];
    
    UILabel *title = [[UILabel alloc] init];
    
    title.textColor = AppFontF18215Color;
    
    title.font = [UIFont systemFontOfSize:AppFont24Size];
    
    title.width = 100;
    
    title.height = 25;
    
    title.centerX = headView.centerX;
    
    title.centerY = headView.centerY;
    
    [headView addSubview:title];
    
    headView.backgroundColor = noticeModel.is_checked ? AppFontfdf1e0Color : AppFontf1f1f1Color;
    
    headView.hidden = !noticeModel.is_checked;
    
    title.hidden = !noticeModel.is_checked;
    
    imageView.hidden = !noticeModel.is_checked;
    
    if (noticeModel.is_checked && section != 0) {
        
        imageView.image = [UIImage imageNamed:@"work_reply_padding_icon"];
        
        title.text = @"你上次看到这里了";
        
    }else {
        
        imageView.image = [UIImage imageNamed:@""];
        
        title.text = @"";
    }
    return headView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    JGJAllNoticeModel *noticeModel = self.dataArr[section];
    
    CGFloat height = noticeModel.is_checked ? 25 : 10;
    
    if (section == 0) {
        
        height = CGFLOAT_MIN;
    }
    
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.dataArr.count) {
        return;
    }
    if ([[self.dataArr[indexPath.section] reply_type] isEqualToString:@"log"] || [[self.dataArr[indexPath.section] reply_type] isEqualToString:@"notice"]) {
        
        JGJChatMsgListModel *model = [JGJChatMsgListModel new];
        
        model.msg_id = [self.dataArr[indexPath.section] msg_id];
        
        model.class_type = _WorkproListModel.class_type;
        
        model.msg_type = [self.dataArr[indexPath.section] reply_type];
        
        model.group_id = _WorkproListModel.group_id;
        
        JGJDetailViewController *detailVC = [[JGJDetailViewController alloc]init];
        
        detailVC.chatRoomGo = YES;
        
        detailVC.jgjChatListModel = model;
        
        detailVC.workProListModel = self.WorkproListModel;
        
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }else if([[self.dataArr[indexPath.section] reply_type] isEqualToString:@"task"]){
        
        JGJChatMsgListModel *model = [JGJChatMsgListModel new];
        
        model.msg_id = [self.dataArr[indexPath.section] msg_id];
        
        model.group_id = _WorkproListModel.group_id;
        
        model.class_type = _WorkproListModel.class_type;
        
        model.msg_type = [self.dataArr[indexPath.section] reply_type];
        
        JGJTaskViewController *detailVC = [[JGJTaskViewController alloc]init];
        
        detailVC.jgjChatListModel = model;
        
        detailVC.workProListModel = self.WorkproListModel;
        
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }else if ([[self.dataArr[indexPath.section] reply_type] isEqualToString:@"meeting"]){
        
        NSString *meetingStr = [NSString stringWithFormat:@"%@conference/details?class_type=%@&close=%@&group_id=%@&id=%@",JGJWebDiscoverURL, _WorkproListModel.class_type, @(_WorkproListModel.isClosedTeamVc), _WorkproListModel.group_id,[self.dataArr[indexPath.section] msg_id]];
        
        JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:meetingStr];
        [self.navigationController pushViewController:webVc animated:YES];
        
        
    }else{
        
        
        [self safeQualityVcWithIndexPath:indexPath];
    }
    
}
//质量安全
- (void)safeQualityVcWithIndexPath:(NSIndexPath *)indexPath {
    
    JGJAllNoticeModel *replayListModel = self.dataArr[indexPath.section];
    
    JGJQualityDetailVc *detailVc = [JGJQualityDetailVc new];
    
    detailVc.proListModel = self.WorkproListModel;
    
    JGJQualitySafeListModel *listModel = [JGJQualitySafeListModel new];
    
    JGJQualitySafeCommonModel *commonModel = [JGJQualitySafeCommonModel new];
    
    commonModel.msg_type = replayListModel.reply_type;
    
    listModel.msg_id = replayListModel.msg_id;
    
    listModel.msg_type = replayListModel.reply_type;
    
    if (![NSString isEmpty:replayListModel.msg_type]) {
        
        listModel.msg_type = replayListModel.msg_type;
    }
    
    detailVc.commonModel = commonModel;
    
    detailVc.listModel = listModel;
    
    [self.navigationController pushViewController:detailVc animated:YES];
    
}

-(void)cleanAll
{
    JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
    
    desModel.popDetail = @"确定要清空工作回复列表吗？";
    
    JGJCustomPopView *alertView = [JGJCustomPopView showWithMessage:desModel];
    
    __weak typeof(self) weakSelf = self;
    
    alertView.onOkBlock = ^{
        
        [weakSelf requestCleanAll];
        
    };
}

- (void)requestCleanAll {
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    
    [paramDic setObject:self.WorkproListModel.class_type?:@"" forKey:@"class_type"];
    
    [paramDic setObject:self.WorkproListModel.group_id?:@"" forKey:@"group_id"];
    
    [TYLoadingHub showLoadingWithMessage:@""];
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/Quality/cleanReplyMessage" parameters:paramDic success:^(id responseObject) {
        if (_dataArr.count) {
            [_dataArr removeAllObjects];
            
        }
        [TYShowMessage showSuccess:@"清除成功！"];
        
        [self setDefaultViewWithDataArray:nil];
        
        [self.tableView reloadData];
        
        [TYLoadingHub hideLoadingView];
        
    }failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)setWorkproListModel:(JGJMyWorkCircleProListModel *)WorkproListModel
{
    if (!_WorkproListModel) {
        
        _WorkproListModel = [JGJMyWorkCircleProListModel new];
        
    }
    _WorkproListModel = WorkproListModel;
    
}

- (NSMutableArray<JGJAllNoticeModel *> *)dataArr
{
    if (!_dataArr) {
        
        _dataArr = [NSMutableArray array];
        
    }
    
    return _dataArr;
}
- (void)JGJHttpRequst
{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    
    [paramDic setObject:self.WorkproListModel.class_type?:@"" forKey:@"class_type"];
    
    [paramDic setObject:self.WorkproListModel.group_id?:@"" forKey:@"group_id"];
    
    [paramDic setObject:@(pageSize) forKey:@"pagesize"];
    
    _pageNum = 1;
    
    [paramDic setObject:@(_pageNum) forKey:@"pg"];
    
    //    [TYLoadingHub showLoadingWithMessage:@""];
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/Quality/getAllNoticeMessage" parameters:paramDic success:^(id responseObject) {
        
        
        self.dataArr = [JGJAllNoticeModel mj_objectArrayWithKeyValuesArray:responseObject];
        
        [self setfirstWorkReplyModelWithDataArray:self.dataArr];
        
        [self setDefaultViewWithDataArray:self.dataArr];
        
        if (_dataArr.count && !self.WorkproListModel.isClosedTeamVc) {
            
            [self loadRightButton];
        }
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        //        [TYLoadingHub hideLoadingView];
        
    }failure:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
        
        //        [TYLoadingHub hideLoadingView];
        
    }];
}
-(void)clickreplyUserNameLable:(NSInteger)indepath
{
    JGJPerInfoVc *perInfoVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJPerInfoVc"];
    
    perInfoVc.jgjChatListModel.uid = [[self.dataArr[indepath] user_info] uid];
    perInfoVc.jgjChatListModel.group_id = [self.dataArr[indepath] group_id];
    perInfoVc.jgjChatListModel.class_type = [self.dataArr[indepath] class_type];
    JGJTeamMemberCommonModel *commonModel = [JGJTeamMemberCommonModel new];
    JGJSynBillingModel *memberModel = [JGJSynBillingModel new];
    memberModel.is_active = [NSString stringWithFormat:@"%@", [self.dataArr[indepath] is_active]];
    memberModel.real_name =[[self.dataArr[indepath] user_info] real_name];
    memberModel.telphone = [[self.dataArr[indepath] user_info] telephone];
    commonModel.teamModelModel = memberModel;
    
    if ([memberModel.is_active isEqualToString:@"0"]) {
        
        [self handleClickedUnRegisterAlertViewWithCommonModel:commonModel];
    }else {
        
        [self.navigationController pushViewController:perInfoVc animated:YES];
    }
    
    
}

-(void)clickHedPickBtn:(NSInteger)indexpath
{
    JGJPerInfoVc *perInfoVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJPerInfoVc"];
    
    perInfoVc.jgjChatListModel.uid = [[self.dataArr[indexpath] user_info] uid];
    perInfoVc.jgjChatListModel.group_id = [self.dataArr[indexpath] group_id];
    perInfoVc.jgjChatListModel.class_type = [self.dataArr[indexpath] class_type];
    JGJTeamMemberCommonModel *commonModel = [JGJTeamMemberCommonModel new];
    JGJSynBillingModel *memberModel = [JGJSynBillingModel new];
    memberModel.is_active = [NSString stringWithFormat:@"%@", [self.dataArr[indexpath] is_active]];
    memberModel.real_name =[[self.dataArr[indexpath] user_info] real_name];
    memberModel.telphone = [[self.dataArr[indexpath] user_info] telephone];
    commonModel.teamModelModel = memberModel;
    
    if ([memberModel.is_active isEqualToString:@"0"]) {
        
        [self handleClickedUnRegisterAlertViewWithCommonModel:commonModel];
    }else {
        
        [self.navigationController pushViewController:perInfoVc animated:YES];
    }
    
    
}


-(void)JGJHttpLoadMoreRequst
{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    
    [paramDic setObject:self.WorkproListModel.class_type?:@"" forKey:@"class_type"];
    
    [paramDic setObject:self.WorkproListModel.group_id?:@"" forKey:@"group_id"];
    
    [paramDic setObject:@(pageSize) forKey:@"pagesize"];
    
    _pageNum ++;
    
    [paramDic setObject:@(_pageNum) forKey:@"pg"];
    
    [self.tableView.mj_footer  beginRefreshing];
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/Quality/getAllNoticeMessage" parameters:paramDic success:^(id responseObject) {
        
        NSMutableArray *loadArr = [[NSMutableArray alloc]init];
        loadArr = [JGJAllNoticeModel mj_objectArrayWithKeyValuesArray:responseObject];
        
        if (loadArr.count) {
            
            [_dataArr addObjectsFromArray:loadArr];
            
        }else{
            self.tableView.mj_footer = nil;
        }
        
        [self setfirstWorkReplyModelWithDataArray:self.dataArr];
        
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    }failure:^(NSError *error) {
        
        [self.tableView.mj_footer endRefreshing];
        
    }];
    
}

- (void)handleClickedUnRegisterAlertViewWithCommonModel:(JGJTeamMemberCommonModel *)commonModel {
    
    commonModel.alertViewHeight = 210.0;
    commonModel.alertmessage = @"该用户还未注册,赶紧让他下载【吉工家工人班组】一起开展工作吧!";
    commonModel.alignment = NSTextAlignmentLeft;
    [JGJCustomProInfoAlertVIew alertViewWithCommonModel:commonModel];
    
}

- (CGFloat)rowHeightWithContent:(NSString *)content
{
    
    if ([NSString isEmpty:content]) {
        
        content = @"";
    }
    if ([JGJLableSize RowHeight:content?:@"" andFont:[UIFont systemFontOfSize:15] totalDepart:75] > 25) {
        
        return 18;
    }else{
        
        return 0;
    }
    
    
    
}

#pragma mark - 设置默认页面
- (void)setDefaultViewWithDataArray:(NSArray *)dataArray {
    
    if (dataArray.count == 0) {
        
        self.navigationItem.rightBarButtonItem = nil;
        
        CFRefreshStatusView *statusView = [[CFRefreshStatusView alloc] initWithImage:PNGIMAGE(@"NoDataDefault_NoManagePro") withTips:@"暂无记录哦~"];
        
        statusView.frame = self.tableView.bounds;
        
        self.tableView.tableHeaderView = statusView;
    }
    
}

- (void)setfirstWorkReplyModelWithDataArray:(NSArray *)dataArray{
    
    if (dataArray.count > 0) {
        
        for (JGJAllNoticeModel *noticeModel in dataArray) {
            
            if (noticeModel.is_readed || noticeModel.is_checked) {
                
                noticeModel.is_checked = YES;
                
                break;
            }
        }
        
    }
    
}
@end
