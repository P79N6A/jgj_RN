//
//  JGJPublishTaskVc.m
//  mix
//
//  Created by yj on 2017/5/31.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJPublishTaskVc.h"

#import "YYTextView.h"

#import "JGJPushContentCell.h"

#import "JLGAddProExperienceTableViewCell.h"

#import "UILabel+GNUtil.h"

#import "JGJCustomLable.h"

#import "JGJTaskPrincipalCell.h"

#import "JGJTaskJoinMemberCell.h"

#import "JGJCreatTeamCell.h"

#import "JGJTaskTracerVc.h"

#import "JGJTaskPrincipalVc.h"

#import "JGJTaskRequestModel.h"

#import "NSString+Extend.h"

#import "JGJTaskLevelSelVc.h"

#import "NSDate+Extend.h"

#import "ATDatePicker.h"

#import "JGJTaskRootVc.h"

#import "JGJQuaSafeTool.h"

@interface JGJPublishTaskVc ()<

    UITableViewDelegate,

    UITableViewDataSource,

    JLGMYProExperienceTableViewCellDelegate,

    JGJTaskJoinMemberCellDelegate,

    JGJTaskPrincipalVcDelegate

>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *containSaveButtonView;

@property (nonatomic, strong) UIButton *publishButton;

@property (nonatomic, strong) JGJTaskPublishRequestModel *taskPublishRequestModel;

@property (nonatomic, strong) JGJQuaSafeToolReplyModel *repleModel;

@end

@implementation JGJPublishTaskVc

@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isNeedWatermark = YES;
    self.title = @"发任务";
    [self initialSubView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger count = 1;
    
    switch (section) {
        case 0:
            count = 2;
            break;
        case 1:
            count = 1;
            break;
        case 2:
            count = 1;
            break;
        case 3:
            count = self.taskTimeLevelModels.count;
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
                
                JGJPushContentCell *contentCell = [JGJPushContentCell cellWithTableView:tableView];
                
                contentCell.lineView.hidden = YES;
                
                contentCell.maxContentWords = 1000;
                
                contentCell.placeholderText = @"请输入任务内容";
                
                contentCell.pushContentCellBlock = ^(YYTextView *textView) {
                    
                    weakSelf.taskPublishRequestModel.task_content = textView.text;
                    
                    weakSelf.repleModel.replyText = textView.text;
                };
                
                if (![NSString isEmpty:self.repleModel.replyText]) {
                    
                    contentCell.checkRecordDefaultText = self.repleModel.replyText;
                    
                }                
                cell = contentCell;
            }else if (indexPath.row == 1) {
                
                cell = [self registerPushImageTableView:tableView cellForRowAtIndexPath:indexPath];
                
            }
            
        }
            
            
            break;
        case 1:{
            
            JGJTaskPrincipalCell *principalCell = [self registerkPrincipalTableView:tableView cellForRowAtIndexPath:indexPath];
            
            
            cell = principalCell;
        }
            
            break;
            
        case 2:{
            
            JGJTaskJoinMemberCell *joinMemberCell = [self registerkJoinMemberTableView:tableView cellForRowAtIndexPath:indexPath];
            
            cell = joinMemberCell;
        }
            
            break;
            
        case 3:{
            
            JGJCreatTeamCell *timeLevelCell = [self registerTimeLevelTableView:tableView cellForRowAtIndexPath:indexPath];
            
            
            cell = timeLevelCell;
        }
            
            break;
        default:
            break;
    }
    
    return cell;
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
        [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    };
    
    return  returnCell;
}

- (JGJTaskPrincipalCell *)registerkPrincipalTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJTaskPrincipalCell *principalCell = [JGJTaskPrincipalCell cellWithTableView:tableView];
    
    principalCell.principalModel = self.principalModel;
    
    return principalCell;
    
}

- (JGJTaskJoinMemberCell *)registerkJoinMemberTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJTaskJoinMemberCell *joinMemberCell = [JGJTaskJoinMemberCell cellWithTableView:tableView];
    
    joinMemberCell.delegate = self;
    
    joinMemberCell.taskTracerModels = self.taskTracerModels;
    
    return joinMemberCell;
    
}

- (JGJCreatTeamCell *)registerTimeLevelTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJCreatTeamCell *cell = [JGJCreatTeamCell cellWithTableView:tableView];
    
    JGJCreatTeamModel *timeLevelModel = self.taskTimeLevelModels[indexPath.row];
    
    cell.creatTeamModel = timeLevelModel;
    
    cell.lineView.hidden = indexPath.row == self.taskTimeLevelModels.count - 1;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakSelf = self;
    switch (indexPath.section) {
        case 0:
            
            break;
            
        case 1:{
            
            JGJTaskPrincipalVc *principalVc = [JGJTaskPrincipalVc new];
            
            principalVc.delegate = self;
            
            principalVc.proListModel = self.proListModel;
            
            principalVc.principalModels = self.principalModels;
            
            principalVc.lastIndexPath = self.lastIndexPath;
            
            principalVc.principalModel = self.principalModel;
            
            principalVc.memberSelType = JGJMemberUndertakeMemeberType;
            
            [self.navigationController pushViewController:principalVc animated:YES];
        }
            
            break;
            
        case 2:
            
            break;
            
        case 3:{
            
            if (indexPath.row == 0) {
                
                JGJCreatTeamModel *taskTimeModel = self.taskTimeLevelModels[0];
                
                ATDatePicker *datePicker = [[ATDatePicker alloc] initWithDatePickerMode:UIDatePickerModeDateAndTime DateFormatter:@"yyyy-MM-dd:EEEE HH:mm" datePickerFinishBlock:^(NSString *dateString) {
                    
                    NSString *finishTime = [dateString stringByReplacingCharactersInRange:NSMakeRange(10, 4) withString:@""];
                    
                    taskTimeModel.remarkInfo = dateString;
                    
                    taskTimeModel.detailTitle = finishTime;
                    
                    [weakSelf freshIndexSection:3 row:0];
                    
                    TYLog(@"%@", dateString);
                }];
                
                if (![taskTimeModel.detailTitle isEqualToString:@"无"]) {
                    
                    datePicker.date = [NSDate dateFromString:taskTimeModel.remarkInfo withDateFormat:@"yyyy-MM-dd:EEEE HH:mm"];
                }
                
                [datePicker show];
                
            }else if (indexPath.row == 1) {
                
                JGJTaskLevelSelVc *taskLevelSelVc = [JGJTaskLevelSelVc new];
                
                taskLevelSelVc.lastIndexPath = self.lastLevelIndexPath;
                
                taskLevelSelVc.dataSource = self.taskLevelModels;
                
                [self.navigationController pushViewController:taskLevelSelVc animated:YES];
            }
            
        }
            
            break;
            
        default:
            break;
    }
    
}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = 80;
    switch (indexPath.section) {
        case 0:{
            
            if(indexPath.row == 0) {
                
                height = 110;
                
            }else if (indexPath.row == 1) {
                
                //                height = 90.0;
                
                JLGAddProExperienceTableViewCell *cell = [JLGAddProExperienceTableViewCell new];
                
                height =  [cell getHeightWithImagesArray:self.imagesArray];
            }
            
        }
            
            break;
        case 1:{
            
            height = 85;
        }
            
            break;
        case 2:{
            
            height = 93;
        }
            
            break;
        case 3:{
            
            height = 45;
        }
            
            break;
            
        default:
            break;
    }
    
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    JGJCustomLable *headerLable = [[JGJCustomLable alloc] initWithFrame:CGRectMake(12, 0, TYGetUIScreenWidth, 30)];
    
    headerLable.textInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    
    headerLable.textColor = AppFont333333Color;
    
    headerLable.font = [UIFont systemFontOfSize:AppFont30Size];
    
    switch (section) {
        case 0: {
            
            headerLable.text = [NSString stringWithFormat:@"当前项目: %@", self.proListModel.group_name];
            headerLable.textColor = AppFont999999Color;
            
        }
            
            break;
        case 1:{
            
            headerLable.text = @"负责人 (点击头像可切换)";
            
            [headerLable markText:@"(点击头像可切换)" withColor:AppFont999999Color];
            
        }
            
            break;
        case 2:{
            
            headerLable.text = @"参与者 (点击头像可删除)";
            
            [headerLable markText:@"(点击头像可删除)" withColor:AppFont999999Color];
        }
            
            break;
            
        default:
            break;
    }
    
    headerLable.backgroundColor = AppFontf1f1f1Color;
    
    return headerLable;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    CGFloat height = 36.0;
    
    if (section == 3) {
        
        height = 10;
    }
    
    return height;
}

#pragma mark - JGJTaskJoinMemberCellDelegate

- (void)taskJoinMemberCell:(JGJTaskJoinMemberCell *)cell didSelectedMember:(JGJSynBillingModel *)memberModel {
    
    if (memberModel.isAddModel) {
        
        JGJTaskTracerVc *taskTracerVc = [[UIStoryboard storyboardWithName:@"JGJTask" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJTaskTracerVc"];
        
        taskTracerVc.taskTracerType = JGJTaskJoinTracerType;
        
        taskTracerVc.proListModel = self.proListModel;
        
        taskTracerVc.selectedButtonStatus = self.selectedButtonStatus;
        
        [self.navigationController pushViewController:taskTracerVc animated:YES];
        
        //这句话放在后面，setter方法里面有加载索引
        taskTracerVc.taskTracerModels = self.allTaskTracerModels;
        
    }else {
        
        memberModel.isSelected =  !memberModel.isSelected;
        
        //删除了人员标记没有选中
        
        self.selectedButtonStatus = NO;
    }
    
}

#pragma mark - JGJTaskPrincipalVc

- (void)taskPrincipalVc:(JGJTaskPrincipalVc *)principalVc didSelelctedMemberModel:(JGJSynBillingModel *)memberModel {


}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
}

#pragma mark - 点击编辑框以后的键盘位置
- (void)CollectionCellTouch{
    
    [self.view endEditing:YES];
}

#pragma mark - 发布按钮

- (void)publishBtnClick:(UIButton *)sender {
    
    self.taskPublishRequestModel.group_id = self.proListModel.group_id;
    
    self.taskPublishRequestModel.class_type = self.proListModel.class_type;
    
    self.taskPublishRequestModel.principal_uid = self.principalModel.uid;
    
    if ([NSString isEmpty:self.taskPublishRequestModel.task_content] && self.imagesArray.count == 0) {
        
        [TYShowMessage showError:@"任务内容、图片至少填写一项"];
        
        [self.view endEditing:YES];
        
        return;
    }
    
    if ([NSString isEmpty:self.principalModel.uid] || [self.principalModel.uid isEqualToString:@"0"]) {
        
        [TYShowMessage showError:@"请选择任务负责人"];
        
        return;
    }
    
    NSMutableString *upLoadTaskTracerUids = [NSMutableString string];
    
    for (JGJSynBillingModel *taskTracerModel in self.taskTracerModels) {
        
        if (!taskTracerModel.isAddModel && ![NSString isEmpty:taskTracerModel.uid]) {
            
            [upLoadTaskTracerUids appendFormat:@"%@,",taskTracerModel.uid];
        }
    }
    
    //    删除末尾的分号
    if (![NSString isEmpty:upLoadTaskTracerUids]) {
        
        [upLoadTaskTracerUids deleteCharactersInRange:NSMakeRange(upLoadTaskTracerUids.length - 1, 1)];
    }
    
    self.taskPublishRequestModel.priticipant_uids = upLoadTaskTracerUids;
    
    //完成时间、紧急程度
    
    JGJCreatTeamModel *taskTimeLevelModel = self.taskTimeLevelModels[0];
    
    
    if ([taskTimeLevelModel.detailTitle isEqualToString:@"无"] || [NSString isEmpty:taskTimeLevelModel.detailTitle]) {
        
        self.taskPublishRequestModel.task_finish_time = nil;
        
    }else {
        
        NSDate *finishTimeDate = [NSDate dateFromString:taskTimeLevelModel.detailTitle withDateFormat:@"yyyy-MM-dd HH:mm"];
        
        self.taskPublishRequestModel.task_finish_time = finishTimeDate.timestamp;
        
    }
    
    JGJCreatTeamModel *taskLevelModel = self.taskTimeLevelModels[1];
    
    self.taskPublishRequestModel.task_level = taskLevelModel.detailTitlePid;
    
    NSDictionary *parameters = [self.taskPublishRequestModel mj_keyValues];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [TYLoadingHub showLoadingWithMessage:nil];

    [JLGHttpRequest_AFN uploadImagesWithApi:@"v2/task/taskPost" parameters:parameters imagearray:self.imagesArray otherDataArray:nil dataNameArray:nil success:^(id responseObject) {
        
        TYLog(@"succese = %@",responseObject);
        [TYLoadingHub hideLoadingView];
        [TYShowMessage showSuccess:@"发布成功"];
        
        //删除数据库消息
        [self delDataBaseInfo];
        
        for (UIViewController *vc in self.navigationController.viewControllers) {
            
            if ([vc isKindOfClass:[JGJTaskRootVc class]]) {
                
                JGJTaskRootVc *taskRootVc = (JGJTaskRootVc *)vc;
                
                //刷新列表
                
                [taskRootVc freshWaitTask];
                
                [self.navigationController popViewControllerAnimated:YES];
                
                break;
                
            }
            
        }
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }];
    
}


- (void)initialSubView {
    
    JGJQuaSafeToolReplyModel *pubModel = [JGJQuaSafeToolReplyModel new];
    
    pubModel.group_id = self.proListModel.group_id;
    
    pubModel.class_type = self.proListModel.class_type;
    
    pubModel.subClassType = @"taskType";
    
    JGJQuaSafeToolReplyModel *replyModel = [JGJQuaSafeTool replyModel:pubModel];
    
    self.repleModel = replyModel;
    
    [self.tableView reloadData];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(publishBtnClick:)];
    
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    [self.view addSubview:self.tableView];
    
//    [self.view addSubview:self.containSaveButtonView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.mas_equalTo(self.view);
        
        make.height.mas_equalTo(TYGetUIScreenHeight - 64);
    }];
    
    [self setBackButton];
    
}

- (void)freshIndexSection:(NSInteger)section row:(NSInteger)row {
    
    [self.tableView beginUpdates];
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:section]] withRowAnimation:UITableViewRowAnimationNone];
    
    [self.tableView endUpdates];
    
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

#pragma mark - getter
- (NSMutableArray *)taskTimeLevelModels {
    NSArray *titles = @[@"完成期限", @"紧急程度"];
    NSArray *detailTitles = @[@"无", @"一般"];
    if (!_taskTimeLevelModels) {
        _taskTimeLevelModels = [NSMutableArray array];
        for (int indx = 0; indx < titles.count; indx ++) {
            JGJCreatTeamModel *taskModel = [[JGJCreatTeamModel alloc] init];
            taskModel.title = titles[indx];
            taskModel.detailTitlePid = [NSString stringWithFormat: @"%@", indx == 1 ? @"1" : @"0"];
            taskModel.detailTitle = detailTitles[indx];
            [_taskTimeLevelModels addObject:taskModel];
        }
    }
    return _taskTimeLevelModels;
}

- (UIView *)containSaveButtonView {
    if (!_containSaveButtonView) {
        _containSaveButtonView = [[UIView alloc] init];
        _containSaveButtonView.backgroundColor = AppFontfafafaColor;
        [self.view addSubview:_containSaveButtonView];
        [_containSaveButtonView addSubview:self.publishButton];
        [_containSaveButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@63);
            make.left.right.bottom.equalTo(self.view);
        }];
        UIView *lineViewTop = [[UIView alloc] init];
        lineViewTop.backgroundColor = AppFontdbdbdbColor;
        [_containSaveButtonView addSubview:lineViewTop];
        [lineViewTop mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.left.equalTo(_containSaveButtonView);
            make.height.equalTo(@1);
        }];
        UIView *lineViewBottom = [[UIView alloc] init];
        lineViewBottom.backgroundColor = AppFontdbdbdbColor;
        [_containSaveButtonView addSubview:lineViewBottom];
        [lineViewBottom mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.left.equalTo(_containSaveButtonView);
            make.height.equalTo(@1);
        }];
    }
    return _containSaveButtonView;
}

- (UIButton *)publishButton
{
    if (!_publishButton) {
        //添加保存按钮
        _publishButton = [[UIButton alloc] init];
        [self.containSaveButtonView addSubview:_publishButton];
        _publishButton.backgroundColor = JGJMainColor;
        _publishButton.titleLabel.textColor = [UIColor whiteColor];
        [_publishButton setTitle:@"发布" forState:UIControlStateNormal];
        [_publishButton.layer setLayerBorderWithColor:AppFontd7252cColor width:0.5 radius:5];
        [_publishButton addTarget:self action:@selector(publishBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_publishButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            
            make.right.mas_equalTo(-10);
            
            make.height.mas_equalTo(45);
            
            make.centerY.mas_equalTo(self.containSaveButtonView);
        }];
    }
    return _publishButton;
}

- (NSMutableArray *)taskTracerModels {
    
    if (!_taskTracerModels) {
        
        _taskTracerModels = [NSMutableArray new];
        
        JGJSynBillingModel *addModel = [JGJSynBillingModel new];
        
        addModel.real_name = @"添加";
        
        addModel.isAddModel = YES;
        
        addModel.head_pic = @"add_ principal_icon";
        
        [_taskTracerModels addObject:addModel];
    }
    
    return _taskTracerModels;
    
}

-(JGJSynBillingModel *)principalModel {

    if (!_principalModel) {
        
        _principalModel = [JGJSynBillingModel new];
        
        _principalModel.real_name = @"添加";
        
        _principalModel.isAddModel = YES;
        
        _principalModel.head_pic = @"add_ principal_icon";
        
        _principalModel.uid = @"0";
        
        _principalModel.is_active = @"1";
    }

    return _principalModel;
}

- (JGJTaskPublishRequestModel *)taskPublishRequestModel {
    
    if (!_taskPublishRequestModel) {
        
        _taskPublishRequestModel = [JGJTaskPublishRequestModel new];
    }
    
    return _taskPublishRequestModel;
    
}

#pragma mark - 删除信息
- (void)delDataBaseInfo {
    
    JGJQuaSafeToolReplyModel *pubModel = [JGJQuaSafeToolReplyModel new];
    
    pubModel.group_id = self.proListModel.group_id;
    
    pubModel.class_type = self.proListModel.class_type;
    
    pubModel.subClassType = @"taskType";
    
    [JGJQuaSafeTool removeCollecReplyModel:pubModel];
    
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
    
    JGJQuaSafeToolReplyModel *pubModel = [JGJQuaSafeToolReplyModel new];
    
    pubModel.group_id = self.proListModel.group_id;
    
    pubModel.replyText = self.taskPublishRequestModel.task_content;
    
    pubModel.class_type = self.proListModel.class_type;
    
    //唯一id发质量安全用类型
    
    pubModel.subClassType = @"taskType";
    
    [JGJQuaSafeTool addCollectReplyModel:pubModel];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
