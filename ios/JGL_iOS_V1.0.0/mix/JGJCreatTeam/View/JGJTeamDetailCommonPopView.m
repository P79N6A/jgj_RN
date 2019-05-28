//
//  JGJTeamDetailCommonPopView.m
//  JGJCompany
//
//  Created by yj on 16/11/11.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJTeamDetailCommonPopView.h"
#import "TYPhone.h"
#import "UILabel+GNUtil.h"
#import "JGJTeamMangerSourceSyncProCell.h"
#import "NSString+Extend.h"
#define RowH 45
#define ContainRelateViewHeight 40
#define TableViewHeaderHeight 33.0
static const CGFloat SyncSourceViewH = 104 + 4 * RowH + ContainRelateViewHeight;
static const CGFloat OnlySyncUnSourceViewH = 150 + ContainRelateViewHeight;
static const CGFloat NoSyncSourceViewH = 150;
@interface JGJTeamDetailCommonPopView () <
UITableViewDelegate,
UITableViewDataSource,
JGJTeamMangerSourceSyncProCellDelegate
>
@property (weak, nonatomic) IBOutlet UIButton *telphoneButton;
@property (weak, nonatomic) IBOutlet UIView *contailDetailView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containDetailViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *detailDesLable;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UIView *containTelView;
@property (weak, nonatomic) IBOutlet UIView *containRelateView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containRelateViewH;
@property (strong, nonatomic) JGJTeamMemberCommonModel *commonModel;
@property (weak, nonatomic) IBOutlet UILabel *synsedProCountLable;
@property (strong, nonatomic) JGJSourceSynProFirstModel *synProFirstModel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) SyncSourceType sourceType;
@property (strong, nonatomic) JGJAddGroupMemberRequestModel *addGroupMemberRequestModel;
@property (nonatomic,strong) JGJMyWorkCircleProListModel *workProListModel;
@end

@implementation JGJTeamDetailCommonPopView

static JGJTeamDetailCommonPopView *popView;
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setTableHeaderView];
    self.frame = [[UIScreen mainScreen] bounds];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [self.containTelView.layer setLayerBorderWithColor:AppFont666666Color width:1.0 radius:TYGetViewH(self.containTelView) / 2.0];
    [self.telphoneButton setTitleColor:AppFont333333Color forState:UIControlStateNormal];
    [self.tableView.layer setLayerCornerRadius:JGJCornerRadius];
    [self.contailDetailView.layer setLayerCornerRadius:JGJCornerRadius];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleRelateProAction)];
    tap.numberOfTapsRequired = 1;
    [self.containRelateView addGestureRecognizer:tap];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = AppFontf5f5f5Color;
    self.nameLable.textColor = AppFontd7252cColor;
    
    UITapGestureRecognizer *tapName = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapNameAction)];
    self.nameLable.userInteractionEnabled = YES;
    tapName.numberOfTapsRequired = 1;
    [self.nameLable addGestureRecognizer:tapName];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RowH;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger count = 0;
    JGJSourceSynProSeclistModel *syncSecModel = [JGJSourceSynProSeclistModel new];
    if (self.synProFirstModel.list.count > 0) {
        syncSecModel = self.synProFirstModel.list[section];
        count = syncSecModel.sync_source.list.count;
    }
    return count;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JGJTeamMangerSourceSyncProCell *synedProCell = [JGJTeamMangerSourceSyncProCell cellWithTableView:tableView];
    JGJSourceSynProSeclistModel *syncSecProModel = self.synProFirstModel.list[indexPath.section];
    synedProCell.prolistModel = syncSecProModel.sync_source.list[indexPath.row];
    synedProCell.delegate = self;
    return synedProCell;
}

+ (JGJTeamDetailCommonPopView *)popViewWithCommonModel:(JGJTeamMemberCommonModel *)commonModel {
    if(popView && popView.superview) [popView removeFromSuperview];
    popView = [[[NSBundle mainBundle] loadNibNamed:@"JGJTeamDetailCommonPopView" owner:self options:nil] lastObject];
    popView.detailDesLable.text = commonModel.alertmessage;
    popView.nameLable.text = commonModel.teamModelModel.name;
    popView.commonModel = commonModel;
    popView.workProListModel = commonModel.workProListModel;
    [popView.telphoneButton setTitle:popView.commonModel.teamModelModel.telephone forState:UIControlStateNormal];
    popView.detailDesLable.textAlignment = commonModel.alignment;
    if (commonModel.alertViewHeight > 0) {
        popView.containDetailViewHeight.constant = commonModel.alertViewHeight;
    }
    if (commonModel.isRemoveSynMember) {
        [popView hadnleDegaultSyncSourceTypePro];
    } else {
        [popView loadProList];
    }
    return popView;
}

#pragma mark - JGJTeamMangerSourceSyncProCellDelegate
- (void)handleTeamMangerSourceSyncProCellRemoveSynproButtonPressed:(JGJTeamMangerSourceSyncProCell *)cell {
    [self handleRemoveSynProRequest:cell.prolistModel];
}

#pragma mark - 移除单个现项目源
- (void)handleRemoveSynProRequest:(JGJSyncProlistModel *)syncProModel {
    NSDictionary *parameters = @{
                                 @"class_type" : self.commonModel.workProListModel.class_type?:@"team",
                                 
                                 @"uid" : syncProModel.self_uid ?:@"",
                                 
                                 @"group_id" : self.commonModel.workProListModel.group_id?:@"",
                                 
                                 @"pid" : syncProModel.pid?:@""
                                 
                                 };

    [JLGHttpRequest_AFN PostWithNapi:JGJGroupRemoveSyncSourceURL parameters:parameters success:^(id responseObject) {
        
        [self loadProList];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)handleRelateProAction {
    [self dismiss];
    if (self.commonModel.isRemoveSynMember) {
        if ([self.delegate respondsToSelector:@selector(teamDetailCommonPopView:)]) {
            [self.delegate teamDetailCommonPopView:self];
        }
        return;
    }
    if (self.sourceType == AllSyncSourceType || self.sourceType == OnlySyncUnSourceType) {
        if ([self.delegate respondsToSelector:@selector(teamDetailCommonPopView:)]) {
            [self.delegate teamDetailCommonPopView:self];
        }
    }else if (self.sourceType == OnlySyncSourceType) {
        self.commonModel.teamModelModel.is_demand = @"1";
        [self handleUploadSynProInfoRequest];
    }
}

#pragma mark - 点击数据来源人姓名
- (void)handleTapNameAction {
    if ([self.delegate respondsToSelector:@selector(teamDetailCommonPopViewWithpopView:didSelectedMember:)]) {
        [self.delegate teamDetailCommonPopViewWithpopView:self didSelectedMember:self.commonModel.teamModelModel];
    }
    [self dismiss];
}

- (void)handleUploadSynProInfoRequest {
    JGJGroupMembersRequestModel *requestModel = [[JGJGroupMembersRequestModel alloc] init];
    requestModel.real_name = self.commonModel.teamModelModel.real_name;
    requestModel.telephone = self.commonModel.teamModelModel.telephone;
    requestModel.is_demand = self.commonModel.teamModelModel.is_demand;
    self.addGroupMemberRequestModel.source_members = @[requestModel];
    NSDictionary *parameters = [self.addGroupMemberRequestModel mj_keyValues];
    [JGJSocketRequest WebSocketWithParameters:parameters success:^(id responseObject) { //这里后台返回了两次避免重复添加
    } failure:nil];
}

- (IBAction)handleCallButtonPressed:(UIButton *)sender {
    [TYPhone callPhoneByNum:popView.commonModel.teamModelModel.telephone view:self];
}

- (IBAction)handleCancelButtonPressed:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(teamDetailCommonPopViewCancelButtonPressed:)]) {
        [self.delegate teamDetailCommonPopViewCancelButtonPressed:self];
    }
    [self dismiss];
}

- (void)dismiss{
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 0.0;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        popView.transform = CGAffineTransformScale(popView.transform,0.9,0.9);
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

- (void)showView {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    popView.frame = window.bounds;
    [window addSubview:popView];
}

#pragma mark - 获取同步项目列表
- (void)loadProList {
    
    NSString *uid = popView.commonModel.teamModelModel.uid ?:@"";
    
    NSString *teamID = self.commonModel.workProListModel.group_id?:@"";
    
    NSString *class_type = self.commonModel.workProListModel.class_type?:@"team";
    
    NSDictionary *parameters = @{
                                 
                                 @"uid" : uid,
                                 
                                 @"group_id" : teamID,
                                 
                                 @"class_type" : class_type
                                 
                                 };
    
    __weak typeof(self) weakSelf = self;
    
    [TYLoadingHub showLoadingWithMessage:nil];

    [JLGHttpRequest_AFN PostWithNapi:JGJGroupSyncproFromSourceListURL parameters:parameters success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        weakSelf.synProFirstModel = [JGJSourceSynProFirstModel mj_objectWithKeyValues:responseObject];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
    }];
}

- (void)setSynProFirstModel:(JGJSourceSynProFirstModel *)synProFirstModel {
    _synProFirstModel = synProFirstModel;
//    [self showView];
    [self handleTeamMemberSyncPro:synProFirstModel];
}

- (void)handleTeamMemberSyncPro:(JGJSourceSynProFirstModel *)synProFirstModel {
    
    //    NoSynSourceType, //未同步
    //    OnlySyncSourceType, //仅有关联的同步源类型
    //    OnlySyncUnSourceType, //仅有未关联的同步元类型
    //    AllSyncSourceType //两者均有
    self.sourceType = NoSynSourceType;
    JGJSourceSynProSeclistModel *synProSeclistModel = nil;
    if (synProFirstModel.list.count > 0) {
        synProSeclistModel = [self.synProFirstModel.list firstObject];
    }
    NSUInteger sync_sourceCount = synProSeclistModel.sync_source.list.count;
    NSUInteger sync_unsourceCount = synProSeclistModel.sync_unsource.list.count;
    if (sync_sourceCount == 0 && sync_unsourceCount == 0) {
        self.sourceType = NoSynSourceType;
    } else if (sync_sourceCount > 0 && sync_unsourceCount == 0) {
        self.sourceType = OnlySyncSourceType;
    } else if (sync_sourceCount == 0 && sync_unsourceCount > 0) {
        self.sourceType = OnlySyncUnSourceType;
    }else  if (sync_sourceCount > 0 && sync_unsourceCount > 0){
        self.sourceType = AllSyncSourceType;
    }
    [self handleSourceType:self.sourceType sourceSynProFirstModel:synProFirstModel];
    [self showView];
}

- (void)handleSourceType:(SyncSourceType)sourceType sourceSynProFirstModel:(JGJSourceSynProFirstModel *)synProFirstModel {
    switch (sourceType) {
        case NoSynSourceType:
            [self hadnleNoSynSourceTypePro:synProFirstModel];
            break;
        case OnlySyncSourceType:
            [self hadnleOnlySyncSourceTypePro:synProFirstModel];
            break;
        case OnlySyncUnSourceType:
            [self hadnleOnlySyncUnSourceTypePro:synProFirstModel];
            break;
        case AllSyncSourceType:
            [self hadnleAllSyncSourceTypePro:synProFirstModel];
            break;
            
        default:
            break;
    }
}

#pragma mark - 没有同步的项目
- (void)hadnleNoSynSourceTypePro:(JGJSourceSynProFirstModel *)synProFirstModel {
    self.containRelateView.hidden = YES;
    self.containRelateViewH.constant = 0;
    self.containDetailViewHeight.constant = NoSyncSourceViewH;
    self.detailDesLable.text = @"该用户还未同意向你同步项目";
    self.detailDesLable.hidden = NO;
    self.tableView.hidden = YES;
}

#pragma mark - 仅同步关联的项目
- (void)hadnleOnlySyncSourceTypePro:(JGJSourceSynProFirstModel *)synProFirstModel {
    self.containRelateView.hidden = NO;
    self.containRelateViewH.constant = ContainRelateViewHeight;
    self.containDetailViewHeight.constant = SyncSourceViewH;
    self.tableView.hidden = NO;
    self.synsedProCountLable.text = @"要求同步其他项目";
    self.tableView.backgroundView.backgroundColor = [UIColor orangeColor];
    [self.tableView reloadData];
}

#pragma mark - 仅同步未关联的项目
- (void)hadnleOnlySyncUnSourceTypePro:(JGJSourceSynProFirstModel *)synProFirstModel {
    self.containRelateView.hidden = NO;
    self.containRelateViewH.constant = ContainRelateViewHeight;
    self.containDetailViewHeight.constant = OnlySyncUnSourceViewH;
    self.tableView.hidden = YES;
    JGJSourceSynProSeclistModel *synProSeclistModel = [synProFirstModel.list firstObject];
    NSString *syncountStr = [NSString stringWithFormat:@"%@", @(synProSeclistModel.sync_unsource.list.count)];
    NSString *mergeStr = [NSString stringWithFormat:@"他已同步给你 %@ 个项目 %@", syncountStr, @"关联到本组"];
    NSArray *textArray = @[syncountStr,@"关联到本组"];
    self.synsedProCountLable.text = mergeStr;
    self.detailDesLable.text = @"暂时还没有关联的项目";
    [self.synsedProCountLable markattributedTextArray:textArray color:AppFontd7252cColor];
}

#pragma mark - 均有同步关联的项目
- (void)hadnleAllSyncSourceTypePro:(JGJSourceSynProFirstModel *)synProFirstModel {
    self.containRelateView.hidden = NO;
    self.containRelateViewH.constant = ContainRelateViewHeight;
    self.containDetailViewHeight.constant = SyncSourceViewH;
    self.tableView.hidden = NO;
    JGJSourceSynProSeclistModel *synProSeclistModel = [synProFirstModel.list firstObject];
    NSString *syncountStr = [NSString stringWithFormat:@"%@", @(synProSeclistModel.sync_unsource.list.count)];
    NSString *mergeStr = [NSString stringWithFormat:@"他还同步给你 %@ 个项目 %@", syncountStr, @"关联到本组"];
    NSArray *textArray = @[syncountStr,@"关联到本组"];
    self.synsedProCountLable.text = mergeStr;
    self.containRelateViewH.constant = 40;
    [self.synsedProCountLable markattributedTextArray:textArray color:AppFontd7252cColor];
    [self.tableView reloadData];
}

#pragma mark - 仅同步关联的项目
- (void)hadnleDegaultSyncSourceTypePro {
    self.containRelateView.hidden = NO;
    self.containRelateViewH.constant = ContainRelateViewHeight;
    self.containDetailViewHeight.constant = 190;
    self.tableView.hidden = YES;
    self.detailDesLable.text = @"将他添加为数据来源人后，系统会通知他同步项目数据给你";
    self.synsedProCountLable.text = @"删除此人";
    self.tableView.backgroundView.backgroundColor = [UIColor orangeColor];
    [self showView];
}

#pragma mark - 初始化添加班组成员网络请求模型
- (JGJAddGroupMemberRequestModel *)addGroupMemberRequestModel {
    if (!_addGroupMemberRequestModel) {
        _addGroupMemberRequestModel = [[JGJAddGroupMemberRequestModel alloc] init];
        _addGroupMemberRequestModel.ctrl = @"team";
        _addGroupMemberRequestModel.team_id = self.workProListModel.team_id;
        _addGroupMemberRequestModel.action = @"addSourceMember";
    }
    return _addGroupMemberRequestModel;
}

- (void)setTableHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TableViewHeaderHeight)];
    self.tableView.tableHeaderView = headerView;
    headerView.backgroundColor = AppFontf5f5f5Color;
    UILabel *titleLable = [[UILabel alloc] init];
    titleLable.text = @"以下是他同步给你且已关联的项目:";
    titleLable.font = [UIFont systemFontOfSize:AppFont24Size];
    titleLable.textAlignment = NSTextAlignmentLeft;
    titleLable.textColor = AppFont999999Color;
    [headerView addSubview:titleLable];
    UIEdgeInsets padding = UIEdgeInsetsMake(0, 16, 0, 0);
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(headerView).with.insets(padding);
    }];
}
@end
