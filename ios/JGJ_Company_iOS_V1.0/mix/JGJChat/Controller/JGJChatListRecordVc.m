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
#import "JGJChatListRecordModel.h"
#import "JGJChatNoDataDefaultView.h"
static const CGFloat kJGJChatListRecordHeaderH = 31.0;

static const CGFloat kJGJChatListRecordHeaderCellH = 58.0;
static const CGFloat kJGJChatListRecordCellH = 36.0;
static const CGFloat kJGJChatListRecordFotterCellH = 25.0;

@interface JGJChatListRecordVc ()
<
    UITableViewDelegate,
    UITableViewDataSource
>
@property (nonatomic,strong) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSMutableArray <JGJChatListRecordModel *>*dataSourceArr;

@property (nonatomic,assign) NSInteger pageNum;

@property (nonatomic,copy) NSString *postApiStr;

@property (weak, nonatomic) IBOutlet UIButton *recordButton;

@property (nonatomic, strong) JGJChatNoDataDefaultView *chatNoDataDefaultView;
@end

@implementation JGJChatListRecordVc
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self commonInit];
}

- (void)commonInit{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.mj_footer = [MJRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    [self loadNewData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadNewData];
}

- (void)loadNewData{
    self.pageNum = 1;
    [self JLGHttpRequest:YES];
}

- (void)loadMoreData{
    
    [self JLGHttpRequest:NO];
}

- (void)setWorkProListModel:(JGJMyWorkCircleProListModel *)workProListModel{
    _workProListModel = workProListModel;
    [self loadNewData];
}

- (void)JLGHttpRequest:(BOOL )newData{
    
    self.postApiStr = _workProListModel.workCircleProType == WorkCircleExampleProType?@"v2/workday/sampleworkdaylist":@"v2/workday/groupworkdaylist";
    
    if (_workProListModel.workCircleProType == WorkCircleExampleProType) {
        self.tableView.mj_footer = nil;
    }
    
    [JLGHttpRequest_AFN PostWithApi:self.postApiStr parameters:@{@"group_id":self.chatListRequestModel.group_id?:@"",@"pg":@(self.pageNum)} success:^(id responseObject) {
        NSMutableArray <JGJChatListRecordModel *>*dataArr = [JGJChatListRecordModel mj_objectArrayWithKeyValuesArray:responseObject];
        
        if (dataArr.count > 0) {
            ++self.pageNum;
            newData?[self.dataSourceArr removeAllObjects]:nil;
            self.dataSourceArr = [self.dataSourceArr arrayByAddingObjectsFromArray:dataArr].mutableCopy;
            [self.tableView reloadData];
        }
        [self noDataDefaultView];
        
        [self.tableView.mj_footer endRefreshing];
    }failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - 添加没有数据的时候的默认界面
- (void )noDataDefaultView{
    [self noDataDefaultView:self.dataSourceArr.count];
}

- (void )noDataDefaultView:(NSInteger )dataCout{
    if (!self.chatNoDataDefaultView) {
        self.chatNoDataDefaultView = [[JGJChatNoDataDefaultView alloc] init];
        self.chatNoDataDefaultView.backgroundColor = self.tableView.backgroundColor;
        self.chatNoDataDefaultView.userInteractionEnabled = NO;
    }
    
    BOOL needAdd = [self.chatNoDataDefaultView needAddViewWithListType:JGJChatListRecord];
    
    if (!dataCout && needAdd) {
        [self.view addSubview:_chatNoDataDefaultView];
        [self.chatNoDataDefaultView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.view).offset(-63);
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
    NSInteger count = chatListRecordModel.list.count + 2;//加头、尾
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kJGJChatListRecordHeaderH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellHeight = 0.0;
    
    JGJChatListRecordModel *chatListRecordModel = self.dataSourceArr[indexPath.section];
    if (indexPath.row == 0) {
        //头
        cellHeight = kJGJChatListRecordHeaderCellH;
    }else if(indexPath.row == (chatListRecordModel.list.count + 1)){
        //尾
        cellHeight = kJGJChatListRecordFotterCellH;
    }else{
        cellHeight = kJGJChatListRecordCellH;
    }
    
    return cellHeight;
}

// 定义头标题的视图，添加点击事件
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *kTableViewHeaderViewID  = @"JGJChatListRecordVcHeader";
    
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kTableViewHeaderViewID];
    
    UILabel *cellHeaderLabel = [[UILabel alloc] init];
    if(!headerView) {
        UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 0.5)];
        topLineView.backgroundColor = AppFontdbdbdbColor;
        
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:kTableViewHeaderViewID];
        headerView.frame = TYSetRect(0, 0, TYGetUIScreenWidth, kJGJChatListRecordHeaderH);
        
        CGRect labelFrame = headerView.bounds;
        labelFrame.origin.x = 14.0;
        cellHeaderLabel.frame = labelFrame;
        cellHeaderLabel.textColor = TYColorHex(0x666666);
        cellHeaderLabel.backgroundColor = TYColorHex(0xf6f6f6);
        cellHeaderLabel.font = [UIFont boldSystemFontOfSize:14.0];
        
        headerView.contentView.backgroundColor = cellHeaderLabel.backgroundColor;
        [headerView addSubview:topLineView];
        [headerView addSubview:cellHeaderLabel];
    }else{
        cellHeaderLabel = [headerView.subviews lastObject];
    }
    
    JGJChatListRecordModel *chatListRecordModel = self.dataSourceArr[section];
    cellHeaderLabel.text = [self convertDate:chatListRecordModel.date];
    
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
    }else if(indexPath.row == (chatListRecordModel.list.count + 1)){
        //尾
        cell = [JGJChatListRecordFooterCell cellWithTableView:tableView];
    }else{
        if (indexPath.row > chatListRecordModel.list.count) {
            return cell;
        }
        
        ChatListRecord_List *listRecordModel = (ChatListRecord_List *)chatListRecordModel.list[indexPath.row - 1];
        JGJChatListRecordCell *recordCell = [JGJChatListRecordCell cellWithTableView:tableView];
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
        convertDateStr = [NSDate stringFromDate:date format:@"yyyy年MM月"];
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


@end
