//
//  JGJQuaSafeHomeVc.m
//  JGJCompany
//
//  Created by yj on 2017/11/20.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJQuaSafeHomeVc.h"

#import "JGJQuaSafeHomeTopCell.h"

#import "JGJQuaSafeAboutMeCell.h"

#import "JGJCreatPlansView.h"

#import "JGJQualityRecordVc.h"

#import "JGJWebAllSubViewController.h"

#import "JGJHelpCenterTitleView.h"
#import "JGJChatMsgDBManger+JGJIndexDB.h"
@interface JGJQuaSafeHomeVc () <UITableViewDelegate, UITableViewDataSource>

//2.3.4
@property (nonatomic, strong) UITableView *quaSafeTableView;

@property (strong ,nonatomic)JGJNodataDefultModel *creatDataModel;//用来显示创建按钮下面的文字的模型

@property (strong, nonatomic) NSMutableArray *dataSource;

//@property (nonatomic, strong) JGJQualitySafeListRequestModel *requestModel;
@end

@implementation JGJQuaSafeHomeVc

//@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self commonSetUI];
    
}

#pragma mark - 重写父类的方法，不添加上拉下拉刷新
- (void)commonSet {
    
    
}

#pragma mark - 重写父类的方法进入当前页面不下拉刷新
- (void)freshTableView {
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self loadNetData];
    
    //    [self subLoadNetData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    if (indexPath.row == 0) {
        
        JGJQuaSafeHomeTopCell *topCell = [JGJQuaSafeHomeTopCell cellWithTableView:tableView];
        
        topCell.topInfos = self.dataSource[0];
        
        __weak typeof(self) weakSelf = self;
        
        topCell.quaSafeHomeTopCellBlock = ^(NSInteger indx) {
            
            QuaSafeFilterType filterType = (QuaSafeFilterType) indx;
            
            [weakSelf selQuaSafeFilterType:filterType];
        };
        
        cell = topCell;
        
    }else {
        
        JGJQuaSafeAboutMeCell *aboutMeCell = [JGJQuaSafeAboutMeCell cellWithTableView:tableView];
        
        aboutMeCell.typeModel = self.dataSource[indexPath.row];
        
        cell = aboutMeCell;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
     return indexPath.row == 0 ? [JGJQuaSafeHomeTopCell JGJQuaSafeHomeTopCellHeight] :[JGJQuaSafeAboutMeCell JGJQuaSafeAboutMeCellHeight];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QuaSafeFilterType filterType = QuaSafeFilterMyModifyType;
    
    if (indexPath.row == 0) {
        
        return;
    }
    
    if (indexPath.row == 1) {
        
        filterType = QuaSafeFilterMyModifyType;
    }else if (indexPath.row == 2) {
        
        filterType = QuaSafeFilterMyReviewType;
        
    }else if (indexPath.row == 3) {
        
        filterType = QuaSafeFilterMyCommitType;
    }
    
    [self selQuaSafeFilterType:filterType];
}

#pragma mark - 筛选类型
- (void)selQuaSafeFilterType:(QuaSafeFilterType)filterType {
    
    //    QuaSafeFilterWaitModifyType, //待整改
    //
    //    QuaSafeFilterReviewType, //待复查
    //
    //    QuaSafeFilterCompletedType, //已完成
    //
    //    QuaSafeFilterStaType, //统计
    //
    //    QuaSafeFilterMyModifyType, //待我整改
    //
    //    QuaSafeFilterMyCommitType, //我提交的
    //
    //    QuaSafeFilterMyReviewType, //待我复查
    
    NSString *uid = [TYUserDefaults objectForKey:JLGUserUid];
    
    NSString *title = @"待整改";
    switch (filterType) {
            
        case QuaSafeFilterWaitModifyType:{
            
            self.requestModel.uid = nil;
            
            self.requestModel.status = @"1";
            
            title = @"待整改";
        }
            
            break;
            
        case QuaSafeFilterReviewType:{
            
            self.requestModel.uid = nil;
            
            self.requestModel.status = @"2";
            
            title = @"待复查";
        }
            
            break;
            
        case QuaSafeFilterCompletedType:{
            
            self.requestModel.uid = nil;
            
            self.requestModel.status = @"3";
            
            title = @"已完成";
        }
            
            break;
            
        case QuaSafeFilterStaType:{
            
            NSString *statisticsStr = [NSString stringWithFormat:@"%@stcharts?group_id=%@&class_type=%@&&msg_type=%@&close=%@",JGJWebDiscoverURL, self.workProListModel.group_id, self.workProListModel.class_type,self.commonModel.msg_type, @(self.workProListModel.isClosedTeamVc)];
            
            JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:statisticsStr];
            
            [self.navigationController pushViewController:webVc animated:YES];
            
            return;
        }
            
            break;
            
        case QuaSafeFilterMyModifyType:{
            
            self.requestModel.uid = uid;
            
            self.requestModel.status = @"1";
            
            title = @"待我整改";
        }
            
            break;
            
        case QuaSafeFilterMyReviewType:{
            
            self.requestModel.uid = uid;
            
            self.requestModel.status = @"2";
            
            title = @"待我复查";
        }
            
            break;
            
        case QuaSafeFilterMyCommitType:{
            
            self.requestModel.uid = uid;
            
            self.requestModel.status = nil;
            
            title = @"我提交的";
        }
            
            break;
            
        default:
            break;
    }
    
    [self qualitySafeListVcWithTitle:title filterType:filterType];
}

- (void)setSubQualitySafeModel:(JGJQualitySafeModel *)qualitySafeModel {
    
    NSArray *redFlags = @[qualitySafeModel.rect_me_red?:@"", qualitySafeModel.check_me_red?:@"", @"0"];
    
    for (NSInteger indx = 0; indx < self.dataSource.count; indx++) {
        
        NSArray *topInfos = self.dataSource[0];
        
        if (indx == 0) {
            
            for (NSInteger subIndex = 0; subIndex < topInfos.count; subIndex++) {
                
                JGJQuaSafeHomeModel *topModel = topInfos[subIndex];
                
                topModel.title = qualitySafeModel.filterCounts[subIndex];
                
                
            }
            
        }else {
            
            JGJQuaSafeHomeModel *topModel = self.dataSource[indx];
            
            topModel.unReadMsgCount = redFlags[indx - 1];
            
            topModel.title = qualitySafeModel.aboutMeCounts[indx - 1];
        }
        
    }
    
    [self.quaSafeTableView reloadData];
}

- (UITableView *)quaSafeTableView {
    
    if (!_quaSafeTableView) {
        
        
        CGRect rect = CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight - 64);
        _quaSafeTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        _quaSafeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _quaSafeTableView.dataSource = self;
        _quaSafeTableView.delegate = self;
        _quaSafeTableView.backgroundColor = AppFontf1f1f1Color;
        
    }
    
    return _quaSafeTableView;
    
}

- (NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        
        _dataSource = [NSMutableArray new];
        
        NSMutableArray *topDataSource = [NSMutableArray new];
        
        NSArray *topTitles = @[@"待整改", @"待复查", @"已完成", @"统计"];
        
        NSArray *topIcons = @[@"quaSafe_wait_deal_icon", @"wait_review_icon",@"completed_QuaSafe_icon", @"sta_QuaSafe_icon"];
        
        NSArray *typeTitles = @[@"待我整改", @"待我复查", @"我提交的"];
        
        NSArray *typeIcons = @[@"wait_meExecute_icon", @"wait_meReview_icon", @"my_creatQuaSafe_icon"];
        
        for (NSInteger index = 0; index < topTitles.count; index++) {
            
            JGJQuaSafeHomeModel *topModel = [JGJQuaSafeHomeModel new];
            
            topModel.title = topTitles[index];
            
            topModel.icon = topIcons[index];
            
            [topDataSource addObject:topModel];
        }
        
        [_dataSource addObject:topDataSource];
        
        for (NSInteger index = 0; index < typeTitles.count; index++) {
            
            JGJQuaSafeHomeModel *typeModel = [JGJQuaSafeHomeModel new];
            
            typeModel.title = typeTitles[index];
            
            typeModel.icon = typeIcons[index];
            
            [_dataSource addObject:typeModel];
        }
        
    }
    
    return _dataSource;
}

- (void)commonSetUI {
    
    NSString *title = @"质量";
    
    JGJHelpCenterTitleViewType titleViewType = JGJHelpCenterTitleViewQualityType;
    
    if ([self.commonModel.msg_type isEqualToString:@"safe"]) {
        
        title = @"安全";
        
        titleViewType = JGJHelpCenterTitleViewSafeType;
    }
    
    JGJHelpCenterTitleView *titleView = [JGJHelpCenterTitleView helpCenterTitleView];
    
    titleView.proListModel = self.workProListModel;
    
    titleView.titleViewType = titleViewType;
    
    titleView.title = title;
    
    self.navigationItem.titleView = titleView;
    
    self.view.backgroundColor = AppFontf1f1f1Color;
    
    [self.view addSubview:self.quaSafeTableView];
    
    
    if (!self.workProListModel.isClosedTeamVc) {
        
        __weak typeof(self) weakSelf = self;
        
        JGJNodataDefultModel *creatDataModel = [JGJNodataDefultModel new];
        
        creatDataModel.contentStr = [NSString stringWithFormat:@"发%@问题", title];
        
        [JGJCreatPlansView showView:self.view andModel:creatDataModel  andBlock:^(NSString *title) {
            
            [weakSelf pubQuaSafePressed];
            
        }];
    }
    
    
    [JGJComTool showCloseProImageViewWithTargetView:self.view classtype:self.workProListModel.class_type isClose:self.workProListModel.isClosedTeamVc];
    
    
}

#pragma mark - 帮助中心
- (void)helpCenterPressed:(UIButton *)pressed {
    
    
    
}

- (void)pubQuaSafePressed {
    
    JGJQualityRecordVc *qualityRecordVc = [JGJQualityRecordVc new];
    
    qualityRecordVc.proListModel = self.workProListModel;
    
    qualityRecordVc.commonModel = self.commonModel;
    
    [self.navigationController pushViewController:qualityRecordVc animated:YES];
}

#pragma mark - 质量安全列表
- (void)qualitySafeListVcWithTitle:(NSString *)title filterType:(QuaSafeFilterType)filterType {
    
    JGJChatListQualityVc *qualityVc = [[UIStoryboard storyboardWithName:@"JGJChat" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJChatListQualityVc"];
    
    qualityVc.filterType = filterType;
    
    qualityVc.title = title;
    
    qualityVc.commonModel = self.commonModel;
    
    //    chatRootRequestModel.msg_type = @"quality";
    
    //    JGJQualitySafeCommonModel *commonModel = [JGJQualitySafeCommonModel new];
    //
    //    qualityVc.commonModel = self.commonModel;
    //
    //    commonModel.type = JGJChatListQuality;
    //
    //    commonModel.msg_type = @"quality";
    //
    //
    //
    //    //区分质量安全任务存草稿
    //    commonModel.quaSafeCheckType = @"qualityType";
    
    qualityVc.proListModel = self.workProListModel;
    
    qualityVc.requestModel.status = self.requestModel.status;
    
    qualityVc.requestModel.uid = self.requestModel.uid;
    
    JGJChatRootRequestModel *chatRootRequestModel = [JGJChatRootRequestModel new];
    
    chatRootRequestModel.msg_type = self.commonModel.msg_type;
    
    chatRootRequestModel.group_id = self.workProListModel.group_id;
    
    chatRootRequestModel.action = @"groupMessageList";
    
    chatRootRequestModel.class_type = self.workProListModel.class_type;
    
    chatRootRequestModel.ctrl = @"message";
    
    chatRootRequestModel.pageturn = @"next";
    
    JGJChatListBaseVc *baseVc = (JGJChatListBaseVc *)qualityVc;
    
    baseVc.workProListModel = self.workProListModel;
    
    baseVc.chatListRequestModel = chatRootRequestModel;
    
    //进入下一个界面
    
    __weak typeof(self) weakSelf = self;
    
    baseVc.skipToNextVc = ^(UIViewController *nextVc){
        
        [weakSelf.navigationController pushViewController:nextVc animated:YES];
    };
    
    [self.navigationController pushViewController:qualityVc animated:YES];
}

- (void)loadNetData {
    
    NSDictionary *parameters = @{@"group_id" : self.workProListModel.group_id?:@"",
                                 @"class_type" : self.workProListModel.class_type?:@"",
                                 @"msg_type" : self.commonModel.msg_type?:@""
                                 };
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/quality/getQualitySafeIndex" parameters:parameters success:^(id responseObject) {
        
        JGJQualitySafeModel *qualitySafeModel = [JGJQualitySafeModel mj_objectWithKeyValues:responseObject];
        
        [self setSubQualitySafeModel:qualitySafeModel];
        
    } failure:^(NSError *error) {
        
        
    }];
    
}



@end

