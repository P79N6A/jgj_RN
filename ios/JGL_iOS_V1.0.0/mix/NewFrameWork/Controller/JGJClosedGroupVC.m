//
//  JGJClosedGroupVC.m
//  mix
//
//  Created by Tony on 2016/8/18.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJClosedGroupVC.h"
#import "JGJClosedGroupCell.h"
#import "UITableViewCell+Extend.h"
#import "JGJChatRootVc.h"
@interface JGJClosedGroupVC ()
<
    UITableViewDataSource,
    UITableViewDelegate,
    JGJClosedGroupCellDelegate
>
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray <JGJClosedGroupModel *>*closedGroupsArr;

@end

@implementation JGJClosedGroupVC

- (void)viewDidLoad{
    [super viewDidLoad];
    [self commonSet];
    [self loadSocketData];
}

- (void)commonSet{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight - 64)];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    self.title = @"已关闭的班组/项目组";
}

- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger count = self.closedGroupsArr.count;
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 80.0;

    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.closedGroupsArr.count) {
        return [UITableViewCell getNilViewCell:tableView indexPath:indexPath];
    }
    
    JGJClosedGroupCell *jgjClosedGroupCell = [JGJClosedGroupCell cellWithTableView:tableView];
    if (!jgjClosedGroupCell.delegate) {
        jgjClosedGroupCell.delegate = self;
    }
    JGJClosedGroupModel *jgjClosedGroupModel = self.closedGroupsArr[indexPath.section];
    jgjClosedGroupCell.jgjClosedGroupModel = jgjClosedGroupModel;
    return jgjClosedGroupCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    CGFloat height = 10;
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    static NSString *kTableViewFooterViewID  = @"JGJClosedGroupVCFooter";
    
    UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kTableViewFooterViewID];
    
    if(!footerView) {
        footerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:kTableViewFooterViewID];
        
        footerView.frame = TYSetRect(0, 0, TYGetUIScreenWidth, 10);
        footerView.contentView.backgroundColor = self.tableView.backgroundColor;
    }
    
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JGJClosedGroupModel *jgjClosedGroupModel = self.closedGroupsArr[indexPath.section];
    JGJMyWorkCircleProListModel *proListModel = [[JGJMyWorkCircleProListModel alloc] init];
    proListModel = [JGJMyWorkCircleProListModel mj_objectWithKeyValues:[jgjClosedGroupModel mj_keyValues]];
    [self handleChatAction:proListModel];
}

#pragma mark - 聊天界面
- (void)handleChatAction:(JGJMyWorkCircleProListModel *)worlCircleModel {
    JGJChatRootVc *chatRootVc = [[UIStoryboard storyboardWithName:@"JGJChat" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJChatRootCommonVc"];
    //传递基本信息
    worlCircleModel.isClosedTeamVc = YES;//当前页面是已关闭
    chatRootVc.workProListModel = worlCircleModel;
    [self.navigationController pushViewController:chatRootVc animated:YES];
}

- (void)openAgainBtnClick:(JGJClosedGroupCell *)JGJClosedGroupCell{
    [self reopenGroup:JGJClosedGroupCell.jgjClosedGroupModel];
}

- (void)loadSocketData {
    NSDictionary *parameters = @{
                                 @"ctrl" : @"group",
                                 @"action": @"getClosedGroupList"
                                 };
    [JGJSocketRequest WebSocketWithParameters:parameters success:^(id responseObject) {
        self.closedGroupsArr = [JGJClosedGroupModel mj_objectArrayWithKeyValuesArray:responseObject];
    } failure:nil];
}

#pragma mark - 重新打开已关闭的班组、项目组
- (void)reopenGroup:(JGJClosedGroupModel *)groupModel {
    NSDictionary *parameters = @{
                                 @"ctrl" : @"group",
                                 @"action": @"reenableGroup",
                                 @"group_id" :groupModel.group_id?:[NSNull null]
     
                                 };
    __weak typeof(self) weakSelf = self;
    [JGJSocketRequest WebSocketWithParameters:parameters success:^(id responseObject) {
        [weakSelf.closedGroupsArr removeObject:groupModel];
        [weakSelf.tableView reloadData];
    } failure:nil];
}

- (void)setClosedGroupsArr:(NSMutableArray<JGJClosedGroupModel *> *)closedGroupsArr {
    _closedGroupsArr = closedGroupsArr;
    [self.tableView reloadData];
}

@end
