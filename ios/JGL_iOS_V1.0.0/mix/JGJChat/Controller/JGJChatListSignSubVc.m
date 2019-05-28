//
//  JGJChatListSignSubVc.m
//  JGJCompany
//
//  Created by Tony on 16/9/29.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatListSignSubVc.h"

#import "NSArray+JGJDateSort.h"

@interface JGJChatListSignSubVc (){
    
    NSInteger _pg;
    
}

@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation JGJChatListSignSubVc

@synthesize signRequest = _signRequest;

- (void)dataInit{
    [super dataInit];
    
     NSString *title = [NSString stringWithFormat:@"%@的签到列表",self.real_name];
    
    if ([self.mber_id isEqualToString:[TYUserDefaults objectForKey:JLGUserUid]]) {
        
        title = @"我的签到列表";
    }
    
    self.signRequest.uid = self.mber_id;
    
    JGJHelpCenterTitleView *titleView = [JGJHelpCenterTitleView helpCenterTitleView];
    
    titleView.titleViewType = JGJHelpCenterTitleViewSignType;
    
    titleView.title = title;
    
    titleView.iconHidden = YES;
    
    self.navigationItem.titleView = titleView;
    
    self.signHeaderType = SignHeaderTypeSignSubVc;
    
    self.tableView.mj_footer = nil;
    
     self.tableView.mj_header = [LZChatRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadSignListData)];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)setChatSignModel:(JGJChatSignModel *)chatSignModel{
    [super setChatSignModel:chatSignModel];
    
    //3.4添加去掉头部
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 0.01)];
    
//    self.tableView.tableHeaderView = nil;
}

//不需要父类的方法
- (void)subClassWillAppear{
    [self noDataDefaultView:self.chatSignModel.list.count];
}

- (void)loadSignListData{
    
    self.signRequest.pg = 1;
    
    NSDictionary *parameters = [self.signRequest mj_keyValues];
    
    [JLGHttpRequest_AFN PostWithNapi:[self requestApi] parameters:parameters success:^(id responseObject) {
        
        [self.dataSource removeAllObjects];
        
        JGJChatSignModel *chatSignModel = [JGJChatSignModel new];
        
        NSMutableArray *list = responseObject;
        
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

- (void)loadMoreSignListData{
    
    NSDictionary *parameters = [self.signRequest mj_keyValues];
    
    [JLGHttpRequest_AFN PostWithNapi:[self requestApi] parameters:parameters success:^(id responseObject) {
        
        if (self.dataSource.count > 0) {
            
            JGJChatSignModel *chatSignModel = [JGJChatSignModel new];
            
            NSMutableArray *list = responseObject;
            
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

- (void)sortDataSource:(NSArray *)dataSource {
    
    [self.dataSource addObjectsFromArray:dataSource];
    
    NSArray *sortArr = [ChatSign_List mj_objectArrayWithKeyValuesArray:[self.dataSource  sortDataSource]];
    
    self.chatSignModel.list = sortArr.mutableCopy;
    
    [self.tableView reloadData];
}

- (NSString *)requestApi {
    
    return @"sign/sign-record-list";
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
    
    CGFloat sectionHeaderHeight = 32.0;

    return sectionHeaderHeight;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [UITableViewCell getNilViewCell:tableView indexPath:indexPath];

    if (self.chatSignModel.list.count - 1 < indexPath.section) {
        return cell;
    }
    
    //获取数据源
    ChatSign_List *chatSign_List = (ChatSign_List *)self.chatSignModel.list[indexPath.section];
    
    if (chatSign_List.sign_list.count - 1 < indexPath.row) {
        return cell;
    }
    
    ChatSign_Sign_List *sign_List = (ChatSign_Sign_List *)chatSign_List.sign_list[indexPath.row];
    
    JGJChatSignMemberCell *chatSignMemberCell = [JGJChatSignMemberCell cellWithTableView:tableView];
    chatSignMemberCell.chatSign_Sign_List = sign_List;
    
    [chatSignMemberCell setIsHiddenLineView:chatSign_List.sign_list.count - 1 == indexPath.row];
    
    cell = chatSignMemberCell;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.chatSignModel.list.count - 1 < indexPath.section) {
        return ;
    }
    
    //获取数据源
    ChatSign_List *chatSign_List = (ChatSign_List *)self.chatSignModel.list[indexPath.section];
    
    if (chatSign_List.sign_list.count - 1 < indexPath.row) {
        return ;
    }
    
    ChatSign_Sign_List *sign_sign_List = (ChatSign_Sign_List *)chatSign_List.sign_list[indexPath.row];
    
    JGJChatSignVc *chatSignVc = [[UIStoryboard storyboardWithName:@"JGJChat" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJChatSignVc"];
    
    chatSignVc.signVcType = JGJChatSignVcCheckType;
    
    chatSignVc.sign_id = sign_sign_List.sign_id;
    
    chatSignVc.chatListType = JGJChatListSign;
    
    chatSignVc.workProListModel = self.workProListModel;
    
    if (self.skipToNextVc) {
        
        self.skipToNextVc(chatSignVc);
        
    }else{
        
        [self.navigationController pushViewController:chatSignVc animated:YES];
    }
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

@end
