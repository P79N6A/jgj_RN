//
//  JGJMemberAppraiseDetailVc.m
//  mix
//
//  Created by yj on 2018/6/9.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJMemberAppraiseDetailVc.h"

#import "JGJComTitleCell.h"

#import "JGJMemberImpressTagCell.h"

#import "JGJMemberAppraiseStarsCell.h"

#import "JGJRefreshTableView.h"

#import "JGJMemberEvalueCell.h"

#import "JGJCustomDefaultView.h"

#import "JGJMemberImpressTagView.h"

#import "JGJTabPaddingView.h"

#import "JGJHeaderFooterPaddingView.h"

@interface JGJMemberAppraiseDetailVc () <

    UITableViewDelegate,

    UITableViewDataSource

>

@property (nonatomic, strong) JGJRefreshTableView *tableView;

@property (nonatomic, strong) JGJComTitleCellDesModel *comTitleCellDesMode;

@property (nonatomic, strong) NSMutableArray *starsScores;

//星星头部距离
@property (nonatomic, assign) CGFloat maxStarLead;

@property (nonatomic, strong) NSArray *evalueList;

@property (nonatomic, strong) JGJCustomDefaultView *defaultView;

//标签高度
@property (nonatomic, assign) CGFloat tagViewHeight;


@property (nonatomic, strong) JGJMemberMangerModel *mangerModel;

@end

@implementation JGJMemberAppraiseDetailVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"评价详情";
    
    self.view.backgroundColor = AppFontf1f1f1Color;
    
    [self.view addSubview:self.tableView];
    
    [self setLeftBatButtonItem];
    
    //获取评价分数
    [self loadNetData];
    
    [self loadEvalueList];
}

- (void)setLeftBatButtonItem {
    
    SEL getLeftButton = NSSelectorFromString(@"getLeftNoTargetButton");
    
    IMP imp = [self.navigationController methodForSelector:getLeftButton];
    
    UIButton* (*func)(id, SEL) = (void *)imp;
    
    UIButton *leftButton = func(self.navigationController, getLeftButton);
    
    [leftButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
}

- (void)backButtonPressed {
    
    UIViewController *popVc = nil;
    
    if (self.isMemberManagerInfoVCComeIn) {
        
        for (UIViewController *vc in self.navigationController.viewControllers) {

            if ([vc isKindOfClass:NSClassFromString(@"JGJMemeberMangerDetailVc")]) {
                
                popVc = vc;
                
                [self.navigationController popToViewController:vc animated:YES];
                
                break;
            }
            
        }
        
    }else {
        
        for (UIViewController *vc in self.navigationController.viewControllers) {

            if ([vc isKindOfClass:NSClassFromString(@"JGJMemeberMangerDetailVc")] || [vc isKindOfClass:NSClassFromString(@"JGJWorkingChatMsgViewController")] || [vc isKindOfClass:NSClassFromString(@"JGJMemeberMangerVc")]) {
                
                popVc = vc;
                
                [self.navigationController popToViewController:vc animated:YES];
                
                break;
            }
            
        }
    }
//    for (UIViewController *vc in self.navigationController.viewControllers) {
////        JGJMemeberMangerDetailVc
//        if ([vc isKindOfClass:NSClassFromString(@"JGJMemeberMangerDetailVc")] || [vc isKindOfClass:NSClassFromString(@"JGJWorkingChatMsgViewController")] || [vc isKindOfClass:NSClassFromString(@"JGJMemeberMangerVc")]) {
//            
//            popVc = vc;
//            
//            [self.navigationController popToViewController:vc animated:YES];
//            
//            break;
//        }
//        
//    }
    
    if (!popVc) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }

}

- (void)loadEvalueList {
    
    JGJRequestBaseModel *request = [[JGJRequestBaseModel alloc] init];
    
    NSMutableDictionary *body = @{@"uid" : self.memberModel.uid?:@""}.mutableCopy;
    
    if (![NSString isEmpty:_cur_role] && ![_cur_role isEqualToString:@"0"]) {
        
        body[@"cur_role"] = _cur_role;
    }
    
    request.body = body;
    
    request.requestApi = @"evaluate/evaluate-list";
    
    self.tableView.request = request;
    
    TYWeakSelf(self);
    
    [self.tableView loadWithViewOfStatus:^UIView *(JGJRefreshTableView *tableView, JGJRefreshTableViewStatus status) {
        
        weakself.evalueList = [JGJMemberEvaListModel mj_objectArrayWithKeyValuesArray:tableView.dataArray];
        
        if (weakself.evalueList.count > 0) {
            
            JGJMemberEvaListModel *evaModel = weakself.evalueList.firstObject;
            
            evaModel.is_near_eva = YES;
        }
        
        [weakself.tableView reloadData];
        
        return nil;
    }];
    
}

- (void)loadNetData {
    
    NSMutableDictionary *parameters = @{@"uid" : self.memberModel.uid?:@""}.mutableCopy;
    
    if (![NSString isEmpty:_cur_role] && ![_cur_role isEqualToString:@"0"]) {
        
        parameters[@"cur_role"] = _cur_role;
    }
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithNapi:@"evaluate/evaluate-info" parameters:parameters success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        JGJMemberMangerModel *mangerModel = [JGJMemberMangerModel mj_objectWithKeyValues:responseObject];
        
        self.mangerModel = mangerModel;
        
        self.tableView.hidden = NO;
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = CGFLOAT_MIN;
    
    if (indexPath.section == 0) {
        
        height = [self firstSectionHeightForRowAtIndexPath:indexPath];
        
    }else {
        
        JGJMemberEvaListModel *listModel = self.evalueList[indexPath.row];
        
        height = listModel.cellHeight;
    }
    
    return height;
}

- (CGFloat)firstSectionHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = CGFLOAT_MIN;
    
    switch (indexPath.row) {
        case 0:{
            
            height = 45;
        }
            
            break;
            
        case 1:
            
        case 2:
            
        case 3:{
            
            JGJMemberAppraiseStarsModel *starsModel = self.starsScores[indexPath.row - 1];
            
            height = starsModel.height;
            
        }
            
            break;
            
        case 4:{
            
            height = self.tagViewHeight;
            
        }
            
            break;
    }
    
    return height;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger count = section == 0 ? 5 : self.evalueList.count;
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    switch (indexPath.section) {
        case 0:{
            
            switch (indexPath.row) {
                case 0:{
                    
                    cell = [self registerComTitleCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
                }
                    
                    break;
                    
                case 1:
                    
                case 2:
                    
                case 3:{
                    
                   cell = [self registerStarsCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
                }
                    
                    break;
                    
                case 4:{
                    
                    cell = [self registerImpressTagCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
                }
                    
                    break;
                    
                default:
                    break;
            }
        
        }
            
            break;
            
        case 1:{
            
            cell = [self registerEvalueCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
        }
            
            break;
            
        default:
            break;
    }
    
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return section == 0 ? [JGJHeaderFooterPaddingView headerFooterPaddingViewWithTableView:tableView] : nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return section == 0 ? 10 : CGFLOAT_MIN;
}

- (UITableViewCell *)registerComTitleCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJComTitleCell *cell = [JGJComTitleCell cellWithTableView:tableView];
    
    cell.desModel = self.comTitleCellDesMode;
    
    return cell;
    
}

- (UITableViewCell *)registerImpressTagCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJMemberImpressTagCell *cell = [JGJMemberImpressTagCell cellWithTableView:tableView];
    
    cell.tagViewType = JGJMemberImpressShowTagViewType;
    
    cell.tagModels = self.mangerModel.tag_list;
    
    return cell;
    
}
    
- (UITableViewCell *)registerStarsCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        
    JGJMemberAppraiseStarsCell *cell = [JGJMemberAppraiseStarsCell cellWithTableView:tableView];
    
    cell.starsModel = self.starsScores[indexPath.row - 1];

    cell.maxStarLead = self.maxStarLead;
    
    return cell;
        
}

- (UITableViewCell *)registerEvalueCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJMemberEvalueCell *cell = [JGJMemberEvalueCell cellWithTableView:tableView];
    
    cell.listModel = self.evalueList[indexPath.row];
//
//    cell.maxStarLead = self.maxStarLead;
    
    return cell;
    
}

- (void)setEvalueList:(NSArray *)evalueList {
    
    _evalueList = evalueList;
    
    [self.tableView reloadData];
    
}

- (void)setMangerModel:(JGJMemberMangerModel *)mangerModel {
    
    _mangerModel = mangerModel;
    
    //计算标签高度
    [self tagViewHeightWithTagNames:_mangerModel.tag_list];
    
    _mangerModel.starsScores = [self starsScores];
    
//    CGFloat want_cooperation_rate = [NSString stringWithFormat:@"%.2lf", _mangerModel.want_cooperation_rate.doubleValue].doubleValue * 100.0;
    
//    NSString *changeColorStr = [NSString stringWithFormat:@"%@%%", @(want_cooperation_rate)];
    
    NSString *des = [NSString stringWithFormat:@"%@人参与评价，其中%@人愿意再次雇佣他", mangerModel.evaluate_pnum?:@"0",mangerModel.want_pnum?:@"0"];
    
    if (JLGisMateBool) {
        
        des = [NSString stringWithFormat:@"%@人参与评价，其中%@人愿意再次为他工作", mangerModel.evaluate_pnum?:@"0",mangerModel.want_pnum?:@"0"];
    }
    
    self.comTitleCellDesMode.des = des;
    
    self.comTitleCellDesMode.changeColors = @[mangerModel.evaluate_pnum?:@"0",mangerModel.want_pnum?:@"0"];
    
//    self.comTitleCellDesMode.changeColorStr = changeColorStr;
    
    [self.tableView reloadData];
}

#pragma mark - 计算高度
- (CGFloat)tagViewHeightWithTagNames:(NSArray *)tagModels {
    
    JGJMemberImpressTagView *tagView = [[JGJMemberImpressTagView alloc] init];
    
    tagView = [tagView tagViewWithTags:tagModels tagViewType:(JGJMemberImpressTagViewType)JGJMemberImpressShowTagViewType];
    
    self.tagViewHeight = tagView.height;
    
    [self.tableView reloadData];
    
    return tagView.height;
}

- (JGJRefreshTableView *)tableView {
    
    if (!_tableView) {
        
        CGRect rect = CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight - JGJ_NAV_HEIGHT);
        
        _tableView = [[JGJRefreshTableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.dataSource = self;
        
        _tableView.delegate = self;
        
        _tableView.backgroundColor = AppFontf1f1f1Color;
        
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 10)];
        
        headView.backgroundColor = AppFontf1f1f1Color;
        
        _tableView.tableHeaderView = headView;
        
        _tableView.hidden = YES;
    }
    
    return _tableView;
}

- (JGJComTitleCellDesModel *)comTitleCellDesMode {
    
    if (!_comTitleCellDesMode) {
        
        _comTitleCellDesMode = [[JGJComTitleCellDesModel alloc] init];
        
        _comTitleCellDesMode.title = @"评价";
        
        _comTitleCellDesMode.des = @"";
    }
    
    return _comTitleCellDesMode;
}

- (NSArray *)starsScores {
    
    NSArray *titles = @[@"工作态度", @"专业技能", @"靠谱程度"];
    
    if (JLGisMateBool) {
        
        titles = @[@"没有拖欠工资", @"没有辱骂工人", @"靠谱程度"];
        
    }
    
    self.maxStarLead = [NSString maxWidthWithContents:titles offset:35.0 font:AppFont30Size];
    
    NSArray *scroes = @[self.mangerModel.attitude_or_arrears?:@"0",self.mangerModel.professional_or_abuse?:@"0",self.mangerModel.reliance_degree?:@"0"];
    
    _starsScores = [NSMutableArray array];
    
    for (NSInteger index = 0; index < titles.count; index++) {
        
        JGJMemberAppraiseStarsModel *starsModel = [JGJMemberAppraiseStarsModel new];
        
        starsModel.title = titles[index];
        
        starsModel.score = scroes[index];
        
        starsModel.isForbidTouch = YES;
        
        starsModel.height = index == 1 ? 15 : 54;
        
        [_starsScores addObject:starsModel];
    }
    
    return _starsScores;
}

@end
