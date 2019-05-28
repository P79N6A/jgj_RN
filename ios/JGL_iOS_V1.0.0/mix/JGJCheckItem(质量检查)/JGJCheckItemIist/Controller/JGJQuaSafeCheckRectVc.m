//
//  JGJQuaSafeCheckRectVc.m
//  JGJCompany
//
//  Created by yj on 2017/11/23.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJQuaSafeCheckRectVc.h"

#import "JGJCustomLable.h"

#import "JGJPushContentCell.h"

#import "JLGMYProExperienceTableViewCell.h"

#import "JGJCreatTeamCell.h"

#import "JLGAddProExperienceTableViewCell.h"

#import "JGJCusSwitchMsgCell.h"

#import "JGJCreatTeamCell.h"

#import "ATDatePicker.h"

#import "NSDate+Extend.h"

#import "NSString+Extend.h"

#import "JGJTaskLevelSelVc.h"

#import "JGJTaskPrincipalVc.h"

#import "CustomAlertView.h"

#import "JGJQualitySafeRequestModel.h"

#import "JGJChatRootVc.h"

#import "JGJTabBarViewController.h"

#import "JGJChatListBaseVc.h"

#import "JGJQualityLocationVc.h"

#import "JGJQuaSafeTool.h"

#import "JGJAddressBookTool.h"

#import "JGJTRectNotifyWarningCell.h"

@interface JGJQuaSafeCheckRectVc () <

    UITableViewDelegate,

    UITableViewDataSource,

    JGJTaskPrincipalVcDelegate,

    JGJTaskLevelSelVcDelegate,

    JLGMYProExperienceTableViewCellDelegate

>

@property (nonatomic, strong) UITableView *tableView;

//存放位置，严重程度
@property (nonatomic, strong) NSMutableArray *rectInfos;

@property (nonatomic, strong) UIView *containSaveButtonView;

@property (nonatomic, strong) UIButton *publishButton;

//@property (nonatomic, strong) JGJQualitySafeRequestModel *qualitySafeRequestModel;

@property (nonatomic, strong) JGJQuaSafeToolReplyModel *repleModel;

@property (nonatomic, strong) JGJQuaSafeRectNotifyRequset *qualitySafeRequestModel;

@end

@implementation JGJQuaSafeCheckRectVc

@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"整改通知";
    self.isShowEditeBtn = YES;
    [self initialSubView];
    
    [self setBackButton];
    
    
    JGJQuaSafeToolReplyModel *pubModel = [JGJQuaSafeToolReplyModel new];
    
    pubModel.group_id = self.proListModel.group_id;
    
    pubModel.class_type = self.proListModel.class_type;
    
    pubModel.subClassType = self.commonModel.quaSafeCheckType;
    
    JGJQuaSafeToolReplyModel *replyModel = [JGJQuaSafeTool replyModel:pubModel];
    
    self.repleModel = replyModel;
    
    [self.tableView reloadData];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(publishBtnClick:)];
    
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
}

#pragma mark - 返回按钮按下
- (void)setBackButton {
    
    SEL getLeftButton = NSSelectorFromString(@"getLeftNoTargetButton");
    IMP imp = [self.navigationController methodForSelector:getLeftButton];
    UIButton* (*func)(id, SEL) = (void *)imp;
    UIButton *leftButton = func(self.navigationController, getLeftButton);
    
    [leftButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
}


- (void)backButtonPressed {
    
    //去掉检查记录整改发质量
    if (self.listModel) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
        return;
    }
    
    JGJQuaSafeToolReplyModel *pubModel = [JGJQuaSafeToolReplyModel new];
    
    pubModel.group_id = self.proListModel.group_id;
    
    pubModel.replyText = self.qualitySafeRequestModel.text;
    
    pubModel.class_type = self.proListModel.class_type;
    
    //唯一id发质量安全用类型
    
    pubModel.subClassType = self.commonModel.quaSafeCheckType;
    
    [JGJQuaSafeTool addCollectReplyModel:pubModel];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger count = 1;
    
    switch (section) {
        case 0:{
            
            count = 2;
        }
            break;
            
        case 1:
            count = 1;
            break;
            
        case 2:
            
            count = self.rectInfos.count;
            
            break;
            
        default:
            break;
    }
    
    return count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    __weak typeof(self) weakSelf = self;
    
    switch (indexPath.section) {
        case 0:{
            
            if (indexPath.row == 0) {
                
                __weak JGJPushContentCell *contentCell = [JGJPushContentCell cellWithTableView:tableView];
                
                contentCell.maxContentWords = 400;
                contentCell.pushContentCellBlock = ^(YYTextView *textView) {
                    
                    weakSelf.qualitySafeRequestModel.text = textView.text;
                    
                    weakSelf.repleModel.replyText = textView.text;
                    
                    if ([NSString isEmpty:weakSelf.qualitySafeRequestModel.text]) {
                        
                        if ([NSString isEmpty:weakSelf.qualitySafeRequestModel.text]) {
                            
                            weakSelf.listModel.inspect_name = nil;
                            
                            weakSelf.listModel.text = nil;
                            
                            contentCell.placeholderText = @"问题描述";
                        }
                    }
                };
                
                //添加照片输入改变的时候，刷新会是原来的值
                if (![NSString isEmpty:weakSelf.qualitySafeRequestModel.text]) {
                    
                    contentCell.checkRecordDefaultText = weakSelf.qualitySafeRequestModel.text;
                    
                }else if (![NSString isEmpty:self.dotListModel.dot_name] && ![NSString isEmpty:self.proInfoModel.plan_name]) {
                    
                    contentCell.checkRecordDefaultText = [NSString stringWithFormat:@"检查计划:%@\n检查人:%@(%@)\n检查项:%@\n检查内容:%@\n%@   %@", self.proInfoModel.plan_name, self.proInfoModel.user_info.real_name,self.proInfoModel.user_info.telphone, self.proInfoModel.pro_name, self.dotListModel.content_name, self.dotListModel.dot_name, @"待整改"];
                    
                }else if (![NSString isEmpty:self.repleModel.replyText]) {
                    
                    contentCell.checkRecordDefaultText = self.repleModel.replyText;
                    
                } else {
                    
                    contentCell.placeholderText = @"问题描述";
                }
                
                cell = contentCell;
                
            }else if (indexPath.row == 1) {
                
                JGJTRectNotifyWarningCell *warningCell = [JGJTRectNotifyWarningCell cellWithTableView:tableView];
                
                cell = warningCell;
            }
            
        }
            
            
            break;
        case 1:{
            
            cell = [self registerPushImageTableView:tableView cellForRowAtIndexPath:indexPath];
        }
            
            break;
            
        case 2:{
            
            cell = [self registerLocalLevelCellTableView:tableView cellForRowAtIndexPath:indexPath];
            
        }
            
            break;
            
        default:
            break;
    }
    
    return cell;
}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = 45.0;
    
    switch (indexPath.section) {
        case 0:{
            
            height = 110;
            
            if (indexPath.row == 1) {
                
                height = 40;
            }
            
        }
            
            break;
        case 1:{
            
            JLGAddProExperienceTableViewCell *cell = [JLGAddProExperienceTableViewCell new];
            
            height =  [cell getHeightWithImagesArray:self.imagesArray];
        }
            
            break;
            
        default:
            break;
    }
    
    return height;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    CGFloat height = 36.0;
    
    JGJCustomLable *headerLable = [[JGJCustomLable alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, height)];
    
    JGJCustomLable *proLable = [[JGJCustomLable alloc] initWithFrame:CGRectMake(TYGetUIScreenWidth - 262, 0, 250, height)];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, height)];
    
    contentView.backgroundColor = AppFontf1f1f1Color;
    
    [contentView addSubview:headerLable];
    
    [contentView addSubview: proLable];
    
    proLable.textAlignment = NSTextAlignmentRight;
    
    proLable.backgroundColor = [UIColor clearColor];
    
    proLable.textColor = AppFont333333Color;
    
    proLable.font = [UIFont systemFontOfSize:AppFont30Size];
    
    headerLable.textInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    
    headerLable.backgroundColor = AppFontf1f1f1Color;
    
    headerLable.textColor = AppFont333333Color;
    
    headerLable.font = [UIFont systemFontOfSize:AppFont30Size];
    
    NSArray *titles = @[@"当前项目", @"添加图片", @"整改要求"];
    
    headerLable.text = titles[section];
    
    if (section == 0) {
        
        proLable.text = self.proListModel.group_name;
        
    }else {
        
      proLable.text = @"";
    }

    return contentView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    CGFloat height = 36.0;
    
    return height;
}

- (UITableViewCell *)registerPushImageTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JLGAddProExperienceTableViewCell *returnCell = [JLGAddProExperienceTableViewCell cellWithTableView:tableView];
    
    returnCell.delegate = self;
    
    returnCell.imagesArray = self.imagesArray.mutableCopy;
    
    __weak typeof(self) weakSelf = self;
    returnCell.deleteCallBack = ^(JLGPhoneCollection *collectionCell, NSInteger index){
        [weakSelf removeImageAtIndex:index];
        
        //取出url
        __block NSMutableArray *deleteUrlArray = [NSMutableArray array];
        [collectionCell.deleteImgsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[NSString class]]) {
                [deleteUrlArray addObject:obj];
            }
        }];
        
        [weakSelf.deleteImgsArray addObjectsFromArray:deleteUrlArray];
        [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    };
    
    return  returnCell;
}

- (JGJCreatTeamCell *)registerLocalLevelCellTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJCreatTeamCell *cell = [JGJCreatTeamCell cellWithTableView:tableView];
    
    cell.creatTeamModel = self.rectInfos[indexPath.row];
    
    cell.lineView.hidden = indexPath.row == self.rectInfos.count - 1;
    
    return cell;
    
}

- (JGJCreatTeamCell *)registerPrinTimeInfoCellTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJCreatTeamCell *cell = [JGJCreatTeamCell cellWithTableView:tableView];
    
    cell.creatTeamModel = self.prinTimeInfos[indexPath.row];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.view endEditing:YES];
    
    switch (indexPath.section) {
        case 0:
            
            break;
            
        case 1:{
            
            
        }
            
            break;
            
        case 2:{
            
            if (indexPath.row == 0) {
                
                [self selRectLocation];
  
            }else if (indexPath.row == 1) {
                
                [self selSerLevel];
                
            }else if (indexPath.row == 2) {
                
                [self selPrinMember];
                
            }else if (indexPath.row == 3) {
                
                [self selRectMsgType];
                
            }else if (indexPath.row == 4) {
                
                [self selRectDate];
            }
            
        }
            
            break;
            
        default:
            break;
    }
    
    
}

#pragma mark - 隐患部位
- (void)selRectLocation {
    
    __weak typeof(self) weakSelf = self;
    
    JGJQualityLocationVc *locationVc = [[UIStoryboard storyboardWithName:@"JGJSafeQua" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJQualityLocationVc"];
    
    locationVc.qualityLocationVcBlock = ^(JGJQualityLocationVc *locationVc, JGJQualityLocationModel *locationModel){
        
        JGJCreatTeamModel *addressModel = self.rectInfos[0];
        
        addressModel.detailTitle = locationModel.text;
        
        addressModel.detailTitlePid = locationModel.id;
        
        [weakSelf freshIndexSection:2 row:0];
    };
    
    locationVc.proListModel = self.proListModel;
    
    [self.navigationController pushViewController:locationVc animated:YES];
}

#pragma mark - 选择隐患等级
- (void)selSerLevel {
    
    JGJTaskLevelSelVc *taskLevelSelVc = [JGJTaskLevelSelVc new];
    
    taskLevelSelVc.delegate = self;
    
    taskLevelSelVc.levelSelType = JGJTaskLevelSelSeriousType;
    
    JGJCreatTeamModel *rectMsgTypeModel = self.rectInfos[1];
    
    taskLevelSelVc.selLevel = rectMsgTypeModel.detailTitle;
    
    [self.navigationController pushViewController:taskLevelSelVc animated:YES];
}

#pragma mark - 整体负责人
- (void)selPrinMember {
    
    JGJTaskPrincipalVc *principalVc = [JGJTaskPrincipalVc new];
    
    principalVc.delegate = self;
    
    principalVc.memberSelType = JGJRectNotifySelMemberType;
    
    //3.3.3添加
     JGJCreatTeamModel *prinModel = self.rectInfos[2];
    
    JGJSynBillingModel *selMember = [JGJSynBillingModel new];
    
    selMember.uid = prinModel.detailTitlePid;
    
    principalVc.principalModel = selMember;
    
    principalVc.proListModel = self.proListModel;
    
    principalVc.principalModels = self.principalModels;
    
    principalVc.lastIndexPath = self.lastIndexPath;
    
    [self.navigationController pushViewController:principalVc animated:YES];
}

#pragma mark - 选择整改类型
- (void)selRectMsgType {
    
    JGJTaskLevelSelVc *taskLevelSelVc = [JGJTaskLevelSelVc new];
    
    taskLevelSelVc.delegate = self;
    
    taskLevelSelVc.levelSelType = JGJTaskLevelRectMsgTypeType;
    
    JGJCreatTeamModel *rectMsgTypeModel = self.rectInfos[3];
    
    taskLevelSelVc.selLevel = rectMsgTypeModel.detailTitle;
    
    taskLevelSelVc.dataSource = self.qualityLevelModels;
    
    [self.navigationController pushViewController:taskLevelSelVc animated:YES];
}

#pragma mark - 整改完成期限
- (void)selRectDate {
    
    JGJCreatTeamModel *timeModel = self.rectInfos[4];
    
    __weak typeof(self) weakSelf = self;
    
    ATDatePicker *datePicker = [[ATDatePicker alloc] initWithDatePickerMode:UIDatePickerModeDate DateFormatter:@"yyyy-MM-dd" datePickerFinishBlock:^(NSString *dateString) {
        
        timeModel.detailTitle = dateString;
        
        [weakSelf freshIndexSection:2 row:4];
        
        TYLog(@"%@", dateString);
    }];
    
    NSString *dateStr = [NSString stringFromDate:[NSDate date] withDateFormat:@"yyyy-MM-dd"];
    
    if (![NSString isEmpty:dateStr]) {
        
        datePicker.minimumDate = [NSDate dateFromString:dateStr withDateFormat:@"yyyy-MM-dd"];
    }
    
    if (![NSString isEmpty:timeModel.detailTitle]) {
        
        datePicker.date = [NSDate dateFromString:timeModel.detailTitle withDateFormat:@"yyyy-MM-dd"];
    }
    
    [datePicker show];
}

#pragma mark - 点击编辑框以后的键盘位置
- (void)CollectionCellTouch{
    
    [self.view endEditing:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
    
}

- (void)taskLevelSelVc:(JGJTaskLevelSelVc *)levelSelVc selectedIndexPath:(NSIndexPath *)indexPath selectedModel:(JGJTaskLevelSelModel *)selModel {
    
    if (levelSelVc.levelSelType == JGJTaskLevelRectMsgTypeType) {
        
        JGJCreatTeamModel *rectMsgTypeModel = self.rectInfos[3];
        
        rectMsgTypeModel.detailTitle = selModel.levelName;
        
        rectMsgTypeModel.detailTitlePid = selModel.levelUid;
        
        self.qualityLevelModels = levelSelVc.dataSource;
        
    }else if (levelSelVc.levelSelType == JGJTaskLevelSelSeriousType) {
        
        JGJCreatTeamModel *levelTypeModel = self.rectInfos[1];
        
        levelTypeModel.detailTitle = selModel.levelName;
        
        levelTypeModel.detailTitlePid = selModel.levelUid;
    }
    
    [levelSelVc.navigationController popViewControllerAnimated:YES];
    
    [self.tableView reloadData];
}

- (void)taskPrincipalVc:(JGJTaskPrincipalVc *)principalVc didSelelctedMemberModel:(JGJSynBillingModel *)memberModel {
    
    JGJCreatTeamModel *prinModel = self.rectInfos[2];
    
    prinModel.detailTitle = memberModel.real_name;
    
    prinModel.detailTitlePid = memberModel.uid;
    
    [principalVc.navigationController popViewControllerAnimated:YES];
    
    [self.tableView reloadData];
}

#pragma mark - 提交

- (void)publishBtnClick:(UIButton *)sender {
    
    self.qualitySafeRequestModel.pro_id = self.proInfoModel.pro_id;
    
    self.qualitySafeRequestModel.plan_id = self.proInfoModel.plan_id;
    
    self.qualitySafeRequestModel.dot_id = self.dotListModel.dot_id;
    
     self.qualitySafeRequestModel.content_id = self.dotListModel.content_id;
    
    JGJCreatTeamModel *localModel = self.rectInfos[0];
    
    self.qualitySafeRequestModel.location_text = localModel.detailTitle;
    
    JGJCreatTeamModel *levelModel = self.rectInfos[1];
    
    self.qualitySafeRequestModel.severity = levelModel.detailTitlePid;
    
    JGJCreatTeamModel *prinModel = self.rectInfos[2];
    
    self.qualitySafeRequestModel.principal_uid = prinModel.detailTitlePid;
    
    JGJCreatTeamModel *rectTypeModel = self.rectInfos[3];
    
    NSString *msgtype = @"quality";
    
    if ([rectTypeModel.detailTitle isEqualToString:@"质量"]) {
        
        msgtype = @"quality";
        
    }else if ([rectTypeModel.detailTitle isEqualToString:@"安全"]) {
        
        msgtype = @"safe";
        
    }else if ([rectTypeModel.detailTitle isEqualToString:@"任务"]) {
        
        msgtype = @"task";

    }
    
    self.qualitySafeRequestModel.msg_type = msgtype;
    
    JGJCreatTeamModel *timeModel = self.rectInfos[4];
    
    NSString *finishTime = @"";
    
    if ([timeModel.detailTitle containsString:@"-"]) {
        
        finishTime = [timeModel.detailTitle stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    
    self.qualitySafeRequestModel.finish_time = finishTime;
    
    
    if ([NSString isEmpty:self.qualitySafeRequestModel.text] && self.imagesArray.count == 0) {
        
        [TYShowMessage showPlaint:@"问题描述和图片至少需要填一项"];
        
        return;
    }
    
    if ([rectTypeModel.detailTitle isEqualToString:@"任务"]) {
        
        msgtype = @"task";
        
        NSString *location = [NSString stringWithFormat:@"\n隐患部位:%@", localModel.detailTitle];
        
        if ([NSString isEmpty:localModel.detailTitle]) {
            
            location = @"";
        }
        
        NSString *level = [NSString stringWithFormat:@"\n隐患级别:%@", levelModel.detailTitle];
        
        if ([NSString isEmpty:levelModel.detailTitle]) {
            
            level = @"";
        }
        
        NSString *taskLevelStr = [NSString stringWithFormat:@"%@%@", location, level];
        
        NSString *content = self.qualitySafeRequestModel.text;
        
        self.qualitySafeRequestModel.text = [NSString stringWithFormat:@"%@%@", content, taskLevelStr];
    }
    
    if ([NSString isEmpty:self.qualitySafeRequestModel.principal_uid]) {
        
        [TYShowMessage showPlaint:@"请选择整改负责人"];
        
        return;
    }
    
    if ([NSString isEmpty:self.qualitySafeRequestModel.msg_type]) {
        
        [TYShowMessage showPlaint:@"请选择整改类型"];
        
        return;
    }
    
    NSDictionary *parameters = [self.qualitySafeRequestModel mj_keyValues];
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN uploadImagesWithApi:@"v2/inspect/reformInspect" parameters:parameters imagearray:self.imagesArray success:^(id responseObject) {
        
        TYLog(@"responseObject ==== %@", responseObject);
        
        [TYShowMessage showSuccess:@"发布成功"];
        
        [TYLoadingHub hideLoadingView];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
    
}

- (void)popVc:(JGJChatRootVc *)chatRootVc imgsAddArr:(NSArray *)imgsAddressArr{
    
    self.qualitySafeRequestModel.msg_type = self.commonModel.msg_type;
    
    NSDictionary *dataInfo = [self.qualitySafeRequestModel mj_keyValues];
    
    [chatRootVc addAllNotice:dataInfo];
    
    [self freshDataList];
    
    //删除数据库消息
    [self delDataBaseInfo];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 删除信息
- (void)delDataBaseInfo {
    
    JGJQuaSafeToolReplyModel *pubModel = [JGJQuaSafeToolReplyModel new];
    
    pubModel.group_id = self.proListModel.group_id;
    
    pubModel.class_type = self.proListModel.class_type;
    
    //唯一id发质量安全用类型
    
    pubModel.subClassType = self.commonModel.quaSafeCheckType;
    
    [JGJQuaSafeTool removeCollecReplyModel:pubModel];
    
}

- (void)freshIndexSection:(NSInteger)section row:(NSInteger)row {
    
    [self.tableView beginUpdates];
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:section]] withRowAnimation:UITableViewRowAnimationNone];
    
    [self.tableView endUpdates];
    
}

- (void)freshDataList {
    
    JGJChatRootVc *chatRootVc = self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2];
    
    if ([chatRootVc isKindOfClass:[JGJChatListBaseVc class]]) {
        
        JGJChatListBaseVc *baseVc = (JGJChatListBaseVc *)chatRootVc;
        
        if (![self isKindOfClass:NSClassFromString(@"JGJChatListAllVc")]) {
            
            [baseVc.tableView.mj_header beginRefreshing];
        }
        
    }
}

- (NSMutableArray *)rectInfos {
    
    if (!_rectInfos) {
        
        _rectInfos = [NSMutableArray new];
        
        NSArray *titles = @[@"隐患部位", @"隐患级别", @"整改负责人", @"整改类型", @"整改完成期限"];
        
        NSArray *detailTitles = @[@"", @"一般", @"", @"质量", @""];
        
        for (int indx = 0; indx < titles.count; indx ++) {
            
            JGJCreatTeamModel *desModel = [[JGJCreatTeamModel alloc] init];
            
            desModel.title = titles[indx];
            
            desModel.detailTitle = detailTitles[indx];
            
            desModel.detailTitlePid = indx == 1 ? @"1" : nil;
            
            [_rectInfos addObject:desModel];
        }
    }
    
    return _rectInfos;
    
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
    
    //    [self.view addSubview:self.containSaveButtonView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.mas_equalTo(self.view);
        
        make.height.mas_equalTo(TYGetUIScreenHeight - 64);
    }];
    
}

- (JGJQuaSafeRectNotifyRequset *)qualitySafeRequestModel {
    
    if (!_qualitySafeRequestModel) {
        
        _qualitySafeRequestModel = [JGJQuaSafeRectNotifyRequset new];
    }
    
    return _qualitySafeRequestModel;
}

@end
