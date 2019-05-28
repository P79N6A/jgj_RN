//
//  JGJChatOhterListBaseVc.m
//  JGJCompany
//
//  Created by Tony on 2016/11/29.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatOhterListBaseVc.h"
#import "JGJDetailViewController.h"
#import "JGJNotifyCationDetailViewController.h"
#import "JGJLogFilterViewController.h"

#import "CFRefreshStatusView.h"
#import "NSDate+Extend.h"
#import "JGJChatMsgDBManger+JGJIndexDB.h"
@interface JGJChatOhterListBaseVc ()
{
    UILabel *totalLabel;
    UILabel *titleLabel;
    NSInteger _page;
    CFRefreshStatusView *_statusView;
    
    NSString *_beforeTimeStr;
}
@property (nonatomic, strong) NSMutableArray *timesHeaderShowArr;
@end
@implementation JGJChatOhterListBaseVc
- (void)dataInit{
    [super dataInit];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"JGJChatOtherListell" bundle:nil] forCellReuseIdentifier:@"JGJChatOtherListell"];

    self.tableView.backgroundColor = AppFontf1f1f1Color;
    
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(chatListLoadData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(chatListLoadUpData)];
    
    JGJHelpCenterTitleView *titleView = [JGJHelpCenterTitleView helpCenterTitleView];

    if ([self.chatListRequestModel.msg_type isEqualToString:@"log"]) {
        
        titleView.proListModel = self.workProListModel;
        
        // 是否为班组日志
        if ([self.workProListModel.class_type isEqualToString:@"group"]) {
            
            titleView.titleViewType = JGJHelpCenterTitleViewGroupLogType; //班组日志类型
        }else {
            
            titleView.titleViewType = JGJHelpCenterTitleViewLogType; //项目日志类型
        }
        
        titleView.title = @"工作日志";
    }else{
        
        titleView.proListModel = self.workProListModel;
        
        titleView.titleViewType = JGJHelpCenterTitleViewNotifyType; //添加类型
        
        titleView.title = @"通知";
        
    }
    self.navigationItem.titleView = titleView;
}


- (void)viewWillAppear:(BOOL)animated {
    
    if ([self.chatListRequestModel.msg_type isEqualToString:@"log"]) {
        
        self.tableView.transform = CGAffineTransformMakeTranslation(0, 45);
        self.navigationItem.rightBarButtonItem = nil;
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"filtrateImage"] style:UIBarButtonItemStylePlain target:self action:@selector(clickFilterView)];
        self.navigationItem.rightBarButtonItem = barButton;
        
        JGJIndexDataModel *indexModel = [JGJChatMsgDBManger getTheIndexModelInIndexTable];
        indexModel.unread_log_count = @"0";
        [JGJChatMsgDBManger updateIndexModelToIndexTable:indexModel];
    }else if ([self.chatListRequestModel.msg_type isEqualToString:@"notice"])
    {
        
        
        [self.tableView.mj_header beginRefreshing];
        
    }
    
    [super viewWillAppear:animated];
    if (!self.dataSourceArray.count) {
//        [self chatListLoadData];
    }

  
//2.1.2-yj点击分类清楚未读信息标记
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatListVcRefresh:)]) {
        [self.delegate chatListVcRefresh:self];
    }
    
    
}


- (void)filterLogWithParamDic:(NSDictionary *)paramDic andtype:(logClickType)type isFielterIn:(BOOL)isFielterIn {
    
    if (self.workProListModel.workCircleProType == WorkCircleExampleProType) {
        
        self.tableView.mj_header = nil;
        
    }else{
        
        JGJLogListModel *chatOhterMsgListModel;
        chatOhterMsgListModel = [self.dataSourceArray lastObject];
        
        self.parameters = [[NSMutableDictionary alloc]initWithDictionary:paramDic];
        
        [self.parameters setValue:self.workProListModel.class_type?:@"" forKey:@"class_type"];
        [self.parameters setValue:self.workProListModel.team_id?:@"" forKey:@"group_id"];
        [self.parameters setValue:@"" forKey:@"pg"];
        [self.parameters setValue:@"" forKey:@"pagesize"];
        if (_logQuestType == meLogTYpe && [self.parameters.allKeys containsObject:@"uid"]) {
            if ([NSString isEmpty: self.parameters[@"uid"] ]) {
                [self.parameters setValue:[TYUserDefaults objectForKey:JLGUserUid]?:@"" forKey:@"uid"];
            }
        }
        [TYLoadingHub showLoadingNoDataDefultWithMessage:nil];
        
        [JLGHttpRequest_AFN PostWithApi:@"pc/log/logList" parameters:self.parameters success:^(id responseObject) {
            
            [TYLoadingHub hideLoadingView];
            if (![(NSArray *)responseObject count]) {
                self.dataSourceArray  = [NSMutableArray array];
                return ;
            }
            _LogTotalModel = [JGJLogTotalListModel mj_objectWithKeyValues:responseObject];
            
            _datasource = [[NSMutableArray alloc]initWithArray:responseObject[@"list"]];
            NSMutableArray *dataSourceArr  = [JGJLogListModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
            self.dataSourceArray = dataSourceArr.mutableCopy;
            [self noDataDefaultView];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            if (isFielterIn) {
                
                [self addHeaderView];
            }
            
            [self setFilterNumtext];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(chatListVcRefresh:)]) {
                [self.delegate chatListVcRefresh:self];
            }

        }failure:^(NSError *error) {
            
            [self.tableView.mj_header endRefreshing];
            [TYLoadingHub hideLoadingView];
            
        }];
    }
}

- (void)filterLogWithParamDic:(NSDictionary *)paramDic andtype:(logClickType)type andBlock:(filterBlock)blockArr {

    if (self.workProListModel.workCircleProType == WorkCircleExampleProType) {
        
        self.tableView.mj_header = nil;
        
    }else{

        JGJLogListModel *chatOhterMsgListModel;
        chatOhterMsgListModel = [self.dataSourceArray lastObject];
        
        self.parameters = [[NSMutableDictionary alloc]initWithDictionary:paramDic];
        
        [self.parameters setValue:self.workProListModel.class_type?:@"" forKey:@"class_type"];
        [self.parameters setValue:self.workProListModel.team_id?:@"" forKey:@"group_id"];
        [self.parameters setValue:@"" forKey:@"pg"];
        [self.parameters setValue:@"" forKey:@"pagesize"];
        if (_logQuestType == meLogTYpe && [self.parameters.allKeys containsObject:@"uid"]) {
            if ([NSString isEmpty: self.parameters[@"uid"] ]) {
                [self.parameters setValue:[TYUserDefaults objectForKey:JLGUserUid]?:@"" forKey:@"uid"];
            }
        }
        [TYLoadingHub showLoadingNoDataDefultWithMessage:nil];

        [JLGHttpRequest_AFN PostWithApi:@"pc/log/logList" parameters:self.parameters success:^(id responseObject) {
            
            [TYLoadingHub hideLoadingView];
            if (![(NSArray *)responseObject count]) {
                self.dataSourceArray  = [NSMutableArray array];
                return ;
            }
            _LogTotalModel = [JGJLogTotalListModel mj_objectWithKeyValues:responseObject];
            
            _datasource = [[NSMutableArray alloc]initWithArray:responseObject[@"list"]];
            NSMutableArray *dataSourceArr  = [JGJLogListModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
            self.dataSourceArray = dataSourceArr.mutableCopy;
            [self noDataDefaultView];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self addRepeatepeatView];
            [self setFilterNumtext];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(chatListVcRefresh:)]) {
                [self.delegate chatListVcRefresh:self];
            }
            
        }failure:^(NSError *error) {
            
            [self.tableView.mj_header endRefreshing];
            [TYLoadingHub hideLoadingView];

        }];
    }
        
}

- (void)setFilterNumtext {
    
    int index = 0;
    for (int i = 0; i < self.dataSourceArray.count; i ++) {
        
        index = index + [[self.dataSourceArray[i] day_num] intValue];
    }
    
    self.repeatView.numlable.text = [NSString stringWithFormat:@"共筛选出 %@ 条记录",_LogTotalModel.allnum?:@"0"];
    [self.repeatView.numlable markText:_LogTotalModel.allnum?:@"0" withColor:AppFontd7252cColor];
}
- (void)chatListLoadData{
    
    _page = 1;
    if (self.workProListModel.workCircleProType == WorkCircleExampleProType) {
        
        self.tableView.mj_header = nil;
        
    }else{
        
        if ([self.chatListRequestModel.msg_type isEqualToString:@"log"]) {
            
            JGJLogListModel *chatOhterMsgListModel;
            chatOhterMsgListModel = [self.dataSourceArray lastObject];

            [self addHeaderView];
            if (self.headerView.meButton.selected) {
                
                self.parameters = @{@"uid":[TYUserDefaults objectForKey:JLGUserUid],//提交人Uid
                                    @"cat_id":@"",
                                    @"send_stime":@"",
                                    @"send_etime":@"",
                                    @"group_id":self.workProListModel.team_id?:@"",
                                    @"s_date":@"",
                                    @"class_type":self.workProListModel.class_type,
                                    }.mutableCopy;
            }else {
                
                self.parameters = @{@"uid":@"",//提交人Uid
                                    @"cat_id":@"",
                                    @"send_stime":@"",
                                    @"send_etime":@"",
                                    @"group_id":self.workProListModel.team_id?:@"",
                                    @"s_date":@"",
                                    @"class_type":self.workProListModel.class_type,
                                    }.mutableCopy;
            }

            [JLGHttpRequest_AFN PostWithApi:@"pc/log/logList" parameters:self.parameters success:^(id responseObject) {
                
                _datasource = [[NSMutableArray alloc]initWithArray:responseObject[@"list"]];
                self.headerView.filtrateButton.hidden = NO;
                self.headerView.allButton.hidden = NO;
                self.headerView.meButton.hidden = NO;
                self.headerView.backgroundColor = [UIColor whiteColor];
                self.headerView.departLable.hidden = NO;
                self.headerView.SecondDepartLable.hidden = NO;
                [self.headerView setMeLOgNumWithStr:responseObject[@"my_num"]?:@"0"];

                NSMutableArray *dataSourceArr  = [JGJLogListModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
                self.dataSourceArray = dataSourceArr.mutableCopy;
                _LogTotalModel = [JGJLogTotalListModel mj_objectWithKeyValues:responseObject];
                
                //新消息标记
                self.is_new_message = [NSString stringWithFormat:@"%@", responseObject[@"is_new_message"]].boolValue;
                
                [self noDataDefaultView];
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(chatListVcRefresh:)]) {
                   
                    [self.delegate chatListVcRefresh:self];
                }
                
            }failure:^(NSError *error) {

                [self.tableView.mj_header endRefreshing];
                
            }];
            
        }else{
            
            self.parameters = @{
                                @"group_id":self.workProListModel.team_id?:[NSNull null],
                                @"class_type":self.workProListModel.class_type,
                                @"pg":@(_page),
                                @"pagesize":@(20)
                                }.mutableCopy;

            [JLGHttpRequest_AFN PostWithNapi:@"notice/notice-list" parameters:self.parameters success:^(id responseObject) {
                
                TYLog(@"通知列表responseObject = %@",responseObject);
                [self.dataSourceArray removeAllObjects];
                [self.dataSourceArray addObjectsFromArray:[JGJChatMsgListModel mj_objectArrayWithKeyValuesArray:responseObject]];
                
                [self showDefaultNodataArray:self.dataSourceArray];
                
                [self delTimesHeaderLabelShowOrHidden];
                [self.tableView.mj_header endRefreshing];
                
            } failure:^(NSError *error) {
                
                [self.tableView.mj_header endRefreshing];
                [TYLoadingHub hideLoadingView];
            }];
        }
    }
}




#pragma mark - 是否显示缺省页面
- (void)showDefaultNodataArray:(NSArray *)dataArray {
    
    if (dataArray.count == 0) {
        
        if (!_statusView) {
            
            _statusView = [[CFRefreshStatusView alloc] initWithImage:PNGIMAGE(@"NoDataDefault_NoManagePro") withTips:@"暂无记录哦~"];
        }
        
        _statusView.frame = self.tableView.bounds;
        
        self.tableView.tableHeaderView = _statusView;
        
        _statusView.hidden = NO;
        
    }else {
        
        if (_statusView) {
            
            self.tableView.tableHeaderView.frame = CGRectZero;
            
            _statusView.hidden = YES;
        }

    }
    
}

- (void)getLogListLoadData {
    
    if (self.workProListModel.workCircleProType == WorkCircleExampleProType) {
        
        self.tableView.mj_header = nil;
        
    }else{
        
        JGJLogListModel *chatOhterMsgListModel;
        chatOhterMsgListModel = [self.dataSourceArray lastObject];
        [self addHeaderView];
        [TYLoadingHub showLoadingNoDataDefultWithMessage:nil];

        [JLGHttpRequest_AFN PostWithApi:@"pc/log/logList" parameters:self.parameters success:^(id responseObject) {
            _datasource = [[NSMutableArray alloc]initWithArray:responseObject[@"list"]];
            _LogTotalModel = [JGJLogTotalListModel mj_objectWithKeyValues:responseObject];
            
            NSMutableArray *dataSourceArr  = [JGJLogListModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
            self.dataSourceArray = dataSourceArr.mutableCopy;
            
            [self noDataDefaultView];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(chatListVcRefresh:)]) {
                [self.delegate chatListVcRefresh:self];
            }
            [TYLoadingHub hideLoadingView];

        }failure:^(NSError *error) {
            
            [self.tableView.mj_header endRefreshing];
            [TYLoadingHub hideLoadingView];

        }];
        
        
    }
}

- (void)chatListLoadUpData{
    
    _page ++;
    if (self.workProListModel.workCircleProType == WorkCircleExampleProType) {
        
        [self.tableView.mj_header endRefreshing];
        return;
    }
    if (!self.parameters) {
        
        self.parameters = @{
                            @"uid":@"",//提交人Uid
                            @"cat_id":@"",
                            @"send_stime":@"",
                            @"send_etime":@"",
                            @"group_id":self.workProListModel.team_id?:@"",
                            @"s_date":_LogTotalModel.s_date?:@"",
                            @"class_type":self.workProListModel.class_type,
                            }.mutableCopy;
    }else{
        
        [self.parameters setValue:_LogTotalModel.s_date?:@"" forKey: @"s_date"];
    }
    if ([self.chatListRequestModel.msg_type isEqualToString:@"log"]) {
        [JLGHttpRequest_AFN PostWithApi:@"pc/log/logList" parameters:self.parameters success:^(id responseObject) {
            _datasource = [[NSMutableArray alloc]initWithArray:responseObject[@"list"]];
            _LogTotalModel = [JGJLogTotalListModel mj_objectWithKeyValues:responseObject];
            NSMutableArray *dataSourceArr  = [JGJLogListModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
            
            if (dataSourceArr.count) {
                
                self.dataSourceArray = [self.dataSourceArray arrayByAddingObjectsFromArray:dataSourceArr].mutableCopy;
                [self.tableView reloadData];
            }
            
            [self.tableView.mj_footer endRefreshing];
            if (_repeatView ) {
                [self setFilterNumtext];
            }
        }failure:^(NSError *error) {
            self.tableView.mj_footer = nil;
            
        }];
    }else{
        JGJChatOtherMsgListModel *chatOhterMsgListModel;
        if (self.dataSourceArray.count>0) {
            chatOhterMsgListModel = [self.dataSourceArray lastObject];
        }
        
        self.parameters = @{
                            @"group_id":self.workProListModel.team_id?:[NSNull null],
                            @"class_type":self.workProListModel.class_type,
                            @"pg":@(_page),
                            @"pagesize":@(20)
                            }.mutableCopy;
        
        [JLGHttpRequest_AFN PostWithNapi:@"notice/notice-list" parameters:self.parameters success:^(id responseObject) {
            
            TYLog(@"通知列表responseObject = %@",responseObject);
            [self.dataSourceArray addObjectsFromArray:[JGJChatMsgListModel mj_objectArrayWithKeyValuesArray:responseObject]];
            [self delTimesHeaderLabelShowOrHidden];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        } failure:^(NSError *error) {
            
            [self.tableView.mj_header endRefreshing];
            [TYLoadingHub hideLoadingView];
        }];
    }

}

- (void)delTimesHeaderLabelShowOrHidden {
    
    [self.timesHeaderShowArr removeAllObjects];
    for (int i = 0; i < self.dataSourceArray.count; i ++) {
        
        JGJChatMsgListModel *model = self.dataSourceArray[i];
        if (i == 0) {
            
            _beforeTimeStr = model.send_date;
            [self.timesHeaderShowArr addObject:@"显示"];
            
        }else {
            
            NSString *thisTimeStr = model.send_date;
            
            if ([_beforeTimeStr isEqualToString:thisTimeStr]) {
                
                [self.timesHeaderShowArr addObject:@"隐藏"];
                
            }else {
                
                [self.timesHeaderShowArr addObject:@"显示"];
            }
            _beforeTimeStr = thisTimeStr;
            
        }
    }
    
    [self.tableView reloadData];
}

- (void)setChatListRequestModel:(JGJChatRootRequestModel *)chatListRequestModel{
    [super setChatListRequestModel:chatListRequestModel];
    [self chatListLoadData];
}

- (void)setCur_name:(NSString *)cur_name {
    
    _cur_name = cur_name;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataSourceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.chatListRequestModel.msg_type isEqualToString:@"log"]) {
        
        JGJLogListModel *chatOhterListModel = (JGJLogListModel *)self.dataSourceArray[section];
        
        return chatOhterListModel.list.count;
    }
    
//    JGJChatOtherMsgListModel *chatOhterListModel = (JGJChatOtherMsgListModel *)self.dataSourceArray[section];
//
//    return chatOhterListModel.list.count;

    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if ([self.chatListRequestModel.msg_type isEqualToString:@"log"]) {
        
        return 30.0;
    }else {
        
        if ([self.timesHeaderShowArr[section] isEqualToString:@"显示"]) {
            
            return 30.0;
        }else {
            
            return 0.0;
        }
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.chatListRequestModel.msg_type isEqualToString:@"log"]) {
        JGJLogListModel *chatOhterListModel = (JGJLogListModel *)self.dataSourceArray[indexPath.section];
        JGJLogSectionListModel *chatListModel = chatOhterListModel.list[indexPath.row];
        CGFloat thumbnailImageViewWH = (TYGetUIScreenWidth - 30) / 4.0;
        CGFloat height = [NSString stringWithContentWidth:(TYGetUIScreenWidth - 64) content:chatListModel.show_list_content?:@"" font:AppFont30Size];
        if (height > 25) {
            
            height = 42;
        }
//        CGFloat cellHeight = 114 + thumbnailImageViewWH + height;

        CGFloat cellHeight = 98 + thumbnailImageViewWH + height;
        
        if (chatListModel.imgs.count > 0 && [NSString isEmpty:chatListModel.show_list_content]) {
//            cellHeight -= 35;

            
            cellHeight -= 20;
            
        }else if (chatListModel.imgs.count == 0 && ![NSString isEmpty:chatListModel.show_list_content]) {
            
            cellHeight -= thumbnailImageViewWH ; //微调
            
        }
        
#pragma mark - 后期添加 解决图片变形
        if (chatOhterListModel.list.count - 1 == indexPath.row) {
            
            return cellHeight - 15;
            
        }
        
        return cellHeight;
        
    }else{
        

//    JGJChatOtherMsgListModel *chatOhterListModel = (JGJChatOtherMsgListModel *)self.dataSourceArray[indexPath.section];
//    JGJChatMsgListModel *chatListModel = chatOhterListModel.list[indexPath.row];
    
   
        JGJChatMsgListModel *chatListModel = self.dataSourceArray[indexPath.section];
        CGFloat thumbnailImageViewWH = (TYGetUIScreenWidth - 30) / 4.0;
    
        //仅有文字
        CGFloat height = [NSString stringWithContentWidth:(TYGetUIScreenWidth - 64) content:chatListModel.msg_text font:AppFont30Size];
        if (height > 25) {
            
            height = 42;
        }
        
        CGFloat cellHeight = 98 + thumbnailImageViewWH + height;
        
        if (chatListModel.msg_src.count > 0 && [NSString isEmpty:chatListModel.msg_text]) {
            
    //        cellHeight -= 35;

            
            cellHeight -= 20;//之前是35
            
        }else if (chatListModel.msg_src.count == 0 && ![NSString isEmpty:chatListModel.msg_text]) {
            
            cellHeight -= thumbnailImageViewWH ; //微调
            
        }
        return cellHeight;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *noDataView = [[UIView alloc] initWithFrame:TYSetRect(0, 0, TYGetUIScreenWidth, 7.0)];
    noDataView.backgroundColor = self.tableView.backgroundColor;
    
    if (self.dataSourceArray.count == 0) {
        return noDataView;
    }
    
    
    static NSString *kChatListSignVcHeaderID  = @"JGJChatOhterListBaseVc";
    
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kChatListSignVcHeaderID];
    
    if(!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:kChatListSignVcHeaderID];
        headerView.frame = TYSetRect(0, 0, TYGetUIScreenWidth, 30.0);
        headerView.contentView.backgroundColor = self.tableView.backgroundColor;
        
        CGRect labelFrame = headerView.frame;
        labelFrame.origin.x = 10;
        labelFrame.size.width -= labelFrame.origin.x;
        
        titleLabel = [[UILabel alloc] initWithFrame:labelFrame];
        titleLabel.font = [UIFont systemFontOfSize:15.0];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = TYColorHex(0x666666);
        titleLabel.tag = 102;
        titleLabel.backgroundColor = headerView.contentView.backgroundColor;
        [headerView addSubview:titleLabel];
        
        
        totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(TYGetUIScreenWidth - 130, 0, 120, 30)];
        totalLabel.tag = 101;
        totalLabel.font = [UIFont systemFontOfSize:15.0];
        totalLabel.textAlignment = NSTextAlignmentRight;
        totalLabel.textColor = TYColorHex(0x666666);
        totalLabel.backgroundColor = headerView.contentView.backgroundColor;
        [headerView addSubview:totalLabel];
        
        
        if (![self.chatListRequestModel.msg_type isEqualToString:@"log"]) {
            
            if ([self.timesHeaderShowArr[section] isEqualToString:@"显示"]) {
                
                titleLabel.hidden = NO;
                totalLabel.hidden = NO;
            }else {
                
                titleLabel.hidden = YES;
                totalLabel.hidden = YES;
            }
        }
        
    }
    
    if ([self.chatListRequestModel.msg_type isEqualToString:@"log"]) {
        
        JGJLogListModel *chatOtherMsgListModel = self.dataSourceArray[section];
        
        for (UIView *obj  in headerView.subviews) {
            
            if (obj.tag == 101) {
                
                totalLabel = (UILabel *)obj;
                totalLabel.text = [NSString stringWithFormat:@"共%@篇",chatOtherMsgListModel.day_num];
                totalLabel.text = [NSString stringWithFormat:@"共%@篇",chatOtherMsgListModel.day_num];

            }else if (obj.tag == 102)
            {
                titleLabel = (UILabel *)obj;
                titleLabel.text = chatOtherMsgListModel.log_date;
            }
        }
    }else{
        
        JGJChatOtherMsgListModel *chatOtherMsgListModel = self.dataSourceArray[section];
        JGJChatMsgListModel *chatListModel = self.dataSourceArray[section];
        [headerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj isKindOfClass:[UILabel class]]) {
                
                titleLabel = obj;
                
                NSDate *date = [NSDate dateFromString:chatListModel.send_date withDateFormat:@"yyyyMMdd"];
                if (date.isToday) {
                    
                    titleLabel.text = [NSString stringWithFormat:@"今天 %@",chatListModel.send_date_str];
                    
                }else if (date.isYesToday) {
                    
                    titleLabel.text = [NSString stringWithFormat:@"昨天 %@",chatListModel.send_date_str];
                    
                }else {
                    
                    titleLabel.text = chatListModel.send_date_str;
                }
                
                *stop = YES;
            }
        }];
    }
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if (self.dataSourceArray.count == 0) {//没有数据
        cell = [UITableViewCell getNilViewCell:tableView indexPath:indexPath];
    }else{//有数据
        if ([self.chatListRequestModel.msg_type isEqualToString:@"log"]) {
            
            JGJLogListModel *chatOhterListModel = (JGJLogListModel *)self.dataSourceArray[indexPath.section];
            
            JGJLogSectionListModel *chatListModel = chatOhterListModel.list[indexPath.row];
            
            JGJChatOtherListell *chatListBaseCell = [JGJChatOtherListell cellWithTableView:tableView];
            chatListBaseCell.contentDetailView.layer.masksToBounds = YES;
            chatListBaseCell.contentDetailView.layer.cornerRadius = 5;
            chatListBaseCell.indexPath = indexPath;
            chatListBaseCell.logModel = chatListModel;
            chatListBaseCell.selectionStyle = UITableViewCellSelectionStyleNone;
#pragma mark - 修改UI
            if (indexPath.row == chatOhterListModel.list.count - 1) {
                chatListBaseCell.bottomConstance.constant = 0;
            }else{
                chatListBaseCell.bottomConstance.constant = 15;

            
            }
       
            if (!chatListBaseCell.delegate) {
                chatListBaseCell.delegate = self;
            }
            
            if (!chatListBaseCell.topTitleView.delegate) {
                chatListBaseCell.topTitleView.delegate = self;
            }
            
            
            cell = chatListBaseCell;
            
        }else{
        
//            JGJChatOtherMsgListModel *chatOhterListModel = (JGJChatOtherMsgListModel *)self.dataSourceArray[indexPath.section];

//            JGJChatMsgListModel *chatListModel = chatOhterListModel.list[indexPath.row];
            
            JGJChatMsgListModel *chatListModel = self.dataSourceArray[indexPath.section];
            JGJChatOtherListell *chatListBaseCell = [JGJChatOtherListell cellWithTableView:tableView];
            chatListBaseCell.tag = indexPath.row;
            chatListBaseCell.indexPath = indexPath;
            chatListBaseCell.jgjChatListModel = chatListModel;
            chatListBaseCell.contentDetailView.layer.masksToBounds = YES;
            chatListBaseCell.contentDetailView.layer.cornerRadius = 5;
            chatListBaseCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            //设置delegate
            if (!chatListBaseCell.delegate) {
                chatListBaseCell.delegate = self;
            }
            
            if (!chatListBaseCell.topTitleView.delegate) {
                chatListBaseCell.topTitleView.delegate = self;
            }
            
            cell = chatListBaseCell;
    
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

#if 0
    JGJChatListAllDetailVc *allDetailVc = [JGJChatListAllDetailVc new];
    allDetailVc.jgjChatListModel = chatListModel;
    allDetailVc.jgjChatListModel.pro_name = self.workProListModel.pro_name;
    allDetailVc.jgjChatListModel.group_name = self.workProListModel.group_name;

    self.skipToNextVc(allDetailVc);
#else
    if ([self.chatListRequestModel.msg_type  isEqualToString:@"log"]) {
        
        JGJDetailViewController *allDetailVc = [JGJDetailViewController new];
        JGJLogListModel *chatOhterListModel = (JGJLogListModel *)self.dataSourceArray[indexPath.section];
        
        JGJLogSectionListModel *chatListModel = chatOhterListModel.list[indexPath.row];
        
        JGJChatMsgListModel *chatLogListModel = [[JGJChatMsgListModel alloc]init];
        chatLogListModel.msg_src = chatListModel.imgs;
        chatLogListModel.msg_type = @"log";
        chatLogListModel.msg_id = chatListModel.id;
        chatLogListModel.msg_text = chatListModel.show_list_content;
        chatLogListModel.user_name = chatListModel.user_info.real_name;
        chatLogListModel.head_pic = chatListModel.user_info.head_pic;
        chatLogListModel.create_time = chatListModel.create_time;
        chatLogListModel.uid = chatListModel.user_info.uid;
        chatLogListModel.chatListType =JGJChatListLog;
        chatLogListModel.group_id =self.workProListModel.group_id;
        chatLogListModel.class_type =self.workProListModel.class_type;
        chatLogListModel.cat_id = chatListModel.cat_id;
        chatLogListModel.from_group_name = self.workProListModel.all_pro_name;
        chatLogListModel.cat_name = chatListModel.cat_name;
        chatLogListModel.week_day = chatListModel.week_day;
        
        allDetailVc.IsClose    = self.workProListModel.isClosedTeamVc;
        
        allDetailVc.workProListModel  = self.workProListModel;
        
        allDetailVc.jgjChatListModel = chatLogListModel;
        
        self.skipToNextVc(allDetailVc);
    }else{
        

        JGJChatMsgListModel *chatListModel = self.dataSourceArray[indexPath.section];
        chatListModel.msg_type = self.msgType;
    
        JGJDetailViewController *allDetailVc = [JGJDetailViewController new];
    
        chatListModel.from_group_name = self.workProListModel.all_pro_name;
        allDetailVc.workProListModel = self.workProListModel;
        allDetailVc.jgjChatListModel = chatListModel;
        allDetailVc.IsClose = self.workProListModel.isClosedTeamVc;
        self.skipToNextVc(allDetailVc);
    }
#endif
}

- (void)tapImageGoWithtag:(NSIndexPath *)indexpath {
    
    JGJChatMsgListModel *chatListModel = [[JGJChatMsgListModel alloc] init];;
    if ([self.chatListRequestModel.msg_type  isEqualToString:@"log"]) {
        
        JGJChatOtherMsgListModel *chatOhterListModel = (JGJChatOtherMsgListModel *)self.dataSourceArray[indexpath.section];
        chatListModel = chatOhterListModel.list[indexpath.row];
    }else {
        
        
//        JGJChatOtherMsgListModel *chatOhterListModel = (JGJChatOtherMsgListModel *)self.dataSourceArray[indexpath.section];
        chatListModel = self.dataSourceArray[indexpath.section];
    }
    
    chatListModel.msg_type = self.msgType;
    JGJDetailViewController *allDetailVc = [JGJDetailViewController new];
    allDetailVc.workProListModel = self.workProListModel;
    chatListModel.from_group_name = self.workProListModel.group_name;
    allDetailVc.jgjChatListModel = chatListModel;
    allDetailVc.IsClose = self.workProListModel.isClosedTeamVc;
    self.skipToNextVc(allDetailVc);
}

- (void)setFilterModel:(JGJFilterLogModel *)filterModel {
    
    _filterModel = filterModel;
}

- (JGJRepeatInitView *)repeatView {
    
    if (!_repeatView) {
        _repeatView = [[JGJRepeatInitView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 45)];
        _repeatView.backgroundColor = [UIColor whiteColor];
        _repeatView.delegate = self;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickFilterView)];
        _repeatView.userInteractionEnabled = YES;
        [_repeatView addGestureRecognizer:tap];
    }
    return _repeatView;
}

- (void)clickFilterView
{
//    if (_repeatView) {
//        [_repeatView removeFromSuperview];
//        _repeatView = nil;
//    }
    JGJLogFilterViewController *pushVC = [[UIStoryboard storyboardWithName:@"JGJLogFilterViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJLogFilterVC"];

    if (_logQuestType == meLogTYpe) {
        
        pushVC.isMeLogType = YES;
    }else {
        
        pushVC.isMeLogType = NO;
    }
    pushVC.cur_name = self.cur_name;
    pushVC.WorkCircleProListModel = self.workProListModel;
    pushVC.orignalFilterModel = self.filterModel;
    [self.navigationController pushViewController:pushVC animated:YES];
    
}
-(JGJLogHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[JGJLogHeaderView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 45)];
        _headerView.backgroundColor = AppFontffffffColor;
        _headerView.delegate = self;
    }
    return _headerView;
}
-(void)clickRepeatButton
{
    [self addHeaderView];
    self.parameters = nil;
    self.filterModel = [JGJFilterLogModel new];
    [self chatListLoadData];
}
-(void)clickLogTopButtonWithType:(logClickType)type
{
    _logQuestType = type;
    if (type == otherType) {
        JGJLogFilterViewController *pushVC = [[UIStoryboard storyboardWithName:@"JGJLogFilterViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJLogFilterVC"];
        pushVC.WorkCircleProListModel = self.workProListModel;
        [self.navigationController pushViewController:pushVC animated:YES];
        self.headerView.filtrateButton.selected = NO;
        self.headerView.allButton.selected = YES;
        self.headerView.meButton.selected = NO;
        
    }else if(type == meLogTYpe){
        //        self.tableView.tableHeaderView = self.headerView;
        
        [self addHeaderView];
        self.parameters = @{@"uid":[TYUserDefaults objectForKey:JLGUserUid]?:@"" ,//提交人Uid
                            @"cat_id":@"",
                            @"send_stime":@"",
                            @"send_etime":@"",
                            @"group_id":self.workProListModel.team_id?:@"",
                            @"s_date":@"",
                            @"class_type":self.workProListModel.class_type,
                            }.mutableCopy;
        self.headerView.filtrateButton.selected = NO;
        self.headerView.allButton.selected = NO;
        self.headerView.meButton.selected = YES;
        [self getLogListLoadData];
        
    }else if (type == allLogtype){
        //        self.tableView.tableHeaderView = self.headerView;
        [self addHeaderView];
        
        self.headerView.filtrateButton.selected = NO;
        self.headerView.allButton.selected = YES;
        self.headerView.meButton.selected = NO;
        self.parameters = @{@"uid":@"",//提交人Uid
                            @"cat_id":@"",
                            @"send_stime":@"",
                            @"send_etime":@"",
                            @"group_id":self.workProListModel.team_id?:@"",
                            @"s_date":@"",
                            @"class_type":self.workProListModel.class_type,
                            }.mutableCopy;
        [self getLogListLoadData];
        
        
    }
}
-(void)addRepeatepeatView
{
    if (_headerView) {
        [_headerView removeFromSuperview];
    }
    
    [self.view addSubview:self.repeatView];
}
-(void)addHeaderView
{
    if (_repeatView) {
        [_repeatView removeFromSuperview];
    }
    
    [self.view addSubview:self.headerView];
    
}

#pragma mark - 刷新小铃铛 子类使用
- (void)freshMessage {
    
    
}
#pragma mark -默认页查看帮助

-(void)JGJChatNoDataDefaultViewClickHelpBtn
{
    JGJHelpCenterTitleView *titleView = [JGJHelpCenterTitleView new];
    
    if ([self.workProListModel.class_type isEqualToString:@"group"]) {
        
        titleView.titleViewType = JGJHelpCenterTitleViewGroupLogType; //班组日志类型
    }else {
        
        titleView.titleViewType = JGJHelpCenterTitleViewLogType; //项目日志类型
    }
    
    titleView.proListModel = self.workProListModel;
    
    [titleView helpCenterActionWithTitleViewType:JGJHelpCenterTitleViewLogType target:self];
    
}

- (NSMutableArray *)timesHeaderShowArr {
    
    if (!_timesHeaderShowArr) {
        
        _timesHeaderShowArr = [[NSMutableArray alloc] init];
    }
    return _timesHeaderShowArr;
}
@end
