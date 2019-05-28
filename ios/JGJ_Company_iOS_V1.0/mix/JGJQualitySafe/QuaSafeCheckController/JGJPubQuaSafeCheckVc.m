//
//  JGJPubQuaSafeCheckVc.m
//  JGJCompany
//
//  Created by yj on 2017/7/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJPubQuaSafeCheckVc.h"

#import "JGJCreatTeamCell.h"

#import "JGJPubQuaSafeCheckHeaderView.h"

#import "JGJQuaSafeCheckItemCell.h"

#import "JGJDescribeInfoCell.h"

#import "NSString+Extend.h"

#import "JGJTaskPrincipalVc.h"

#import "JGJQuaSafeCheckVc.h"

#import "JGJChatListQualityVc.h"

#import "JGJQuaSafeOrderDefaultView.h"

@interface JGJPubQuaSafeCheckVc ()<

    UITableViewDelegate,

    UITableViewDataSource,

    JGJPubQuaSafeCheckHeaderViewDelegate,

    JGJTaskPrincipalVcDelegate
>


@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *pubButton;

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) NSMutableArray *selectedDataSource;

@property (nonatomic, strong) NSMutableArray *checkMembers;

@property (nonatomic, strong) JGJDescribeInfoModel *desInfoModel;

@property (nonatomic, strong) JGJPubCheckPlanRequestModel *requestModel;

@property (nonatomic, strong) JGJPubQuaSafeCheckHeaderView *itemHeader;

//检查执行人
@property (nonatomic, strong) JGJSynBillingModel *principalModel;

@property (nonatomic, strong) JGJQuaSafeOrderDefaultView *orderDefaultView;

@end

@implementation JGJPubQuaSafeCheckVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发检查计划";
    
    self.view.backgroundColor = AppFontf1f1f1Color;
    
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    
    UIButton *pubButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    pubButton.frame = CGRectMake(0, 0, 100, 40);

    self.pubButton = pubButton;
    
    pubButton.hidden = YES;
    
    [pubButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    
    [pubButton setTitle:@"发布" forState:UIControlStateNormal];
    
    [pubButton addTarget:self action:@selector(pubCheckItemPressed) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:pubButton];
    
    [self initialSubView];
    
    self.tableView.hidden = YES;
    
    [self loadNetData];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger count = 1;
    
    switch (section) {
        case 0:
            count = 1;
            break;
            
        case 1:
            count = self.dataSource.count;
            break;
            
        case 2:
            count = 1;
            break;
            
        default:
            break;
    }
    
    return count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        
        JGJCreatTeamCell *memberCell = [JGJCreatTeamCell cellWithTableView:tableView];
        
        memberCell.creatTeamModel = self.checkMembers[0];
        
        memberCell.lineView.hidden = YES;
        
        cell = memberCell;
        
    }else if (indexPath.section == 1) {
    
        JGJQuaSafeCheckItemCell *checkItemCell = [JGJQuaSafeCheckItemCell cellWithTableView:tableView];
        
        checkItemCell.infoModel = self.dataSource[indexPath.row];
        
        cell = checkItemCell;
    }else {
    
        JGJDescribeInfoCell *desCell = [JGJDescribeInfoCell cellWithTableView:tableView];
        
        desCell.desInfoModel = self.desInfoModel;
        
        cell = desCell;
    
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    JGJQuaSafePubCheckInfoModel *infoModel = self.dataSource[indexPath.row];
    
    if (indexPath.section == 0) {
        
        JGJTaskPrincipalVc *principalVc = [JGJTaskPrincipalVc new];
        
        principalVc.delegate = self;
        
        principalVc.proListModel = self.proListModel;
        
        principalVc.memberSelType = JGJPubCheckPlanSelMemberType;
        
        principalVc.title = @"选择检查执行人";
        
        principalVc.principalModel = self.principalModel;
        
        principalVc.principalModels = self.principalModels;
        
        principalVc.lastIndexPath = self.lastIndexPath;
        
        [self.navigationController pushViewController:principalVc animated:YES];
        
        
    }else if (indexPath.section == 1) {
        
        if ([infoModel.child_num isEqualToString:@"0"]) {
            [TYShowMessage showPlaint:@"该检查大项未中包括具体检查分项，不能加入检查计划"];
            return;
        }
        
        JGJQuaSafePubCheckInfoModel *infoModel = self.dataSource[indexPath.row];
        
        infoModel.isSelected = !infoModel.isSelected;
        
        if (infoModel.isSelected) {
            
            [self.selectedDataSource addObject:infoModel];
        }else {
        
            [self.selectedDataSource removeObject:infoModel];
        }
        
        [self.tableView beginUpdates];
        
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        [self.tableView endUpdates];
    
    }
    
    [self changeHeaderStatus];
}

#pragma mark - JGJTaskPrincipalVcDelegate
- (void)taskPrincipalVc:(JGJTaskPrincipalVc *)principalVc didSelelctedMemberModel:(JGJSynBillingModel *)memberModel {
    
    JGJCreatTeamModel *checkModel = self.checkMembers[0];
    
    checkModel.detailTitle = memberModel.real_name;
    
    checkModel.detailTitlePid = memberModel.uid;
    
    self.principalModels = principalVc.cacheSortContactsModels;
    
    self.lastIndexPath = principalVc.lastIndexPath;
    
    [self.tableView beginUpdates];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    [self.tableView endUpdates];
    
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)changeHeaderStatus {

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isSelected == %@", @(YES)];
    
    NSArray *selDataSource = [self.dataSource filteredArrayUsingPredicate:predicate];
    
    NSPredicate *canSelPredicate = [NSPredicate predicateWithFormat:@"child_num != %@", @"0"];
    
    NSArray *canSelDataSource = [self.dataSource filteredArrayUsingPredicate:canSelPredicate];
    
    self.itemHeader.selButton.selected = (canSelDataSource.count == selDataSource.count && selDataSource.count > 0);
    
    NSString *pubButtonTitle = @"发布";
    
    if (selDataSource.count > 0) {
        
       pubButtonTitle = [NSString stringWithFormat:@"发布(%@)", @(selDataSource.count)];

    }
    
    [self.pubButton setTitle:pubButtonTitle forState:UIControlStateNormal];
}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = 45.0;
    
    if (indexPath.section == 2) {
        
        height = 58;
    }

    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 10)];
    
    headerView.backgroundColor = AppFontf1f1f1Color;
    
    if (section == 1) {
        
        JGJPubQuaSafeCheckHeaderView *itemHeader = [JGJPubQuaSafeCheckHeaderView checkProHeaderViewWithTableView:tableView];
        self.itemHeader = itemHeader;
        itemHeader.delegate = self;
        
        headerView = itemHeader;
    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    CGFloat height = 10.0;
    
    if (section == 1) {
        
        height = [JGJPubQuaSafeCheckHeaderView pubQuaSafeCheckHeaderView];
    }
    
    return height;
}

#pragma mark - JGJPubQuaSafeCheckHeaderViewDelegate
- (void)pubQuaSafeCheckHeaderView:(JGJPubQuaSafeCheckHeaderView *)headerView selectedHeader:(BOOL)isSelectedHeader{

    if (isSelectedHeader) {
        
        for (JGJQuaSafePubCheckInfoModel *infoModel in self.dataSource) {
            
            if (![infoModel.child_num isEqualToString:@"0"]) {
                
                infoModel.isSelected = YES;
                
                [self.selectedDataSource addObject:infoModel];
                
            }else {
        
                infoModel.isSelected  = NO;
            }
            
        }
        
    }else {
    
        for (JGJQuaSafePubCheckInfoModel *infoModel in self.dataSource) {
            
            infoModel.isSelected = NO;
    
        }
        
        [self.selectedDataSource removeAllObjects];
    
    }
    
    [self changeHeaderStatus];
    
    [self.tableView reloadData];
}

- (void)pubCheckItemPressed {
    
    if (self.selectedDataSource.count == 0) {
        
        [TYShowMessage showPlaint:@"请至少选择一个检查大项"];
        
        return;
    }

    JGJCreatTeamModel *checkModel = self.checkMembers[0];

    self.requestModel.principal_uid = checkModel.detailTitlePid;
    
    NSMutableString *upLoadItemUids = [NSMutableString string];
    
    for (JGJQuaSafePubCheckInfoModel *infoModel in self.selectedDataSource) {
        
        if (![NSString isEmpty:infoModel.insp_id]) {
            
            [upLoadItemUids appendFormat:@"%@,",infoModel.insp_id];
        }
    }
    
    //    删除末尾的分号
    if (![NSString isEmpty:upLoadItemUids]) {
        
        [upLoadItemUids deleteCharactersInRange:NSMakeRange(upLoadItemUids.length - 1, 1)];
    }
    
    self.requestModel.insp_id = upLoadItemUids;
    
    NSDictionary *parameters = [self.requestModel mj_keyValues];
    
    [TYLoadingHub showLoadingWithMessage:nil];
    [JLGHttpRequest_AFN PostWithApi:@"v2/quality/pubInspectQuality" parameters:parameters success:^(id responseObject) {
        
        [TYShowMessage showSuccess:@"发布成功"];
        
        [TYLoadingHub hideLoadingView];
        
        [self freshTableView];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        [TYShowMessage showError:@"发布失败"];
    }];
}

- (void)freshTableView {
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        
        if ([vc isKindOfClass:[JGJChatListQualityVc class]]) {
            
            JGJChatListQualityVc *parentVc = (JGJChatListQualityVc *)vc;
            
            for (JGJQuaSafeCheckVc *childVc in parentVc.childViewControllers) {
                
                if ([childVc isKindOfClass:[JGJQuaSafeCheckVc class]]) {
                    
                    JGJQuaSafeCheckVc *checkVc = (JGJQuaSafeCheckVc *)childVc;
                    
                    
                    [checkVc freshTableView];
                    
                    break;
                }
                
            }
            
        }
    }
    
}

- (void)loadNetData {
    
    NSDictionary *parameters = @{@"parent_id" : @"0",
                                 @"group_id" : self.proListModel.group_id?:@"",
                                 @"class_type" : self.proListModel.class_type,
                                 @"msg_type" : self.commonModel.msg_type};
    [TYLoadingHub showLoadingWithMessage:nil];
    [JLGHttpRequest_AFN PostWithApi:@"v2/quality/getInspectQualityList" parameters:parameters success:^(id responseObject) {
        
        self.dataSource = [JGJQuaSafePubCheckInfoModel mj_objectArrayWithKeyValuesArray:responseObject[@"allrow"]];

        self.principalModel.real_name = responseObject[@"real_name"];
        
        JGJCreatTeamModel *checkModel = self.checkMembers[0];
        
        checkModel.detailTitle = self.principalModel.real_name;
        
        [TYLoadingHub hideLoadingView];
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];

}

- (void)setDataSource:(NSArray *)dataSource {

    _dataSource = dataSource;
    
    if (dataSource.count == 0) {
        
        [self.view addSubview:self.orderDefaultView];
        
    }else {
    
        self.tableView.hidden = NO;
    }
    
    self.pubButton.hidden = dataSource.count == 0;
    
    [self.tableView reloadData];

}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = AppFontf1f1f1Color;
    }
    
    return _tableView;
    
}

- (void)initialSubView {
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.bottom.mas_equalTo(self.view);
        
    }];
    
}

- (NSMutableArray *)checkMembers {
    
    if (!_checkMembers) {
        
        _checkMembers = [NSMutableArray new];
        
        NSString *myName = [TYUserDefaults objectForKey:JLGRealName];
        
        NSString *myUid = [TYUserDefaults objectForKey:JLGUserUid];
        
        NSArray *titles = @[@"检查执行人"];
        
        NSArray *detailTitles = @[myName];
        
        for (int indx = 0; indx < titles.count; indx ++) {
            
            JGJCreatTeamModel *checkModel = [[JGJCreatTeamModel alloc] init];
            
            checkModel.title = titles[indx];
            
            checkModel.detailTitle = detailTitles[indx];
            
            checkModel.detailTitlePid = myUid;
            
            [_checkMembers addObject:checkModel];
            
        }
        
    }
    
    return _checkMembers;
    
}

- (NSMutableArray *)selectedDataSource {

    if (!_selectedDataSource) {
        
        _selectedDataSource = [NSMutableArray new];
    }
    
    return _selectedDataSource;

}

- (JGJDescribeInfoModel *)desInfoModel {

    if (!_desInfoModel) {
        
        _desInfoModel = [JGJDescribeInfoModel new];
        
        NSString *classType = @"[质量]";
        
        if ([self.commonModel.msg_type isEqualToString:@"safe"]) {
            
            classType = @"[安全]";
            
        }
        
        _desInfoModel.desInfo = [NSString stringWithFormat:@"如需添加检查项,请在电脑浏览器上登录吉工宝\nwww.jgongb.com,进入%@模块进行设置", classType];
        
        _desInfoModel.changeColorInfo = classType;
        
    }

    return _desInfoModel;
}

- (JGJPubCheckPlanRequestModel *)requestModel {

    if (!_requestModel) {
        
        _requestModel = [JGJPubCheckPlanRequestModel new];
        
        _requestModel.group_id = self.proListModel.group_id;
        
        _requestModel.class_type = self.proListModel.class_type;
        
        //发布者Uid
        _requestModel.uid = [TYUserDefaults objectForKey:JLGUserUid];
        
        _requestModel.msg_type = self.commonModel.msg_type;
    }

    return _requestModel;
}

- (JGJSynBillingModel *)principalModel {

    if (!_principalModel) {
        
        _principalModel = [JGJSynBillingModel new];
        
        NSString *myName = [TYUserDefaults objectForKey:JLGRealName];
        
        NSString *myUid = [TYUserDefaults objectForKey:JLGUserUid];
        
        _principalModel.uid = myUid;
        
        _principalModel.real_name = myName;
    }
    
    return _principalModel;

}

- (JGJQuaSafeOrderDefaultView *)orderDefaultView {
    
    if (!_orderDefaultView) {
        
        _orderDefaultView = [[JGJQuaSafeOrderDefaultView alloc] initWithFrame:self.view.bounds];
        
        JGJQuaSafeOrderDefaultViewModel *infoModel = [JGJQuaSafeOrderDefaultViewModel new];
        
        infoModel.desButtonTitle = @"该项目还没有设置检查项";
        
        NSString *classType = @"[质量]";
        
        if ([self.commonModel.msg_type isEqualToString:@"safe"]) {
            
            classType = @"[安全]";

        }
        
        infoModel.desInfo = [NSString stringWithFormat:@"请在电脑浏览器上登录吉工宝\nwww.jgongb.com，进入%@模块进行设置", classType];

        infoModel.changeColorDes = classType;
        
        infoModel.actionButtonTitle = @"";
        
        infoModel.isHiddenActionButton = YES;
        
        infoModel.isHiddenlineView = YES;
        
        infoModel.desInfoFontSize = AppFont28Size;
        
        infoModel.desButtonFontColor = AppFontB9B9B9Color;
        
        infoModel.desInfoFontColor = AppFontB9B9B9Color;
        
        _orderDefaultView.infoModel = infoModel;
        
    }
    
    return _orderDefaultView;
}

@end
