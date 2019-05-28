//
//  JGJLogListViewController.m
//  JGJCompany
//
//  Created by Tony on 2017/7/21.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJLogListViewController.h"
#import "JGJChatOtherListell.h"
#import "UIScrollView+MJRefresh.h"
#import "MJRefresh.h"
@interface JGJLogListViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
JGJChatListBaseCellDelegate,
TopTimeViewDelegate
>

@end


@implementation JGJLogListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableview.delegate = self;
    _tableview.dataSource = self;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
//    if (self.dataSourceArray.count == 0) {//没有数据
//        cell = [UITableViewCell getNilViewCell:tableView indexPath:indexPath];
//    }else{//有数据
//        JGJChatOtherMsgListModel *chatOhterListModel = (JGJChatOtherMsgListModel *)self.dataSourceArray[indexPath.section];
//        
//        JGJChatMsgListModel *chatListModel = chatOhterListModel.list[indexPath.row];
//        
        JGJChatOtherListell *chatListBaseCell = [JGJChatOtherListell cellWithTableView:tableView];
        
        chatListBaseCell.indexPath = indexPath;
//        chatListBaseCell.jgjChatListModel = chatListModel;
    
        chatListBaseCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //设置delegate
        if (!chatListBaseCell.delegate) {
            chatListBaseCell.delegate = self;
        }
        
        if (!chatListBaseCell.topTitleView.delegate) {
            chatListBaseCell.topTitleView.delegate = self;
        }
        cell = chatListBaseCell;
        return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35.0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(void)getLogListData
{
    if (self.workProListModel.workCircleProType == WorkCircleExampleProType) {
        self.tableview.mj_header = nil;
    }else{
        
        
        
        
        self.parameters = @{@"ctrl":@"message",
                            @"action":@"getOtherMessageList",
                            @"group_id":self.workProListModel.team_id?:[NSNull null],
                            @"s_date":@"",
                            @"class_type":self.workProListModel.class_type,
                            @"msg_type":@"log"
                            }.mutableCopy;
        
        [JGJSocketRequest WebSocketWithParameters:self.parameters success:^(id responseObject) {
  
            _datasource = [[NSMutableArray alloc]initWithArray:responseObject[@"msg_list"]];
            NSMutableArray *dataSourceArr = dataSourceArr = [JGJChatOtherMsgListModel mj_objectArrayWithKeyValuesArray:responseObject[@"msg_list"]];
//            self.dataSourceArray = dataSourceArr.mutableCopy;
//            [self noDataDefaultView];
            [self.tableview reloadData];
            [self.tableview.mj_header endRefreshing];
            
//            if (self.delegate && [self.delegate respondsToSelector:@selector(chatListVcRefresh:)]) {
//                [self.delegate chatListVcRefresh:self];
//            }
        } failure:^(NSError *error,id values) {
        [self.tableview.mj_header endRefreshing];
        }];
    }



}
@end
