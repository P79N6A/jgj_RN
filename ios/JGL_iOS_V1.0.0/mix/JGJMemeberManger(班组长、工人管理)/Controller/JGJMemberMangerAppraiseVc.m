//
//  JGJMemberMangerAppraiseVc.m
//  mix
//
//  Created by yj on 2018/4/19.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJMemberMangerAppraiseVc.h"

#import "JGJCusBottomButtonView.h"

#import "JGJMemberAppraiseInputCell.h"

#import "JGJMemberImpressTagCell.h"

#import "JGJMemAppraiseMemInfoCell.h"

#import "JGJMemberWorkInfoCell.h"

#import "JGJPushContentCell.h"

#import "JGJMemberAppraiseStarsCell.h"

#import "JGJMemberWillingCell.h"

#import "JGJCustomLable.h"

#import "JGJMemberImpressTagView.h"

#import "JGJMemberMangerRequestModel.h"

#import "JGJMemberAppraiseTagVc.h"

#import "IQKeyboardManager.h"

#import "JGJMemeberMangerDetailVc.h"

#import "JGJComLineSpacingCell.h"

#import "JGJMemberAppraiseDetailVc.h"

@interface JGJMemberMangerAppraiseVc () <

    UITableViewDelegate,

    UITableViewDataSource,

    JGJMemberImpressTagCellDelegate,

    JGJMemberAppraiseInputCellDelegate,

    JGJMemberWillingCellDelegate

>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) JGJCusBottomButtonView *buttonView;

@property (nonatomic, strong) JGJMemberImpressTagViewModel *tagViewModel;

@property (nonatomic, strong) JGJMemberMangerAppraiseRequestModel *requestModel;

//评分模型
@property (nonatomic, strong) NSMutableArray *starsScores;

//标签View
@property (nonatomic, strong) JGJMemberImpressTagView *tagView;

//评价信息
@property (nonatomic, strong) JGJMemberEvaluateInfoModel *evaInfoMode;

//星星头部距离
@property (nonatomic, assign) CGFloat maxStarLead;

@end

@implementation JGJMemberMangerAppraiseVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"评价";
    
    [self.view addSubview:self.buttonView];
    
    [self.view addSubview:self.tableView];

    TYWeakSelf(self);
    
    self.buttonView.handleCusBottomButtonViewBlock = ^(JGJCusBottomButtonView *buttonView) {
        
        [weakself evaluateSubmit];
    };
    
    [self loadEvaluateInfo];
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = 0;
    
    switch (indexPath.section) {
            
        case 0:{
            
            if (indexPath.row == 0) {
                
                height = 60;
                
            }else if (indexPath.row == 1) { //分割线
                
                height = 6;
                
            }else if (indexPath.row == 2) { //人员信息
                
                height = 43;
                
            }else if (indexPath.row == 3) { //分割线
                
                height = 13;
                
            }else if ( indexPath.row == 4) { //分割线
                
                height = 20;
                
            }
            
        }
            
            break;
            
        case 1:{
            
            //多标签
            if (indexPath.row == 0) {
                
                height = self.evaInfoMode.tagViewHeight;
                
            }else if (indexPath.row == 1) {
                
                height = 55;
            }
        }
            
            break;
            
        case 2:{
            
             height = 100;
            
        }
            
            break;
            
        case 3:{
            
            height = 52;
        }
            
            break;
            
        case 4:{
            
            height = 75;
        }
            
            break;
            
        default:
            break;
    }
    
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

//第一组有两个分割线
    
    NSArray *sections = @[@5, @2, @1,@3,@1];
    
    NSInteger count = [sections[section] integerValue];
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    switch (indexPath.section) {
            
        case 0:{
            
            switch (indexPath.row) {
                case 0:{
                    
                    cell = [self registerHeadMemberInfoCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
                    
                }
                    break;
                    
                case 1:{
                    
                     cell = [self registerComLineSpacingCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
                    
                }
                    break;
                    
                case 2:
                    
                case 3:{
                    
                     cell = [self registerWorkInfoCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
                    
                }
                    break;
                    
                case 4:{
                    
                    cell = [self registerComLineSpacingCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
                    
                }
                    break;
                    
                default:
                    break;
            }
            
        }
            
            break;
            
        case 1:{
            
            //多标签
            if (indexPath.row == 0) {
                
                cell = [self registerImpressTagCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
                
            }else if (indexPath.row == 1) {
                
               cell = [self registerInputCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
            }
        }
            
            break;
            
        case 2:{
            
            cell = [self registerContentCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
        }
            
            break;
            
        case 3:{
            
           cell = [self registerStarsCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
        }
            
            break;
            
        case 4:{
            
            cell = [self registerWillingCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
        }
            
            break;
            
        default:
            break;
    }

    return cell;
    
}

- (UITableViewCell *)registerHeadMemberInfoCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJMemAppraiseMemInfoCell *cell = [JGJMemAppraiseMemInfoCell cellWithTableView:tableView];
    
    cell.memberModel = self.memberModel;
    
    return cell;
    
}

- (UITableViewCell *)registerWorkInfoCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJMemberWorkInfoCell *cell = [JGJMemberWorkInfoCell cellWithTableView:tableView];
    
    cell.infoModel = self.evaInfoMode.cooProInfos[indexPath.row - 2];
    
    return cell;
    
}

- (UITableViewCell *)registerImpressTagCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJMemberImpressTagCell *cell = [JGJMemberImpressTagCell cellWithTableView:tableView];
    
    cell.tagViewType = JGJMemberImpressSelTagViewType;
    
    cell.tagModels = self.evaInfoMode.tag_list;
    
    cell.delegate = self;
    
    cell.topView.hidden = YES;
    
    cell.bottomView.hidden = YES;
    
    self.tagView = cell.tagView;
    
    return cell;
    
}

- (UITableViewCell *)registerInputCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJMemberAppraiseInputCell *cell = [JGJMemberAppraiseInputCell cellWithTableView:tableView];
    
    cell.delegate = self;
    
    return cell;
    
}

- (UITableViewCell *)registerContentCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJPushContentCell *cell = [JGJPushContentCell cellWithTableView:tableView];
    
    cell.placeholderText = [NSString stringWithFormat:@"请填写你对该%@的评价",  JLGisMateBool ? @"班组长" : @"工人"];
    
    cell.maxContentWords = 200;
    
    TYWeakSelf(self);
    
    cell.pushContentCellBlock = ^(YYTextView *textView) {
      
        weakself.requestModel.evaluate_content = textView.text;
    };
    
    return cell;
    
}

- (UITableViewCell *)registerStarsCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJMemberAppraiseStarsCell *cell = [JGJMemberAppraiseStarsCell cellWithTableView:tableView];
    
    cell.starsCellType = JGJMemberAppraiseStarsCellEvaType;
    
    cell.starsModel = self.starsScores[indexPath.row];
    
    cell.maxStarLead = self.maxStarLead;
    
    return cell;
    
}

- (UITableViewCell *)registerWillingCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJMemberWillingCell *cell = [JGJMemberWillingCell cellWithTableView:tableView];
    
    cell.delegate = self;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return  nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    CGFloat height = 36;
    
    if (section == 0) {
        
        height = CGFLOAT_MIN;
        
    }
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1 && indexPath.row == 1) {
        
        [self inputTagVc];
    }
    
    [self endEditKeyBoard];
    
}

#pragma mark - 标签按钮按下改变状态
- (void)impressTagCell:(JGJMemberImpressTagCell *)cell tagView:(JGJMemberImpressTagView *)tagView sender:(JGJCusButton *)sender {
    
    self.evaInfoMode.tagViewHeight = tagView.height;
    
    [self.tableView reloadData];
    
    self.tagView = tagView;

}

- (CGFloat)tagViewHeightWithTagNames:(NSArray *)tagModels {
    
    JGJMemberImpressTagView *tagView = [[JGJMemberImpressTagView alloc] init];
    
    tagView = [tagView tagViewWithTags:tagModels tagViewType:JGJMemberImpressSelTagViewType];
    
    self.evaInfoMode.tagViewHeight = tagView.height;
    
    return tagView.height;
}

#pragma mark - JGJMemberWillingCellDelegate

- (void)memberWillingCell:(JGJMemberWillingCell *)cell buttonType:(JGJMemberWillingButtonType)buttonType {
    
    self.requestModel.is_cooperate_again = buttonType == JGJMemberUnWillingType ? @"0" : @"1";
    
}

#pragma mark - 评价提交
- (void)evaluateSubmit {
    
    //印象标签
    
    NSMutableString *tagnames = [NSMutableString string];
    
    for (JGJCusButton *btn in self.tagView.subviews) {
        
        if ([btn isKindOfClass:NSClassFromString(@"UIButton")]) {
            
            JGJMemberImpressTagViewModel *tagModel = btn.tagModel;
            
            if (tagModel.selected) {
                
                [tagnames appendFormat:@"%@,", tagModel.tag_name];
            }
            
        }
        
    }
    
    if ([tagnames rangeOfString:@","].location != NSNotFound) {
        
        [tagnames replaceCharactersInRange:NSMakeRange(tagnames.length - 1, 1) withString:@""];
    }
    
    if ([NSString isEmpty:tagnames]) {
        
        [TYShowMessage showPlaint:@"请选择你对他的印象"];
        
        return;
    }
    
//非必填
//    if ([NSString isEmpty:self.requestModel.evaluate_content]) {
//
//        [TYShowMessage showPlaint:@"请填写你对他的评价"];
//
//        return;
//
//    }
    
    self.requestModel.tag_names = tagnames;
    
    //评价分数
    if (self.starsScores.count == 3) {
    
        //工作态度
        self.requestModel.attitude_or_arrears = [self.starsScores[0] score];

        //专业技能
        self.requestModel.professional_or_abuse = [self.starsScores[1] score];

        //靠谱程度
        self.requestModel.reliance_degree = [self.starsScores[2] score];
        
    }
    
    if ([NSString isEmpty:self.requestModel.attitude_or_arrears] || [NSString isEmpty:self.requestModel.professional_or_abuse] || [NSString isEmpty:self.requestModel.reliance_degree]) {
        
        [TYShowMessage showPlaint:@"请你对他进行评分"];
        
        return;
    }
    
    NSDictionary *parameters = [self.requestModel mj_keyValues];
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithNapi:@"evaluate/evaluate-submit" parameters:parameters success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        [self freshMemberDetail];
                
        [self checkEvalue];
        
        if (self.successBlock) {
            
            self.successBlock();
        }
                
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
    
}

#pragma mark - 查看评价
- (void)checkEvalue {
    
    JGJMemberAppraiseDetailVc *detailVc = [[JGJMemberAppraiseDetailVc alloc] init];
    detailVc.isMemberManagerInfoVCComeIn = self.isMemberManagerInfoVCComeIn;
    detailVc.memberModel = self.memberModel;
    
    [self.navigationController pushViewController:detailVc animated:YES];
}

- (void)freshMemberDetail {
    
    for (JGJMemeberMangerDetailVc *detaiVc in self.navigationController.viewControllers) {
        
        if ([detaiVc isKindOfClass:NSClassFromString(@"JGJMemeberMangerDetailVc")]) {
         
            detaiVc.isFresh = YES;
            
            break;
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self endEditKeyBoard];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    CGFloat height = 36.0;
    
    CGFloat remarkHeaderW = 240;
    
    NSString *remark = @"满意请给5星哦";
    
    remarkHeaderW = [NSString stringWithContentSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) content:remark font:AppFont30Size].width;
    
    UIButton *headerBtn = [[UIButton alloc] init];
    
    [headerBtn addTarget:self action:@selector(endEditKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *remarkBtn = [[UIButton alloc] initWithFrame:CGRectMake(TYGetUIScreenWidth - remarkHeaderW - 10, 0, remarkHeaderW, height)];
    
    [remarkBtn addTarget:self action:@selector(endEditKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    
    [remarkBtn setTitleColor:AppFont999999Color forState:UIControlStateNormal];
    
    remarkBtn.adjustsImageWhenHighlighted = NO;

    remarkBtn.titleLabel.font = [UIFont systemFontOfSize:AppFont30Size];

    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, height)];
    
    contentView.backgroundColor = AppFontf1f1f1Color;
    
    [contentView addSubview:remarkBtn];
    
    [contentView addSubview:headerBtn];
    
    [headerBtn setTitleColor:AppFont333333Color forState:UIControlStateNormal];
    
    headerBtn.adjustsImageWhenHighlighted = NO;
    
    headerBtn.titleLabel.font = [UIFont systemFontOfSize:AppFont30Size];
    
    headerBtn.backgroundColor = AppFontf1f1f1Color;
    
    if (section == 0) {

        [headerBtn setTitle:@"" forState:UIControlStateNormal];
        
    }else {
        
        NSArray *sections = @[@"你对他的印象", @"你对他的评价", @"你对他的评分", @"有新的项目，是否愿意再次雇佣他?"];
        
        if (JLGisMateBool) {
            
            sections = @[@"你对他的印象", @"你对他的评价", @"你对他的评分", @"有新的项目，是否愿意再次为他工作？"];
            
        }
        
        CGFloat headerW = [NSString stringWithContentSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) content:sections[section - 1] font:AppFont30Size].width;
        
        headerBtn.frame = CGRectMake(10, 0, headerW, height);
        
        remarkBtn.hidden = section != 3;
        
        if (section == 3) {
            
            [remarkBtn setTitle:remark forState:UIControlStateNormal];

        }
        
        NSString *headerTitle = section == 0 ? nil : sections[section - 1];
        
        [headerBtn setTitle:headerTitle forState:UIControlStateNormal];
    }
    
    return contentView;
    
}

- (UITableViewCell *)registerComLineSpacingCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJComLineSpacingCell *cell = [JGJComLineSpacingCell cellWithTableView:tableView];
    
    cell.lineView.hidden = YES;
    
    return cell;
    
}

#pragma mark - 获取页面基本信息，标签个数合作情况
- (void)loadEvaluateInfo {
    
    [JLGHttpRequest_AFN PostWithNapi:@"evaluate/evaluate-page-info" parameters:@{@"uid" : self.memberModel.uid?:@""} success:^(id responseObject) {
        
        self.evaInfoMode = [JGJMemberEvaluateInfoModel mj_objectWithKeyValues:responseObject];
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

- (void)setEvaInfoMode:(JGJMemberEvaluateInfoModel *)evaInfoMode {
    
    _evaInfoMode = evaInfoMode;
    
    //合作情况
    _evaInfoMode.cooProInfos = [self cooProInfos];
    
    //测试默认印象标签
    
//    _evaInfoMode.tag_list = [self tag_names];
    
    [self tagViewHeightWithTagNames:_evaInfoMode.tag_list];
    
    [self.tableView reloadData];
}

- (NSArray *)cooProInfos {
    
    NSMutableArray *infos = [NSMutableArray array];
    
    NSString *role = @"你";
    
    if (JLGisMateBool) {
        
        role = @"他";
        
    }
    
    NSString *cooperation_pro_num = [NSString stringWithFormat:@"在%@个项目上为%@工作过", _evaInfoMode.cooperation_pro_num?:@"0", role];
    //错误 #19436总共改为 总计
    NSString *total_work_hours = [NSString stringWithFormat:@"总计为%@工作%@个小时",role, _evaInfoMode.total_work_hours?:@"0"];
    
    NSArray *titles = @[cooperation_pro_num, total_work_hours];
    
    NSArray *changeColorStrs = @[_evaInfoMode.cooperation_pro_num?:@"0", _evaInfoMode.total_work_hours?:@"0"];
    
    NSArray *images = @[@"appraise_pro_icon", @"appraise_work_time_icon"];
    
    for (NSInteger index = 0; index < titles.count; index++) {
        
        JGJMemberWorkInfoModel *workInfoModel = [JGJMemberWorkInfoModel new];
        
        workInfoModel.typeDes = titles[index];
        
        workInfoModel.imageStr = images[index];
        
        workInfoModel.changeColorStr = changeColorStrs[index];
        
        [infos addObject:workInfoModel];
        
    }
    
    return infos;
}

- (NSMutableArray *)tag_names {

   NSArray *tag_list = @[@"盗墓笔记我为为为我",@"空空道人谈",@"叶文话要说",@"相声",@"二货一筐",@"单田方",@"城市",@"美女",@"社交恐惧",@"家庭矛盾",@"失恋",@"局势很简单",@"Word",@"美女",@"美女与野兽",@"体育",@"生化危机"];
    
    NSMutableArray *tagModels = [NSMutableArray array];
    
    for (NSInteger index = 0; index < tag_list.count; index++) {
        
        JGJMemberImpressTagViewModel *tagModel = [JGJMemberImpressTagViewModel new];
        
        tagModel.tag_name = tag_list[index];
        
        [tagModels addObject:tagModel];
    }

    return tagModels;
}

#pragma mark - JGJMemberAppraiseInputCellDelegate

- (void)inputWithCell:(JGJMemberAppraiseInputCell *)cell inputCellResType:(JGJMemberAppraiseInputCellResType)inputCellResType {
    
    switch (inputCellResType) {
        case JGJMemberAppraiseInputCellButtonResType:{
            
            [self inputTagVc];
            
        }
            break;
            
        default:
            break;
    }
}

- (void)inputTagVc {
    
    if (self.tagView.selTagModels.count >= MaxTagCount) {
        
        [TYShowMessage showPlaint:@"最多可选中5个标签"];
        
        return;
    }
        
    JGJMemberAppraiseTagVc *tagVc = [[JGJMemberAppraiseTagVc alloc] init];

    [self presentViewController:tagVc animated:YES completion:nil];
    
    TYWeakSelf(self);
    
    //添加单个标签
    tagVc.tagVcBlock = ^(JGJMemberImpressTagViewModel *tagModel) {
      
        weakself.tagView.tagModel = tagModel;
    };
    
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        CGRect rect = CGRectMake(0, 0, TYGetUIScreenWidth, TYGetMinY(self.buttonView) +JGJ_NAV_HEIGHT);
        
        UITableViewController *tvc=[[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
        
        [self addChildViewController:tvc];
        
        [tvc.view setFrame:rect];
        
        _tableView = tvc.tableView;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.dataSource = self;
        
        _tableView.delegate = self;
        
        _tableView.backgroundColor = AppFontf1f1f1Color;
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 10)];
        
        footerView.backgroundColor = AppFontf1f1f1Color;
        
        _tableView.tableFooterView = footerView;
    }
    
    return _tableView;
}

- (JGJCusBottomButtonView *)buttonView {
    
    if (!_buttonView) {
        
        CGFloat height = [JGJCusBottomButtonView cusBottomButtonViewHeight];
        
        CGFloat buttonViewY = TYGetUIScreenHeight - JGJ_NAV_HEIGHT - height - JGJ_IphoneX_BarHeight;
        
        _buttonView = [[JGJCusBottomButtonView alloc] initWithFrame:CGRectMake(0, buttonViewY, TYGetUIScreenWidth, height)];
        
        [_buttonView.actionButton setTitle:@"提交" forState:UIControlStateNormal];
        
    }
    return _buttonView;
}

- (JGJMemberMangerAppraiseRequestModel *)requestModel {
    
    if (!_requestModel) {
        
        _requestModel = [JGJMemberMangerAppraiseRequestModel new];
        
        _requestModel.uid = self.memberModel.uid;
        
        //默认愿意
        _requestModel.is_cooperate_again = @"1";
    }
    
    return _requestModel;
}

- (NSMutableArray *)starsScores {
    
    NSArray *titles = @[@"工作态度", @"专业技能", @"靠谱程度"];
    
    if (JLGisMateBool) {
        
        titles = @[@"没有拖欠工资", @"没有辱骂工人", @"靠谱程度"];
        
    }
    
    self.maxStarLead = [NSString maxWidthWithContents:titles offset:35.0 font:AppFont30Size];
    
    if (!_starsScores) {
        
        _starsScores = [NSMutableArray array];
        
        for (NSInteger index = 0; index < titles.count; index++) {
            
            JGJMemberAppraiseStarsModel *starsModel = [JGJMemberAppraiseStarsModel new];
            
            starsModel.title = titles[index];
            
            starsModel.score = 0;
            
            starsModel.height = 54;
            
            [_starsScores addObject:starsModel];
        }
        
    }
    
    return _starsScores;
}

- (void)endEditKeyBoard{
    
    [self.view endEditing:YES];
}


@end
