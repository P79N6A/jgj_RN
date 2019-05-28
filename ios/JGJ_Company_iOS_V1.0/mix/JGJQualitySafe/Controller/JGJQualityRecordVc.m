//
//  JGJQualityRecordVc.m
//  JGJCompany
//
//  Created by yj on 2017/6/6.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJQualityRecordVc.h"

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

#import "JGJCommonTitleCell.h"

@interface JGJQualityRecordVc ()<

UITableViewDelegate,

UITableViewDataSource,

JLGMYProExperienceTableViewCellDelegate,

JGJCusSwitchMsgCellDelegate

>

@property (nonatomic, strong) UITableView *tableView;

//存放位置，严重程度
@property (nonatomic, strong) NSMutableArray *locaLevelInfos;

@property (nonatomic, strong) UIView *containSaveButtonView;

@property (nonatomic, strong) UIButton *publishButton;

@property (nonatomic, strong) JGJQualitySafeRequestModel *qualitySafeRequestModel;

@property (nonatomic, strong) JGJQuaSafeToolReplyModel *repleModel;

//整改cell用于开启键盘监听使用
@property (nonatomic, strong) JGJPushContentCell *modifyCell;
@end

@implementation JGJQualityRecordVc

@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isNeedWatermark = YES;// 是否拍摄的照片需要添加水印
    self.isShowEditeBtn = YES;// 是否可以给选择的照片绘图
    if ([self.commonModel.msg_type isEqualToString:@"quality"]) {
        
        self.title = @"发质量问题";
        
    }else if ([self.commonModel.msg_type isEqualToString:@"safe"]) {
        
        self.title = @"发安全问题";
    }
    
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
    
    
    //
    //    [JGJAddressBookTool loadGroupMembersWithProListModel:self.proListModel addressBookToolBlock:^(JGJAddressBookSortContactsModel *sortContactModel) {
    //
    //        TYLog(@"sortContactModel === %@", @(sortContactModel.sortContacts.count));
    //
    //    }];
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
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger count = 1;
    
    switch (section) {
        case 0:
            count = 1;
            break;
            
        case 1:
            count = 1;
            break;
            
        case 2:
            count = 2;
            break;
            
        case 3:{
            
            JGJChatDetailInfoCommonModel *modifyModel = self.prinTimeInfos[0];
            
            count = !modifyModel.isOpen ? 1 : self.prinTimeInfos.count;
        }
            
            break;
            
        default:
            break;
    }
    
    return count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    __weak JGJPushContentCell *contentCell = [JGJPushContentCell cellWithTableView:tableView];
    
    __weak typeof(self) weakSelf = self;
    
    switch (indexPath.section) {
        case 0:{
            
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
                
            }else if (![NSString isEmpty:self.listModel.inspect_name] && ![NSString isEmpty:self.listModel.text]) {
                
                contentCell.checkRecordDefaultText = [NSString stringWithFormat:@"检查大项:%@\n检查分项:%@\n检查结果:%@", self.listModel.inspect_name, self.listModel.text, @"未通过"];
                
            }else if (![NSString isEmpty:self.repleModel.replyText]) {
                
                contentCell.checkRecordDefaultText = self.repleModel.replyText;
                
            } else {
                
                contentCell.placeholderText = @"问题描述";
            }
            
            cell = contentCell;
            
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
            
        case 3:{
            
            if (indexPath.row == 0) {
                
                JGJCusSwitchMsgCell *switchMsgCell = [JGJCusSwitchMsgCell cellWithTableView:tableView];
                
                switchMsgCell.commonModel = self.prinTimeInfos[indexPath.row];
                
                switchMsgCell.isAllScreenWShow = YES;
                
                switchMsgCell.delegate = self;
                
                switchMsgCell.lineView.hidden = YES;
                
                cell = switchMsgCell;
                
            }else if (indexPath.row == 1) { //10px分割线
                
                JGJCommonTitleCell *titleCell = [JGJCommonTitleCell cellWithTableView:tableView];
                
                titleCell.contentView.backgroundColor = AppFontf1f1f1Color;
                
                titleCell.desModel = self.prinTimeInfos[indexPath.row];
                
                cell = titleCell;
                
            }else if (indexPath.row == 2 || indexPath.row == 3) {
                
                cell = [self registerPrinTimeInfoCellTableView:tableView cellForRowAtIndexPath:indexPath];
            }
            
            else if (indexPath.row == 4) {
                
                JGJCommonTitleCell *titleCell = [JGJCommonTitleCell cellWithTableView:tableView];
                
                titleCell.contentView.backgroundColor = AppFontf1f1f1Color;
                
                titleCell.desModel = self.prinTimeInfos[indexPath.row];
                
                cell = titleCell;
                
            }else if (indexPath.row == 5) {
                
                //                JGJPushContentCell *modifyCell = [JGJPushContentCell cellWithTableView:tableView];
                
                //                self.modifyCell = modifyCell;
                
                contentCell.maxContentWords = 400;
                
                contentCell.placeholderText = @"请输入整改措施";
                
                contentCell.checkRecordDefaultText = self.qualitySafeRequestModel.msg_step?:@"";
                
                contentCell.pushContentCellBlock = ^(YYTextView *textView) {
                    
                    weakSelf.qualitySafeRequestModel.msg_step = textView.text;
                    
                };
                
                cell = contentCell;
                
            }
            
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
            
        }
            
            break;
        case 1:{
            
            JLGAddProExperienceTableViewCell *cell = [JLGAddProExperienceTableViewCell new];
            
            height =  [cell getHeightWithImagesArray:self.imagesArray];
        }
            
            break;
            
        case 3:{
            
            if (indexPath.row == 5) {
                
                height = 110;
                
            }else if (indexPath.row == 1) {
                
                height = 10;
            }
        }
            
            break;
            
        default:
            break;
    }
    
    return height;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    CGFloat height = 36.0;
    
    JGJCustomLable *headerLable = [[JGJCustomLable alloc] initWithFrame:CGRectMake(12, 0, 120, height)];
    
    JGJCustomLable *proLable = [[JGJCustomLable alloc] initWithFrame:CGRectMake(140, 0, TYGetUIScreenWidth - 152, height)];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, height)];
    
    contentView.backgroundColor = AppFontf1f1f1Color;
    
    [contentView addSubview:headerLable];
    
    [contentView addSubview: proLable];
    
    proLable.textAlignment = NSTextAlignmentRight;
    
    proLable.backgroundColor = AppFontf1f1f1Color;
    
    proLable.textColor = AppFont333333Color;
    
    proLable.font = [UIFont systemFontOfSize:AppFont30Size];
    
    
    headerLable.textInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    
    headerLable.backgroundColor = AppFontf1f1f1Color;
    
    headerLable.textColor = AppFont333333Color;
    
    headerLable.font = [UIFont systemFontOfSize:AppFont30Size];
    
    switch (section) {
        case 0: {
            
            headerLable.text = @"当前项目";
            
            proLable.text = self.proListModel.all_pro_name;
            
            headerLable.textInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            
            return contentView;
        }
            
            break;
        case 1:{
            
            headerLable.text = @"添加图片";
            
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
    
    if (section == 3 || section == 2) {
        
        height = 10;
    }
    
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
    
    cell.creatTeamModel = self.locaLevelInfos[indexPath.row];
    
    cell.lineView.hidden = indexPath.row == self.locaLevelInfos.count - 1;
    
    return cell;
    
}

- (JGJCreatTeamCell *)registerPrinTimeInfoCellTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJCreatTeamCell *cell = [JGJCreatTeamCell cellWithTableView:tableView];
    
    cell.creatTeamModel = self.prinTimeInfos[indexPath.row];
    
    cell.lineView.hidden = 3 == indexPath.row;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.view endEditing:YES];
    
    __weak typeof(self) weakSelf = self;
    
    switch (indexPath.section) {
        case 0:
            
            break;
            
        case 1:{
            
            
        }
            
            break;
            
        case 2:{
            
            if (indexPath.row == 0) {
                
                JGJQualityLocationVc *locationVc = [[UIStoryboard storyboardWithName:@"JGJSafeQua" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJQualityLocationVc"];
                
                locationVc.qualityLocationVcBlock = ^(JGJQualityLocationVc *locationVc, JGJQualityLocationModel *locationModel){
                    
                    JGJCreatTeamModel *addressModel = self.locaLevelInfos[0];
                    
                    addressModel.detailTitle = locationModel.text;
                    
                    addressModel.detailTitlePid = locationModel.id;
                    
                    [weakSelf freshIndexSection:2 row:0];
                };
                
                locationVc.proListModel = self.proListModel;
                
                [self.navigationController pushViewController:locationVc animated:YES];
                
            }else if (indexPath.row == 1) {
                
                JGJTaskLevelSelVc *taskLevelSelVc = [JGJTaskLevelSelVc new];
                
                JGJCreatTeamModel *levelModel = self.locaLevelInfos[1];
                
                taskLevelSelVc.selLevel = levelModel.detailTitle;
                
                taskLevelSelVc.levelSelType = JGJTaskLevelSelSeriousType;
                
                taskLevelSelVc.lastIndexPath = self.lastLevelIndexPath;
                
                taskLevelSelVc.dataSource = self.qualityLevelModels;
                
                [self.navigationController pushViewController:taskLevelSelVc animated:YES];
                
            }
            
        }
            
            break;
            
        case 3:{
            
            if (indexPath.row == 0) {
                
                
                
            }else if (indexPath.row == 2) {
                
                JGJTaskPrincipalVc *principalVc = [JGJTaskPrincipalVc new];
                
                principalVc.memberSelType = JGJMemberSelPrincipalType;
                
                //3.3.3添加
                JGJCreatTeamModel *selPrincipalModel = self.prinTimeInfos[2];
                
                JGJSynBillingModel *selMember = [JGJSynBillingModel new];
                
                selMember.real_name = selPrincipalModel.detailTitle;
                
                selMember.uid = selPrincipalModel.detailTitlePid;
                
                principalVc.principalModel = selMember;
                
                principalVc.proListModel = self.proListModel;
                
                principalVc.principalModels = self.principalModels;
                
                principalVc.lastIndexPath = self.lastIndexPath;
                
                [self.navigationController pushViewController:principalVc animated:YES];
                
            }else if (indexPath.row == 3) {
                
                JGJCreatTeamModel *timeModel = self.prinTimeInfos[indexPath.row];
                
                ATDatePicker *datePicker = [[ATDatePicker alloc] initWithDatePickerMode:UIDatePickerModeDate DateFormatter:@"yyyy-MM-dd" datePickerFinishBlock:^(NSString *dateString) {
                    
                    timeModel.detailTitle = dateString;
                    
                    [weakSelf freshIndexSection:indexPath.section row:indexPath.row];
                    
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
            
        }
            
            break;
            
        default:
            break;
    }
    
    
}

#pragma mark - 点击编辑框以后的键盘位置
- (void)CollectionCellTouch{
    
    [self.view endEditing:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
    
}

#pragma mark - JGJCusSwitchMsgCellDelegate
- (void)cusSwitchMsgCell:(JGJCusSwitchMsgCell *)cell switchType:(JGJCusSwitchMsgCellType)switchType {
    
    JGJChatDetailInfoCommonModel *modifyModel = self.prinTimeInfos[0];
    
    JGJCreatTeamModel *memberModel = self.prinTimeInfos[self.prinTimeInfos.count - 1];
    
    modifyModel.isOpen = cell.commonModel.isOpen;
    
    //   去掉整改负责人选项
    if (!modifyModel.isOpen) {
        
        memberModel.detailTitlePid = nil;
        
        self.principalModels = nil;
        
        memberModel.detailTitle = @"";
        
        
    }
    
    self.qualitySafeRequestModel.is_rectification = [NSString stringWithFormat:@"%@", @(cell.commonModel.isOpen)];
    
    [self.tableView reloadData];
    
}

#pragma mark - 提交

- (void)publishBtnClick:(UIButton *)sender {
    
    self.qualitySafeRequestModel.msg_text = self.qualitySafeRequestModel.text;
    
    if ([NSString isEmpty:self.qualitySafeRequestModel.text] && self.imagesArray.count == 0) {
        [TYShowMessage showPlaint:@"问题描述和图片至少需要填一项"];
        [self.view endEditing:YES];
        return;
    }
    
    //2.3.0添加检查项id开始
    self.qualitySafeRequestModel.insp_id = self.listModel.insp_id;
    
    self.qualitySafeRequestModel.pu_inpsid = self.listModel.pu_inpsid;
    //2.3.0结束
    
    self.qualitySafeRequestModel.msg_type = self.commonModel.msg_type;
    
    JGJCreatTeamModel *localModel = self.locaLevelInfos[0];
    
    if ([localModel.detailTitle isEqualToString:@"无"] || [NSString isEmpty:localModel.detailTitle]) {
        
        self.qualitySafeRequestModel.location = nil;
        
        self.qualitySafeRequestModel.location_id = nil;
        
    }else {
        
        self.qualitySafeRequestModel.location = localModel.detailTitle;
        
        self.qualitySafeRequestModel.location_id = localModel.detailTitlePid;
    }
    
    JGJCreatTeamModel *levelModel = self.locaLevelInfos[1];
    
    self.qualitySafeRequestModel.severity = levelModel.detailTitlePid;
    
    JGJCreatTeamModel *memeberModel = self.prinTimeInfos[2];
    
    JGJChatDetailInfoCommonModel *modifyModel = self.prinTimeInfos[0];
    
    if ([self.qualitySafeRequestModel.is_rectification isEqualToString:@"1"] && [NSString isEmpty:memeberModel.detailTitlePid]) {
        
        [TYShowMessage showError:@"请选择整改负责人"];
        
        [self.view endEditing:YES];
        
        return;
        
    }
    
    self.qualitySafeRequestModel.principal_uid = memeberModel.detailTitlePid;
    
    JGJCreatTeamModel *timeModel = self.prinTimeInfos[3];
    
    NSString *finishTime = @"";
    
    if ([timeModel.detailTitle containsString:@"-"]) {
        
        finishTime = [timeModel.detailTitle stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    
    self.qualitySafeRequestModel.finish_time = finishTime;
    
    //    JGJChatDetailInfoCommonModel *modifyModel = self.prinTimeInfos[0];
    
    self.qualitySafeRequestModel.is_rectification = [NSString stringWithFormat:@"%@", @(modifyModel.isOpen)];
    JGJChatRootVc *chatRootVc = nil;
    
    //检查记录带过来的值
    for (UIViewController *curVc in self.navigationController.viewControllers) {
        
        if ([curVc isKindOfClass:NSClassFromString(@"JGJChatListQualityVc")]) {
            
            chatRootVc = (JGJChatRootVc *)curVc;
            
            break;
        }
        
    }
    
    self.qualitySafeRequestModel.msg_type = self.commonModel.msg_type;
    
    self.qualitySafeRequestModel.local_id = [JGJChatMsgDBManger localID];
    
    NSDictionary *parameters = [self.qualitySafeRequestModel mj_keyValues];
    
    CustomAlertView *alertView = [CustomAlertView showWithMessage:nil leftButtonTitle:nil midButtonTitle:nil rightButtonTitle:nil];
    
    [alertView showProgressImageView:@"正在发布..."];
    
    [JLGHttpRequest_AFN newUploadImagesWithApi:@"group/pub-quality-or-safe" parameters:parameters imagearray:self.imagesArray otherDataArray:nil dataNameArray:nil success:^(id responseObject) {
        
        [self pubSuccessWithResponse:responseObject];
        
        [alertView dismissWithBlcok:nil];
        
        [TYShowMessage showSuccess:@"发布成功"];
        
    } failure:^(NSError *error) {
        
        [alertView dismissWithBlcok:nil];
        
        [TYShowMessage showPlaint:@"发布失败"];
        
    }];
    
}

- (void)pubSuccessWithResponse:(NSDictionary *)response {
    
    //    TYLog(@"插入数据库==========%@", response);
    
    
    //是发质量安全存数据库
    
    NSString *msg_id = [NSString stringWithFormat:@"%@", response[@"msg_id"]];
    
    NSString *msg_type = [NSString stringWithFormat:@"%@", response[@"msg_type"]];
    
    if (![NSString isEmpty:msg_id] && ![NSString isEmpty:msg_type]) {
        
        JGJChatMsgListModel *msgModel = [JGJChatMsgListModel mj_objectWithKeyValues:response];
        
        msgModel.local_id = [JGJChatMsgDBManger localID];
        
        //读状态
        [JGJSocketRequest receiveMySendMsgModel:msgModel isReaded:YES];
        
        
        [JGJSocketRequest receiveMySendMsgWithMsgs:@[msgModel] action:@"sendMessage"];
        
        //取消读状态
        [JGJSocketRequest receiveMySendMsgModel:msgModel isReaded:NO];
        
    }
    
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

- (NSMutableArray *)locaLevelInfos {
    
    if (!_locaLevelInfos) {
        
        _locaLevelInfos = [NSMutableArray new];
        
        NSArray *titles = @[@"隐患部位", @"隐患级别"];
        
        NSArray *detailTitles = @[@"", @"一般"];
        
        for (int indx = 0; indx < titles.count; indx ++) {
            
            JGJCreatTeamModel *desModel = [[JGJCreatTeamModel alloc] init];
            
            desModel.title = titles[indx];
            
            desModel.detailTitle = detailTitles[indx];
            
            desModel.detailTitlePid = indx == 1 ? @"1" : nil;
            
            [_locaLevelInfos addObject:desModel];
        }
    }
    
    return _locaLevelInfos;
    
}

- (NSMutableArray *)prinTimeInfos {
    
    if (!_prinTimeInfos) {
        
        _prinTimeInfos = [NSMutableArray new];
        
        NSArray *titles = @[@"需要整改", @"", @"整改负责人", @"整改完成期限",@"整改措施", @"请输入整改措施"];
        
        NSArray *detailTitles = @[@"", @"", @"", @"", @"", @""];
        
        for (int indx = 0; indx < titles.count; indx ++) {
            
            if (indx == 0) {
                
                JGJChatDetailInfoCommonModel *modifyModel = [JGJChatDetailInfoCommonModel new];
                
                modifyModel.title = titles[indx];
                
                modifyModel.isOpen = YES;
                
                self.qualitySafeRequestModel.is_rectification = [NSString stringWithFormat:@"%@", @(modifyModel.isOpen)];
                
                [_prinTimeInfos addObject:modifyModel];
                
            }else {
                
                JGJCreatTeamModel *desModel = [[JGJCreatTeamModel alloc] init];
                
                desModel.title = titles[indx];
                
                desModel.detailTitle = detailTitles[indx];
                
                [_prinTimeInfos addObject:desModel];
            }
            
        }
        
    }
    
    return _prinTimeInfos;
    
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        UITableViewController* tvc=[[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
        
        [self addChildViewController:tvc];
        
        [tvc.view setFrame:self.view.frame];
        
        _tableView = tvc.tableView;
        
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
        [_publishButton setTitle:@"提交" forState:UIControlStateNormal];
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

- (JGJQualitySafeRequestModel *)qualitySafeRequestModel {
    
    if (!_qualitySafeRequestModel) {
        
        _qualitySafeRequestModel = [JGJQualitySafeRequestModel new];
        
        _qualitySafeRequestModel.class_type = self.proListModel.class_type?:@"";
        
        _qualitySafeRequestModel.group_id = self.proListModel.group_id?:@"";
        
    }
    
    return _qualitySafeRequestModel;
}

@end
