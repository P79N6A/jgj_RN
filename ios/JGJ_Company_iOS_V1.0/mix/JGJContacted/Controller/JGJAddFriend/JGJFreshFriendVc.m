//
//  JGJFreshFriendVc.m
//  mix
//
//  Created by yj on 17/2/14.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJFreshFriendVc.h"
#import "JGJAddFriendVc.h"
#import "JGJFreshFriendListCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "JGJPerInfoVc.h"
#import "CFRefreshStatusView.h"

#import "JGJCommonButton.h"

#import "JGJRefreshTableView.h"

typedef enum : NSUInteger {
    JGJFreshFriendVcDelButtonType
} JGJFreshFriendVcButtonType;

@interface JGJFreshFriendVc ()<
UITableViewDelegate,
UITableViewDataSource,
SWTableViewCellDelegate,
JGJFreshFriendListCellDelegate
>
@property (weak, nonatomic) IBOutlet JGJRefreshTableView *tableView;
@property (strong, nonatomic) NSMutableArray *friendList;
@end

@implementation JGJFreshFriendVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JGJCommonButton *rightItemBtn = [[JGJCommonButton alloc] init];
    
    rightItemBtn.buttonTitle = @"添加朋友";
    
    rightItemBtn.type = JGJCommonDefaultType;
    
    [rightItemBtn addTarget:self action:@selector(handleAddFriendRightItemAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemBtn];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"JGJFreshFriendListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"JGJFreshFriendListCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadAddFriendsList];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friendList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 75.0;
    height = [tableView fd_heightForCellWithIdentifier:@"JGJFreshFriendListCell" configuration:^(JGJFreshFriendListCell *cell) {
        JGJFreshFriendListModel *friendListModel = self.friendList[indexPath.row];
        cell.friendListModel = friendListModel;
    }];
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JGJFreshFriendListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JGJFreshFriendListCell" forIndexPath:indexPath];
    cell.rightUtilityButtons = [self handleAddCellButtons];
    cell.lineView.hidden = indexPath.row == self.friendList.count - 1;
    JGJFreshFriendListModel *friendListModel = self.friendList[indexPath.row];
    cell.friendListModel = friendListModel;
    cell.friendListCellDelegate = self;
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self JGJTableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)JGJTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JGJFreshFriendListModel *friendListModel = self.friendList[indexPath.row];
    JGJPerInfoVc *perInfoVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJPerInfoVc"];
    perInfoVc.jgjChatListModel.uid = friendListModel.uid;
    perInfoVc.jgjChatListModel.group_id = friendListModel.uid;
    perInfoVc.jgjChatListModel.class_type = @"singleChat";
    perInfoVc.message = friendListModel.msg_text;
    perInfoVc.status = friendListModel.status;
    [self.navigationController pushViewController:perInfoVc animated:YES];
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
    return YES;
}
#pragma mark - 处理显示置顶和取消
- (NSArray *)handleAddCellButtons {
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     AppFontd7252cColor title:@"删除"];
    return rightUtilityButtons;
}

- (void)swipeableTableViewCell:(JGJFreshFriendListCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case JGJFreshFriendVcDelButtonType:
            [self handleDelRuquestFriendWithFriendModel:cell.friendListModel friendListCell:cell];
            break;
        default:
            break;
    }
}

- (void)handleDelRuquestFriendWithFriendModel:(JGJFreshFriendListModel *)friendModel friendListCell:(JGJFreshFriendListCell *)cell {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    NSDictionary *parameters = @{
                                 @"uid" : friendModel.uid?:@"",
                                 };
    
    __weak typeof(self) weakSelf = self;
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithNapi:@"chat/del-add-friends" parameters:parameters success:^(id responseObject) {
        
        [weakSelf.friendList removeObjectAtIndex:indexPath.row];
        
        [weakSelf.tableView reloadData];
        
        [self setFriendList:self.friendList];
        
        [TYLoadingHub hideLoadingView];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
    }];
    
}

#pragma mark - 设置滑动的偏移量
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x > [cell rightUtilityButtonsWidth]) {
        scrollView.contentOffset = CGPointMake([cell rightUtilityButtonsWidth], 0);
    }
}

- (void)handleAddFriendRightItemAction {
    JGJAddFriendVc *addFriendVc = [[UIStoryboard storyboardWithName:@"JGJAddFriend" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJAddFriendVc"];
    [self.navigationController pushViewController:addFriendVc animated:YES];
}

- (void)loadAddFriendsList {
    
    JGJRequestBaseModel *request = [[JGJRequestBaseModel alloc] init];
    
    request.pagesize = JGJPageSize;
    
    request.pg = 1;
    
    request.requestApi = JGJChatAddFriendsListURL;
    
    self.tableView.request = request;
    
    TYWeakSelf(self);
    
    [self.tableView loadWithViewOfStatus:^UIView *(JGJRefreshTableView *tableView, JGJRefreshTableViewStatus status) {
        
        weakself.friendList = [JGJFreshFriendListModel mj_objectArrayWithKeyValuesArray:tableView.dataArray];
        
        if (weakself.friendList.count == 0) {
            
            tableView.des =@"暂无新朋友申请";
            
        }
        
        return nil;
        
    }];
    
}

- (void)setFriendList:(NSMutableArray *)friendList {
    _friendList = friendList;
    if (friendList.count == 0) {
        CFRefreshStatusView *statusView = [[CFRefreshStatusView alloc] initWithImage:PNGIMAGE(@"NoDataDefault_NoManagePro") withTips:@"暂无新朋友申请"];
        statusView.frame = self.view.bounds;
        self.tableView.tableHeaderView = statusView;
    }
    [self.tableView reloadData];
}

#pragma mark - JGJFreshFriendListCellDelegate
- (void)JGJFreshFriendListWithCell:(JGJFreshFriendListCell *)cell didSelectedFriendListModel:(JGJFreshFriendListModel *)friendListModel {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    NSDictionary *parameters = @{
                                 @"uid" : friendListModel.uid?:@"",
                                 };
    
    __weak typeof(self) weakSelf = self;
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithNapi:@"chat/agree-friends" parameters:parameters success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        JGJFreshFriendListModel *friendListModel = weakSelf.friendList[indexPath.row];
        
        friendListModel.status = JGJFriendListAddedMsgType; //已添加
        
        [weakSelf.tableView beginUpdates];
        
        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        [weakSelf.tableView endUpdates];
        
        [TYShowMessage showSuccess:@"添加成功！"];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
        [weakSelf loadAddFriendsList];
        
    }];
}

@end
