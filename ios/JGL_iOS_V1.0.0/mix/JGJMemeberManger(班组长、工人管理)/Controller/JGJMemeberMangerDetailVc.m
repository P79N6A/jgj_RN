//
//  JGJMemeberMangerDetailVc.m
//  mix
//
//  Created by yj on 2018/4/18.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJMemeberMangerDetailVc.h"

#import "JGJMemManDetailMemCell.h"

#import "JGJRecordStaListCell.h"

#import "JGJMemberAppraiseStarsCell.h"

#import "JGJMemberAppraiseListCell.h"

#import "JGJMemberImpressTagCell.h"

#import "JGJComTitleCell.h"

#import "JGJRecordStaListHeaderView.h"

#import "JGJCusBottomButtonView.h"

#import "JGJMemberMangerModel.h"

#import "JGJComLineSpacingCell.h"

#import "JGJMemberMangerAppraiseVc.h"

#import "JGJMemberImpressTagView.h"

#import "JGJMemberMangerRequestModel.h"

#import "MJRefresh.h"

#import "UITableView+FDTemplateLayoutCell.h"

#import "JGJModMemberView.h"

#import "JGJComDefaultView.h"

#import "JGJRecordStaListDetailVc.h"

#import "JLGCustomViewController.h"

#import "JGJMemberAppraiseDetailVc.h"

#import "JGJCustomDefaultView.h"

#import "JGJModifyInfoVc.h"

#import "JGJRecordHeader.h"

#import "JGJPerInfoVc.h"

#import "JGJWorkerRemarkCell.h"

#import "JGJComTitleDesCell.h"
#import "JGJMoreDayViewController.h"

#import "JGJMemeberMangerVc.h"

#define JGJPageSize 20

@interface JGJMemeberMangerDetailVc () <

    UITableViewDelegate,

    UITableViewDataSource

>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) JGJCusBottomButtonView *buttonView;

@property (nonatomic, strong) JGJMemberMangerModel *mangerModel;

@property (nonatomic, assign) CGFloat maxTrail;

//星星头部距离
@property (nonatomic, assign) CGFloat maxStarLead;

//评价列表
@property (nonatomic, strong) NSMutableArray *evaList;

@property (nonatomic, strong) JGJMemberEvaListRequestModel *evaListRequestModel;

@property (nonatomic, strong) JGJComTitleCellDesModel *comTitleCellDesMode;

@property (nonatomic, strong) JGJComTitleDesInfoModel *modifyRecordDesModel;

//评价缺省页
@property (nonatomic, strong) JGJCustomDefaultView *defaultView;

@property (nonatomic, strong) JGJMemberImpressTagView *tagView;

@property (nonatomic, strong) JGJMemberImpressTagCell *tagCell;

@property (nonatomic, strong) JGJCustomDefaultViewModel *defaultViewModel;

@property (nonatomic, strong) JGJGetWorkTplByUidModel *getWorkTplByUidModel;
@end

@implementation JGJMemeberMangerDetailVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = JLGisMateBool ? @"班组长信息" : @"工人信息";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"JGJMemberAppraiseListCell" bundle:nil] forCellReuseIdentifier:@"JGJMemberAppraiseListCell"];
    
    self.view.backgroundColor = AppFontf1f1f1Color;
    
    [self.view addSubview:self.tableView];
    
    [self loadNetData];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (_isFresh) {
        
        [self resetTagView];
        
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadEvaluateList)];
        
    }
}


#pragma mark - 重置页面
- (void)resetTagView {
    
    self.evaListRequestModel.pg = 1;
    
    [self.evaList removeAllObjects];
    
    [self.tagCell.tagView.tags removeAllObjects];
    
    for (UIButton *btn in self.tagCell.tagView.subviews) {
        
        [btn removeFromSuperview];
        
    }
    
    [self loadNetData];
    
    [self loadEvaluateList];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = CGFLOAT_MIN;
    
    switch (indexPath.section) {
            
        case 0:{
            
            height = 80;

        }
            
            break;
            
        case 1:{
            
            height = self.mangerModel.notes_H;
        }
            break;
            
        case 2:{
            
            height = 50;
        }
            break;
            
        case 3:{
            
            //这里多一个结算高度
            
            CGFloat offset =  [JGJRecordStaListCell cellHeight] + 19;
            
            height = self.mangerModel.isExistRecordData ? offset: CGFLOAT_MIN;
        }
            
            break;
            
        default:
            break;
    }
    
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger count = 0;
    
    switch (section) {
        case 0:
        case 1:
        case 2:
            
            count = 1;
            
            break;

        case 3:
            
            count = self.mangerModel.isExistRecordData ? 1 : 0;
            
            break;
        
        case 4:{
            
            count = self.mangerModel.isExistStar ? 6 : 0;
         
        }
            
            break;
            
        case 5:{
            
//            count = self.evaList.count;
            
        }
            
            break;
            
        default:
            break;
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    switch (indexPath.section) {
        case 0:{
            
            cell = [self registerMemberCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
            
        }
            break;
            
        case 1:{
            
            cell = [self registerRemarkCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
        }
            break;
            
        case 2:{
            
            cell = [self registerBatchModifyRecordCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
        }
            break;
            
        case 3:{
            
            cell = [self registerRecordStaListCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
        }
            break;
            
        default:
            break;
    }
    
    return cell;
    
}

- (UITableViewCell *)registerRemarkCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJWorkerRemarkCell *cell = [JGJWorkerRemarkCell cellWithTableView:tableView];
    
    cell.mangerModel = self.mangerModel;
    
    return cell;
}

- (UITableViewCell *)registerBatchModifyRecordCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJComTitleDesCell *cell = [JGJComTitleDesCell cellWithTableView:tableView];
    
    cell.infoModel = self.modifyRecordDesModel;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //人员统计
    
    //点击修改记工
    
    if (indexPath.section == 2 && indexPath.row == 0) {
        
        [self clickModifyRecord];
        
    }else if (indexPath.section == 3 && indexPath.row == 0) {
        
        [self staListDetailVc];
        
    }
    
}

- (UITableViewCell *)registerMemberCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJMemManDetailMemCell *cell = [JGJMemManDetailMemCell cellWithTableView:tableView];
    
    TYWeakSelf(self);
    
    cell.memberModel  = self.memberModel;
    
    cell.memManDetailMemCellBlock = ^(JGJSynBillingModel *memberModel, JGJMemManDetailMemBtntype btnType) {
      
        if (btnType == JGJMemManDetailMemHeadBtntype) {
            
            [weakself headBtnTypePressed:memberModel];
            
        }else if (btnType == JGJMemManDetailMemEditInfoBtntype) {
            
            [weakself modifyNameButtonPressed];
            
        }
        
    };
    
    return cell;
    
}

- (UITableViewCell *)registerRecordStaListCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJRecordStaListCell *cell = [JGJRecordStaListCell cellWithTableView:tableView];
    
    cell.isShowWork = NO;
    
    cell.maxTrail = self.maxTrail;
    
    JGJRecordWorkStaListModel *staListModel = self.mangerModel.bill_info;
    
    staListModel.name = self.memberModel.name;

  
    cell.staListModel = staListModel;

    cell.lineView.hidden = NO;

    cell.isScreenShowLine = YES;
    
    return cell;
    
}

- (UITableViewCell *)registerStarsCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJMemberAppraiseStarsCell *cell = [JGJMemberAppraiseStarsCell cellWithTableView:tableView];
    
    cell.starsModel = self.mangerModel.starsScores[indexPath.row - 1];
    
    cell.maxStarLead = self.maxStarLead;
    
    return cell;
    
}

- (UITableViewCell *)registerAppraiseListCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    JGJMemberAppraiseListCell *cell = [JGJMemberAppraiseListCell cellWithTableView:tableView];
    
    JGJMemberAppraiseListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JGJMemberAppraiseListCell" forIndexPath:indexPath];
    
    cell.evaModel = self.evaList[indexPath.row];
    
    return cell;
    
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
        
    self.tagCell = cell;
    
    return cell;
    
}

- (UITableViewCell *)registerComLineSpacingCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJComLineSpacingCell *cell = [JGJComLineSpacingCell cellWithTableView:tableView];
    
    cell.lineView.hidden = YES;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 1 || section == 2 || section == 3) {
        
        return 10;
    }
    
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    CGFloat height = 0.01;
    
    switch (section) {
            
        case 2:
            
        case 3:{
            
            height = 10;
        }
            
            break;
            
        default:
            break;
    }
    
    return  [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, height)];

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    CGFloat height = 0.01;
    
    if (section == 3 && self.mangerModel.isExistRecordData) {
        
        height = 30;
        
    }else if (section == 3) {
        
        height = 10;
    }
    
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    JGJRecordStaListHeaderView *headerView = [[JGJRecordStaListHeaderView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 30)];
    
    return section == 3 && self.mangerModel.isExistRecordData ? headerView : [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 0.01)];
}

- (void)loadNetData {
    
    NSDictionary *parameters = @{@"uid" : self.memberModel.uid?:@""};
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithNapi:@"evaluate/evaluate-info" parameters:parameters success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        JGJMemberMangerModel *mangerModel = [JGJMemberMangerModel mj_objectWithKeyValues:responseObject];
        
        NSMutableArray *notes_img = [NSMutableArray new];

        if (mangerModel.notes_img.count > 0) {

            for (NSString *img in mangerModel.notes_img) {

                if (![NSString isEmpty:img]) {

                    [notes_img addObject:img];
                }
            }
        }
        
        mangerModel.notes_img = notes_img;
        
        BOOL isExistRecordData = NO;
        
        if (mangerModel.bill_info) {
            
            isExistRecordData = YES;
        }
        
        mangerModel.isExistRecordData = isExistRecordData;
        
        //是否有评论分数
        
         BOOL isExistStar = NO;
        
        if (mangerModel.professional_or_abuse || mangerModel.attitude_or_arrears || mangerModel.reliance_degree) {
            
            isExistStar = YES;
        }
        
        mangerModel.bill_info.name = self.memberModel.name;
        
        mangerModel.isExistStar = isExistStar;
        
        //隐藏评价按钮
        if (!mangerModel.can_evaluate) {
            
            [self unCanEvalueWithIsAddDefault:NO];
        }
        
        //评价数量
        
        [self showDefaultWithEvalueCount:mangerModel.evaluate_num];
        
        self.mangerModel = mangerModel;
        
        [self calRemarkHeight:mangerModel];
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
}

#pragma mark - 获取工资模板

- (void)getWageForm {
    
    
    
}

- (JGJGetWorkTplByUidModel *)getWorkTplByUidModel {
    
    if (!_getWorkTplByUidModel) {
        
        _getWorkTplByUidModel = [[JGJGetWorkTplByUidModel alloc] init];
        
    }
    return _getWorkTplByUidModel;
}

#pragma mark - 点击修改记工，修改回来有个block回调刷新当页数据

- (void)clickModifyRecord {
    
    //self.memberModel.uid 人的uid ，getWageForm模板接口
    
    
    NSDictionary *parameters = @{@"accounts_type":@"1",
                                 @"uid":self.memberModel.uid?:@""};
    
    [TYLoadingHub showLoadingWithMessage:nil];
    [JLGHttpRequest_AFN PostWithNapi:@"workday/get-work-tpl-by-uid" parameters:parameters success:^(id responseObject) {
        
        self.getWorkTplByUidModel = [JGJGetWorkTplByUidModel mj_objectWithKeyValues:responseObject];
        
        JGJMoreDayViewController *moreDay = [[JGJMoreDayViewController  alloc] init];
        moreDay.is_Need_ChoiceType_Cache = YES;
        YZGGetBillModel *JlgGetBillModel = [[YZGGetBillModel alloc] init];
        
        GetBillSet_Tpl *set_tpl = [[GetBillSet_Tpl alloc] init];
        set_tpl.w_h_tpl = self.getWorkTplByUidModel.my_tpl.w_h_tpl;
        set_tpl.s_tpl = self.getWorkTplByUidModel.my_tpl.s_tpl;
        set_tpl.o_h_tpl = self.getWorkTplByUidModel.my_tpl.o_h_tpl;
        set_tpl.hour_type = self.getWorkTplByUidModel.my_tpl.hour_type;
        set_tpl.o_s_tpl = self.getWorkTplByUidModel.my_tpl.o_s_tpl;
        JlgGetBillModel.set_tpl = set_tpl;
        JlgGetBillModel.name = self.memberModel.real_name;
        JlgGetBillModel.uid = [self.memberModel.uid integerValue];
        JlgGetBillModel.phone_num = self.memberModel.telephone;
        JlgGetBillModel.is_not_telph = self.memberModel.is_not_telph;
        
        JlgGetBillModel.proname = self.memberModel.proname;
        
        if ([NSString isEmpty:self.memberModel.proname]) {
            
            JlgGetBillModel.proname = nil;
        }
        
        NSInteger pid = 0;
        
        if (![NSString isEmpty:self.memberModel.pid]) {
            
            pid = [self.memberModel.pid integerValue];
        }
        
        JlgGetBillModel.pid = pid;
        
        moreDay.JlgGetBillModel = JlgGetBillModel;
        
        TYWeakSelf(self);
        moreDay.recordBillSuccess = ^{
            
            [weakself loadNetData];
            
            [weakself freshMemberManger];
            
        };
        [self.navigationController pushViewController:moreDay animated:YES];
        [TYLoadingHub hideLoadingView];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
    }];
    
    

    
}

- (void)freshMemberManger {
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        
        if ([vc isKindOfClass:NSClassFromString(@"JGJMemeberMangerVc")]) {
            
            JGJMemeberMangerVc *mangerVc = (JGJMemeberMangerVc *)vc;
            
            [mangerVc beginReFresh];
            
            break;
        }
        
    }
    
}

- (void)calRemarkHeight:(JGJMemberMangerModel *)mangerModel {
    
    CGFloat note_text_H = [NSString stringWithContentWidth:TYGetUIScreenWidth - 40 content:mangerModel.notes_txt font:AppFont28Size];
    
    mangerModel.notes_txt_H = note_text_H;
    
    CGFloat notes_img_H = [JGJRemarkAvatarView avatarViewHeightWithImageCount:mangerModel.notes_img.count];
    
    mangerModel.notes_img_H = notes_img_H;
    
    mangerModel.notes_H = note_text_H + notes_img_H + 8 + 17 + 25 + 8 + 10;
    
    if ([NSString isEmpty:mangerModel.notes_txt] && mangerModel.notes_img.count > 0) {
        
        mangerModel.notes_H = note_text_H + notes_img_H + 25 + 10 + 10;
        
    }else if ([NSString isEmpty:mangerModel.notes_txt] && mangerModel.notes_img.count == 0) {
        
        mangerModel.notes_H = 0;
        
    }else if (![NSString isEmpty:mangerModel.notes_txt] && mangerModel.notes_img.count == 0) {
        
        mangerModel.notes_H = note_text_H + notes_img_H + 8 + 17 + 25 + 10;
    }
    
}

- (void)loadEvaluateList {
    
    NSDictionary *parameters = @{@"uid" : self.memberModel.uid?:@"",
                                 
                                 @"pg" : @(self.evaListRequestModel.pg),
                                 
                                 @"pagesize" : @(JGJPageSize)
                                 
                                 };
    
    [JLGHttpRequest_AFN PostWithNapi:@"evaluate/evaluate-list" parameters:parameters success:^(id responseObject) {
        
        NSArray *evaList = [JGJMemberEvaListModel mj_objectArrayWithKeyValuesArray:responseObject];
        
        if (evaList.count  > 0) {
            
            _tableView.tableFooterView.height = 24;
            
        }else {
            
            _tableView.tableFooterView.height = 0.01;
        }
        
        if (evaList.count > 0) {
            
            self.evaListRequestModel.pg ++;
            
            [self.evaList addObjectsFromArray:evaList];
            
        }
        
        if (evaList.count < JGJPageSize) {
            
            self.tableView.mj_footer = nil;
            
        }
        
        [self.tableView.mj_footer endRefreshing];
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {

    }];
    
}



- (NSMutableArray *)evaList {
    
    if (!_evaList) {
        
        _evaList = [NSMutableArray array];
    }
    
    return _evaList;
}

- (void)setMangerModel:(JGJMemberMangerModel *)mangerModel {
    
    _mangerModel = mangerModel;
    
    //计算标签高度
    [self tagViewHeightWithTagNames:mangerModel.tag_list];
    
    //计算记账数据到尾部偏移
    
    if (mangerModel.bill_info) {

        self.maxTrail = [JGJRecordStaListCell maxWidthWithStaList:@[mangerModel.bill_info]] + 5;
        
    }
    
    self.mangerModel.starsScores = [self starsScores];
    
    CGFloat want_cooperation_rate = [NSString stringWithFormat:@"%.2lf", mangerModel.want_cooperation_rate.doubleValue].doubleValue * 100.0;
    
    NSString *changeColorStr = [NSString stringWithFormat:@"%@%%", @(want_cooperation_rate)];
    
    NSString *des = [NSString stringWithFormat:@"%@%@", changeColorStr,@"的人愿意再次雇佣他"];
    
    if (JLGisMateBool) {
        
        des = [NSString stringWithFormat:@"%@%@", changeColorStr,@"的人愿意再次为他工作"];
    }
    
    self.comTitleCellDesMode.des = des;
    
    self.comTitleCellDesMode.changeColorStr = changeColorStr;
    
    _tableView.hidden = NO;
    
    [self.tableView reloadData];
}

- (NSArray *)starsScores {
    
    NSArray *titles = @[@"工作态度", @"专业技能", @"靠谱程度"];
    
    if (JLGisMateBool) {
        
        titles = @[@"没有拖欠工资", @"没有辱骂工人", @"靠谱程度"];
        
    }
    
   self.maxStarLead = [NSString maxWidthWithContents:titles offset:35.0 font:AppFont30Size];
    
    NSArray *scroes = @[self.mangerModel.attitude_or_arrears?:@"0",self.mangerModel.professional_or_abuse?:@"0",self.mangerModel.reliance_degree?:@"0"];
    
    NSMutableArray *starsScores = [NSMutableArray array];
    
    for (NSInteger index = 0; index < titles.count; index++) {
        
        JGJMemberAppraiseStarsModel *starsModel = [JGJMemberAppraiseStarsModel new];
        
        starsModel.title = titles[index];
        
        starsModel.score = scroes[index];
        
        starsModel.isForbidTouch = YES;
        
        starsModel.height = index == 1 ? 15 : 54;
        
        [starsScores addObject:starsModel];
    }
    
    return starsScores;
}

#pragma mark - 计算高度
- (CGFloat)tagViewHeightWithTagNames:(NSArray *)tagModels {
    
    JGJMemberImpressTagView *tagView = [[JGJMemberImpressTagView alloc] init];
    
    tagView = [tagView tagViewWithTags:tagModels tagViewType:(JGJMemberImpressTagViewType)JGJMemberImpressShowTagViewType];
    
    self.mangerModel.tagViewHeight = tagView.height;
    
    return tagView.height;
}

#pragma mark - 修改姓名
- (void)modifyNameButtonPressed {
    
    TYWeakSelf(self);
    
    JGJModifyInfoVc *modifyInfoVc = [[JGJModifyInfoVc alloc] init];
    
    modifyInfoVc.memberModel = self.memberModel;
    
    modifyInfoVc.mangerModel = self.mangerModel;
    
    [self.navigationController pushViewController:modifyInfoVc animated:YES];
    
    modifyInfoVc.modifyInfoBlock = ^(JGJCommonInfoDesModel *remarkModel) {
        
        weakself.memberModel.real_name = remarkModel.des;
        
        UIColor *backGroundColor = [NSString modelBackGroundColor:remarkModel.des];
        
        weakself.memberModel.modelBackGroundColor = backGroundColor;
        
        [weakself.tableView reloadData];
        
        //修改姓名
        [weakself modifyUserEvalueInfo:remarkModel];

    };
    
}

#pragma mark - 点击头部到他的资料
- (void)headBtnTypePressed:(JGJSynBillingModel *)memberModel {
    
    //工人还未在平台注册但添加的时候，有电话号码，点击他的头像，气泡提示“该用户还未注册，赶紧邀请他下载[吉工家]一起使用吧！
    
    if (![memberModel.is_active isEqualToString:@"1"] && !memberModel.is_not_telph) {
        
        [TYShowMessage showPlaint:@"该用户还未注册，赶紧邀请他下载[吉工家]一起使用吧！"];
        
    }else if ([memberModel.is_active isEqualToString:@"1"]) {
        
        [self perInfoWithMemberModel:memberModel];
        
    }
    
}

#pragma mark - 如该工人已经在平台注册，点击他的头像，跳转到“他的资料”界面

- (void)perInfoWithMemberModel:(JGJSynBillingModel *)memberModel {
    
    JGJPerInfoVc *perInfoVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJPerInfoVc"];
    
    perInfoVc.jgjChatListModel.uid = memberModel.uid;
    
    perInfoVc.jgjChatListModel.group_id = memberModel.uid;
    
    perInfoVc.jgjChatListModel.class_type = @"singleChat";
    
    [self.navigationController pushViewController:perInfoVc animated:YES];
    
    TYWeakSelf(self);
    
    perInfoVc.callHandelPerInfoBlock = ^(JGJChatPerInfoModel *perInfoModel) {
      
        weakself.memberModel.real_name = perInfoModel.comment_name;
        
        UIColor *backGroundColor = [NSString modelBackGroundColor:perInfoModel.comment_name];
        
        weakself.memberModel.modelBackGroundColor = backGroundColor;
        
        [weakself.tableView reloadData];
        
    };
    
}

#pragma mark - 修改用户信息
- (void)modifyUserEvalueInfo:(JGJCommonInfoDesModel *)evalueInfo {
    
    NSString *name = evalueInfo.des;
    
    NSString *notes_txt = evalueInfo.notes_txt;
    
    NSString *notes_img = evalueInfo.notes_img;
    
    if ([NSString isEmpty:name]) {
        
        NSString *warningStr = [NSString stringWithFormat:@"请输入%@的姓名", JLGisLeaderBool ? @"工人" : @"班组长"];
        
        [TYShowMessage showPlaint:warningStr];
        
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"uid" : self.memberModel.uid?:@"",
                                 @"comment_name" : name?:@"",
                                 @"notes_txt" : notes_txt?:@"",
                                 @"notes_img" : notes_img?:@"",
                                 @"modify_parnter" : @"1"
                                 };
    

    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithNapi:JGJModifyCommentNameURL parameters:parameters success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        [self loadNetData];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
    }];
}

#pragma mark - 不能评价 、添加缺省页隐藏按钮
- (void)unCanEvalueWithIsAddDefault:(BOOL)isAddDefault {
    
    self.tableView.frame = self.view.bounds;
    
    self.buttonView.hidden = YES;
    
    if (isAddDefault) {

        self.tableView.tableFooterView = self.defaultView;
    }

}

#pragma mark - 显示评价按钮
- (void)showDefaultWithEvalueCount:(NSString *)count {
    
    _defaultView = [[JGJCustomDefaultView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 400)];
    
    TYWeakSelf(self);
    
    if (![NSString isEmpty:count] && ![count isEqualToString:@"0"]) {
        
        self.defaultViewModel.isOnlyShowLeft = YES;
        
        self.defaultViewModel.des = [NSString stringWithFormat:@"该%@已收到 %@ 条评价", [self roleDes], count];
        
        self.defaultViewModel.changeColorDes = [NSString stringWithFormat:@"%@", count];
        
        self.defaultViewModel.imageStr = @"evalue_exist_data";
        
        self.defaultViewModel.rightButtonTitle = @"我也去评价";
        
    }else {
        
        self.defaultViewModel.des = [NSString stringWithFormat:@"暂时还没人对该%@评价过", [self roleDes]];
        
        self.defaultViewModel.imageStr = @"evalue_unexist_data";
        
        self.defaultViewModel.rightButtonTitle = @"我去评价";
    }
    
    self.defaultViewModel.leftButtonTitle = @"查看对他的评价";
    
    self.defaultView.leftBtnActionBlock = ^{
    
        [weakself checkEvalue];
    };
    
    self.defaultView.rightBtnActionBlock = ^{
        
        if (weakself.mangerModel.can_evaluate) {
            
            [weakself skipEvalueVc];
            
        }else {
            
            if (![NSString isEmpty:weakself.mangerModel.can_not_msg]) {
                
                [TYShowMessage showPlaint:weakself.mangerModel.can_not_msg];
                
            }else {
                
                [TYShowMessage showPlaint:@"暂时不能评价"];
            }
            
        }
      
        
    };
    
    self.defaultViewModel.isOnlyShowRight = YES;
    
    self.defaultView.desModel = self.defaultViewModel;
    
    UIView *offsetView = [[UIView alloc] initWithFrame:CGRectMake(0, _defaultView.height - 100, TYGetUIScreenWidth, 100)];
    
    offsetView.backgroundColor = AppFontf1f1f1Color;
    
    [self.defaultView addSubview:offsetView];
    
    self.tableView.tableFooterView = self.defaultView;
}

#pragma mark - 进入评价页面
- (void)skipEvalueVc {
    
    self.isFresh = NO;
    
    if (![self checkIsRealName]) {
        
        TYWeakSelf(self);
        if ([self.navigationController isKindOfClass:NSClassFromString(@"JLGCustomViewController")]) {
            
            JLGCustomViewController *customVc = (JLGCustomViewController *) self.navigationController;
            
            customVc.customVcBlock = ^(id response) {
                
                [weakself skipAppraiseVc];
                
            };
            
        }
        
    }else {
        
        [self skipAppraiseVc];
        
    }
    
}

#pragma mark - 去评价页面
- (void)skipAppraiseVc {
    
    JGJMemberMangerAppraiseVc *appraiseVc = [[JGJMemberMangerAppraiseVc alloc] init];
    appraiseVc.isMemberManagerInfoVCComeIn = YES;
    appraiseVc.memberModel = self.memberModel;
    
    [self.navigationController pushViewController:appraiseVc animated:YES];
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

#pragma mark - 人员统计
- (void)staListDetailVc {
    
    JGJRecordWorkStaListModel *staListModel = self.mangerModel.bill_info;

    staListModel.class_type_id = self.memberModel.uid;
    
    staListModel.class_type = @"person";
    
    staListModel.is_lock_name = YES;
    
    [JGJRecordStaSearchTool skipVcWithVc:self staListModel:staListModel user_info:self.memberModel];
    
}

#pragma mark - 查看评价
- (void)checkEvalue {
    
    JGJMemberAppraiseDetailVc *detailVc = [[JGJMemberAppraiseDetailVc alloc] init];
    
    detailVc.isMemberManagerInfoVCComeIn = YES;

    detailVc.memberModel = self.memberModel;
    
    [self.navigationController pushViewController:detailVc animated:YES];
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        CGRect rect = CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight);
        
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.dataSource = self;
        
        _tableView.delegate = self;
        
        _tableView.backgroundColor = AppFontf1f1f1Color;
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 24)];
        
        footerView.backgroundColor = [UIColor whiteColor];
        
        _tableView.tableFooterView = footerView;
        
        _tableView.hidden = YES;
    }
    
    return _tableView;
}

- (JGJCusBottomButtonView *)buttonView {
    
    if (!_buttonView) {
        
        CGFloat height = [JGJCusBottomButtonView cusBottomButtonViewHeight];
        
        CGFloat buttonViewY = TYGetUIScreenHeight - JGJ_NAV_HEIGHT - height - JGJ_IphoneX_BarHeight;
        
        _buttonView = [[JGJCusBottomButtonView alloc] initWithFrame:CGRectMake(0, buttonViewY, TYGetUIScreenWidth, height)];
        
        [_buttonView.actionButton setTitle:@"去评价" forState:UIControlStateNormal];
        
    }
    return _buttonView;
}

-(JGJMemberEvaListRequestModel *)evaListRequestModel {
    
    if (!_evaListRequestModel) {
        
        _evaListRequestModel = [JGJMemberEvaListRequestModel new];
        
        _evaListRequestModel.pg = 1;
        
        _evaListRequestModel.pagesize = JGJPageSize;
    }
    
    return _evaListRequestModel;
}

- (JGJComTitleCellDesModel *)comTitleCellDesMode {
    
    if (!_comTitleCellDesMode) {
        
        _comTitleCellDesMode = [[JGJComTitleCellDesModel alloc] init];
        
        _comTitleCellDesMode.title = @"评价";
        
        _comTitleCellDesMode.des = @"";
    }
    
    return _comTitleCellDesMode;
}

- (NSString *)roleDes {
    
    return JLGisLeaderBool ? @"工人" : @"班组长";
}

- (JGJCustomDefaultViewModel *)defaultViewModel {
    
    if(!_defaultViewModel) {
    
        _defaultViewModel = [JGJCustomDefaultViewModel new];
    
        _defaultViewModel.des = [NSString stringWithFormat:@"暂时还没人对该%@评价过", [self roleDes]];
    
        _defaultViewModel.rightButtonTitle = @"我也去评价";
    
        _defaultViewModel.isOnlyShowRight = YES;
    
    }
    
    return _defaultViewModel;
}

- (JGJComTitleDesInfoModel *)modifyRecordDesModel {
    
    if (!_modifyRecordDesModel) {
        
        _modifyRecordDesModel = [[JGJComTitleDesInfoModel alloc] init];
        
        _modifyRecordDesModel.title = @"批量修改记工";
        
        _modifyRecordDesModel.des = @"";
    }
    
    return _modifyRecordDesModel;
}

@end
