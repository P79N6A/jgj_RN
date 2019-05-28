//
//  JGJMyChatGroupsVc.m
//  mix
//
//  Created by yj on 2019/3/6.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJMyChatGroupsVc.h"

#import "JGJMyChatGroupsHeaderView.h"

#import "JGJMyChatGroupsBottomView.h"

#import "JGJChatRootVc.h"

#import "JLGCustomViewController.h"

#import "JGJMyChatGroupsVc+chatWorkReplyAction.h"

#import "JGJMyChatGroupsVc+selProTypeAction.h"

#import "JGJWorkCircleProTypeTableViewCell.h"

#import "JGJMyChatGroupsNoDataView.h"

#import "UIButton+JGJUIButton.h"
#import "JGJDataManager.h"

static NSString *const JGJWorkCircleProListCollectionViewCellID = @"JGJWorkCircleProListCollectionViewCell";

static NSString * const JGJMyChatGroupsHeaderViewHeaderViewID = @"JGJMyChatGroupsHeaderView";

static NSString * const JGJMyChatGroupsNoDataViewID = @"JGJMyChatGroupsNoDataView";

@interface JGJMyChatGroupsVc ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic)NSArray *infoModels;

@property (strong, nonatomic) JGJMyChatGroupsBottomView *bottomView;

@property (strong, nonatomic) UIImageView *clocedImageView;

@end

@implementation JGJMyChatGroupsVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的项目班组";
    
    [self registerClassView];
    
    [self creatRightItem];
    
    [self addSubUI];
    
    // 设置班组,项目的好友来源类型
    [self setFriendAddFromTypeOfGroupChat];
    
}

/**
 设置班组,项目的好友来源类型
 */
- (void)setFriendAddFromTypeOfGroupChat
{
    if ([self.classType isEqualToString:@"group"]){
        // 班组
        [JGJDataManager sharedManager].addFromType = JGJFriendAddFromtTeam;
        
    } else if ([self.classType isEqualToString:@"team"]){
        // 项目
        [JGJDataManager sharedManager].addFromType = JGJFriendAddFromProject;
    }
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self getChatProModel];
}

- (void)addSubUI {
    
    [self.view addSubview:self.collectionView];
    
    [self.view addSubview:self.bottomView];
    
    [self setNavigationLeftButtonItem];
}

- (void)setNavigationLeftButtonItem {

    UIButton *backBtn = [UIButton getLeftBackButton];
    
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}

- (void)backBtnClick:(UIButton *)sender {
    
    UIViewController *popVc = self.popVc;
    
    //质量、安全、任务、通知详情页
    if ([self.popVc isKindOfClass:[UIViewController class]]) {
        
        [self.navigationController popToViewController:self.popVc animated:YES];
        
        return;
    }
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        
        if ([vc isKindOfClass:NSClassFromString(@"JGJContactedListVc")]) {
            
            popVc = vc;
            
            break;
        }
        
    }
    
    if (popVc) {
        
        [self.navigationController popToViewController:popVc animated:YES];
        
    }else {
        
       [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark - 注册View

- (void)registerClassView {
    
    [self.collectionView registerNib:[UINib nibWithNibName:JGJMyChatGroupsHeaderViewHeaderViewID bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:JGJMyChatGroupsHeaderViewHeaderViewID];
    
    [self.collectionView registerNib:[UINib nibWithNibName:JGJMyChatGroupsNoDataViewID bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:JGJMyChatGroupsNoDataViewID];
    
    [self.collectionView registerNib:[UINib nibWithNibName:JGJWorkCircleProListCollectionViewCellID bundle:nil] forCellWithReuseIdentifier:JGJWorkCircleProListCollectionViewCellID];
}

#pragma mark - 获取项目模型

- (void)getChatProModel {
    
    if (JGJHomeLoadStatus != 3) {
        
        [TYUserDefaults setInteger:1 forKey:JGJHomeLoadStatusKey];  //加载中设置成 1
        
    }
    __weak typeof(self) weakSelf = self;
    [JGJChatGetOffLineMsgInfo shareManager].getIndexListSuccess = ^(JGJMyWorkCircleProListModel *proListModel) {
        
        [TYUserDefaults setInteger:3 forKey:JGJHomeLoadStatusKey];  //成功设置成 3
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            weakSelf.proListModel = proListModel;
            
            [weakSelf.collectionView reloadData];
        });
    };
    
    [JGJChatGetOffLineMsgInfo shareManager].getIndexListFailed = ^{
        
        [TYUserDefaults setInteger:2 forKey:JGJHomeLoadStatusKey];  //失败设置成  2
        
        [weakSelf.collectionView reloadData];
        
    };
    // 刷新首页消息
    [JGJChatGetOffLineMsgInfo refreshIndexTbToHomeVC];
    
}

- (void)setProListModel:(JGJMyWorkCircleProListModel *)proListModel {
    
    _proListModel = proListModel;
    
    self.bottomView.proListModel = proListModel;
    
    //没有项目隐藏底部工作回复、聊天按钮
    
    BOOL isUnProInfo = proListModel.isUnProInfo;
    
    self.bottomView.hidden = isUnProInfo;
    
    self.collectionView.scrollEnabled = !isUnProInfo;
    
    BOOL isClose = proListModel.group_info.isClosedTeamVc;
    
    self.clocedImageView.hidden = !isClose;
    
    if (isClose) {
        
        [self closeGroupFlag];
        
    }
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.infoModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JGJWorkCircleProListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:JGJWorkCircleProListCollectionViewCellID forIndexPath:indexPath];
    JGJWorkCircleMiddleInfoModel *infoModel = self.infoModels[indexPath.row];
//    cell.delegate = self;
    cell.infoModel = infoModel;
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJWorkCircleMiddleInfoModel *infoModel = self.infoModels[indexPath.row];
    
    infoModel.isHightlight = YES;
    
    JGJWorkCircleProListCollectionViewCell* cell = (JGJWorkCircleProListCollectionViewCell *) [collectionView cellForItemAtIndexPath:indexPath];
    
    cell.infoModel = infoModel;
    
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJWorkCircleMiddleInfoModel *infoModel = self.infoModels[indexPath.row];
    
    infoModel.isHightlight = NO;
    
    JGJWorkCircleProListCollectionViewCell *cell = (JGJWorkCircleProListCollectionViewCell *) [collectionView cellForItemAtIndexPath:indexPath];
    
    cell.infoModel = infoModel;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *headerView;
    
    if (self.proListModel.isUnProInfo && [kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        headerView = [self registerNoDataViewCollectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
        
    }else
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        JGJMyChatGroupsHeaderView *groupsHeaderView = (JGJMyChatGroupsHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:JGJMyChatGroupsHeaderViewHeaderViewID forIndexPath:indexPath];
        
        groupsHeaderView.proListModel = self.proListModel;

        headerView = groupsHeaderView;
        
        TYWeakSelf(self);
        
        groupsHeaderView.switchBlock = ^{
          
            [weakself handleButtonPressed:JGJMyChatGroupsSwitchGroupsActionType];
            
        };
    }
    
    return headerView;
}

- (UICollectionReusableView *)registerNoDataViewCollectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
     JGJMyChatGroupsNoDataView *noDataView = (JGJMyChatGroupsNoDataView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:JGJMyChatGroupsNoDataViewID forIndexPath:indexPath];
    
    TYWeakSelf(self);
    
    noDataView.creatGroupActionBlock = ^{
        
        [weakself handleButtonPressed:JGJMyChatGroupsCreatGroupActionType];
        
    };
    
    noDataView.sweepActionBlock = ^{
        
        [weakself handleButtonPressed:JGJMyChatGroupsQRSweepActionType];
    };
    
    return noDataView;
    
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    CGFloat height = self.proListModel.isUnProInfo ? TYGetUIScreenHeight: [JGJMyChatGroupsHeaderView headerHeight];
    
    return CGSizeMake(TYGetUIScreenWidth, height) ;
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJWorkCircleMiddleInfoModel *infoModel = self.infoModels[indexPath.row];
    
    //选择对应的质量安全等模块
    
    [self selProTypeModel:infoModel];
    
//    - (void)JGJWorkCircleProTypeTableViewCell:(JGJWorkCircleProTypeTableViewCell *)cell didSelectedType:(JGJWorkCircleMiddleInfoModel *)infoModel;
    
}

- (UICollectionView *)collectionView{
    
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        CGFloat itemW = TYGetUIScreenWidth / 4.0;
        
        layout.itemSize = CGSizeMake(itemW, SelItemHeight);
        
        layout.minimumLineSpacing = 0;
        
        layout.minimumInteritemSpacing = 0;
        
        layout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight - self.bottomView.height) collectionViewLayout:layout];
        
        _collectionView.bounces = YES;
        
        _collectionView.alwaysBounceVertical = YES;
        
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        _collectionView.delegate = self;
        
        _collectionView.dataSource = self;
        
        _collectionView.backgroundColor = AppFontffffffColor;
        
        self.view.backgroundColor = AppFontffffffColor;
        
    }
    
    return _collectionView;
}

- (NSArray *)infoModels {
    
    if (!self.proListModel || self.proListModel.isUnProInfo) {
        
        return @[];
    }
    
    JGJMyWorkCircleProListModel *proModel = self.proListModel;
    BOOL is_myCreater = [proModel.group_info.myself_group isEqualToString:@"1"];
    
    BOOL isTeam = [self.proListModel.group_info.class_type isEqualToString:@"team"];
    
    BOOL is_agency_author = proModel.group_info.is_myAgency_group && !isTeam; //是否具有代理权限
    
    BOOL is_myset_agency = proModel.group_info.is_agency_group && is_myCreater; //是否具有代理权限
    
    NSArray *teamIsExistMsgs = @[proModel.unread_quality_count?:@"",
                                 proModel.unread_safe_count?:@"",
                                 proModel.unread_inspect_count?:@"",//检查
                                 proModel.unread_task_count?:@"",
                                 proModel.unread_notice_count?:@"",
                                 
                                 proModel.unread_sign_count?:@"",
                                 proModel.unread_meeting_count?:@"",//会议
                                 proModel.unread_approval_count?:@"",
                                 proModel.unread_log_count?:@"",
                                 proModel.unread_weath_count?:@"",
                                 
                                 @"",
                                 @"",
                                 @"",
                                 
                                 @"0",
                                 @"0",
                                 @"0",
                                 @"0"
                                 ];
    
    //初始没有代班长 unread_bill_count
    NSMutableArray *groupIsExistMsgs = @[@"0",
                                         @"0",
                                         proModel.unread_billRecord_count?:@"",//出勤公示
                                         proModel.unread_sign_count?:@"",
                                         proModel.unread_notice_count?:@"",
                                         proModel.unread_quality_count?:@"",
                                         proModel.unread_safe_count?:@"",
                                         proModel.unread_log_count?:@"",
                                         @"0", @"0"].mutableCopy;
    
    NSArray *imageIcons = isTeam ? ProListImageIcons : GroupListImageIcons;
    
    NSArray *descs = isTeam ? ProListDescs : GroupListDescs;
    
    if (is_agency_author) {    //我是代班长的情况
        
        imageIcons = AgencyGroupListImageIcons;
        
        descs = AgencyGroupListDescs;
        
        NSMutableArray *agencyInfos = @[@"0",@"0", @"0",@"0"].mutableCopy;
        
        [agencyInfos addObjectsFromArray:groupIsExistMsgs];
        
        groupIsExistMsgs = agencyInfos;
        
    }else if (is_myset_agency) { //我设置的代班长
        
        imageIcons = MySetAgencyListImageIcons;
        
        descs = MySetAgencyListDescs;
        
        if (groupIsExistMsgs.count > 0) {
            
            [groupIsExistMsgs insertObject:@"0" atIndex:1];
            
        }
    }
    
    NSArray *unReadMsgs = isTeam ? teamIsExistMsgs : groupIsExistMsgs;
    
    NSMutableArray *infos = [NSMutableArray array];
    
    for (int i = 0; i < imageIcons.count; i ++) {
        
        JGJWorkCircleMiddleInfoModel *infoModel = [[JGJWorkCircleMiddleInfoModel alloc] init];
        
        infoModel.InfoImageIcon = imageIcons[i];
        
        if (i < unReadMsgs.count) {
            
            infoModel.isHiddenUnReadMsgFlag = [unReadMsgs[i] integerValue] == 0;
            
        }
        
        if (i < descs.count) {
            
            infoModel.desc = descs[i];
        }
        
        infoModel.cellType = i;
        
        [infos addObject:infoModel];
    }
    
    _infoModels = infos;
    
    return _infoModels;
}

- (JGJMyChatGroupsBottomView *)bottomView {

    if (!_bottomView) {

        CGFloat height = [JGJMyChatGroupsBottomView bottomViewHeight] + JGJ_IphoneX_BarHeight;

        _bottomView = [[JGJMyChatGroupsBottomView alloc] initWithFrame:CGRectMake(0, TYGetUIScreenHeight - height - JGJ_NAV_HEIGHT, TYGetUIScreenWidth, height)];

        TYWeakSelf(self);
        
        _bottomView.chatActionBlock = ^{
        
            [weakself handleButtonPressed:JGJMyChatGroupsChatActionType];
        };
        
        _bottomView.workReplyActionBlock = ^{
          
            [weakself handleButtonPressed:JGJMyChatGroupsWorkReplyActionType];
        };

    }

    return _bottomView;
}

- (void)closeGroupFlag{
    
    if (self.proListModel.group_info.isClosedTeamVc) {
        
        if (!self.clocedImageView) {
            
            UIImageView *clocedImageView = [[UIImageView alloc] init];
            
            self.clocedImageView = clocedImageView;
            
            [self.collectionView addSubview:self.clocedImageView];
        }
        
        NSString *closeType = @"Chat_closedGroup";
        
        if ([self.proListModel.group_info.class_type isEqualToString:@"team"]) {
            
            closeType = @"pro_closedFlag_icon";
        }
        
        self.clocedImageView.image = [UIImage imageNamed:closeType];
        
        CGFloat offset = [self.proListModel.group_info.class_type isEqualToString:@"group"] ? -100 : -50;
        
        [self.clocedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_equalTo(self.view.mas_centerX);
            
            make.centerY.mas_equalTo(self.view.mas_centerY).mas_offset(offset);
            
            make.width.mas_equalTo(126);
            
            make.height.mas_equalTo(70);
            
        }];
        
    }
    
}

@end
