//
//  JGJCreatProAddMemberVC.m
//  JGJCompany
//
//  Created by yj on 16/9/21.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJCreatProAddMemberVC.h"
#import "JGJTeamMemberCell.h"
#import "JGJAddTeamMemberVC.h"
#import "JGJCreatProAddMemberDescCell.h"
#import "JGJCreatProAddDataSourceVC.h"
#import "NSString+Extend.h"
#import "JGJDataSourceMemberPopView.h"
#import "JGJTeamDetailCommonPopView.h"
#import "JGJChatRootVc.h"
typedef enum : NSUInteger {
    AddMemberCellType,
    AddmemberDesCellType,
} CreatProAddMemberCellType;
@interface JGJCreatProAddMemberVC () <
JGJTeamMemberCellDelegate,
UITableViewDataSource,
UITableViewDelegate,
JGJAddTeamMemberDelegate,
JGJDataSourceMemberPopViewDelegate,
JGJTeamDetailCommonPopViewDelagate
>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) CGFloat collectionViewHeight;//班组成员高度
@property (nonatomic, strong) NSMutableArray *groupMembersInfos;//存储上传班组成员模型数组
@property (nonatomic, strong) JGJCreatTeamRequest *creatTeamRequest;
@property (nonatomic, strong) NSMutableArray *creatTeamModels;//创建班组模型数组
@property (weak, nonatomic) IBOutlet UIButton *stepButton;
@property (nonatomic, assign) BOOL isSuccessRequest;//是否成功上传数据

@end

@implementation JGJCreatProAddMemberVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonSet];
}


#pragma UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    switch (indexPath.row) {
        case AddMemberCellType: {
            JGJTeamMemberCell *teamMemberCell  = [JGJTeamMemberCell cellWithTableView:tableView];
            teamMemberCell.delegate = self;
            teamMemberCell.memberFlagType = ShowAddTeamMemberFlagType;
            JGJTeamMemberCommonModel *commonModel = self.commonModel;
            teamMemberCell.commonModel = commonModel; //班组成员个数 和类型
            commonModel.teamMemberModels = self.teamMemberModels;
            commonModel.count = (self.teamMemberModels.count == 1 ? 0 : self.teamMemberModels.count - 1); //减去一个是去掉加号模型
            teamMemberCell.teamMemberModels = self.teamMemberModels;
            cell = teamMemberCell;
        }
            break;
        case AddmemberDesCellType: {
            JGJCreatProAddMemberDescCell *descCell  = [JGJCreatProAddMemberDescCell cellWithTableView:tableView];
            descCell.proDecModel = self.proDecModel;
            JGJTeamMemberCommonModel *commonModel = self.commonModel;
            if (commonModel.teamControllerType == JGJAddProSourceMemberControllerType) {
                descCell.lineViewH.constant = 0;
                descCell.desLeading.constant = 0;
                descCell.titleLableCenterX.constant = -10;
            }
            cell = descCell;
        }
            break;
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0.0;
    switch (indexPath.row) {
        case AddMemberCellType: {
            height = self.collectionViewHeight;
        }
            break;
        case AddmemberDesCellType: {
            height = [JGJCreatProAddMemberDescCell creatProAddMemberDescCellHeight];
        }
            break;
        default:
            break;
    }
    return height;
}

#pragma mark - JGJTeamMemberCellDelegate 进入通信录添加班组成员
- (void)handleJGJTeamMemberCellAddTeamMember:(JGJTeamMemberCell *)teamMemberCell {
    JGJSynBillingCommonModel *synBillingCommonModel = [[JGJSynBillingCommonModel alloc] init];
    JGJAddTeamMemberVC *addTeamMemberVC = [[UIStoryboard storyboardWithName:@"JGJCreatTeam" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJAddTeamMemberVC"];
    synBillingCommonModel.synBillingTitle = self.commonModel.memberType == JGJProMemberType ? @"添加项目成员" : @"添加数据来源人";
    addTeamMemberVC.delegate = self;
    addTeamMemberVC.groupMemberMangeType = self.groupMemberMangeType;
    addTeamMemberVC.synBillingCommonModel = synBillingCommonModel;
    addTeamMemberVC.notifyModel = self.notifyModel;//通知模型
    addTeamMemberVC.sourceSynProFirstModel = self.sourceSynProFirstModel; //反传数据
    addTeamMemberVC.currentTeamMembers = self.teamMemberModels;
    addTeamMemberVC.commonModel = self.commonModel;
    addTeamMemberVC.sortContactsModel = self.sortContactsModel;
    [self.navigationController pushViewController:addTeamMemberVC animated:YES];
}

#pragma mark - 点击删除弹框显示
- (void)handleJGJTeamMemberCellRemoveIndividualTeamMember:(JGJSynBillingModel *)teamMemberModel {
    if (self.groupMemberMangeType == JGJGroupMemberMangeAddMemberType) {
        [self removeAddMember:teamMemberModel];
    }else if (![NSString isEmpty:teamMemberModel.uid]) {
        JGJDataSourceMemberPopView *popMesageView = [[JGJDataSourceMemberPopView alloc] initWithFrame:self.view.bounds teamMemberModel:teamMemberModel];
        popMesageView.delegate = self;
    }else if(self.groupMemberMangeType == JGJGroupMemberMangePushNotifyType){  //这里有个弹框
        JGJTeamMemberCommonModel *commonModel = [[JGJTeamMemberCommonModel alloc] init];
        commonModel.alertViewHeight = 190.0;
        commonModel.alertmessage = @"暂时还没有关联的项目";
        commonModel.alignment = NSTextAlignmentCenter;
        commonModel.isHidden = NO;
        commonModel.isRemoveSynMember = YES;
        commonModel.teamModelModel = teamMemberModel;
        JGJTeamDetailCommonPopView *popView = [JGJTeamDetailCommonPopView popViewWithCommonModel:commonModel];
        popView.delegate = self;
    }
}

#pragma mark - JGJTeamDetailCommonPopViewDelegate
- (void)teamDetailCommonPopView:(JGJTeamDetailCommonPopView *)popView {
    [self removeAddMember:popView.commonModel.teamModelModel];
}

#pragma mark - 点击弹窗移除成员
- (void)JGJDataSourceMemberPopViewRemoveMember:(JGJSynBillingModel *)teamMemberModel {
    [self removeAddMember:teamMemberModel];
}

#pragma mark - 弹框确认按钮按下
- (void)JGJDataSourceMemberPopViewConfirmTeamMemberModel:(JGJDataSourceMemberPopView *)popView {
    TYLog(@"确认按钮按下,确认信息!");
}

- (void)handleJGJTeamMemberCellUnRegisterTeamModel:(JGJTeamMemberCommonModel *)commonModel {
    [self handleJGJTeamMemberCellRemoveIndividualTeamMember:commonModel.teamModelModel];
}

#pragma mark - JGJGroupMemberMangeDelegate返回添加的成员
- (void)handleJGJGroupMemberSelectedTeamMembers:(NSMutableArray *)teamsMembers groupMemberMangeType:(JGJGroupMemberMangeType)groupMemberMangeType {
    NSMutableArray *groupMembersInfos = [NSMutableArray array];
    for (JGJSynBillingModel *teamMemberModel in teamsMembers) { //添加返回的成员需要上传的信息
        JGJGroupMembersRequestModel *membersModel = [[JGJGroupMembersRequestModel alloc] init];
        membersModel.real_name = teamMemberModel.real_name;
        membersModel.telephone = teamMemberModel.telephone;
        teamMemberModel.isAddedSyn = YES;
        if (![NSString isEmpty:teamMemberModel.uid]) { //有数据源的联系人是否要求同步其他项目
            membersModel.is_demand = teamMemberModel.is_demand;
        }
        teamMemberModel.isSelected = NO; //返回时取消之前已选中状态
        [groupMembersInfos addObject:membersModel];
    }
    [self.groupMembersInfos addObjectsFromArray:groupMembersInfos];
    for (JGJSynBillingModel *mangerMemberModel in self.teamMemberModels) { //删除添加图片模型
        //teamsMembers.count空就不删除
        if (mangerMemberModel.isMangerModel) {
            [self.teamMemberModels removeObject:mangerMemberModel];
        }
    }
    JGJTeamMemberCommonModel *commonModel = self.commonModel;
    commonModel.teamMemberModels = self.teamMemberModels;
    JGJSynBillingModel *memberModel = [[JGJSynBillingModel alloc] init];
    memberModel.addHeadPic = @"menber_add_icon";
    memberModel.isMangerModel = YES;
    [teamsMembers addObject:memberModel];
    [self.teamMemberModels addObjectsFromArray:teamsMembers];
    [self calculateCollectiveViewHeight:self.teamMemberModels];//数据发生改变，重新计算高度
    switch (groupMemberMangeType) {
        case JGJGroupMemberMangePushNotifyType: { //返回发送通知成员
            memberModel.name = @"添加来源人";
            self.discussTeamRequest.source_members = self.groupMembersInfos; //添加数据来源人
        }
            break;
        case JGJGroupMemberMangeAddMemberType: {
            memberModel.name = @"添加成员";
            self.discussTeamRequest.team_members = self.groupMembersInfos; //添加成员信息
        }
            break;
        case JGJGroupMemberMangeRemoveMemberType: { //创建项目没有删除
            
        }
            break;
        default:
            break;
    }
    [self refreshIndexPathSection:0 indexpathRow:0];
}

#pragma mark - privateMethod
#pragma mark - 计算班组成员高度
- (void)calculateCollectiveViewHeight:(NSMutableArray *)dataSource {
    NSInteger lineCount = 0;
    NSUInteger teamMemberCount = dataSource.count;
    int count = 0;
    count = teamMemberCount % 4; //取余数看是否加一行
    lineCount = teamMemberCount < 3 ? 1 : (count == 0 ? teamMemberCount / 4.0 :  (NSInteger)roundf(teamMemberCount / 4.0 + 0.5));
    CGFloat collectionViewHeight = lineCount * (LineMargin  + 3) + lineCount * ItemHeight + HeaderHegiht ;
    self.collectionViewHeight = collectionViewHeight;
}

- (void)refreshIndexPathSection:(NSUInteger)IndexPathSection indexpathRow:(NSUInteger)indexpathRow {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:indexpathRow inSection:IndexPathSection];
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}

#pragma mark - buttonAction
#pragma mark - 处理下一步按钮事件
- (IBAction)handleStepButtonAction:(UIButton *)sender {
    
    TYLog(@"uid== %@ source_pro_id--- %@", self.notifyModel.source_pro_id,self.notifyModel.uid);
    //2.1.2更改
    //1.有数据源逻辑 创建项目，添加成员，添加数据来源人
    //2.没有数据来源人去掉添加数据来源过程。
    if ([NSString isEmpty:self.notifyModel.source_pro_id]) {
        [self handleUpLoadMemberSuccess];
    }else {
         [self handleStepCreatProAddDataSourceVC:self.discussTeamRequest];
    }
}

- (void)handleStepCreatProAddDataSourceVC:(JGJCreatDiscussTeamRequest *)discussTeamRequest {
    JGJCreatProAddDataSourceVC *addMemberVC = [[UIStoryboard storyboardWithName:@"JGJCreatPro" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJCreatProAddDataSourceVC"];
    if (self.notifyModel) {
        addMemberVC.notifyModel = self.notifyModel;
    }
    addMemberVC.discussTeamRequest = discussTeamRequest;
    [self.navigationController pushViewController:addMemberVC animated:YES];
}

#pragma mark - 处理跳过按钮事件
- (IBAction)handelStepButtomItemAction:(UIBarButtonItem *)sender {
    if ([NSString isEmpty:self.notifyModel.source_pro_id]) {
        [self handleUpLoadMemberSuccess];
    }else {
        [self handleStepCreatProAddDataSourceVC:self.discussTeamRequest];
    }
}

#pragma mark - setter
- (void)setTeamMemberModels:(NSMutableArray *)teamMemberModels {
    _teamMemberModels = teamMemberModels;
    [self calculateCollectiveViewHeight:_teamMemberModels];
    [self refreshIndexPathSection:0 indexpathRow:0];
}

#pragma mark - getter
- (JGJTeamMemberCommonModel *)commonModel {
    if (!_commonModel) {
        _commonModel = [[JGJTeamMemberCommonModel alloc] init];
        _commonModel.isHiddenDeleteFlag = NO;
        _commonModel.headerTitle = @"邀请更多人加入到项目组";
        _commonModel.teamControllerType = JGJAddProNormalMemberControllerType; //当前类型是创建项目，添加人员
        _commonModel.headerTitleColor = AppFontf7f7f7Color;
        _commonModel.headerTitleTextColor = AppFont999999Color;
        _commonModel.memberType = JGJProMemberType;//项目成员
    }
    return _commonModel;
}

- (JGJCreatProDecModel *)proDecModel {
    if (!_proDecModel) {
        _proDecModel = [[JGJCreatProDecModel alloc] init];
        _proDecModel.title = @"邀请更多人有哪些好处?";
        _proDecModel.desc =  @"1. 所有加入到项目组的成员都可以随时查看项目用工、安全、质量、进度等相关信息;\n2. 所有加入到项目组的成员可以进行签到、发布通知等相关操作。";
    }
    return _proDecModel;
}

- (NSMutableArray *)groupMembersInfos {
    if (!_groupMembersInfos) {
        _groupMembersInfos = [NSMutableArray array];
    }
    return _groupMembersInfos;
}

- (void)commonSet {
    [self.stepButton.layer setLayerCornerRadius:JGJCornerRadius];
    NSMutableArray *dataSource = [NSMutableArray array];
    JGJSynBillingModel *memberModel = [[JGJSynBillingModel alloc] init];
    memberModel.addHeadPic = @"menber_add_icon";
    memberModel.name = @"添加成员";
    memberModel.isMangerModel = YES;
    [dataSource addObject: memberModel];
    self.teamMemberModels = dataSource;
    self.groupMemberMangeType = JGJGroupMemberMangeAddMemberType;
    
    if (![NSString isEmpty:self.notifyModel.source_pro_id]) {
        [self.stepButton setTitle:@"下一步" forState:UIControlStateNormal];
    }else {
        [self.stepButton setTitle:@"完成 进入项目组" forState:UIControlStateNormal];
    }
}

#pragma mark - 移除人员
- (void)removeAddMember:(JGJSynBillingModel *)teamMemberModel {
    if (!teamMemberModel.isMangerModel) {
        NSMutableArray *members = [NSMutableArray array];
        members = self.teamMemberModels;
        [members removeObject:teamMemberModel];
        self.teamMemberModels = members;
        //保证移除
        if (![NSString isEmpty:teamMemberModel.telephone] && self.groupMemberMangeType == JGJGroupMemberMangeAddMemberType) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"telphone contains %@", teamMemberModel.telephone];
            JGJSynBillingModel *removeTeamModel = [self.groupMembersInfos filteredArrayUsingPredicate:predicate].lastObject;
            [self.groupMembersInfos removeObject:removeTeamModel];
            self.discussTeamRequest.team_members = self.groupMembersInfos;
        }
    }
}

#pragma mark - 2.1.2添加没有数据源创建项目直接进入聊天页面 子类也写了相同的方法

#pragma mark - 聊天界面
- (void)handleUpLoadMemberSuccess {
    [self handleCreatTeamRequestModel];
    NSDictionary *parameters = [self.discussTeamRequest mj_keyValues];
    __weak typeof(self) weakSelf = self;
    [TYLoadingHub showLoadingWithMessage:nil];
    [JGJSocketRequest WebSocketWithParameters:parameters success:^(id responseObject) {
        [TYLoadingHub hideLoadingView];
        [responseObject setObject:@"1" forKey:@"myself_group"]; //自己创建
        self.proListModel = [JGJMyWorkCircleProListModel mj_objectWithKeyValues:responseObject];
        self.proListModel.pro_name = self.discussTeamRequest.pro_name; //
        self.proListModel.class_type = @"team";
        [weakSelf handleSkipJGJChatRootVcWithProListModel:self.proListModel];
    } failure:^(NSError *error,id values) {
        [TYLoadingHub hideLoadingView];
    }];
}

#pragma mark - 处理上传参数
- (void)handleCreatTeamRequestModel {
    NSMutableArray *confirmSourceArray = [NSMutableArray array];
    NSMutableArray *allTeamMembers = [NSMutableArray array];
    NSMutableArray *sourceArray = [NSMutableArray array];
    NSMutableString *sourceProId = [NSMutableString string];
    for (JGJSynBillingModel *teamMemberModel in self.teamMemberModels) { //添加返回的成员需要上传的信息
        JGJGroupMembersRequestModel *membersModel = [[JGJGroupMembersRequestModel alloc] init];
        membersModel.real_name = teamMemberModel.real_name;
        membersModel.telephone = teamMemberModel.telephone;
        if (![NSString isEmpty:teamMemberModel.uid]) { //有数据源的联系人是否要求同步其他项目
            membersModel.is_demand = teamMemberModel.is_demand;
            [confirmSourceArray addObject:membersModel];//添加有源的联系人
            [sourceProId appendFormat:@"%@,", teamMemberModel.source_pro_id];
        }else {
            if (![NSString isEmpty:teamMemberModel.telephone]) {
                [sourceArray addObject:membersModel]; //没有源的来源人
            }
        }
    }
    if (sourceArray.count > 0) {
        [allTeamMembers addObjectsFromArray:sourceArray]; //添加数据源
    }
    if (confirmSourceArray.count > 0) {
        [allTeamMembers addObjectsFromArray:confirmSourceArray]; //添加有源的数据源
    }
    if (allTeamMembers.count > 0 || self.discussTeamRequest.team_members.count > 0) {
        [allTeamMembers addObjectsFromArray:self.discussTeamRequest.team_members];
    }
    self.discussTeamRequest.team_members = allTeamMembers; //全部成员
//    self.discussTeamRequest.confirm_source_members = confirmSourceArray;//有源的联系人
//    self.discussTeamRequest.source_members = sourceArray; //无源的联系人
//    self.discussTeamRequest.source_pro_id = sourceProId; //所有的项目id
}

#pragma mark - 处理跳转聊天页面
- (void)handleSkipJGJChatRootVcWithProListModel:(JGJMyWorkCircleProListModel *)proListModel {
    JGJChatRootVc *chatRootVc = [[UIStoryboard storyboardWithName:@"JGJChat" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJChatRootVc"];
    chatRootVc.workProListModel = proListModel;
    [self.navigationController pushViewController:chatRootVc animated:YES];
}


@end
