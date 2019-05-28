//
//  JGJCheckGroupChatAllMemberVc.m
//  mix
//
//  Created by yj on 16/12/26.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJCheckGroupChatAllMemberVc.h"
#import "JGJGroupChatMemberCollectionViewCell.h"
#import "JGJPerInfoVc.h"
#import "JGJGroupChatListVc.h"
#import "JGJGroupChatDetailInfoAddMemberVc.h"
#import "JGJAddTeamMemberVC.h"
#import "NSString+Extend.h"
#import "TYTextField.h"

#import "JGJCustomPopView.h"

#import "JGJSureOrderListViewController.h"

#import "JGJCustomAlertView.h"

#import "JGJGroupMangerTool.h"

#import "JGJTeamMemberCollectionViewCell.h"

#import "JGJCustomProInfoAlertVIew.h"

#import "CFRefreshStatusView.h"

#import "JGJMemberSelTypeVc.h"

#import "JGJKnowledgeDaseTool.h"

#import "JGJTeamDetailCommonPopView.h"

#import "JGJUnhandleSourceListVC.h"

static NSString *const TeamMemberCollectionViewCellID = @"JGJTeamMemberCollectionViewCell";

#define ItemWidth 70

#define ItemHeight (ItemWidth + 20)

#define LinePadding  (TYIS_IPHONE_5_OR_LESS ? 5 : (TYIS_IPHONE_6 ? 10 : 18))

#define HeaderHegiht 40

#define LineMargin 10  //行间距

#define ItemSpacing (TYIS_IPHONE_5_OR_LESS ? 6 : 16)

@interface JGJCheckGroupChatAllMemberVc ()<
UICollectionViewDataSource,
UICollectionViewDelegate,
JGJGroupChatMemberCollectionViewCellDelegate,
JGJAddTeamMemberDelegate,
JGJTeamMemberCollectionViewCellDelegate,

JGJTeamDetailCommonPopViewDelagate,

JGJUnhandleSourceListVCDelegate
>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (strong, nonatomic) JGJRemoveGroupMemberRequestModel *removeGroupMemberRequestModel;
@property (strong, nonatomic) NSMutableArray *removeMembers;//移除的成员

@property (weak, nonatomic) IBOutlet JGJCustomSearchBar *cusSearchBar;

@property (strong, nonatomic) NSArray *searhMemberModels;

@property (strong, nonatomic) NSArray *allMemberModels;

@property (strong, nonatomic) JGJAddGroupMemberRequestModel *addGroupMemberRequestModel;

@property (nonatomic, strong) JGJTeamGroupInfoDetailRequest *infoDetailRequest; //请求详情页

@property (nonatomic, strong)  CFRefreshStatusView *statusView;

//分享菜单
@property (nonatomic, strong) JGJKnowledgeDaseTool *shareMenuTool;

//是否是代理班组长
@property (nonatomic, assign) BOOL isAgency;

@end

@implementation JGJCheckGroupChatAllMemberVc
//static NSString *const JGJGroupChatMemberCollectionViewCellID = @"JGJGroupChatMemberCollectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"JGJTeamMemberCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:TeamMemberCollectionViewCellID];
    self.layout.itemSize = CGSizeMake(ItemWidth, ItemHeight);
    
    CGFloat padding = TYIST_IPHONE_X ? 10 : LinePadding;
    
    self.layout.sectionInset = UIEdgeInsetsMake(0, padding, 0, padding);
    self.layout.minimumInteritemSpacing = 0;
    self.layout.minimumLineSpacing = 0;

    [self initialTopSearchbar];

    [TYLoadingHub showLoadingWithMessage:nil];
    
    NSString *title = @"所有成员";
    
    if (self.commonModel.memberType == JGJProSourceMemberType) {
        
        title = [NSString stringWithFormat:@"所有数据来源人(%@)",@(_teamInfo.source_members.count)];
        
    }
    
    self.title = title;
    
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
//    self.cusSearchBar.searchBarTF.text = nil;
    
    [self loadProMember];

}

- (void)loadProMember {
    
    NSDictionary *parameters = [self.infoDetailRequest mj_keyValues];
    
    [JLGHttpRequest_AFN PostWithNapi:JGJGetMembersListURL parameters:parameters success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        NSMutableArray *members = [JGJSynBillingModel mj_objectArrayWithKeyValuesArray:responseObject];
        
        if (self.commonModel.memberType == JGJProSourceMemberType) {
            
            //获取数据来源人,
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"is_source_member == %@", @(YES)];
            
            members = [members filteredArrayUsingPredicate:predicate].mutableCopy;
        }
        
        JGJTeamInfoModel *teamInfoModel = [[JGJTeamInfoModel alloc] init];
        
        if (self.commonModel.memberType == JGJProSourceMemberType) {
            
            teamInfoModel.source_members = members;
            
        }else {
            
            teamInfoModel.member_list = members;
        }
        
        [self setTitleCount:members.count];
        
        //防止闪烁
        if (self.commonModel.memberType == JGJProSourceMemberType) {
            
            if (_teamInfo.source_members.count == members.count) {
                
                return ;
            }

        }else {
            
            if (_teamInfo.member_list.count == members.count) {
                
                return ;
            }
            
        }
        
        teamInfoModel.creater_uid = self.teamInfo.creater_uid;
        
        NSString *myuid = [TYUserDefaults objectForKey:JLGUserUid];
        
        teamInfoModel.is_creater = [NSString stringWithFormat:@"%@", @([myuid isEqualToString:self.teamInfo.creater_uid])];
        
        teamInfoModel.creater_uid = self.teamInfo.creater_uid;
        
        teamInfoModel.is_admin = self.teamInfo.is_admin;
        
        JGJGroupInfoModel *group_info = [JGJGroupInfoModel new];
        
        group_info.class_type = self.workProListModel.class_type;
        
        teamInfoModel.group_info = group_info;
        
        self.teamInfo = teamInfoModel;
        
        
    } failure:^(NSError *error) {
        
         [TYLoadingHub hideLoadingView];
        
    }];
    
}

- (void)setTeamInfo:(JGJTeamInfoModel *)teamInfo {
    
    _teamInfo = teamInfo;
    
    self.memberModels = [NSMutableArray new];
    
    NSInteger count = _teamInfo.member_list.count;
    
    if (self.commonModel.memberType == JGJProSourceMemberType) {
        
        [self.memberModels addObjectsFromArray:_teamInfo.source_members];
        
        count = _teamInfo.source_members.count;
        
    }else {
        
        [self.memberModels addObjectsFromArray:_teamInfo.member_list];
    }
    
    NSArray *mangerModels = [self accordTypeGetMangerModels:_teamInfo]; //根据条件得到添加删除选项
    
    [self.memberModels addObjectsFromArray:mangerModels];
    
    self.allMemberModels = self.memberModels.copy;
    
    [self setTitleCount:count];
    
    [self.collectionView reloadData];
    
}

- (void)setTitleCount:(NSInteger)count {
    
    NSString *title = [NSString stringWithFormat:@"所有成员(%@)", @(count)];
    
    if ([_teamInfo.group_info.class_type isEqualToString:@"groupChat"]) {
        
        _teamInfo.members_num = [NSString stringWithFormat:@"%@", @(count)];
        
        title = [NSString stringWithFormat:@"群成员(%@)",  @(count)];
    }
    
    if (self.commonModel.memberType == JGJProSourceMemberType) {
        
        title = [NSString stringWithFormat:@"所有数据来源人(%@)",@(count)];
        
    }
    
    if (count >= 0) {
       
        self.title = title;
        
    }
    
}

- (void)initialTopSearchbar {
    
    self.cusSearchBar.searchBarTF.placeholder = @"请输入名字进行查找";
    
    self.cusSearchBar.searchBarTF.clearButtonMode = UITextFieldViewModeAlways;
    
    self.cusSearchBar.searchBarTF.maxLength = 20;
    
    __weak typeof(self) weakSelf = self;
    
    self.cusSearchBar.searchBarTF.valueDidChange = ^(NSString *value){
        
        if ([NSString isEmpty:value]) {
            
            weakSelf.memberModels = weakSelf.allMemberModels.copy;
            
            weakSelf.cusSearchBar.searchBarTF.text = nil;
            
            [weakSelf.cusSearchBar.searchBarTF resignFirstResponder];
            
            if (weakSelf.statusView) {
                
                [weakSelf.statusView removeFromSuperview];
            }
            
        }else {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"real_name contains  %@", value];
            
            weakSelf.memberModels = [_teamInfo.member_list filteredArrayUsingPredicate:predicate].mutableCopy;
            
            if (weakSelf.memberModels.count == 0) {
                
                if (!weakSelf.statusView) {
                    
                    CFRefreshStatusView *statusView = [[CFRefreshStatusView alloc] initWithImage:PNGIMAGE(@"NoDataDefault_NoManagePro") withTips:@"未搜索到相关内容"];
                    weakSelf.statusView = statusView;
                    statusView.frame = weakSelf.collectionView.bounds;
                    statusView.y = 48;
                }
                
                [weakSelf.view addSubview:weakSelf.statusView];
                
            }else {
                
                if (weakSelf.statusView) {
                    
                    [weakSelf.statusView removeFromSuperview];
                }
            }
            
            [weakSelf.collectionView reloadData];
        }
        
    };
    
}

- (void)setSearhMemberModels:(NSArray *)searhMemberModels {
    
    [self.collectionView reloadData];
}

- (void)setMemberModels:(NSMutableArray *)memberModels {
    
    _memberModels = memberModels;
    
    [self.collectionView reloadData];
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.memberModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    JGJTeamMemberCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TeamMemberCollectionViewCellID forIndexPath:indexPath];
    
    //    ShowAddTeamMemberFlagType = 1, //仅显示添加图片
    //    ShowAddAndRemoveTeamMemberFlagType, //显示添加移除标记图片
    
    cell.memberFlagType = (self.teamInfo.is_admin || [self.teamInfo.is_creater boolValue] || _isAgency) ? ShowAddAndRemoveTeamMemberFlagType :  ShowAddTeamMemberFlagType;
    
    cell.commonModel = self.commonModel;
    
    cell.searchValue = self.cusSearchBar.searchBarTF.text;
    
    JGJSynBillingModel *memberModel = nil;
    if (self.memberModels.count > 0) {
        
        memberModel = self.memberModels[indexPath.row];
        
        cell.teamMemberModel = memberModel;
    }
    
    cell.headButton.userInteractionEnabled = NO;
    
    cell.delegate = self;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    JGJSynBillingModel *memberModel = self.memberModels[indexPath.item];
    
    self.commonModel.teamModelModel = memberModel;
    
    //点击的是数据来源人,去掉加减号
    if (self.commonModel.memberType == JGJProSourceMemberType && !memberModel.isAddModel && !memberModel.isRemoveModel) {
        
        [self clickedSourceMember:self.commonModel];
        
        return;
    }
    
    if ([memberModel.is_active isEqualToString:@"1"]) { //都能点击
        
        [self handleDidSelectedMemberWithMemberModel:memberModel];
        
    }else if ([memberModel.is_active isEqualToString:@"0"] && !memberModel.isMangerModel) {
        
        [self handleJGJUnRegisterTeamModel: self.commonModel];
        
    }else if (memberModel.isAddModel) {
        
        [self handleAddMember];
        
    }else if (memberModel.isRemoveModel) {
        
        [self handleRemoveMember];
        
    }
}

#pragma mark - JGJTeamMemberCollectionViewCellDelegate  不是我们平台成员弹框

- (void)handleJGJUnRegisterTeamModel:(JGJTeamMemberCommonModel *)commonModel {
    
    [self handleUnRegisterMemberCellWithTeamModel:commonModel];
}

#pragma mark - 点击不是我们平台成员弹框
- (void)handleUnRegisterMemberCellWithTeamModel:(JGJTeamMemberCommonModel *)commonModel {
    
    if(self.workProListModel.isClosedTeamVc){
        
        return;
    }
    
    if ([commonModel.teamModelModel.is_active isEqualToString:@"0"]) {
        
        commonModel.alertViewHeight = 210.0;
        
        commonModel.alertmessage = @"该用户还未注册,赶紧邀请他下载[吉工家]一起使用吧！";
        
        commonModel.alignment = NSTextAlignmentLeft;
        
        JGJCustomProInfoAlertVIew *alertView = [JGJCustomProInfoAlertVIew alertViewWithCommonModel:commonModel];
        
        if (!self.shareMenuTool) {
            
            self.shareMenuTool = [[JGJKnowledgeDaseTool alloc] init];
            
            self.shareMenuTool.targetVc  = self;
            
            self.shareMenuTool.isUnCanShareCount = YES; //不清零
        }
        
        __weak typeof(self) weakSelf = self;
        
        alertView.confirmButtonBlock = ^{
            
            NSString *img = [NSString stringWithFormat:@"%@%@", JLGHttpRequest_IP_center, @"media/default_imgs/logo.jpg"];
            
            NSString *uid = [TYUserDefaults objectForKey:JLGUserUid];
            
            NSString *url =[NSString stringWithFormat:@"%@page/open-invite.html?uid=%@&plat=person", JGJWebDiscoverURL,uid];;
            
            NSString *title = @"我正在用招工找活、记工记账神器：吉工家APP";
            
            NSString *desc = @"1200万建筑工友都在用！下载注册就送100积分抽百元话费！";
            
            [weakSelf.shareMenuTool showShareBtnClick:img desc:desc title:title url:url];
        };
        
        
    } else if ([commonModel.teamModelModel.is_active isEqualToString:@"1"]) {
        
        [self handleDidSelectedMemberWithMemberModel:commonModel.teamModelModel];
        
    }
}


#pragma mark -点击班组成员是我们平台注册人员进入资料页
- (void)handleDidSelectedMemberWithMemberModel:(JGJSynBillingModel *)memberModel {
    
    JGJPerInfoVc *perInfoVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJPerInfoVc"];
    perInfoVc.jgjChatListModel.uid = memberModel.uid;
    perInfoVc.jgjChatListModel.group_id = self.workProListModel.group_id;
    perInfoVc.jgjChatListModel.class_type = self.workProListModel.class_type;
    [self.navigationController pushViewController:perInfoVc animated:YES];
}

#pragma mark - 添加人员
- (void)handleAddMember {
    
    //只有项目添加人员才弹框
    if ([self showPopView]) {
        
        return;
    }
    
    //班组项目组添加
    if (self.allMemberVcType == CheckAllMemberVcGroupMangerType || self.allMemberVcType == CheckAllMemberVcTeamMangerType) {
        
        [self addGroupMangermember];
        
    }else {
        
        JGJGroupChatDetailInfoAddMemberVc *addMemberVc  = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJGroupChatDetailInfoAddMemberVc"];
        
        addMemberVc.contactedAddressBookVcType = JGJContactedAddressBookAddMembersVcType;
        
        addMemberVc.teamInfo = self.teamInfo;//已存在人员也要显示
        
        addMemberVc.workProListModel = self.workProListModel;
        
        [self.navigationController pushViewController:addMemberVc animated:YES];
    }
    
}

#pragma mark - 移除人员
- (void)handleRemoveMember {
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    JGJSynBillingCommonModel *synBillingCommonModel = [[JGJSynBillingCommonModel alloc] init];
    JGJAddTeamMemberVC *removeMemberVC = [[UIStoryboard storyboardWithName:@"JGJCreatTeam" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJAddTeamMemberVC"];
    removeMemberVC.delegate = self;
    synBillingCommonModel.synBillingTitle = @"删除成员";
    removeMemberVC.groupMemberMangeType = JGJGroupMemberMangeRemoveMemberType;
    removeMemberVC.currentTeamMembers = [self handleGetRemoveMembers];
    removeMemberVC.synBillingCommonModel = synBillingCommonModel;
    [self.navigationController pushViewController:removeMemberVC animated:YES];
    
    [TYLoadingHub hideLoadingView];
}

#pragma mark - 处理得到移除的成员
- (NSArray *)handleGetRemoveMembers{
    NSString *myUid = [TYUserDefaults objectForKey:JLGUserUid];
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isMangerModel != %@ AND is_creater == %@ AND uid != %@", @(YES), @"0", myUid];
    
    //部分路径进入没有创建者id
    NSPredicate *creatPredicate = [NSPredicate predicateWithFormat:@"is_creater == %@", @"1"];
    
    if (self.memberModels.count > 0) {
        
        NSArray *creatMembers = [self.memberModels filteredArrayUsingPredicate:creatPredicate];
        
        if (creatMembers.count > 0) {
            
            JGJSynBillingModel *creatMember = creatMembers.firstObject;
            
            if (![NSString isEmpty:creatMember.uid]) {
                
                _teamInfo.creater_uid = creatMember.uid;
                
            }
            
        }
        
    }
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"is_creater != %@ AND uid != %@ AND isMangerModel != %@ AND is_source_member = %@ AND is_agency != %@", @"1", myUid, @(YES), @(NO), @(YES)];
    
    self.teamInfo.is_creater = [NSString stringWithFormat:@"%@", @([_teamInfo.creater_uid isEqualToString:myUid])];
    
    BOOL isCreater = [self.teamInfo.is_creater boolValue];
    
    if (isCreater) {
        
        predicate = [NSPredicate predicateWithFormat:@"is_creater != %@ AND uid != %@ AND isMangerModel != %@", @"1", myUid, @(YES)];
        
    }else
    
        if (self.commonModel.memberType == JGJProSourceMemberType) {
            
            predicate = [NSPredicate predicateWithFormat:@"is_creater != %@ AND uid != %@ AND isMangerModel != %@ AND is_admin == %@ AND is_source_member = %@", @"1", myUid, @(YES), @(NO), @(YES)];
        }
        
//    if (self.teamInfo.team_info.is_admin && !isCreater) {
//
//        predicate = [NSPredicate predicateWithFormat:@"is_creater != %@ AND uid != %@ AND isMangerModel != %@ AND is_admin == %@ AND is_source_member = %@", @"1", myUid, @(YES), @(NO), @(NO)];
//
//    }
    
    NSArray *contacts = [self.memberModels filteredArrayUsingPredicate:predicate];
    
    return contacts;
}

#pragma mark - 去掉添加和移除模型
- (NSArray *)handleGetAddMembers {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isMangerModel != %@", @(YES)];
    
    NSArray *contacts = [self.memberModels filteredArrayUsingPredicate:predicate];
    
    return contacts;
    
}

#pragma mark - JGJGroupMemberMangeDelegate 返回删除和添加的成员
- (void)handleJGJGroupMemberSelectedTeamMembers:(NSMutableArray *)teamsMembers groupMemberMangeType:(JGJGroupMemberMangeType)groupMemberMangeType {
    switch (groupMemberMangeType) {
        case JGJGroupMemberMangePushNotifyType:
        case JGJGroupMemberMangeAddMemberType:{
            [self getAddTeamMembers:teamsMembers groupMemberMangeType:JGJGroupMemberMangeAddMemberType]; //上传班组成员信息
        }
            
            break;
        case JGJGroupMemberMangeRemoveMemberType:
            [self upLoadRemoveGroupMembers:teamsMembers groupMemberMangeType:JGJGroupMemberMangeRemoveMemberType];
            break;
        default:
            break;
    }
}

#pragma mark - 移除班组成员
- (void)upLoadRemoveGroupMembers:(NSMutableArray *)teamMembers groupMemberMangeType:(JGJGroupMemberMangeType)groupMemberMangeType {
    self.removeMembers = teamMembers;
    NSMutableArray *uidArr = [NSMutableArray array];
    
    for (JGJSynBillingModel *teamMemberModel in teamMembers) {
        
        teamMemberModel.isSelected = NO;
        
        teamMemberModel.isAddedSyn = NO; //清楚返回的选择和添加状态
        
        if (![NSString isEmpty:teamMemberModel.uid]) {
            
            [uidArr addObject:teamMemberModel.uid];
        }
        
    }
    
    NSString *uids = [uidArr componentsJoinedByString:@","];
    
    self.removeGroupMemberRequestModel.uid = uids;
    
    NSDictionary *parameters = [self.removeGroupMemberRequestModel mj_keyValues];
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithNapi:JGJGroupDelMembersURL parameters:parameters success:^(id responseObject) {
        
        //回调首页使用，成员人数改变使用
        
        if (self.successBlock) {
            
            self.successBlock(responseObject);
        }
        
        [TYLoadingHub hideLoadingView];
        
        [TYShowMessage showSuccess:@"删除成功"];
        
         [self loadProMember];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
}

#pragma mark - 获取成员信息
- (void)getAddTeamMembers:(NSMutableArray *)teamMembers groupMemberMangeType:(JGJGroupMemberMangeType)groupMemberMangeType {
    NSMutableArray *groupMembersInfos = [NSMutableArray array];
    for (JGJSynBillingModel *teamMemberModel in teamMembers) { //添加返回的成员需要上传的信息
        JGJGroupMembersRequestModel *membersModel = [[JGJGroupMembersRequestModel alloc] init];
        membersModel.real_name = teamMemberModel.real_name;
        membersModel.telephone = teamMemberModel.telephone;
        membersModel.uid = teamMemberModel.uid;
        teamMemberModel.isAddedSyn = YES;
        teamMemberModel.isSelected = NO;
        [groupMembersInfos addObject:membersModel];
    } //获取姓名和电话
    [self handleUploadTeamMembers:groupMembersInfos groupMemberMangeType:groupMemberMangeType];
}

#pragma mark - 上传班组成员信息
- (void)handleUploadTeamMembers:(NSMutableArray *)groupMembersInfos groupMemberMangeType:(JGJGroupMemberMangeType)groupMemberMangeType {
    
    __weak typeof(self) weakSelf = self;
    
    NSString *requestApi = JGJAddMembersURL;
    
    NSMutableDictionary *parameters = [self.addGroupMemberRequestModel mj_keyValues];
    
    NSString *group_members = @"";
    
    NSString *source_members = @"";
    
    if (self.commonModel.memberType == JGJProSourceMemberType || groupMemberMangeType == JGJGroupMemberMangePushNotifyType) {
        
        self.addGroupMemberRequestModel.source_members = groupMembersInfos;
        
        self.addGroupMemberRequestModel.team_members = nil;
        
        source_members = [[JGJGroupMembersRequestModel mj_keyValuesArrayWithObjectArray:self.addGroupMemberRequestModel.source_members] mj_JSONString];
        
        requestApi = JGJGroupAddSourceMemberURL;
        
    } else {
        
        
        self.addGroupMemberRequestModel.group_members = groupMembersInfos;
        
        self.addGroupMemberRequestModel.source_members = nil;
        
        group_members = [[JGJGroupMembersRequestModel mj_keyValuesArrayWithObjectArray:self.addGroupMemberRequestModel.group_members] mj_JSONString];
        
    }
    
    parameters = [self.addGroupMemberRequestModel mj_keyValuesWithIgnoredKeys:@[@"group_members", @"source_members"]];
    
    if (![NSString isEmpty:group_members]) {
        
        parameters[@"group_members"] = group_members;
    }
    
    if (![NSString isEmpty:source_members]) {
        
        parameters[@"source_members"] = source_members;
    }
    
    [JLGHttpRequest_AFN PostWithNapi:requestApi parameters:parameters success:^(id responseObject) {
        
        //回调首页使用，成员人数改变使用
        
        [TYShowMessage showSuccess:@"添加成功"];
        
        if (self.successBlock) {
            
            self.successBlock(responseObject);
        }
        
        [self loadProMember];
        
    } failure:^(NSError *error) {
        
        
    }];
}

#pragma mark - 删除成功去掉显示成员
- (void)upLoadTeamMembersSuccessShowTeamsAllMembers {
    NSMutableArray *allmembers = self.memberModels;
    for (NSUInteger indx = self.removeMembers.count; indx > 0; indx--) {
        JGJSynBillingModel *meberModel = self.memberModels[indx];
        [allmembers removeObject:meberModel];
    }
    NSUInteger memberNum = [self.workProListModel.members_num integerValue];
    memberNum = memberNum - self.removeMembers.count;
    self.teamInfo.members_num = [NSString stringWithFormat:@"%@", @(memberNum)];

    self.memberModels = allmembers;
    
    NSString *title = [NSString stringWithFormat:@"所有成员(%@)", @(memberNum)];
    
    if ([_teamInfo.group_info.class_type isEqualToString:@"groupChat"]) {
        
        _teamInfo.members_num = [NSString stringWithFormat:@"%@", @(memberNum)];
        
        title = [NSString stringWithFormat:@"群成员(%@)",  @(memberNum)];
    }
    
    self.title = title;
}

- (JGJRemoveGroupMemberRequestModel *)removeGroupMemberRequestModel {
    
    if (!_removeGroupMemberRequestModel) {
        _removeGroupMemberRequestModel = [[JGJRemoveGroupMemberRequestModel alloc] init];
        
        if ([self.workProListModel.class_type isEqualToString:@"team"]) {
            
            _removeGroupMemberRequestModel.ctrl = self.workProListModel.class_type;
            
            _removeGroupMemberRequestModel.group_id = self.workProListModel.group_id;
        }else {
            
            _removeGroupMemberRequestModel.ctrl = @"group";
            
            _removeGroupMemberRequestModel.group_id = self.workProListModel.group_id;
        }
        
        _removeGroupMemberRequestModel.action = @"delMembers";
        
        _removeGroupMemberRequestModel.class_type = self.workProListModel.class_type ?:@"groupChat";
    }
    return _removeGroupMemberRequestModel;
}

#pragma mark - 处理项目建群
- (void)handleSelectedWorkCircleCreatGroup {
    JGJGroupChatListVc *groupChatListVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJGroupChatListVc"];
    groupChatListVc.groupChatListVcType = JGJGroupChatListWorkVcType;
    groupChatListVc.chatType = JGJGroupChatType;
    [self.navigationController pushViewController:groupChatListVc animated:YES];
}


#pragma mark - 处理对应点的弹框

- (BOOL)showPopView {
        
    if (![self.teamInfo.group_info.class_type isEqualToString:@"team"]) {
        
        return NO;
    }
    
    self.teamInfo.cur_member_num = self.teamInfo.members_num.integerValue;
    
    self.workProListModel.is_senior_expire = self.teamInfo.team_info.is_senior_expire;
    
//    self.workProListModel.is_cloud_expire = self.teamInfo.team_info.is_cloud_expire;
    
    self.workProListModel.is_degrade = self.teamInfo.team_info.is_degrade;
    
    JGJGroupMangerTool *mangerTool = [[JGJGroupMangerTool alloc] init];
    
    mangerTool.workProListModel = self.workProListModel;
    
    mangerTool.teamInfo = self.teamInfo;
    
    mangerTool.targetVc = self.navigationController;
    
    return mangerTool.isPopView;
}

#pragma mark - 项目管理添加人员
- (void)addGroupMangermember {
    
    //班组项目组添加页面
    [self addMemberSelTypeVcCommonModel:self.commonModel];
    
}

#pragma mark - 添加成员
- (void)addMemberSelTypeVcCommonModel:(JGJTeamMemberCommonModel *)commonModel {
    
    JGJMemberSelTypeVc *selTypeVc = [JGJMemberSelTypeVc new];
    
    selTypeVc.workProListModel = self.workProListModel;
    
    selTypeVc.teamInfo = self.teamInfo;
    
    selTypeVc.commonModel = commonModel;
    
    //班组项目组添加
    if ([self.workProListModel.class_type isEqualToString:@"group"]) {
        
        selTypeVc.contactedAddressBookVcType = JGJGroupMangerAddMembersVcType;
        
    }else if ([self.workProListModel.class_type isEqualToString:@"team"]) {
        
        selTypeVc.contactedAddressBookVcType = JGJTeamMangerAddMembersVcType;
    }
    
    selTypeVc.targetVc = self;
    
    [self.navigationController pushViewController:selTypeVc animated:YES];
    
}

#pragma mark - 初始化添加班组成员网络请求模型
- (JGJAddGroupMemberRequestModel *)addGroupMemberRequestModel {
    
    if (!_addGroupMemberRequestModel) {
        
        _addGroupMemberRequestModel = [[JGJAddGroupMemberRequestModel alloc] init];
        
        _addGroupMemberRequestModel.is_qr_code = self.commonModel.memberType == JGJProMemberType ? @"0" : nil;
        
        _addGroupMemberRequestModel.group_id = self.workProListModel.group_id;
        
    }
    return _addGroupMemberRequestModel;
}

- (JGJTeamGroupInfoDetailRequest *)infoDetailRequest {
    
    if (!_infoDetailRequest) {
        _infoDetailRequest = [[JGJTeamGroupInfoDetailRequest alloc] init];
        _infoDetailRequest.group_id = self.workProListModel.group_id;
//        _infoDetailRequest.ctrl = [self.workProListModel.class_type isEqualToString:@"groupChat"] ? @"group" : @"team";
//        _infoDetailRequest.action = [self.workProListModel.class_type isEqualToString:@"groupChat"] ? @"getGroupInfo" : @"getMemberList";
        
        _infoDetailRequest.class_type = self.workProListModel.class_type;
    }
    return _infoDetailRequest;
}

#pragma mark - 根据条件类型返回添加和删除模型
- (NSMutableArray *)accordTypeGetMangerModels:(JGJTeamInfoModel *)teamInfo {
    
    NSMutableArray *dataSource = [NSMutableArray array];
    if (self.workProListModel.isClosedTeamVc == YES) {
        return dataSource;
    }
    NSArray *picNames = @[@"menber_add_icon", @"member_ minus_icon"];
    NSArray *titles = @[@"添加", @"删除"];
    NSInteger count = 0;
    
    NSString *myUid = [TYUserDefaults objectForKey:JLGUserUid];
    
    if (![NSString isEmpty:_teamInfo.agency_group_user.uid]) {
        
        self.isAgency = [_teamInfo.agency_group_user.uid isEqualToString:myUid];
    }
    
    if (teamInfo.is_admin || [teamInfo.creater_uid isEqualToString:myUid] || self.isAgency) {
        
        count = 2;
        
    }else {
        
        count = 1;
    }
    
    for (int idx = 0; idx < count; idx ++) {
        JGJSynBillingModel *memberModel = [[JGJSynBillingModel alloc] init];
        memberModel.isMangerModel = YES;
        if (idx == 0) {
            memberModel.addHeadPic = picNames[0];
            memberModel.isAddModel = YES;
        }
        if (idx == 1) {
            memberModel.removeHeadPic = picNames[1];
            memberModel.isRemoveModel = YES;
        }
        memberModel.name = titles[idx];
        [dataSource addObject:memberModel];
    }
    return dataSource;
}

#pragma mark - JGJTeamDetailCommonPopViewDelagate  关联本地项目
- (void)teamDetailCommonPopView:(JGJTeamDetailCommonPopView *)popView {
    JGJUnhandleSourceListVC *sourceListVC = [[UIStoryboard storyboardWithName:@"JGJCreatTeam" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJUnhandleSourceListVC"];
    sourceListVC.synProFirstModel = popView.synProFirstModel;
    sourceListVC.teamMemberModel = popView.commonModel.teamModelModel;
    sourceListVC.skipVC = self;
    sourceListVC.delegate = self;
    sourceListVC.sourceTeamType = JGJExistSourceTeamType;
    [self.navigationController pushViewController:sourceListVC animated:YES];
}


- (void)teamDetailCommonPopViewCancelButtonPressed:(JGJTeamDetailCommonPopView *)popView {
    //    [self loadGetGroupInfo];
}

#pragma mark - 点击数据来源人姓名跳转到个人聊页面
- (void)teamDetailCommonPopViewWithpopView:(JGJTeamDetailCommonPopView *)popView didSelectedMember:(JGJSynBillingModel *)memberModel {
    if ([memberModel.is_active isEqualToString:@"0"]) {
        [TYShowMessage showPlaint:@"TA还没注册，没有更多资料了"];
        return;
    }
    [self handleDidSelectedMemberWithMemberModel:memberModel];
}

#pragma mark - JGJUnhandleSourceListVCDelegate
- (void)JGJUnhandleSourceListVcConfirmButtonPressed:(JGJUnhandleSourceListVC *)sourceListVC {
    JGJGroupMembersRequestModel *membersModel = [[JGJGroupMembersRequestModel alloc] init];
    membersModel.real_name = sourceListVC.teamMemberModel.real_name;
    membersModel.telephone = sourceListVC.teamMemberModel.telephone;
    membersModel.uid = sourceListVC.teamMemberModel.uid;
    membersModel.is_demand = sourceListVC.teamMemberModel.is_demand;
    self.addGroupMemberRequestModel.source_members = @[membersModel];
    self.addGroupMemberRequestModel.source_pro_id = sourceListVC.teamMemberModel.source_pro_id;
    
    NSMutableDictionary *parameters = [self.addGroupMemberRequestModel mj_keyValuesWithIgnoredKeys:@[@"source_members"]];
    
    NSString *source_members = [[JGJGroupMembersRequestModel mj_keyValuesArrayWithObjectArray:self.addGroupMemberRequestModel.source_members] mj_JSONString];
    
    if (![NSString isEmpty:source_members]) {
        
        parameters[@"source_members"] = source_members;
    }
    
    [JLGHttpRequest_AFN PostWithNapi:JGJGroupAddSourceMemberURL parameters:parameters success:^(id responseObject) {
        
        [self.navigationController popToViewController:sourceListVC.skipVC animated:YES];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 点击的是数据来源人弹出的消息
- (void)clickedSourceMember:(JGJTeamMemberCommonModel *)commonModel {
    
    if(commonModel.memberType == JGJProSourceMemberType) {
        
        if ([commonModel.teamModelModel.synced isEqualToString:@"1"]) {
            commonModel.alertViewHeight = 190.0;
            commonModel.alertmessage = @"暂时还没有关联的项目";
            commonModel.alignment = NSTextAlignmentCenter;
            commonModel.isHidden = NO;
        } else {
            commonModel.alertmessage = @"该用户还未同意向你同步项目";
            commonModel.alertViewHeight = 150.0;
            commonModel.isHidden = YES;
            commonModel.alignment = NSTextAlignmentCenter;
        }
        commonModel.workProListModel = self.workProListModel;
        JGJTeamDetailCommonPopView *popView = [JGJTeamDetailCommonPopView popViewWithCommonModel:commonModel];
        popView.delegate = self;
    }
}

@end
