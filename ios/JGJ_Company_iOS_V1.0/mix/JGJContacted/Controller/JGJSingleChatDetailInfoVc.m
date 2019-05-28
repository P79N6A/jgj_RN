//
//  JGJSingleChatDetailInfoVc.m
//  mix
//
//  Created by yj on 16/12/20.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJSingleChatDetailInfoVc.h"
#import "JGJCusSwitchMsgCell.h"
#import "JGJSingleChatDetailInfoHeadCell.h"
#import "JGJCustomButtonCell.h"
#import "JGJGroupChatDetailInfoAddMemberVc.h"
#import "JGJTabBarViewController.h"
#import "NSString+Extend.h"
#import "JGJPerInfoVc.h"
#import "JGJCommonTitleCell.h"
#import "JGJCustomPopView.h"

#import "JGJChatMsgDBManger.h"

#import "JGJChatMsgDBManger+JGJClearCacheDB.h"

#import "JGJChatMsgDBManger+JGJGroupDB.h"

#import "JGJChatListAllVc.h"

#import "JGJChatRootVc.h"

@interface JGJSingleChatDetailInfoVc () <JGJCustomButtonCellDelegate,JGJSingleChatDetailInfoHeadCellDelegate, JGJCusSwitchMsgCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *detailInfos; //消息免打扰和置顶信息
@property (nonatomic, strong) JGJTeamGroupInfoDetailRequest *infoDetailRequest; //请求详情页
@property (nonatomic, strong) JGJTeamInfoModel *singleDetaiInfo;
@property (nonatomic, strong) JGJModifyTeamInfoRequestModel *modifyTeamInfoRequestModel;
@property (nonatomic, strong) NSMutableArray *clearCache;//清除缓存组
@end

@implementation JGJSingleChatDetailInfoVc

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadGetGroupInfo];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 50.0;
    switch (indexPath.section) {
        case 0:{
            height = 110.0;
        }
            break;
        case 1:{
            height = 45.0;
            if (indexPath.row == 2) {
                height = 85.0;
            }else if (indexPath.row == 0) {
                
                NSString *myUid = [TYUserDefaults objectForKey:JLGUserUid];
                
                if ([self.singleDetaiInfo.group_info.group_id isEqualToString:myUid]) {
                    
                    height = 0;
                }
                
            }
        }
            break;
        default:
            break;
    }
    return height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger count = self.singleDetaiInfo.member_list.count;
    
    if (section == 1) {
        
        count = 2;
        
    }else if(section == 2){
        
        count = 1;
        
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    switch (indexPath.section) {
        case 0: {
            JGJSingleChatDetailInfoHeadCell *headCell = [JGJSingleChatDetailInfoHeadCell cellWithTableView:tableView];
            headCell.delegate = self;
            headCell.contactModel = [self.singleDetaiInfo.member_list firstObject];
            cell = headCell;
        }
            break;
        case 1:{
            if (indexPath.row == 2) {
                JGJCustomButtonCell *customButtonCell = [JGJCustomButtonCell cellWithTableView:tableView];
                JGJCustomButtonModel *customButtonModel = [[JGJCustomButtonModel alloc] init];
                customButtonModel.buttonTitle = @"删除聊天";
                customButtonModel.buttontype = JGJCustomDelChatButtonCell;
                customButtonModel.backColor = [UIColor whiteColor];
                customButtonModel.contentBackColor = AppFontf1f1f1Color;
                customButtonModel.titleColor = AppFont333333Color;
                customButtonModel.layerColor = [UIColor whiteColor];
                customButtonModel.isDefaulStyle = YES;
                customButtonCell.customButtonModel = customButtonModel;
                customButtonCell.delegate = self;
                cell = customButtonCell;
            }else {
                JGJCusSwitchMsgCell *switchMsgCell = [JGJCusSwitchMsgCell cellWithTableView:tableView];
                JGJChatDetailInfoCommonModel *detailInfoCommonModel = self.detailInfos[indexPath.row];
                detailInfoCommonModel.isOpen = indexPath.row == 0 ? self.singleDetaiInfo.is_no_disturbed : self.singleDetaiInfo.is_sticked;
                switchMsgCell.commonModel = detailInfoCommonModel;
                
                if (indexPath.row == 0) {
                    
                    NSString *myUid = [TYUserDefaults objectForKey:JLGUserUid];
                    
                    switchMsgCell.contentView.hidden = [self.singleDetaiInfo.group_info.group_id isEqualToString:myUid];
                    
                }
                switchMsgCell.delegate = self;
                cell = switchMsgCell;
            }
        }
            break;
            
        case 2:{
            
            cell = [self registerClearCacheCellWithTableView:tableView indexpath:indexPath];
            
        }
            break;
            
        default:
            break;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = AppFontf1f1f1Color;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = CGFLOAT_MIN;
    
    if (section == 1 || section == 2) {
        
        height = 10.0;
    }
    return height;
}

- (UITableViewCell *)registerClearCacheCellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)indexPath{
    
    JGJCommonTitleCell *cell = [JGJCommonTitleCell cellWithTableView:tableView];
    
    cell.lineView.hidden = YES;
    
    cell.desModel = self.clearCache[indexPath.row];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 2) {
        
        [self registerClearCacheWithTableView:tableView didSelectRowAtIndexPath:indexPath];
    }
    
}

- (void)registerClearCacheWithTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
    
    desModel.popDetail = @"确定清空聊天记录吗？";
    
    desModel.leftTilte = @"取消";
    
    desModel.rightTilte = @"确定";
    
    desModel.popTextAlignment = NSTextAlignmentCenter;
    
    JGJCustomPopView *alertView = [JGJCustomPopView showWithMessage:desModel];
    
    TYWeakSelf(self);
    
    alertView.onOkBlock = ^{
        
        [weakself clearChatMsgDB];
        
    };
}

#pragma mark - 清除数据库缓存
- (void)clearChatMsgDB {
    
    JGJChatMsgListModel *msgModel = [[JGJChatMsgListModel alloc] init];
    
    msgModel.class_type = self.workProListModel.class_type;
    
    msgModel.group_id = self.workProListModel.group_id;
    
    //现将要清除的消息id存入数据库，然后再删除
    
    msgModel = [JGJChatMsgDBManger maxMsgListModelWithChatMsgListModel:msgModel];
    
    JGJChatClearCacheModel *cacheModel = [JGJChatClearCacheModel mj_objectWithKeyValues:[msgModel mj_keyValuesWithKeys:@[@"class_type",@"group_id",@"msg_id"]]];
    
    [JGJChatMsgDBManger insertToCacheModelTableWithCacheModel:cacheModel];
    
    //清除消息表
    [JGJChatMsgDBManger delGroupMsgModel:msgModel];
    
    //移除数据源
    JGJChatListAllVc *msgListVc = [self getAllMsgListVc];
    
    if (msgListVc.dataSourceArray.count > 0) {
        
        [msgListVc.dataSourceArray removeAllObjects];
    }
    
    if (msgListVc.muSendMsgArray.count > 0) {
        
        [msgListVc.muSendMsgArray removeAllObjects];
    }
    
    [msgListVc.tableView reloadData];
    
    [TYShowMessage showSuccess:@"清空成功！"];
}

- (JGJChatListAllVc *)getAllMsgListVc {
    
    JGJChatListAllVc *chatAllVc = nil;
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        
        if ([vc isKindOfClass:[JGJChatRootVc class]]) {
            
            JGJChatRootVc *chatRootVc = (JGJChatRootVc *)vc;
            
            JGJChatRootChildVcModel *rootChildVcModel = (JGJChatRootChildVcModel *)chatRootVc.childVcs[0];
            
            chatAllVc = (JGJChatListAllVc *)rootChildVcModel.vc;
        }
    }
    
    return chatAllVc;
}

#pragma mark - JGJCusSwitchMsgCellDelegate
- (void)cusSwitchMsgCell:(JGJCusSwitchMsgCell *)cell switchType:(JGJCusSwitchMsgCellType)switchType {
    switch (switchType) {
        case JGJCusSwitchRepulseMsgCell:{
            [self JGJCusSwitchRepulseMsgCell:cell switchType:switchType];
        }
            break;
        case JGJCusSwitchStickMsgCell:{
            [self JGJCusSwitchStickMsgCell:cell switchType:switchType];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 回置顶或者取消打扰
#pragma mark - JGJSingleChatDetailInfoHeadCellDelegate
- (void)JGJSingleChatDetailInfoHeadCell:(JGJSingleChatDetailInfoHeadCell *)cell buttonType:(JGJSingleChatDetailInfoHeadCellButtonType)buttonType {
    switch (buttonType) {
        case JGJSingleChatDetailInfoHeadCellHeadPicButtonType:{ //进去个人页面
            if (![NSString isEmpty:cell.contactModel.uid]) {
                JGJPerInfoVc *perInfoVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJPerInfoVc"];
                perInfoVc.jgjChatListModel.uid = cell.contactModel.uid;
                perInfoVc.jgjChatListModel.group_id = self.workProListModel.group_id;
                perInfoVc.jgjChatListModel.class_type = self.workProListModel.class_type;
                if (self.workProListModel.is_find_job) {
                    perInfoVc.workProListModel = self.workProListModel;
                }
                [self.navigationController pushViewController:perInfoVc animated:YES];
            }
        }
            break;
        case JGJSingleChatDetailInfoHeadCellGroupButtonType: { //发起群聊
            JGJGroupChatDetailInfoAddMemberVc *addMemberVc  = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJGroupChatDetailInfoAddMemberVc"];
            addMemberVc.contactedAddressBookVcType = JGJSingleChatCreatGroupChatVcType; //单聊创建群聊
            self.workProListModel.cur_group_id = self.singleDetaiInfo.group_info.group_id; //当前人的id
            self.workProListModel.cur_class_type = self.singleDetaiInfo.group_info.class_type; //当前群类型
            addMemberVc.workProListModel = self.workProListModel;
            [self.navigationController pushViewController:addMemberVc animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 回置顶或者取消打扰
- (void)JGJCusSwitchRepulseMsgCell:(JGJCusSwitchMsgCell *)cell switchType:(JGJCusSwitchMsgCellType)switchType {
    NSString *is_not_disturbed = [NSString stringWithFormat:@"%@", @(cell.commonModel.isOpen)];
    NSIndexPath *indexpath = [self.tableView indexPathForCell:cell];
    NSDictionary *parameters = @{
                                 @"class_type" : @"singleChat",
                                 @"group_id" : self.workProListModel.group_id?:@"",
                                 @"is_not_disturbed" : is_not_disturbed};
    [TYLoadingHub showLoadingWithMessage:nil];
    
    __weak typeof(self) weakSelf = self;
    
    [JLGHttpRequest_AFN PostWithNapi:JGJGroupModifyURL parameters:parameters success:^(id responseObject) {
        
        weakSelf.singleDetaiInfo.is_no_disturbed = cell.commonModel.isOpen;
        
        [weakSelf.tableView beginUpdates];
        
        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
        
        [weakSelf.tableView endUpdates];
        
        [TYLoadingHub hideLoadingView];
        
        // 更新 消息免打扰
        JGJChatGroupListModel *groupListModel = [JGJChatMsgDBManger getChatGroupListModelWithGroup_id:weakSelf.workProListModel.group_id classType:weakSelf.workProListModel.class_type];
        
        groupListModel.is_no_disturbed = cell.commonModel.isOpen;
        
        [JGJChatMsgDBManger updateChatGroupListTableWithJGJChatMsgListModel:groupListModel];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
}

- (void)JGJCusSwitchStickMsgCell:(JGJCusSwitchMsgCell *)cell switchType:(JGJCusSwitchMsgCellType)switchType {
    NSIndexPath *indexpath = [self.tableView indexPathForCell:cell];
    TYLog(@"switchType=== %ld isOpen--- %@", switchType, @(cell.commonModel.isOpen));
    NSString *status = cell.commonModel.isOpen ? @"0" : @"1";
    
    NSDictionary *parameters = @{
                                 @"status" : status,
                                 
                                 @"class_type" : self.workProListModel.class_type?:@"",
                                 
                                 @"group_id" : self.workProListModel.group_id?:@""
                                 
                                 };
    
    __weak typeof(self) weakSelf = self;
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithNapi:@"chat/set-stick" parameters:parameters success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        self.singleDetaiInfo.is_sticked = cell.commonModel.isOpen;
        
        [self.tableView beginUpdates];
        
        [self.tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
        
        [self.tableView endUpdates];
        
        [JGJChatMsgDBManger updateIs_topToGroupTableWithIsTop:cell.commonModel.isOpen group_id:self.workProListModel.group_id class_type:self.workProListModel.class_type];
        
        
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
}

#pragma mark - 加载班组详情信息
- (void)loadGetGroupInfo {
    
    NSDictionary *parameters = [self.infoDetailRequest mj_keyValues];
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    __weak typeof(self) weakSelf = self;
    
    [JLGHttpRequest_AFN PostWithNapi:JGJGetGroupInfoURL parameters:parameters success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        JGJTeamInfoModel *singleDetaiInfo = [JGJTeamInfoModel mj_objectWithKeyValues:responseObject];
        singleDetaiInfo.group_info.class_type = weakSelf.workProListModel.class_type;
        
        weakSelf.singleDetaiInfo = singleDetaiInfo;
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
}

- (void)setSingleDetaiInfo:(JGJTeamInfoModel *)singleDetaiInfo {
    _singleDetaiInfo = singleDetaiInfo;
    [self.tableView reloadData];
}

- (JGJTeamGroupInfoDetailRequest *)infoDetailRequest {
    if (!_infoDetailRequest) {
        
        _infoDetailRequest = [[JGJTeamGroupInfoDetailRequest alloc] init];
        
        _infoDetailRequest.group_id = self.workProListModel.group_id;
        
        _infoDetailRequest.class_type = @"singleChat";
    }
    return _infoDetailRequest;
}

- (JGJModifyTeamInfoRequestModel *)modifyTeamInfoRequestModel {
    if (!_modifyTeamInfoRequestModel) {
        _modifyTeamInfoRequestModel = [[JGJModifyTeamInfoRequestModel alloc] init];
        _modifyTeamInfoRequestModel.ctrl = @"group";
        _modifyTeamInfoRequestModel.action = @"modifyGroupInfo";
        _modifyTeamInfoRequestModel.class_type = @"groupChat";
        _modifyTeamInfoRequestModel.group_id = self.workProListModel.group_id;
    }
    return _modifyTeamInfoRequestModel;
}

- (NSMutableArray *)detailInfos {
    
    NSArray *titles = @[@"消息免打扰", @"置顶聊天"];
    NSArray *switchTypes = @[@(JGJCusSwitchRepulseMsgCell), @(JGJCusSwitchStickMsgCell)];
    if (!_detailInfos) {
        _detailInfos = [NSMutableArray array];
        for (int indx = 0; indx < titles.count; indx ++) {
            JGJChatDetailInfoCommonModel *commonModel  = [JGJChatDetailInfoCommonModel new];
            commonModel.switchMsgType = [switchTypes[indx] integerValue];
            commonModel.title = titles[indx];
            commonModel.isOpen = NO;
            [_detailInfos addObject:commonModel];
        }
    }
    return _detailInfos;
}

- (NSMutableArray *)clearCache {
    
    if (!_clearCache) {
        
        _clearCache = [NSMutableArray array];
        
        NSArray *titles = @[@"清空聊天记录"];
        
        for (int indx = 0; indx < titles.count; indx ++) {
            
            JGJCreatTeamModel *teamModel = [[JGJCreatTeamModel alloc] init];
            
            teamModel.title = titles[indx];
            
            [_clearCache addObject:teamModel];
            
        }
    }
    
    return _clearCache;
}

@end

