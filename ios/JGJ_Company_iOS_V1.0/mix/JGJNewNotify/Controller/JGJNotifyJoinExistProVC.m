//
//  JGJNotifyJoinExistProVC.m
//  JGJCompany
//
//  Created by YJ on 16/11/9.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJNotifyJoinExistProVC.h"
#import "JGJNotifyJoinExistProTopCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "JGJNotifyJoinExistTeamCell.h"
#import "JGJChatRootVc.h"
#import "JGJNewNotifyTool.h"
#import "JGJWorkingChatMsgViewController.h"
@interface JGJNotifyJoinExistProVC () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *confirmButtonPressed;
@property (strong, nonatomic) NSArray *dataSource; //项目组信息系
@property (strong, nonatomic) NSIndexPath *lastIndexPath;
@property (strong, nonatomic) JGJAddGroupMemberRequestModel *addGroupMemberRequestModel;
@property (strong, nonatomic) JGJMyWorkCircleProListModel *workCircleProListModel;
@end

@implementation JGJNotifyJoinExistProVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self comonSet];
    [self loadExistTeam];
    
}

- (void)comonSet {
    self.title = @"选择加入现有项目组";
    [self.tableView registerNib:[UINib nibWithNibName:@"JGJNotifyJoinExistProTopCell" bundle:nil] forCellReuseIdentifier:@"JGJNotifyJoinExistProTopCell"];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];//AppFontf1f1f1Color;
    [self.confirmButtonPressed.layer setLayerCornerRadius:JGJCornerRadius];
    [self.confirmButtonPressed setTitle:@"确定" forState:(UIControlStateNormal)];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger count = 0;
    if (section == 0) {
        count = 1;
    } else {
        count = self.dataSource.count;
    }
    return count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 60;
    if (indexPath.section == 0) {
        height = [tableView fd_heightForCellWithIdentifier:@"JGJNotifyJoinExistProTopCell" configuration:^(JGJNotifyJoinExistProTopCell *cell) {
            cell.notifyModel = self.notifyModel;
        }];
    }else {
        height = 50.0;
    }
    return height;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        JGJNotifyJoinExistProTopCell *proTopCell = [tableView dequeueReusableCellWithIdentifier:@"JGJNotifyJoinExistProTopCell" forIndexPath:indexPath];
        proTopCell.notifyModel = self.notifyModel;
        cell = proTopCell;
    }else {
        JGJNotifyJoinExistTeamCell *teamCell = [JGJNotifyJoinExistTeamCell cellWithTableView:tableView];
        teamCell.teamInfoModel = self.dataSource[indexPath.row];
        cell = teamCell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSIndexPath *temp = self.lastIndexPath;
    
    if(temp && temp!=indexPath)
    {
        JGJExistTeamInfoModel *lastTeamInfoModel = self.dataSource[self.lastIndexPath.row];
        
        lastTeamInfoModel.isSelected = NO;
        
        [tableView reloadRowsAtIndexPaths:@[temp] withRowAnimation:UITableViewRowAnimationNone];
        
        
    }
    
    JGJExistTeamInfoModel *teamInfoModel = self.dataSource[indexPath.row];
    
    self.lastIndexPath = indexPath;
    
    teamInfoModel.isSelected = YES;
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
}

- (void)loadExistTeam {
        
    NSArray *proList = [JGJChatMsgDBManger getCurrentMyCreateTeamProjecyList];
    
    NSArray *dataSource = [JGJChatGroupListModel mj_keyValuesArrayWithObjectArray:proList];
    
    self.dataSource = [JGJExistTeamInfoModel mj_objectArrayWithKeyValuesArray:dataSource];
    
    TYLog(@"-----这里需要添加已存在的项目");
}

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    [self.tableView reloadData];
}

#pragma mark - 底部确认按钮按下
- (IBAction)handleBottomButtonPressed:(UIButton *)sender {
    
    JGJExistTeamInfoModel *teamInfoModel = self.dataSource[self.lastIndexPath.row];
    NSDictionary *parameters = @{@"group_id":teamInfoModel.group_id,
                                 @"class_type":@"team",
                                 @"msg_id":self.notifyModel.target_uid
                                 };
    
    [JLGHttpRequest_AFN PostWithNapi:JGJAddMembersURL parameters:parameters success:^(id responseObject) {
        
        //加入成功回调
        if (self.notifyJoinExistProSuccessBlock) {
            
            self.notifyJoinExistProSuccessBlock(responseObject);
        }
        BOOL isHaveWorkVC = NO;
        JGJWorkingChatMsgViewController *workVC;
        for (UIViewController *vc in self.navigationController.viewControllers) {
            
            if ([vc isKindOfClass:[JGJWorkingChatMsgViewController class]]) {
                
                isHaveWorkVC = YES;
                workVC = (JGJWorkingChatMsgViewController *)vc;
                break;
            }
        }
        
        if (isHaveWorkVC) {
            
            [self.navigationController popToViewController:workVC animated:YES];
            
        }else {
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark - 初始化添加班组成员网络请求模型
- (JGJAddGroupMemberRequestModel *)addGroupMemberRequestModel {
    
    if (!_addGroupMemberRequestModel) {
        
        _addGroupMemberRequestModel = [[JGJAddGroupMemberRequestModel alloc] init];
        
    }
    return _addGroupMemberRequestModel;
}

#pragma mark - 聊天界面更新数据库数据
- (void)handleChatAction:(JGJMyWorkCircleProListModel *)worlCircleModel {
    
    JGJChatRootVc *chatRootVc = [[UIStoryboard storyboardWithName:@"JGJChat" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJChatRootVc"];
    chatRootVc.workProListModel = worlCircleModel;
    [self.navigationController pushViewController:chatRootVc animated:YES];
}

@end
