//
//  JGJQualityMsgReplyListVc.m
//  JGJCompany
//
//  Created by yj on 2017/6/7.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJQualityMsgReplyListVc.h"

#import "JGJQualityMsgReplyListCell.h"

#import "CFRefreshStatusView.h"

#import "JGJQualityDetailVc.h"

#import "JGJDetailViewController.h"

#import "JGJTaskViewController.h"

@interface JGJQualityMsgReplyListVc () <

UITableViewDelegate,

UITableViewDataSource

>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation JGJQualityMsgReplyListVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"回复消息";
    [self initialSubView];
    
    [self loadNetData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJQualityMsgReplyListCell *replyListCell = [JGJQualityMsgReplyListCell cellWithTableView:tableView];
    
    replyListCell.listModel = self.dataArray[indexPath.row];
    
    return replyListCell;
}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.commonModel.msg_type isEqualToString:@"quality"] || [self.commonModel.msg_type isEqualToString:@"safe"]) {
        
        [self safeQualityVcWithIndexPath:indexPath];
        
    }else if ([self.commonModel.msg_type isEqualToString:@"task"]) {
        
        [self taskVcWithIndexPath:indexPath];
        
    }else if ([self.commonModel.msg_type isEqualToString:@"log"]) {
        
        [self logVcWithIndexPath:indexPath];
        
    }else if ([self.commonModel.msg_type isEqualToString:@"notice"]) {
        
        [self noticeVcWithIndexPath:indexPath];
    }
    
    TYLog(@"点击进质量详情页");
    
}

#pragma mark - 质量安全
- (void)safeQualityVcWithIndexPath:(NSIndexPath *)indexPath {
    
    JGJQualityDetailReplayListModel *replayListModel = self.dataArray[indexPath.row];
    
    JGJQualitySafeListModel *listModel = [JGJQualitySafeListModel mj_objectWithKeyValues:[replayListModel mj_keyValues]];
    
    JGJQualityDetailVc *detailVc = [JGJQualityDetailVc new];
    
    detailVc.proListModel = self.proListModel;
    
    detailVc.commonModel = self.commonModel;
    
    detailVc.listModel = listModel;
    
    [self.navigationController pushViewController:detailVc animated:YES];
    
}

#pragma mark - 日志
- (void)logVcWithIndexPath:(NSIndexPath *)indexPath {
    
    JGJQualityDetailReplayListModel *replayListModel = self.dataArray[indexPath.row];
    JGJDetailViewController *allDetailVc = [JGJDetailViewController new];
    allDetailVc.chatRoomGo = YES;
    allDetailVc.workProListModel = self.proListModel;
    
    JGJChatMsgListModel *chatLogListModel = [[JGJChatMsgListModel alloc]init];
    
    chatLogListModel = [self getJGJChatmsgListModelFormModel:replayListModel];
    
    allDetailVc.IsClose    = self.proListModel.isClosedTeamVc;
    
    allDetailVc.workProListModel  = self.proListModel;
    
    allDetailVc.jgjChatListModel = chatLogListModel;
    [self.navigationController pushViewController:allDetailVc animated:YES];
    
}

#pragma mark - 通知
- (void)noticeVcWithIndexPath:(NSIndexPath *)indexPath {
    
    JGJQualityDetailReplayListModel *replayListModel = self.dataArray[indexPath.row];
    
    JGJDetailViewController *allDetailVc = [JGJDetailViewController new];
    
    allDetailVc.workProListModel = self.proListModel;
    
    JGJChatMsgListModel *chatLogListModel = [[JGJChatMsgListModel alloc]init];
    
    chatLogListModel = [self getJGJChatmsgListModelFormModel:replayListModel];
    
    allDetailVc.IsClose    = self.proListModel.isClosedTeamVc;
    
    allDetailVc.workProListModel  = self.proListModel;
    
    allDetailVc.jgjChatListModel = chatLogListModel;
    
    [self.navigationController pushViewController:allDetailVc animated:YES];
}



- (JGJChatMsgListModel *)getJGJChatmsgListModelFormModel:(JGJQualityDetailReplayListModel *)replayListModel
{
    JGJChatMsgListModel *chatLogListModel = [[JGJChatMsgListModel alloc]init];
    
    chatLogListModel.msg_src = replayListModel.reply_msg_src;
    
    //    chatLogListModel.msg_type = @"notice";
    
    chatLogListModel.msg_id = replayListModel.msg_id;
    
    chatLogListModel.id = replayListModel.id;
    
    
    chatLogListModel.msg_text = replayListModel.msg_text;
    
    chatLogListModel.user_name = replayListModel.user_info.real_name;
    
    chatLogListModel.head_pic = replayListModel.user_info.head_pic;
    
    chatLogListModel.create_time = replayListModel.create_time;
    
    //    chatLogListModel.uid = replayListModel.user_info.uid;
    
    chatLogListModel.chatListType =JGJChatListLog;
    
    chatLogListModel.group_id =self.proListModel.group_id;
    
    chatLogListModel.class_type =self.proListModel.class_type;
    
    chatLogListModel.cat_id = replayListModel.cat_id;
    
    chatLogListModel.from_group_name = self.proListModel.all_pro_name;
    
    chatLogListModel.cat_name = replayListModel.cat_name;
    
    chatLogListModel.week_day = replayListModel.week_day;
    
    chatLogListModel.msg_type = replayListModel.msg_type;
    
    return  chatLogListModel;
}
#pragma mark - 任务
- (void)taskVcWithIndexPath:(NSIndexPath *)indexPath {
    
    JGJQualityDetailReplayListModel *replayListModel = self.dataArray[indexPath.row];
    
    JGJChatMsgListModel *chatListModel = [self getJGJChatmsgListModelFormModel:replayListModel];
    
    //    chatListModel.msg_type = @"task";
    
    JGJTaskViewController *allDetailVc = [JGJTaskViewController new];
    
    chatListModel.from_group_name = self.proListModel.all_pro_name ;
    
    allDetailVc.workProListModel = self.proListModel;
    
    JGJChatMsgListModel *chatLogListModel = [[JGJChatMsgListModel alloc]init];
    
    chatLogListModel = [self getTaskJGJChatmsgListModelFormModel:replayListModel];
    
    allDetailVc.jgjChatListModel = chatLogListModel;
    
    allDetailVc.IsClose = self.proListModel.isClosedTeamVc;
    
    [self.navigationController pushViewController:allDetailVc animated:YES];
    
}

- (void)loadNetData {
    
    NSDictionary *parameters = @{@"group_id" : self.proListModel.group_id?:@"",
                                 
                                 @"class_type" : self.proListModel.class_type?:@"",
                                 
                                 @"msg_type" : self.commonModel.msg_type?:@""};
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/quality/getQualitySafeAllList" parameters:parameters success:^(id responseObject) {
        
        self.dataArray = [JGJQualityDetailReplayListModel mj_objectArrayWithKeyValuesArray:responseObject];
        
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark - 是否显示缺省页面
- (void)showDefaultNoDataArray:(NSArray *)dataArray {
    
    if (dataArray.count == 0) {
        
        CFRefreshStatusView *statusView = [[CFRefreshStatusView alloc] initWithImage:PNGIMAGE(@"NoDataDefault_NoManagePro") withTips:@"暂无记录哦~"];
        
        statusView.frame = self.tableView.bounds;
        
        self.tableView.tableHeaderView = statusView;
    }
    
}

- (void)setDataArray:(NSArray *)dataArray {
    
    _dataArray = dataArray;
    
    [self showDefaultNoDataArray:dataArray];
    
    [self.tableView reloadData];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
    
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = AppFontf1f1f1Color;
    }
    
    return _tableView;
    
}

- (void)initialSubView {
    
    [self.view addSubview:self.tableView];
    
    self.view.backgroundColor = AppFontf1f1f1Color;
    
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.bottom.mas_equalTo(self.view);
        
    }];
    
}


- (JGJChatMsgListModel *)getTaskJGJChatmsgListModelFormModel:(JGJQualityDetailReplayListModel *)replayListModel
{
    JGJChatMsgListModel *chatLogListModel = [[JGJChatMsgListModel alloc]init];
    
    chatLogListModel.msg_src = replayListModel.reply_msg_src;
    
    //    chatLogListModel.msg_type = @"notice";
    
    chatLogListModel.msg_id = replayListModel.reply_id;
    
    chatLogListModel.id = replayListModel.id;
    
    chatLogListModel.msg_text = replayListModel.reply_text;
    
    chatLogListModel.user_name = replayListModel.user_info.real_name;
    
    chatLogListModel.head_pic = replayListModel.user_info.head_pic;
    
    chatLogListModel.create_time = replayListModel.create_time;
    
    //    chatLogListModel.uid = replayListModel.user_info.uid;
    
    chatLogListModel.chatListType =JGJChatListLog;
    
    chatLogListModel.group_id =self.proListModel.group_id;
    
    chatLogListModel.class_type =self.proListModel.class_type;
    
    chatLogListModel.cat_id = replayListModel.cat_id;
    
    chatLogListModel.from_group_name = self.proListModel.all_pro_name;
    
    chatLogListModel.cat_name = replayListModel.cat_name;
    
    chatLogListModel.week_day = replayListModel.week_day;
    
    chatLogListModel.msg_type = replayListModel.msg_type;
    
    return  chatLogListModel;
}

@end

