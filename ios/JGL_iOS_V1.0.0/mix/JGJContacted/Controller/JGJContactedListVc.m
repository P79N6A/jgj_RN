//
//  JGJContactedListVc.m
//  JGJCompany
//
//  Created by YJ on 16/12/18.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJContactedListVc.h"
#import "JGJSearchResultsVc.h"
#import "UITableViewCell+Extend.h"
#import "JGJContactedListCell.h"
#import "PopoverView.h"
#import "JGJTabBarViewController.h"
#import "JGJContactedAddressBookBaseVc.h"
#import "JGJLaunchGroupChatVc.h"
#import "JGJChatRootVc.h"
#import "JGJQRCodeVc.h"
#import "JGJSearchResultView.h"
#import "TYTextField.h"
#import "NSString+Extend.h"
#import "CFRefreshStatusView.h"
#import "UILabel+GNUtil.h"
#import "JGJAddFriendVc.h"
#import "UITabBar+JGJTabBar.h"
#import "JGJChatMsgListModel.h"
#import "JGJFreshFriendVc.h"


#import "JLGAppDelegate.h"
#import "FDAlertView.h"
#import "JLGCustomViewController.h"
#import "AFNetworkReachabilityManager.h"
//招工信息
#define LastContactedListModel @"LastContactedListModel"

//分享代码注释
//#import "MobClick.h"

#import <UMAnalytics/MobClick.h>
#import "JGJNetWorkingStatusHeaderView.h"

#import "JGJChatMsgDBManger+JGJGroupDB.h"
#import "JGJChatMsgDBManger.h"
#import "JGJWorkingChatMsgViewController.h"
#import "JGJChatGetOffLineMsgInfo.h"

#import "JGJChatOffLineMsgTool.h"
#import "NSDate+Extend.h"
#import "JGJMangerTool.h"

#import "JGJChatMsgDBManger+JGJClearCacheDB.h"

#import "JGJMyConnecView.h"

#import "JGJSwitchMyGroupsTool.h"
#import "JGJDataManager.h"


static JGJMangerTool *timerTool = nil;
typedef void(^FreshMsgBlock)(void);

typedef enum : NSUInteger {
    JGJContactedListVcMoreButtonAddressBookType,//通讯录
    JGJContactedListVcMoreButtonSweepType, //扫一扫
    JGJContactedListVcMoreButtonGroupChatType, //发起群聊
    JGJContactedListVcMoreButtonAddFriend, //添加朋友
    JGJContactedListVcMoreButtonFreshFriend //新朋友
} JGJContactedListVcMoreButtonType;

typedef enum : NSUInteger {
    JGJContactedListStickedButtonType,
    JGJContactedListDelButtonType
} JGJContactedListButtonType;
@interface JGJContactedListVc ()<
    UITableViewDataSource,
    UITableViewDelegate,
    SWTableViewCellDelegate,
    UITextFieldDelegate,
    JGJSearchResultViewdelegate,
    FDAlertViewDelegate
>{
    
    JGJChatGroupListModel *_delGroup;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *contentSearchBarView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentSearchbarViewH;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelButtonW;
@property (strong, nonatomic) JGJActiveGroupModel *activeGroupModel;
@property (strong, nonatomic) JGJSearchResultView *searchResultView;
@property (weak, nonatomic) IBOutlet LengthLimitTextField *searchBarTF;
@property (strong, nonatomic) JGJTabBarViewController *tabBar;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (strong, nonatomic) PopoverAction *friendAction;
//刷新消息回调
@property (nonatomic, copy) FreshMsgBlock freshMsgBlock;

//选中的项目id
@property (nonatomic, strong) NSString *selGroupId;

// 网络状态headerView
@property (nonatomic, strong) JGJNetWorkingStatusHeaderView *netWorkingHeader;

@property (nonatomic, strong) NSMutableArray *groupDBArr;


@property (nonatomic, copy) NSString * chat_unread_msg_count;//总的消息数

@end

@implementation JGJContactedListVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self commonInit];

    //初始化定时器
    if (!timerTool) {
        
        timerTool = [[JGJMangerTool alloc] init];
        
        timerTool.timeInterval = 0.2;
        
    }
    
}


//网络状态的判断
- (void)networkingConfig
{
    
    // 检测网络连接状态
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];

    // 连接状态回调处理
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
         UIView *defaultView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, CGFLOAT_MIN)];
         
         switch (status)
         {
                 
             case AFNetworkReachabilityStatusUnknown:
                 TYLog(@"网络状态:未知网络状态或者无网络连接");
                 self.netWorkingHeader.frame = CGRectMake(0, 0, TYGetUIScreenWidth, 40);
                 self.tableView.tableHeaderView = _netWorkingHeader;
                 [self.netWorkingHeader setcontentWithNewWorkingStatus:AFNetworkReachabilityStatusUnknown];
                 
                 break;
                 
             case AFNetworkReachabilityStatusNotReachable:
                 TYLog(@"网络不可用");
                 self.netWorkingHeader.frame = CGRectMake(0, 0, TYGetUIScreenWidth, 40);
                 self.tableView.tableHeaderView = _netWorkingHeader;
                 [self.netWorkingHeader setcontentWithNewWorkingStatus:AFNetworkReachabilityStatusNotReachable];
                 
                 break;
                 
             case AFNetworkReachabilityStatusReachableViaWWAN:
                 TYLog(@"网络状态:移动网络");
                 [self.netWorkingHeader setcontentWithNewWorkingStatus:AFNetworkReachabilityStatusReachableViaWWAN];
                 self.tableView.tableHeaderView = defaultView;
                 break;
             case AFNetworkReachabilityStatusReachableViaWiFi:
                 TYLog(@"网络状态:Wifi");
                 [self.netWorkingHeader setcontentWithNewWorkingStatus:AFNetworkReachabilityStatusReachableViaWiFi];
                 self.tableView.tableHeaderView = defaultView;
                 break;
             default:
                 break;
         }
     }];
}


#pragma mark - 通用设置
- (void)commonInit{
    
    self.searchBarTF.layer.borderWidth = 0;
    self.searchBarTF.layer.cornerRadius = 3;
    self.searchBarTF.layer.borderColor = TYColorHex(0Xf3f3f3).CGColor;
    self.searchBarTF.backgroundColor = TYColorHex(0Xf3f3f3);
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.tableHeaderView = nil;
    self.view.backgroundColor = AppFontf1f1f1Color;

    self.cancelButtonW.constant = 12;
    self.cancelButton.hidden = YES;
    self.searchBarTF.maxLength = 20;
    UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search-icon"]];
    searchIcon.contentMode = UIViewContentModeCenter;
    searchIcon.width = 33;
    searchIcon.height = 33;
    self.searchBarTF.leftViewMode = UITextFieldViewModeAlways;
    self.searchBarTF.leftView = searchIcon;
    __weak typeof(self) weakSelf = self;
    self.searchBarTF.valueDidChange = ^(NSString *value){
        [weakSelf searchValueChange:value];
    };
    
    //添加小红点
    [self freshFriendFlagView];
    
    [JGJChatOffLineMsgTool shareChatOffLineMsgTool].offLineCallBack = ^(BOOL complete) {
      
        [weakSelf loadGroupDataFromDB];
    };

    UIView *defaultView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, CGFLOAT_MIN)];
    
    self.tableView.tableHeaderView = defaultView;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self networkingConfig];
    self.freshFriendFlagView.hidden = YES;
    
    JGJSocketRequest *shareSocket = [JGJSocketRequest shareSocketConnect];
    
    TYWeakSelf(self);
    
    shareSocket.contactListCallBack = ^{
      
        [weakself loadGroupDataFromDB];
    };
    
    [self handleSearchBarViewMoveDown];
    
    JGJTabBarViewController *tabBarVc = (JGJTabBarViewController *)self.tabBarController;
    
    __weak typeof(self) weakSelf = self;
    
    tabBarVc.clickChatBlock = ^{
      
        [weakSelf.tableView setContentOffset:CGPointZero animated:YES];
        
    };

    [TYNotificationCenter addObserver:self selector:@selector(getChatListSuccess) name:@"get_chat_list_success" object:nil];
    
    JGJChatOffLineMsgTool *offLineTool = [JGJChatOffLineMsgTool shareChatOffLineMsgTool];
    offLineTool.offLineCallBack = ^(BOOL complete) {
      
        if (complete) {
            
            // 获取数据库表中数据
            [weakSelf loadGroupDataFromDB];
        }
    };

    // 获取数据库表中数据
    [self loadGroupDataFromDB];
    
    if (_isCheckFreshFriend) {
        
//        [self loadGetTemporaryFriendList];
    }
    
    self.tabBarController.tabBar.hidden = NO;
    
}

- (void)getChatListSuccess {
    
    // 获取数据库表中数据
    [self loadGroupDataFromDB];
}

// 从数据库中读取聊聊列表
- (void)loadGroupDataFromDB {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.groupDBArr = [JGJChatMsgDBManger getAllGroupListModel].mutableCopy;
        
        // 刷新首页对应的项目信息
        [JGJChatGetOffLineMsgInfo refreshIndexTbToHomeVC];
        
        [timerTool startTimer];
        TYWeakSelf(self);
        timerTool.toolTimerBlock = ^{
            
            [weakself.tableView reloadData];
            //处理没有数据的情况
            [weakself handleNoActiveGroup];
            // 处理未读数
            [weakself dealTabbarUnreadMessageCount];
            
            [timerTool inValidTimer];
        };
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//
//        });
        
    });
    
}

- (NSMutableArray *)groupDBArr {
    
    if (!_groupDBArr) {
        
        _groupDBArr = [NSMutableArray array];
    }
    return _groupDBArr;
}


#pragma mark - App运行到前台告知服务器不要推送消息
- (void)appForeground {
    
    //App运行到前台,告知服务器不要推消息
    JLGAppDelegate *jlgAppDelegate = (JLGAppDelegate *)[UIApplication sharedApplication].delegate;
    
    [jlgAppDelegate appDidisEnterBackground:@"0" responseBlock:^(id response) {
        
        
        
    }];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self handleSearchBarViewMoveDown];
    
}

- (void)searchValueChange:(NSString *)value {
    [self handleSearchBarMoveTop];
    if (![self.view.subviews containsObject:self.searchResultView] && ![NSString isEmpty:value]) {
        [self.view addSubview:self.searchResultView];
    }else if([self.view.subviews containsObject:self.searchResultView] && [NSString isEmpty:value]){
        [self.searchResultView removeFromSuperview];
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"group_name contains %@", value];
    NSMutableArray *chatList = [self.groupDBArr filteredArrayUsingPredicate:predicate].mutableCopy;
    self.searchResultView.searchValue = value;
    self.searchResultView.results = chatList;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [JGJContactedListCell JGJContactedListCellHeight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.groupDBArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJContactedListCell *cell = [JGJContactedListCell cellWithTableView:tableView];

    JGJChatGroupListModel *proListModel = self.groupDBArr[indexPath.row];
    cell.rightUtilityButtons = [self handleStickWithProListModel:proListModel];
    cell.groupModel = proListModel;
    cell.lineView.hidden = indexPath.row == self.groupDBArr.count - 1;
    cell.delegate = self;

    TYWeakSelf(self);

    cell.contactedListCellBlock = ^(JGJChatGroupListModel *proListModel) {

        [weakself goHomeButtonPressedWithProListModel:proListModel];
    };
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    JGJMyConnecView *headerView = [[JGJMyConnecView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 50)];
    
    TYWeakSelf(self);
    
    headerView.actionBlock = ^{
      
        [weakself checkMyConnecAction];
        
    };
        
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    JGJChatGroupListModel *model = self.groupDBArr[indexPath.row];
    // 清除未读数
    [JGJChatMsgDBManger cleadGroupUnReadMsgCountWithModel:model];
    
    JGJMyWorkCircleProListModel *proListModel = [[JGJMyWorkCircleProListModel alloc] init];
    proListModel.group_id = model.group_id;
    proListModel.class_type = model.class_type;
    proListModel.group_name = model.group_name;
    proListModel.members_num = model.members_num;
    proListModel.is_sticked = model.is_top;
    proListModel.pro_id = model.pro_id;
    proListModel.creater_uid = model.creater_uid;
    proListModel.isClosedTeamVc = model.is_closed;
    // 设置未读消息数
    proListModel.unread_msg_count = model.chat_unread_msg_count;
    // 设置已读消息最大id
    proListModel.maxReadeRdMsgId = model.max_readed_msg_id;
    
    //3.4.2(yj群聊招工弹框提示)
    
    proListModel.extent_msg = model.extent_msg;
    
    proListModel.can_at_all = [[TYUserDefaults objectForKey:JLGUserUid] isEqualToString:model.creater_uid];
    
    JGJContactedListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        if ([model.class_type isEqualToString:@"work"] || [model.class_type isEqualToString:@"activity"] || [model.class_type isEqualToString:@"recruit"]) {
            
            [self handleJoinWorkingChatMsgVCWithChatGroupListModel:model];
            
        }else if ([model.class_type isEqualToString:@"newFriends"]) {
            
            JGJChatMsgListModel *msgModel = [[JGJChatMsgListModel alloc] init];
            msgModel.group_id = model.group_id;
            msgModel.class_type = model.class_type;
            msgModel.sys_msg_type = model.class_type;
            
            //是否正在读消息
            [JGJSocketRequest readedMsgModel:msgModel isReaded:NO];
                
            [self handleMoreButtonPressed:nil buttonType:JGJContactedListVcMoreButtonFreshFriend];
            
        }else {
            
            [self handleJoinChatRootVcWithProListModel:proListModel didSelectRowAtIndexPath:indexPath];
            
        }

        cell.containView.backgroundColor = proListModel.is_sticked ? AppFontF5F6FCColor : [UIColor whiteColor];

    });
    
    cell.containView.backgroundColor = AppFontE4E4E4Color;
    
}

// 跳转到工作, 招聘, 活动类型的界面
- (void)handleJoinWorkingChatMsgVCWithChatGroupListModel:(JGJChatGroupListModel *)groupModel {

    JGJWorkingChatMsgViewController *workingVC = [[JGJWorkingChatMsgViewController alloc] init];
    workingVC.groupModel = groupModel;
    if (![self checkIsRealName]) {
        
        TYWeakSelf(self);
        
        if ([self.navigationController isKindOfClass:NSClassFromString(@"JLGCustomViewController")]) {
            
            JLGCustomViewController *customVc = (JLGCustomViewController *) self.navigationController;
            
            customVc.customVcBlock = ^(id response) {
                
                [weakself.navigationController pushViewController:workingVC animated:YES];
            };
            
        }
        
    }else {
        
        [self.navigationController pushViewController:workingVC animated:YES];
    }
}

#pragma mark - 进入聊天页面
- (void)handleJoinChatRootVcWithProListModel:(JGJMyWorkCircleProListModel *)proListModel didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 其实创建出来的是JGJChatRootCommonVc
    JGJChatRootVc *chatRootVc = [[UIStoryboard storyboardWithName:@"JGJChat" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJChatRootCommonVc"];
    
    //转换对象
    JGJMyWorkCircleProListModel *archProListModel = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:proListModel]];
    
    chatRootVc.workProListModel = archProListModel; //聊天页面
    
    if (![self checkIsRealName]) {
        
        TYWeakSelf(self);
        
        if ([self.navigationController isKindOfClass:NSClassFromString(@"JLGCustomViewController")]) {
            
            JLGCustomViewController *customVc = (JLGCustomViewController *) self.navigationController;
            
            customVc.customVcBlock = ^(id response) {
                
                [weakself.navigationController pushViewController:chatRootVc animated:YES];
            };
            
        }
        
    }else {
        // 设置好友来源:单聊(聊天)
        if ([chatRootVc.workProListModel.class_type isEqualToString:@"singleChat"]){
            [JGJDataManager sharedManager].addFromType = JGJFriendAddFromSingleChat;
        }
        [self.navigationController pushViewController:chatRootVc animated:YES];
    }
    
}

- (void)swipeableTableViewCell:(JGJContactedListCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case JGJContactedListStickedButtonType:
            [self handleStickedButtonPressedWithCell:cell ButtonType:JGJContactedListStickedButtonType];
            break;
        case JGJContactedListDelButtonType:
            [self handleDelButtonPressedWithCell:cell ButtonType:JGJContactedListDelButtonType];
            break;
        default:
            break;
    }
}

#pragma mark - 设置滑动的偏移量
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x > [cell rightUtilityButtonsWidth]) {
        scrollView.contentOffset = CGPointMake([cell rightUtilityButtonsWidth], 0);
    }
}

#pragma mark - 处理置顶按钮
- (void)handleStickedButtonPressedWithCell:(JGJContactedListCell *)cell ButtonType:(JGJContactedListButtonType)buttonType {
    
    JGJChatGroupListModel *groupModel = [[JGJChatGroupListModel alloc] init];
    groupModel = cell.groupModel;
    
    __weak typeof(self) weakSelf = self;
    
    NSString *status = groupModel.is_top ? @"1" : @"0";
    
    NSDictionary *parameters = @{
                                 @"status" : status,
                                 @"class_type" : groupModel.class_type?:@"",
                                 @"group_id" : groupModel.group_id?:@""
                                 };
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithNapi:@"chat/set-stick" parameters:parameters success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        BOOL is_top = !groupModel.is_top;
        BOOL isUpdateSuccess = [JGJChatMsgDBManger updateIs_topToGroupTableWithIsTop:is_top group_id:groupModel.group_id class_type:groupModel.class_type];

        if (isUpdateSuccess) {

            if ([status isEqualToString:@"0"]) {
                
                NSDate *date = [NSDate date];
                groupModel.list_sort_time = date.timestamp;
                BOOL update_success = [JGJChatMsgDBManger updateList_sort_timeWithChatGroupListModel:groupModel];
                if (update_success) {
                    
                    [self loadGroupDataFromDB];
                }
                
            }else {
                
                [self loadGroupDataFromDB];
            }
            
        }
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
    }];
    
}

#pragma mark - 处理删除按钮
- (void)handleDelButtonPressedWithCell:(JGJContactedListCell *)cell ButtonType:(JGJContactedListButtonType)buttonType {

    _delGroup =  [[JGJChatGroupListModel alloc] init];
    _delGroup = cell.groupModel;
    
    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:nil icon:nil message:@"删除后，将清空该聊天的消息记录" delegate:self buttonTitles:@"取消",@"删除", nil];
    
    alert.isHiddenDeleteBtn = YES;
    [alert setMessageColor:AppFont000000Color fontSize:16];
    
    [alert show];
}

- (void)alertView:(FDAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        [TYLoadingHub showLoadingWithMessage:@"请稍候..."];
        
        [JLGHttpRequest_AFN PostWithNapi:@"chat/del-chat" parameters:@{@"group_id":_delGroup.group_id,@"class_type":_delGroup.class_type} success:^(id responseObject) {

            [TYLoadingHub hideLoadingView];
            
            _delGroup.is_delete = YES;
            _delGroup.is_top = NO;
            BOOL is_delete_success = [JGJChatMsgDBManger updateIs_deleteToGroupTableWithIsDelete:_delGroup group_id:_delGroup.group_id class_type:_delGroup.class_type];
            
            if (is_delete_success) {
                
                [TYShowMessage showSuccess:@"删除消息成功！"];
                
                // 本地数据清空
                JGJChatMsgListModel *msgModel = [[JGJChatMsgListModel alloc] init];
                msgModel.group_id = _delGroup.group_id;
                msgModel.class_type = _delGroup.class_type;
                msgModel.sys_msg_type = _delGroup.sys_msg_type;
                
                //获取最大msg_id，漫游不能拉取
                
                [self clearChatMsgDB:msgModel];
                
                BOOL deleSuccess = [JGJChatMsgDBManger delGroupMsgModel:msgModel];
                
                if (deleSuccess) {
                    
                    [self loadGroupDataFromDB];
                }
                
            }
            
        } failure:^(NSError *error) {
            
            [TYLoadingHub hideLoadingView];
        }];
        

    }
}

#pragma mark - 清除数据库缓存漫游不能拉取
- (void)clearChatMsgDB:(JGJChatMsgListModel *)msgModel {
        
    msgModel.class_type = msgModel.class_type;
    
    msgModel.group_id = msgModel.group_id;
    
    //现将要清除的消息id存入数据库，然后再删除
    
    msgModel = [JGJChatMsgDBManger maxMsgListModelWithChatMsgListModel:msgModel];
    
    JGJChatClearCacheModel *cacheModel = [JGJChatClearCacheModel mj_objectWithKeyValues:[msgModel mj_keyValuesWithKeys:@[@"class_type",@"group_id",@"msg_id"]]];
    
    [JGJChatMsgDBManger insertToCacheModelTableWithCacheModel:cacheModel];
    
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
    
    return YES;
}

#pragma mark - JGJSearchResultViewdelegate
- (void)searchResultView:(JGJSearchResultView *)searchResultView didSelectedChatListModel:(JGJMyWorkCircleProListModel *)chatListModel groupModel:(JGJChatGroupListModel *)groupModel{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if ([chatListModel.class_type isEqualToString:@"work"] || [chatListModel.class_type isEqualToString:@"activity"] || [chatListModel.class_type isEqualToString:@"recruit"]) {
            
            [self handleJoinWorkingChatMsgVCWithChatGroupListModel:groupModel];
            
        }else {
            
            [self handleJoinChatRootVcWithProListModel:chatListModel didSelectRowAtIndexPath:nil];
            
        }
        
    });
    
    
}

#pragma mark - buttonAction
- (IBAction)handleMoreButtonPressed:(UIButton *)sender {
    PopoverView *popoverView = [PopoverView popoverView];
    popoverView.style = PopoverViewStyleDark;
    [popoverView showToView:sender withActions:[self JGJChatActions]];
}

- (void)handleMoreButtonPressed:(PopoverAction *)popoverAction buttonType:(JGJContactedListVcMoreButtonType)buttonType {
    
    UIViewController *nextVc = nil;
    
    switch (buttonType) {
        case JGJContactedListVcMoreButtonAddressBookType:{
            JGJContactedAddressBookBaseVc *addressBookBaseVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJContactedAddressBookBaseVc"];
            
            nextVc = addressBookBaseVc;
            
        }
            break;
        case JGJContactedListVcMoreButtonSweepType: {
            
            JGJQRCodeVc *jgjQRCodeVc = [JGJQRCodeVc new];
            
            nextVc = jgjQRCodeVc;
            
        }
            break;
        case JGJContactedListVcMoreButtonGroupChatType:{
            JGJLaunchGroupChatVc *groupChatVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJLaunchGroupChatVc"];
            groupChatVc.contactedAddressBookVcType = JGJLaunchGroupChatVcType; //发起群聊
            
            nextVc = groupChatVc;
            
        }
            break;
            
        case JGJContactedListVcMoreButtonAddFriend: {
            JGJAddFriendVc *addFriendVc = [[UIStoryboard storyboardWithName:@"JGJAddFriend" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJAddFriendVc"];
            
            nextVc = addFriendVc;
        }
            break;
            
        case JGJContactedListVcMoreButtonFreshFriend:{
            
            JGJFreshFriendVc *freshFriendVc = [[UIStoryboard storyboardWithName:@"JGJAddFriend" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJFreshFriendVc"];
            
            nextVc = freshFriendVc;
            
        }
            
            break;
            
        default:
            break;
    }
    
    if (![self checkIsRealName]) {
        
        TYWeakSelf(self);
        
        if ([self.navigationController isKindOfClass:NSClassFromString(@"JLGCustomViewController")]) {
            
            JLGCustomViewController *customVc = (JLGCustomViewController *) self.navigationController;
            
            customVc.customVcBlock = ^(id response) {
                
                [weakself.navigationController pushViewController:nextVc animated:YES];
            };
            
        }
        
    }else {
        
        [self.navigationController pushViewController:nextVc animated:YES];
    }
    
}

#pragma mark - 处理显示置顶和取消
- (NSArray *)handleStickWithProListModel:(JGJChatGroupListModel *)proListModel {
    NSString *stickStr = proListModel.is_top ? @"取消置顶" : @"置顶";
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     AppFontC7C6CBColor title:stickStr];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     AppFontd7252cColor title:@"删除"];
    return rightUtilityButtons;
}

- (NSArray<PopoverAction *> *)JGJChatActions {
    
    // 新朋友 action
    
    // 通信录 action
    __weak typeof(self) weakSelf = self;
    
    PopoverAction *friendAction = [PopoverAction actionWithImage:[UIImage imageNamed:@"fresh_friend_icon"] title:@"新朋友" handler:^(PopoverAction *action) {
        
        TYLog(@"新朋友入口");
        
//        //查看新朋友,查看后清除
//        _isCheckFreshFriend = YES;
        
        [weakSelf handleMoreButtonPressed:nil buttonType:JGJContactedListVcMoreButtonFreshFriend];
        
    }];
    
//    self.friendAction = friendAction;
    
//    friendAction.isShowRedFlag = self.isCheckFreshFriend;
    
    // 添加朋友 action
    PopoverAction *addFriendAction = [PopoverAction actionWithImage:[UIImage imageNamed:@"add-friend-little"] title:@"添加朋友" handler:^(PopoverAction *action) {
        [weakSelf handleMoreButtonPressed:nil buttonType:JGJContactedListVcMoreButtonAddFriend];
    }];
    
    PopoverAction *addressBookAction = [PopoverAction actionWithImage:[UIImage imageNamed:@"address-list"] title:@"通讯录" handler:^(PopoverAction *action) {
        
        //查看新朋友,查看后清除
        
        _isCheckFreshFriend = YES;
        
        [weakSelf handleMoreButtonPressed:nil buttonType:JGJContactedListVcMoreButtonAddressBookType];
    }];
    
    // 发起群聊 action
    PopoverAction *groupChatAction = [PopoverAction actionWithImage:[UIImage imageNamed:@"group-chat"] title:@"发起群聊" handler:^(PopoverAction *action) {
        [weakSelf handleMoreButtonPressed:nil buttonType:JGJContactedListVcMoreButtonGroupChatType];
    }];
    
    // 扫一扫 action
    PopoverAction *sweepAction = [PopoverAction actionWithImage:[UIImage imageNamed:@"RichScan"] title:@"扫一扫" handler:^(PopoverAction *action) {
        [weakSelf handleMoreButtonPressed:nil buttonType:JGJContactedListVcMoreButtonSweepType];
    }];
    
    return @[friendAction, addFriendAction,addressBookAction, groupChatAction, sweepAction];
}


- (void)setActiveGroupModel:(JGJActiveGroupModel *)activeGroupModel {
    
    _activeGroupModel = activeGroupModel;
    
    //处理没有数据的情况
    [self handleNoActiveGroup:_activeGroupModel];
    
    [self.tableView reloadData];
    
//    [self loadGetTemporaryFriendList];
    
    if (_activeGroupModel.unclose.count > 0) {
        
        NSData *activeGroupModelData = [NSKeyedArchiver archivedDataWithRootObject:_activeGroupModel];
        
        [TYUserDefaults setObject:activeGroupModelData forKey:LastContactedListModel];
    }
    
    //清除选择的项目id
    self.selGroupId = nil;
}

#pragma mark - 处理没有数据的情况
- (void)handleNoActiveGroup:(JGJActiveGroupModel *)activeGroupModel {
    if (activeGroupModel.unclose.count == 0) {
        self.contentSearchBarView.hidden = YES;
        self.contentSearchbarViewH.constant = 0;
        NSString *lineText = @"你与工友或同事发起单聊或群聊将在此页展示";
        NSString *tips = [NSString stringWithFormat:@"暂无聊天记录\n%@", lineText];
        CFRefreshStatusView *statusView = [[CFRefreshStatusView alloc] initWithImage:PNGIMAGE(@"notice_default_icon") withTips:tips];
        UIFont *lineFont = [UIFont systemFontOfSize:AppFont30Size];
        statusView.tipsLabel.textColor = AppFont999999Color;
        [statusView.tipsLabel markLineText:lineText withLineFont:lineFont withColor:AppFontccccccColor lineSpace:AppFont30Size];
        statusView.frame = self.view.bounds;
        self.tableView.tableHeaderView = statusView;
    } else {
        self.contentSearchBarView.hidden = NO;
        self.contentSearchbarViewH.constant = 48.0;
        self.tableView.tableHeaderView = nil;
    }
}

- (void)handleNoActiveGroup{
    
    if (self.groupDBArr.count == 0) {
        self.contentSearchBarView.hidden = YES;
        self.contentSearchbarViewH.constant = 0;
        NSString *lineText = @"你与工友或同事发起单聊或群聊将在此页展示";
        NSString *tips = [NSString stringWithFormat:@"暂无聊天记录\n%@", lineText];
        CFRefreshStatusView *statusView = [[CFRefreshStatusView alloc] initWithImage:PNGIMAGE(@"notice_default_icon") withTips:tips];
        UIFont *lineFont = [UIFont systemFontOfSize:AppFont30Size];
        statusView.tipsLabel.textColor = AppFont999999Color;
        [statusView.tipsLabel markLineText:lineText withLineFont:lineFont withColor:AppFontccccccColor lineSpace:AppFont30Size];
        statusView.frame = self.view.bounds;
        self.tableView.tableHeaderView = statusView;
    } else {
        self.contentSearchBarView.hidden = NO;
        self.contentSearchbarViewH.constant = 48.0;
//        self.tableView.tableHeaderView = nil;
    }
}
#pragma mark - 处理tabbar未读数 v3.4 cc添加
- (void)dealTabbarUnreadMessageCount {
    
    UITabBarItem * chatItem = [self.tabBarController.tabBar.items objectAtIndex:1];
    
    NSUInteger chat_unread_msg_count = [JGJChatMsgDBManger getAllUnreadMsgCount];
    
    self.chat_unread_msg_count = [NSString stringWithFormat:@"%@", @(chat_unread_msg_count)];
    
    [self saveUserDefaults:self.chat_unread_msg_count];
    
    if (chat_unread_msg_count > 0) {
        
        chatItem.badgeValue = chat_unread_msg_count > 99 ? @"99+" : [NSString stringWithFormat:@"%ld",[JGJChatMsgDBManger getAllUnreadMsgCount]];
        
    }else {
        
        chatItem.badgeValue = nil;
    }
    
    NSUInteger total_unread_msg_count = chat_unread_msg_count;
    
    if (JGJAppIsDidisEnterBackgroundBool) {

        return;
    }
    
    if (total_unread_msg_count > 0) {
        
        [UIApplication sharedApplication].applicationIconBadgeNumber = total_unread_msg_count;
        
    }else {
        
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
}


#pragma mark - 接收消息的监控
- (void)socketRequestReciveMessage{
    
    [JGJSocketRequest WebSocketAddMonitor:@{@"ctrl":@"message",@"action":@"reddotMessage"} success:^(id responseObject) {
        
        JGJChatMsgListModel *receiveMsg = [JGJChatMsgListModel mj_objectWithKeyValues:responseObject];
        
//        if ([receiveMsg.msg_type isEqualToString:@"group_bill"]) {
//
//            HomeVC *homeVc = self.tabBarController.viewControllers[0];
//
//            if ([homeVc isKindOfClass:[homeVc class]]) {
//
//                homeVc.proListModel.unread_billRecord_count = @"1";
//
//                [homeVc.tableView reloadData];
//
//            }
//
//        }else if ([receiveMsg.msg_type isEqualToString:@"findred"]) {
//
//             HomeVC *homeVc = self.tabBarController.viewControllers[0];
//
//            if ([homeVc isKindOfClass:[homeVc class]]) {
//
//                [homeVc showDynamicMsgRed];
//
//            }
//        }
        
    } failure:nil];
    
}

- (JGJSearchResultView *)searchResultView {
    
    
    CGFloat height = self.tabBarController.tabBar.frame.size.height + 68;
    
    CGFloat searchResultViewY = 68;
    
    if (!_searchResultView) {
        
        JGJSearchResultView *searchResultView = [[JGJSearchResultView alloc] initWithFrame:(CGRect){{0,searchResultViewY},{TYGetUIScreenWidth,TYGetUIScreenHeight - height}}];
        searchResultView.resultViewType = JGJSearchMemberAndGroupResultViewType;
        searchResultView.delegate = self;
        self.searchResultView = searchResultView;
    }
    return _searchResultView;
}

- (IBAction)handleCancelButtonAction:(UIButton *)sender {
   
    [self handleSearchBarViewMoveDown];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

    [self handleSearchBarMoveTop];
    return YES;
}
- (void)handleSearchBarMoveTop {
    
    self.searchResultView.searchValue = nil;
    self.searchResultView.results = @[];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.navigationController.navigationBarHidden = YES;
        self.cancelButtonW.constant = 45;
        self.cancelButton.hidden = NO;
        [self.view addSubview:self.searchResultView];
        [self.view layoutIfNeeded];
    }];
}

- (void)handleSearchBarViewMoveDown {
    self.searchBarTF.text = nil;
    [self.searchBarTF resignFirstResponder];
    [self.view endEditing:YES];
    self.navigationController.navigationBarHidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.cancelButtonW.constant = 12;
        self.cancelButton.hidden = YES;
        [self.searchResultView removeFromSuperview];
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - 获取临时好友 3.4.5去掉小红点
- (void)loadGetTemporaryFriendList {
//    NSString *userId = [TYUserDefaults objectForKey:JLGUserUid];
//    NSDictionary *parameters = @{
//                                 @"uid" : userId?:@""
//                                 };
//
//    NSUInteger chat_unread_msg_count = [JGJChatMsgDBManger getAllUnreadMsgCount];
//
//    //获取总消息数
//    self.chat_unread_msg_count = [NSString stringWithFormat:@"%@", @(chat_unread_msg_count)];
//
//    [JLGHttpRequest_AFN PostWithNapi:JGJGetTemporaryFriendList parameters:parameters success:^(id responseObject) {
//
//        JGJSynBillingModel *freshFriendModel = [JGJSynBillingModel mj_objectWithKeyValues:responseObject];
//
//        if (![NSString isEmpty:freshFriendModel.head_pic]) {
//
//            self.isCheckFreshFriend = YES;
//
//            self.freshFriendFlagView.hidden = NO;
//
//        }else {
//
//            self.isCheckFreshFriend = NO;
//        }
//
//    } failure:^(NSError *error) {
//
//
//    }];
}

- (void)setIsCheckFreshFriend:(BOOL)isCheckFreshFriend {
    _isCheckFreshFriend = isCheckFreshFriend;
//    NSInteger chat_unread_msg_count = [self.chat_unread_msg_count integerValue];
//    if (_isCheckFreshFriend && chat_unread_msg_count == 0) {
//        [self.tabBarController.tabBar showBadgeOnItemIndex:1];
//    }else {
//        [self.tabBarController.tabBar hideBadgeOnItemIndex:1];
//    }
//
//    self.freshFriendFlagView.hidden = !isCheckFreshFriend;
}

- (UIView *)freshFriendFlagView {
    
    if (!_freshFriendFlagView) {
        
        _freshFriendFlagView = [[UIView alloc] initWithFrame:CGRectMake(TYGetViewW(self.moreButton) - 10, TYGetMinY(self.moreButton), 8, 8)];
        
        [_freshFriendFlagView.layer setLayerCornerRadius:4];
        
        _freshFriendFlagView.backgroundColor = TYColorHex(0xFF0000);
        
        _freshFriendFlagView.hidden = YES;
        
        [self.moreButton addSubview:_freshFriendFlagView];
    }
    
    return _freshFriendFlagView;
}

-(BOOL)checkIsRealName{
    SEL checkIsRealName = NSSelectorFromString(@"checkIsRealName");
    IMP imp = [self.navigationController methodForSelector:checkIsRealName];
    BOOL (*func)(id, SEL) = (void *)imp;
    if (!func(self.navigationController, checkIsRealName)) {
        return NO;
    }else{
        return YES;
    }
}

#pragma mark - 切换首页按钮按下
- (void)goHomeButtonPressedWithProListModel:(JGJChatGroupListModel *)proListModel {
    
    JGJSwitchMyGroupsTool *tool = [JGJSwitchMyGroupsTool switchMyGroupsTool];
    
    [tool switchMyGroupsWithGroup_id:proListModel.group_id?:@"" class_type:proListModel.class_type?:@"" targetVc:self];

    
}

- (void)checkMyConnecAction {
    
    NSString *url = [NSString stringWithFormat:@"%@%@", JGJWebDiscoverURL,@"connection"];
    
    JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:url];
    
    [self.navigationController pushViewController:webVc animated:YES];
    
}


- (JGJNetWorkingStatusHeaderView *)netWorkingHeader {
    
    if (!_netWorkingHeader) {
        
        _netWorkingHeader = [[JGJNetWorkingStatusHeaderView alloc] init];
    }
    return _netWorkingHeader;
}

- (void)saveUserDefaults:(NSString *)badge
{
    NSString *version= [UIDevice currentDevice].systemVersion;
    
    if(version.doubleValue < 10.0) {
        
        return;
        
    }
    
    if ([NSString isEmpty:badge]) {
        
        badge = @"0";
    }
    
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:JGJShareSuiteName];
    
    [shared setObject:badge forKey:JGJShareSuiteNameKey];
    
    [shared synchronize];
}


@end
