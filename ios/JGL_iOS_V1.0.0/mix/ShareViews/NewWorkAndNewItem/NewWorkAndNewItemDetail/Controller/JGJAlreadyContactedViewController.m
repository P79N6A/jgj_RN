//
//  JGJAlreadyContactedViewController.m
//  mix
//
//  Created by Tony on 16/4/21.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJAlreadyContactedViewController.h"
#import "MJRefresh.h"
#import "JGJNewWorkItemDetailVC.h"
#import "YZGRecordWorkpointTool.h"
#import "JGJAlreadContactedTableViewCell.h"
#import "JGJNoManageProDefaultTableViewCell.h"
#import "JGJEditProExperienceVC.h"

@interface JGJAlreadyContactedViewController ()
<
    JGJAlreadContactedTableViewCellDelegate,
    JGJNoManageProDefaultTableViewCellDelegate
>
@property (assign,nonatomic) NSUInteger pageNum;
@property (strong, nonatomic) NSString *roleStr;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *alreadyContactedArray;
@property (nonatomic,assign) CGFloat excludeContentH;//除了中间需要根据内容变化的高度
@end

@implementation JGJAlreadyContactedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonset];
}

- (void)commonset{
    self.tableView.hidden = YES;
    self.tableView.backgroundColor = JGJMainBackColor;
    self.roleStr = JLGisLeaderBool?@"2":@"1";
    self.alreadyContactedArray = [NSMutableArray array];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(alreadContactedLoadNewData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(alreadContactedLoadMoreData)];
    
    [self.tableView.mj_header beginRefreshing];
    JGJAlreadContactedTableViewCell *cell = [JGJAlreadContactedTableViewCell cellWithTableView:self.tableView];
    self.excludeContentH = cell.excludeContentH;
}

- (void)alreadContactedLoadNewData{
    self.pageNum = 1;
    [self.alreadyContactedArray removeAllObjects];
    [self JLGHttpRequest];
}

- (void)alreadContactedLoadMoreData{
    //结束刷新
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    [self JLGHttpRequest];
}

- (void)JLGHttpRequest{
    NSDictionary *parameters = @{@"role_type" :  self.roleStr ?:[NSNull null],
                                 @"contacted" : @(1)?:[NSNull null],
                                 @"pg" : @(self.pageNum),
                                 @"work_type" : self.workTypeID ?: [NSNull null],
                                 @"is_all_area" : @(1)?:[NSNull null]
                                 };
    
    [TYShowMessage showHUDWithMessage:@"数据查询中，请稍后！"];
    [JLGHttpRequest_AFN PostWithApi:@"jlforemanwork/findjobactive" parameters:parameters success:^(NSDictionary *responseObject) {
        if (self.tableView.hidden == YES) {
            self.tableView.hidden = NO;
        }

        NSArray *dataArray = [JLGFindProjectModel mj_objectArrayWithKeyValuesArray:responseObject[@"data_list"]];
        
        [dataArray enumerateObjectsUsingBlock:^(JLGFindProjectModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.maxWidth = TYGetUIScreenWidth;
        }];
        
        if (dataArray.count > 0) {
            ++self.pageNum;
            [self.alreadyContactedArray addObjectsFromArray:dataArray];
            [self.tableView reloadData];
        }else if (self.alreadyContactedArray.count == 0) {//如果没有数据，就显示没有数据的cell
            [self.tableView reloadData];
        }
        
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [TYShowMessage hideHUD];
    }failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [TYShowMessage hideHUD];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.alreadyContactedArray.count?self.alreadyContactedArray.count + 1:1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *subTitle = JLGisLeaderBool ? @"项目" : @"工作";
    if (self.alreadyContactedArray.count == 0) {
        JGJNoManageProDefaultTableViewCell *cell = [JGJNoManageProDefaultTableViewCell cellWithTableView:tableView];
        cell.delegate = self;
        cell.titleProLabel.text =  @"你还没有联系过任何\n班组长/工头";
        JGJNoManageProSubStrModel *jgjNoManageProSubStrModel = [[JGJNoManageProSubStrModel alloc] init];
         jgjNoManageProSubStrModel.subStr = [NSString stringWithFormat:@"快去新%@看看适合你的%@吧!", subTitle, subTitle];
            jgjNoManageProSubStrModel.subStrRange = NSMakeRange(2, 3);
        cell.jgjNoManageProSubStrModel = jgjNoManageProSubStrModel;
        tableView.scrollEnabled = NO;
        return cell;
    }else{
        tableView.scrollEnabled = YES;
    }
    
    if (indexPath.row == 0) {
        UITableViewCell *tipCell = [YZGRecordWorkpointTool getJGJTipCell:tableView];
        tipCell.textLabel.text = [NSString stringWithFormat:@"以下%@是我联系过的", subTitle];
        tipCell.textLabel.textAlignment = NSTextAlignmentCenter;
        return tipCell;
    }
    
    JGJAlreadContactedTableViewCell *cell = [JGJAlreadContactedTableViewCell cellWithTableView:tableView];
    
    cell.delegate = self;
    JLGFindProjectModel *jlgFindProjectModel = self.alreadyContactedArray[indexPath.row - 1];
    cell.jlgFindProjectModel = jlgFindProjectModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.alreadyContactedArray.count == 0) {
        return TYGetViewH(tableView);
    }
    
    if (indexPath.row == 0) {
        return 30;
    }
    
    JLGFindProjectModel *jlgFindProjectModel = self.alreadyContactedArray[indexPath.row - 1];
    return self.excludeContentH + jlgFindProjectModel.strViewH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.alreadyContactedArray.count == 0) {
        return ;
    }
    
    JGJNewWorkItemDetailVC *newWorkItemDetailVC = [[UIStoryboard storyboardWithName:@"NewWorkItemDetail" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJNewWorkItemDetailVC"];
    JLGFindProjectModel *jlgFindProjectModel = self.alreadyContactedArray[indexPath.row - 1];
    newWorkItemDetailVC.isShowSkill = YES;
    [newWorkItemDetailVC setValue:jlgFindProjectModel forKey:@"jlgFindProjectModel"];
    newWorkItemDetailVC.jlgFindProjectModel = jlgFindProjectModel;
    newWorkItemDetailVC.workTypeID = self.workTypeID;
    [self.navigationController pushViewController:newWorkItemDetailVC animated:YES];
}

#pragma mark - 点击"晒手艺"或者"看评价"
- (void )AlreadContactedShowSubView:(JGJAlreadContactedTableViewCell *)alreadContactedCell subViewType:(JGJAlreadContactedSubViewType )subViewType{
    if (subViewType == JGJAlreadContactedSubViewTypeShowSkill) {
        UIViewController *addProExper = [[UIStoryboard storyboardWithName:@"MateMine" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJEditProExperienceVC"];
        
        [addProExper setValue:@(YES) forKey:@"isBackLevel"];
        [addProExper setValue:[NSString stringWithFormat:@"%@",@(alreadContactedCell.jlgFindProjectModel.pid)] forKey:@"pid"];
        [self.navigationController pushViewController:addProExper animated:YES];
    }else{
    
        
    }
}

#pragma mark - 去查看《新项目》
- (void )noManageProFindPro:(JGJNoManageProDefaultTableViewCell *)noManageProDefaultCell{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
