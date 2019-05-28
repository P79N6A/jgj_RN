//
//  JGJQualityDetailVc.m
//  mix
//
//  Created by yj on 2017/6/8.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJQualityDetailVc.h"

#import "JGJQualityDetailHeadCell.h"

#import "JGJQualityDetailContentCell.h"

#import "JGJQualityLocalLevelCell.h"

#import "NSString+Extend.h"

#import "JGJQualityModifyConfirmVc.h"

#import "JGJQualityReviewResultVc.h"

#import "JGJCreatTeamCell.h"

#import "ATDatePicker.h"

#import "NSDate+Extend.h"

#import "JGJTaskPrincipalVc.h"

#import "JGJDetailThumbnailCell.h"

#import "JGJNineSquareView.h"

#import "JGJQualityDetailReplyCell.h"

#import "UIView+Extend.h"

#import "JGJCusActiveSheetView.h"

#import "HJPhotoBrowser.h"

#import "JGJCustomPopView.h"

#import "JGJQualityDetailCommonCell.h"

#import "JGJPerInfoVc.h"

#import "JGJCustomProInfoAlertVIew.h"

#import "JGJChatListQualityVc.h"

#import "CFRefreshTableView.h"

#import "JGJImage.h"

#import "JGJTabBarViewController.h"

#import "JGJQuaSafeTool.h"

#import "JGJTabBarViewController.h"

#import "JGJCheckPhotoTool.h"

#import "JGJChatInputView.h"

#import "IQKeyboardManager.h"

#import "JGJQuaSafeCommonSysMsgCell.h"

#import "JGJQuaSafeModifyMeaVc.h"

#import "JGJCusButtonSheetView.h"

//#define PageSize 50

typedef void(^HandleModifyInfoBlock)(id);

@interface JGJQualityDetailVc () <

UITableViewDelegate,

UITableViewDataSource,

JGJTaskPrincipalVcDelegate,

JGJDetailThumbnailCellDelegate,

JGJQualityDetailReplyCellDelegate,

JGJQualityDetailCommonCellDelegate,

JGJQualityDetailHeadCellDelegate,

JGJChatInputViewDelegate

>

@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *localLevelInfos;

@property (nonatomic, strong) JGJQualityDetailModel *qualityDetailModel;

//存放负责人和完成期限
@property (nonatomic, strong) NSMutableArray *principalInfos;

@property (nonatomic, strong) JGJQualityReplyRequestModel *requstModel;

@property (nonatomic, strong) JGJQualityReplyRequestModel *modifyRequstModel;

@property (nonatomic, strong) NSArray *imageUrls;

//整改负责人
@property (nonatomic, strong) JGJSynBillingModel *principalModel;

@property (nonatomic, copy) HandleModifyInfoBlock handleModifyInfoBlock;

//回复指定的信息
@property (nonatomic, strong) JGJQualityDetailReplayListModel *replyListModel;

//@property (strong, nonatomic) dispatch_semaphore_t semaphore;

//去掉分页效果较差
//@property (nonatomic, assign) NSInteger pg;

@property (nonatomic, strong) NSMutableArray *replyList;

@property (nonatomic, strong) JGJChatInputView *chatInputView;

//输入框初始高度
@property (nonatomic, assign) CGFloat chatInputViewH;

@property (nonatomic, strong) JGJQuaSafeCommonSysMsgCellModel *sysMsgCellModel;

//保存详情模型处理同一个内容高度显示问题
@property (nonatomic, strong) NSMutableArray *qualityDetailModels;

//整改措施标题
@property (nonatomic, strong) JGJCreatTeamModel *modifyInfoModel;
@end

@implementation JGJQualityDetailVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"问题详情";
    [self initialSubView];
    
    self.maxImageCount = 9;
    
    [TYNotificationCenter addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [TYNotificationCenter addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    [self initSheetImagePicker];
        
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemPressed:)];
    
    [self setBackButton];
    
    
    JGJQuaSafeToolReplyModel *pubModel = [JGJQuaSafeToolReplyModel new];
    
    pubModel.group_id = self.proListModel.group_id;
    
    pubModel.class_type = self.proListModel.class_type;
    
    pubModel.unique_id = [NSString stringWithFormat:@"%@%@",self.listModel.msg_id, self.commonModel.msg_type];
    
    JGJQuaSafeToolReplyModel *replyModel = [JGJQuaSafeTool replyModel:pubModel];
    
    if (![NSString isEmpty:replyModel.replyText]) {
        
        self.chatInputView.textView.text = replyModel.replyText;
        
        self.requstModel.reply_text = replyModel.replyText;
    }
    
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNetData)];
    
    //写在这里是因为发图片的时候，选择完也会走ViewWill
    [TYLoadingHub showLoadingWithMessage:nil];
    
    self.tableView.estimatedRowHeight = 0;
    
    self.tableView.estimatedSectionHeaderHeight = 0;
    
    self.tableView.estimatedSectionFooterHeight = 0;
    
    [JGJComTool showCloseProImageViewWithTargetView:self.view classtype:self.proListModel.class_type isClose:self.proListModel.isClosedTeamVc];
}


-(void)viewWillDisappear:(BOOL)animated{
    
    [self.chatInputView.textView resignFirstResponder];
    
    [IQKeyboardManager sharedManager].enable = YES;
    
}



- (void)loadReplyList {
    
    NSDictionary *parameters;
    parameters = @{
                   @"msg_id" : self.qualityDetailModel.msg_id?:@"",
                  @"msg_type" : self.qualityDetailModel.msg_type?:@""
                   };
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/quality/getReplyMessageList" parameters:parameters success:^(id responseObject) {
        
        self.replyList = [JGJQualityDetailReplayListModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        //        dispatch_semaphore_signal(self.semaphore);
        
        [self.tableView reloadData];
        
        [self.tableView.mj_header endRefreshing];
        
        [TYLoadingHub hideLoadingView];
        
    } failure:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
        
        [TYLoadingHub hideLoadingView];
        
    }];
    
}

#pragma mark - 发起所有请求详情和回复列表
- (void)postAllRequest {
    
    //    //    /创建信号量/
    //    self.semaphore = dispatch_semaphore_create(0);
    //    //    /创建全局并行/
    //    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //
    //    dispatch_group_t group = dispatch_group_create();
    //
    //    dispatch_group_async(group, queue, ^{
    //        NSLog(@"处理事件A");
    //
    //        [self loadNetData];
    //    });
    //
    //    dispatch_group_async(group, queue, ^{
    //        NSLog(@"处理事件B");
    //
    //        [self loadReplyList];
    //    });
    //
    //    dispatch_group_notify(group, queue, ^{
    //        //        /两个请求对应四次信号等待/
    //        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    //        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    //        NSLog(@"处理事件C");
    //
    //        [TYLoadingHub  hideLoadingView];
    //    });
    
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
    
    pubModel.replyText = self.requstModel.reply_text;
    
    pubModel.class_type = self.proListModel.class_type;
    
    pubModel.unique_id = [NSString stringWithFormat:@"%@%@",self.listModel.msg_id, self.qualityDetailModel.msg_type];
    
    [JGJQuaSafeTool addCollectReplyModel:pubModel];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (self.imagesArray.count == 0 || !self.imagesArray) {

        [self loadNetData];
    }
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    [IQKeyboardManager sharedManager].enable = NO;
    
    self.navigationController.navigationBarHidden = NO;
    
    //    [self postAllRequest];
}

#pragma amrk - 删除缺省页显示
- (void)showDefault:(NSString *)erroInfo {
    
    CFRefreshStatusView *statusView = [[CFRefreshStatusView alloc] initWithImage:PNGIMAGE(@"NoDataDefault_NoManagePro") withTips:erroInfo];
    
    statusView.frame = self.view.bounds;
    
    [self.view addSubview:statusView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger count = 0;
    
    switch (section) {
        case 0:
            count = 11;
            break;
            
        case 1:
            //            count = self.qualityDetailModel.reply_list.count;
            count = self.replyList.count;
            break;
            
        default:
            break;
    }
    
    return count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [UITableViewCell getNilViewCell:tableView indexPath:indexPath];
    __weak typeof(self) weakSelf = self;
    
    if (indexPath.section == 0) {
        
        switch (indexPath.row) {
            case 0:{
                
                JGJQualityDetailHeadCell *headCell = [JGJQualityDetailHeadCell cellWithTableView:tableView];
                
                headCell.delegate = self;
                
                headCell.qualityDetailHeadStatusBlock = ^(JGJQualityDetailHeadCell *headCell) {
                    
                    [weakSelf handleHeadStatusButtonAction:headCell.statusButtonType];
                };
                
                headCell.qualityDetailModel = self.qualityDetailModel;
                
                cell = headCell;
            }
                
                break;
            case 1:{
                
                JGJQualityDetailContentCell *contentCell = [JGJQualityDetailContentCell cellWithTableView:tableView];
                
                contentCell.qualityDetailModel = self.qualityDetailModel;
                
                contentCell.lineView.hidden = YES;
                
                cell = contentCell;
            }
                
                break;
            case 2:{
                
                JGJDetailThumbnailCell *thumbnailCell = [JGJDetailThumbnailCell cellWithTableView:tableView];
                
                thumbnailCell.delegate = self;
                
                thumbnailCell.qualityDetailModel = self.qualityDetailModel;
                
                cell = thumbnailCell;
            }
                
                break;
            case 3:
            case 4:
            case 5:{
                
                JGJQualityLocalLevelCell *localLevelCell = [JGJQualityLocalLevelCell cellWithTableView:tableView];
                
                NSString *local = [NSString stringWithFormat:@"隐患部位：%@", self.qualityDetailModel.location?:@""];
                
                NSString *level = [NSString stringWithFormat:@"隐患级别：%@", self.qualityDetailModel.severityDes?:@""];
                
                NSString *fromGroup = [NSString stringWithFormat:@"来自：%@", self.qualityDetailModel.from_group_name?:@""];
                NSArray *desInfos = @[local, level, fromGroup];
                
                JGJQualityLocalModel *localInfoModel = self.localLevelInfos[indexPath.row - 3];
                
                localInfoModel.isHiddenArrowRightImageView = YES;
                
                NSArray *titleChangeStrs = @[self.qualityDetailModel.location?:@"", self.qualityDetailModel.severityDes?:@"", self.qualityDetailModel.from_group_name?:@""];
                
                localInfoModel.changeColorStr = titleChangeStrs[indexPath.row - 3];
                
                localInfoModel.desTitle = desInfos[indexPath.row - 3];
                
                localInfoModel.changeColor = AppFont666666Color;
                
                if (self.qualityDetailModel.severity.integerValue > 1 && indexPath.row == 4) {
                    
                    localInfoModel.changeColor = AppFontd7252cColor;
                    
                    localInfoModel.changeColorStr = self.qualityDetailModel.severityDes;
                }
                
                if (indexPath.row == 5) {
                    
                    localInfoModel.isHiddenArrowRightImageView = NO;
                    
                    localInfoModel.changeColor = AppFontd7252cColor;
                    
                    localInfoModel.changeColorStr = self.qualityDetailModel.from_group_name?:@"";
                }
                
                localLevelCell.localInfoModel = localInfoModel;
                
                localLevelCell.lineView.hidden = YES;
                
                cell = localLevelCell;
            }
                
                break;
                
            case 6:{
                
                JGJQualityDetailContentCell *paddingCell = [JGJQualityDetailContentCell cellWithTableView:tableView];
                paddingCell.lineView.hidden = NO;
                cell = paddingCell;
            }
                
                break;
                
            case 7:{ //整改措施
                
                JGJQualityDetailCommonCell *modifyCell = [JGJQualityDetailCommonCell cellWithTableView:tableView];
                
                if ([self.qualityDetailModel.statu isEqualToString:@"3"] || !self.qualityDetailModel.isAuthorModify)  {
                    
                    self.modifyInfoModel.detailTitle = @"";
                    
                    self.modifyInfoModel.isHiddenArrow = YES;
                    
                }else {
                    
                    self.modifyInfoModel.detailTitle = @"修改";
                    
                    self.modifyInfoModel.isHiddenArrow = NO;
                }
                
                modifyCell.commonModel = self.modifyInfoModel;
                
                JGJQualityDetailModel *modifyCotentModel = self.qualityDetailModels.lastObject;
                
                modifyCell.lineView.hidden = ![NSString isEmpty:modifyCotentModel.msg_steps];
                
                cell = modifyCell;
                
            }
                
                break;
                
            case 8:{ //整改措施内容
                
                JGJQualityDetailContentCell *modifyContentCell = [JGJQualityDetailContentCell cellWithTableView:tableView];
                
                JGJQualityDetailModel *modifyCotentModel = self.qualityDetailModels.lastObject;
                
                modifyCotentModel.msg_text = modifyCotentModel.msg_steps;
                
                modifyContentCell.qualityDetailModel = modifyCotentModel;
                
                cell = modifyContentCell;
                
            }
                
                break;
                
            case 9:{
                
                JGJQualityDetailCommonCell *memberCell = [JGJQualityDetailCommonCell cellWithTableView:tableView];
                
                memberCell.delegate = self;
                
                JGJCreatTeamModel *prinModel =  self.principalInfos[0];
                
                prinModel.title = [NSString stringWithFormat:@"整改负责人：%@",self.qualityDetailModel.principal_name];
                
                prinModel.changeStr = self.qualityDetailModel.principal_name;
                
                prinModel.changeColor = AppFont4990e2Color;
                
                if ([self.qualityDetailModel.statu isEqualToString:@"3"] || !self.qualityDetailModel.isAuthorModify)  {
                    
                    prinModel.detailTitle = @"";
                    
                    prinModel.title = [NSString isEmpty:self.qualityDetailModel.principal_name] ? @"" : prinModel.title;
                    
                    prinModel.isHiddenArrow = YES;
                }else {
                    
                    prinModel.detailTitle = @"修改";
                    
                    prinModel.isHiddenArrow = NO;
                }
                
                memberCell.commonModel = prinModel;
                
                cell = memberCell;
            }
                
                break;
                
            case 10:{
                
                JGJQualityDetailCommonCell *timeCell = [JGJQualityDetailCommonCell cellWithTableView:tableView];
                
                JGJCreatTeamModel *timeModel =  self.principalInfos[1];
                
                timeModel.title = [NSString stringWithFormat:@"整改完成期限: %@",self.qualityDetailModel.finish_time];
                
                if ([self.qualityDetailModel.statu isEqualToString:@"3"] || !self.qualityDetailModel.isAuthorModify) {
                    
                    timeModel.detailTitle = @"";
                    
                    timeModel.isHiddenArrow = YES;
                    
                    timeModel.title = [NSString isEmpty:self.qualityDetailModel.finish_time] ? @"" : timeModel.title;
                }else {
                    
                    timeModel.detailTitle = @"修改";
                    timeModel.isHiddenArrow = NO;
                }
                
                timeModel.changeStr = self.qualityDetailModel.finish_time;
                
                //                if ([self.qualityDetailModel.finish_time_status isEqualToString:@"1"]) {
                //
                //                    timeModel.changeColor = AppFontd7252cColor;
                //
                //                }else if ([self.qualityDetailModel.finish_time_status isEqualToString:@"2"]) {
                //
                //                    timeModel.changeColor = AppFontF9A00FColor;
                //                }else {
                //
                //                    timeModel.changeColor = AppFont999999Color;
                //                }
                
                timeModel.changeColor = AppFont333333Color;
                
                timeCell.lineView.hidden = YES;
                
                timeCell.commonModel = timeModel;
                
                cell = timeCell;
            }
                
                break;
            default:
                break;
        }
        
    }else if (indexPath.section == 1) {
        
        JGJQualityDetailReplayListModel *listModel = self.replyList[indexPath.row];
        
        if (listModel.is_system_reply) {
            
            JGJQuaSafeCommonSysMsgCell *sysReplyCell = [JGJQuaSafeCommonSysMsgCell cellWithTableView:tableView];
            
            self.sysMsgCellModel.title = listModel.user_info.real_name;
            
            self.sysMsgCellModel.subTitle = listModel.create_time;
            
            self.sysMsgCellModel.changeColorStr = listModel.reply_status_text;
            
            sysReplyCell.commonSysMsgCellModel = self.sysMsgCellModel;
            
            sysReplyCell.lineView.hidden = self.replyList.count - 1 == indexPath.row;
            
            cell = sysReplyCell;
            
        }else {
            
            JGJQualityDetailReplyCell *replyCell = [JGJQualityDetailReplyCell cellWithTableView:tableView];
            
            replyCell.delegate = self;
            
            //        replyCell.listModel = self.qualityDetailModel.reply_list[indexPath.row];
            
            replyCell.lineView.hidden = self.replyList.count - 1 == indexPath.row;
            
            replyCell.listModel = self.replyList[indexPath.row];
            
            cell = replyCell;
        }
        
    }
    
    
    return cell;
}

#pragma mark - JGJDetailThumbnailCellDelegate

- (void)detailThumbnailCell:(JGJDetailThumbnailCell *)cell imageViews:(NSArray *)imageViews didSelectedIndex:(NSInteger)index {
    
    [self.view endEditing:YES];
    
    [JGJCheckPhotoTool browsePhotoImageView:cell.qualityDetailModel.msg_src selImageViews:imageViews didSelPhotoIndex:index];
    
}

- (void)qualityDetailReplyCell:(JGJQualityDetailReplyCell *)cell imageViews:(NSArray *)imageViews didSelectedIndex:(NSInteger)index {
    
    [self.view endEditing:YES];
    
    [JGJCheckPhotoTool browsePhotoImageView:cell.listModel.msg_src selImageViews:imageViews didSelPhotoIndex:index];
    
    
}

- (void)qualityDetailReplyCell:(JGJQualityDetailReplyCell *)cell didSelectedUserInfoModel:(JGJQualityDetailReplayListModel *)userInfoModel {
    
    [self checkPerInfoModel:userInfoModel];
    
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = 50.0;
    
    if (indexPath.section == 0) {
        
        switch (indexPath.row) {
            case 0:
                height = 60.0;
                break;
                
            case 1:{
                
                height = self.qualityDetailModel.cellHeight;
            }
                
                break;
                
            case 2:{
                if (self.qualityDetailModel.msg_src.count == 1) {
                    
                    height = self.qualityDetailModel.imageH + 10;
                    
                }else {
                    
                    height = [JGJNineSquareView nineSquareViewHeight:self.qualityDetailModel.msg_src headViewWH:80.0 headViewMargin:5.0] + 10;
                    
                }
            }
                
                break;
                
            case 3:
            case 4:
            case 5:
                height = 33.0;
                break;
                //分割使用
            case 6:
                height = 15.0;
                break;
                
            case 7:{
                
                height = 43;
            }
                
                break;
                
            case 8:{
                
                JGJQualityDetailModel *pubCotentModel = self.qualityDetailModels.lastObject;
                
                height = [NSString isEmpty:pubCotentModel.msg_steps] ? CGFLOAT_MIN : pubCotentModel.cellHeight;
            }
                
                break;
                
            case 9:{
                
                height = 50.0;
                
                if ([self.qualityDetailModel.statu isEqualToString:@"3"] || !self.qualityDetailModel.isAuthorModify) {
                    
                    height = [NSString isEmpty:self.qualityDetailModel.principal_name] ? CGFLOAT_MIN : 50;
                    
                }
            }
                
                break;
                
            case 10:{
                
                height = 50.0;
                
                if ([self.qualityDetailModel.statu isEqualToString:@"3"] || !self.qualityDetailModel.isAuthorModify) {
                    
                    height = [NSString isEmpty:self.qualityDetailModel.finish_time] ? CGFLOAT_MIN : 50;
                    
                }
            }
                break;
            default:
                break;
        }
        
    }else if (indexPath.section == 1) {
        
        JGJQualityDetailReplayListModel *listModel = self.replyList[indexPath.row];
        
        CGFloat sysInfoHeight = 45;
        
        if (listModel.is_system_reply) {
            
            NSString *sysInfo = [NSString stringWithFormat:@"%@\n%@", listModel.user_info.real_name,listModel.reply_status_text?:@""];
            
            sysInfoHeight = [NSString stringWithContentWidth:TYGetUIScreenWidth - 87 content:sysInfo font:AppFont30Size lineSpace:1] + 11;
            
            if (sysInfoHeight < 45.0) {
                
                sysInfoHeight = 45.0;
            }
        }
        
        height = listModel.is_system_reply ? sysInfoHeight : listModel.cellHeight;
    }
    
    return height;
    
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 200;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self closeGroupShowMessage]) {
        
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    
    //切换项目
    if (indexPath.row == 5 && indexPath.section == 0) {
        
        JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
        desModel.popDetail = @"你确定要切换到该项目首页吗？";
        desModel.popTextAlignment = NSTextAlignmentCenter;
        
        __weak typeof(self) weakSelf = self;
        
        JGJCustomPopView *alertView = [JGJCustomPopView showWithMessage:desModel];
        
        alertView.onOkBlock = ^{
            
            [weakSelf setIndexProListModel:self.proListModel];;
            
        };
    }
    
    if (indexPath.section == 0) {
        
        if ([self.qualityDetailModel.statu isEqualToString:@"3"] || !self.qualityDetailModel.isAuthorModify) {
            
            return;
        }
        
        switch (indexPath.row) {
                
                
            case 7:{
                
                JGJQuaSafeModifyMeaVc *modifyMeaVc = [JGJQuaSafeModifyMeaVc new];
                
                modifyMeaVc.modifyRequstModel = self.modifyRequstModel;
                
                modifyMeaVc.qualityDetailModel = self.qualityDetailModel;
                
                [self.navigationController pushViewController:modifyMeaVc animated:YES];
            }
                
                break;
                
                //整改负责人
            case 9:{
                
                JGJTaskPrincipalVc *principalVc = [JGJTaskPrincipalVc new];
                
                principalVc.delegate = self;
                
                principalVc.proListModel = self.proListModel;
                
                principalVc.memberSelType = JGJQualityDetailModifyMemeberType;
                
                principalVc.principalModel = self.principalModel;
                
                principalVc.principalModels = self.principalModels;
                
                principalVc.lastIndexPath = self.lastIndexPath;
                
                [self.navigationController pushViewController:principalVc animated:YES];
            }
                
                break;
                
                //整改完成期限
            case 10:{
                
                JGJCreatTeamModel *timeModel = self.principalInfos[1];
                
                ATDatePicker *datePicker = [[ATDatePicker alloc] initWithDatePickerMode:UIDatePickerModeDate DateFormatter:@"yyyy-MM-dd" datePickerFinishBlock:^(NSString *dateString) {
                    
                    weakSelf.qualityDetailModel.finish_time = dateString;
                    
                    //修改的时间
                    weakSelf.modifyRequstModel.finish_time = dateString;
                    
                    weakSelf.modifyRequstModel.principal_uid = nil;
                    
                    [weakSelf modifyQaulitySafeInfo];
                    
                    weakSelf.handleModifyInfoBlock = ^(id response) {
                        
                        [weakSelf loadNetData];
                    };
                    
                    [weakSelf freshQualityList];
                    
                    [weakSelf freshIndexSection:0 row:8];
                    
                    TYLog(@"%@", dateString);
                }];
                
                if (![NSString isEmpty:timeModel.detailTitle] && ![timeModel.detailTitle isEqualToString:@"修改"]) {
                    
                    datePicker.date = [NSDate dateFromString:timeModel.detailTitle withDateFormat:@"yyyy-MM-dd"];
                }
                
                [self.view endEditing:YES];
                [datePicker show];
            }
                
                break;
                
            default:
                break;
        }
        
    }else if (indexPath.section == 1) {
        
        JGJQualityDetailReplayListModel *listModel = self.replyList[indexPath.row];
        
        //删除弹框
        if (listModel.operate_delete) {
            
            [self sheetViewWithListModel:listModel];
            
        }else {
            
            self.replyListModel = listModel;
            
            self.chatInputView.textView.placeholder = [NSString stringWithFormat:@"回复%@：" ,listModel.user_info.real_name];
            
            [self.chatInputView.textView becomeFirstResponder];
            
        }
        
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *lineView = [UIView new];
    
    lineView.backgroundColor = AppFontf1f1f1Color;
    
    lineView.frame = CGRectMake(0, 0, TYGetUIScreenWidth, 10);
    
    return lineView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    CGFloat height = CGFLOAT_MIN;
    
    if (section == 1) {
        
        height = 10;
    }
    
    return height;
    
}

#pragma mark - 复查结果和整改完成
- (void)handleHeadStatusButtonAction:(JGJQualityDetailStatusButtonType) statusButtonType {
    
    if ([self closeGroupShowMessage]) {
        
        return;
    }
    
    switch (statusButtonType) {
            
        case JGJQualityDetailReviewResultStatusButtonType:{
            
            JGJQualityReviewResultVc *reviewResultVc = [JGJQualityReviewResultVc new];
            
            reviewResultVc.qualityDetailModel = self.qualityDetailModel;
            
            reviewResultVc.listModel = self.listModel;
            
            [self.navigationController pushViewController:reviewResultVc animated:YES];
        }
            
            break;
            
        case JGJQualityDetailModifyCompleteStatusButtonType:{
            
            JGJQualityModifyConfirmVc *modifyConfirmVc = [JGJQualityModifyConfirmVc new];
            
            modifyConfirmVc.qualityDetailModel = self.qualityDetailModel;
            
            modifyConfirmVc.listModel = self.listModel;
            
            [self.navigationController pushViewController:modifyConfirmVc animated:YES];
            
        }
            
            break;
        default:
            break;
    }
    
}

#pragma mark - JGJQualityDetailHeadCellDelegate

- (void)qualityDetailHeadCell:(JGJQualityDetailHeadCell *)cell didSelectedHeadButtonType:(JGJQualityDetailStatusButtonType)buttonType {
    
    JGJQualityDetailReplayListModel *qualityPublshModel = [JGJQualityDetailReplayListModel new];
    
    JGJSynBillingModel *pubMemberModel = [JGJSynBillingModel new];
    
    pubMemberModel.uid = self.qualityDetailModel.uid;
    
    pubMemberModel.real_name = self.qualityDetailModel.real_name;
    
    pubMemberModel.head_pic =  self.qualityDetailModel.head_pic;
    
    qualityPublshModel.user_info = pubMemberModel;
    
    [self checkPerInfoModel:qualityPublshModel];
    
}

#pragma mark - JGJTaskPrincipalVcDelegate
- (void)taskPrincipalVc:(JGJTaskPrincipalVc *)principalVc didSelelctedMemberModel:(JGJSynBillingModel *)memberModel {
    
    
    self.qualityDetailModel.principal_name = memberModel.real_name;
    
    self.qualityDetailModel.principal_uid = memberModel.uid;
    
    self.principalModels = principalVc.cacheSortContactsModels;
    
    self.lastIndexPath = principalVc.lastIndexPath;
    
    //修改的负责人id
    self.modifyRequstModel.principal_uid = memberModel.uid;
    
    self.modifyRequstModel.finish_time = nil;
    
    [self modifyQaulitySafeInfo];
    
    TYWeakSelf(self);
    
    self.handleModifyInfoBlock = ^(id responseObject) {
      
//        [weakself.tableView reloadData];
        
        [weakself freshIndexSection:0 row:7];
        
        [principalVc.navigationController popViewControllerAnimated:YES];
    };
    
}

- (void)modifyQaulitySafeInfo{
    
    self.modifyRequstModel.msg_type = self.qualityDetailModel.msg_type;
    
//    self.modifyRequstModel.msg_steps = self.qualityDetailModel.msg_steps;
    
    NSDictionary *parameters = [self.modifyRequstModel mj_keyValues];
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/quality/modifyQaulitySafe" parameters:parameters success:^(id responseObject) {
        
        //清除完成时间
        self.modifyRequstModel.finish_time = nil;
        
        
        //清除整改措施
        self.modifyRequstModel.msg_steps = nil;
        
        //整改负责人
        self.modifyRequstModel.principal_uid = nil;
        
        if (self.handleModifyInfoBlock) {
            
            self.handleModifyInfoBlock(responseObject);
        }
        
        [self modifyDetailInfoFreshList];
        
        [TYLoadingHub hideLoadingView];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
    
}

#pragma mark - 是否修改详情信息,刷新列表
- (void)modifyDetailInfoFreshList {
    
    [self.navigationController.viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(__kindof JGJChatListQualityVc * _Nonnull quaListVc, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([quaListVc isKindOfClass:NSClassFromString(@"JGJChatListQualityVc")]) {
            
            quaListVc.isFreshTabView = YES;
            
            *stop = YES;
        }
    }];
}

#pragma mark - JGJQualityDetailCommonCellDelegate 点击整改负责人
- (void)qualityDetailCommonCell:(JGJQualityDetailCommonCell *)cell {
    
    if ([self closeGroupShowMessage]) {
        
        return;
    }
    
    JGJQualityDetailReplayListModel *userInfoModel = [JGJQualityDetailReplayListModel new];
    
    JGJSynBillingModel *userInfo = [JGJSynBillingModel new];
    
    userInfo.uid = self.qualityDetailModel.principal_uid;
    
    userInfo.real_name = self.qualityDetailModel.principal_name;
    
    userInfoModel.user_info = userInfo;
    
    [self checkPerInfoModel:userInfoModel];
}

- (void)freshIndexSection:(NSInteger)section row:(NSInteger)row {
    
    [self.tableView beginUpdates];
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:section]] withRowAnimation:UITableViewRowAnimationNone];
    
    [self.tableView endUpdates];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    if ([self.chatInputView.textView isFirstResponder]) {
        
        self.chatInputView.isDefaultChatInputViewType = YES;
    }
    
    self.chatInputView.switchingKeybaord = NO;
    
    [self keyboardHidden:nil];
    
    [self.view endEditing:YES];
    
}

- (void)loadNetData {
    
    NSDictionary *parameters;
    if (self.isWorkListCommonIn) {
        
        parameters = @{
                       @"msg_id" : self.listModel.msg_id?:@"",
                       @"bill_id" : self.listModel.bill_id?:@"",
                       @"msg_type" : self.listModel.msg_type?:@""
                       };
        
    }else {
        
        parameters = @{@"msg_id" : self.listModel.msg_id?:@"",
                       @"msg_type" : self.listModel.msg_type?:@""
                       };
    }
    
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/quality/getQualitySafeInfo" parameters:parameters success:^(id responseObject) {
        
        self.qualityDetailModel = [JGJQualityDetailModel mj_objectWithKeyValues:responseObject];
        
        [TYLoadingHub hideLoadingView];
        
        
        [self loadReplyList];
        
    } failure:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
        
        [TYLoadingHub hideLoadingView];
        
        NSDictionary *errorDic = (NSDictionary *)error;
        
        if ([errorDic isKindOfClass:[NSDictionary class]]) {
            
            NSInteger code = [errorDic[@"errno"] integerValue];
            [TYShowMessage showError:errorDic[@"errmsg"]];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
    }];
    
}

- (void)setQualityDetailModel:(JGJQualityDetailModel *)qualityDetailModel {
    
    _qualityDetailModel = qualityDetailModel;
    
    NSString *commitUid = [TYUserDefaults objectForKey:JLGUserUid];
    
    //不是问题提交者不显示rightBarButtonItem
    if (![commitUid isEqualToString:self.qualityDetailModel.uid]) {
        
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    if (_qualityDetailModel.msg_src.count == 1) {
        
        [self getSingleImageSizeWithUrl:qualityDetailModel.msg_src.firstObject];
    }
    
    self.tableView.hidden = NO;
    
    [self.tableView reloadData];
    
    //获取当前整改负责人
    self.principalModel.uid = self.qualityDetailModel.principal_uid;
    
    self.principalModel.real_name = self.qualityDetailModel.principal_name;
    
    //发布内容
    JGJQualityDetailModel *pubCotentModel = self.qualityDetailModels[self.qualityDetailModels.count-2];
    
    pubCotentModel = _qualityDetailModel;
    
    //整改措施
    JGJQualityDetailModel *modifyCotentModel = self.qualityDetailModels[self.qualityDetailModels.count-1];

    modifyCotentModel.msg_steps = _qualityDetailModel.msg_steps;
}

-(void)getSingleImageSizeWithUrl:(NSString *)urlstr
{
    self.qualityDetailModel.singleImageView = [[UIImageView alloc]init];
    
    [self.qualityDetailModel.singleImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl,urlstr]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        NSArray *imageSizes = @[@(image.size.width), @(image.size.height)];
        
        CGSize maxSize = CGSizeMake(TYGetUIScreenWidth*2/3, TYGetUIScreenWidth*2/3);
        
        CGSize imageSize = [JGJImage getFitImageSize:imageSizes maxImageSize:maxSize];
        
        self.qualityDetailModel.imageW = imageSize.width;
        
        self.qualityDetailModel.imageH = imageSize.height;
        
        [self.tableView reloadData];
    }];
}


- (void)keyboardShow:(NSNotification *)notification {
    
    NSDictionary *userInfo = notification.userInfo;
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect endKeyboardRect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat yEndOffset = TYGetUIScreenHeight - endKeyboardRect.origin.y;
    
    [UIView animateWithDuration:duration animations:^{
        //显示
        
        [self.chatInputView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.mas_equalTo(self.view).offset(-yEndOffset);
            
        }];
        
        //        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        //
        //            make.top.mas_equalTo(self.view).offset(-yEndOffset);
        //
        //        }];
        
        //        [self.tableView layoutIfNeeded];
        
        [self.chatInputView layoutIfNeeded];
        
    }completion:^(BOOL finished) {
        
        
    }];
    
}

- (void)keyboardHidden:(NSNotification *)notification {
    
    double duration = 0.25;
    
    // 如果正在切换键盘，就不要执行后面的代码
    if (self.chatInputView.switchingKeybaord){
        
        //增加高度
        [UIView animateWithDuration:duration animations:^{
            
            [self.chatInputView mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.bottom.equalTo(self.view).offset(-EmotionKeyboardHeight);
                
            }];
        }];
        
        return;
    }
    
    [UIView animateWithDuration:duration animations:^{
        //显示
        
        [self.chatInputView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.equalTo(self.view.mas_bottom).mas_offset(ChatTabbarSafeBottomMargin);
            
            
        }];
        
        //        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        //
        //            make.top.mas_equalTo(self.view).offset(0);
        //
        //        }];
        //
        //        [self.tableView layoutIfNeeded];
        
        [self.chatInputView layoutIfNeeded];
        
    }completion:^(BOOL finished) {
        
        self.replyListModel = nil;
        
        self.chatInputView.placeholder = @"请输入回复内容";
        
    }];
    
    if (!self.chatInputView.isDefaultChatInputViewType) {
        
        self.chatInputView.isDefaultChatInputViewType = YES;
        
    }
    
    if (self.chatInputView.emotionKeyboard) {
        
        [self.chatInputView.emotionKeyboard removeFromSuperview];
    }
    
}

#pragma mark - JGJSendMessageViewDelegate

- (void)phoneVc:(UIPhotoViewController *)phoneVc imagesArrayAddEnd:(NSArray *)imagesArr {
    
    if ([NSString isEmpty:self.requstModel.reply_text]) {
        
        [self sendMessageInfos:nil];
        
    }else {
        
        [self.chatInputView sendMessage];
    }
    
}

- (void)setReplyListModel:(JGJQualityDetailReplayListModel *)replyListModel {
    
    _replyListModel = replyListModel;
    
    
    
}

- (void)sendMessageInfos:(NSArray *)imagesArr {
    
    //收回键盘
    [self.view endEditing:YES];
    
    self.chatInputView.placeholder = @"请输入回复内容";
    
    if ([NSString isEmpty:self.requstModel.reply_text] && self.imagesArray.count == 0) {
        
        return;
    }
    
    self.requstModel.reply_uid = self.replyListModel.user_info.uid;
    
    
    self.requstModel.msg_type = self.qualityDetailModel.msg_type;
    
    
    NSDictionary *parameters = [self.requstModel mj_keyValues];
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN uploadImagesWithApi:@"v2/quality/replyMessage" parameters:parameters imagearray:self.imagesArray success:^(id responseObject) {
        
        self.requstModel.reply_text = @"";
        [TYLoadingHub hideLoadingView];
        [TYShowMessage showSuccess:@"回复成功"];
        TYLog(@"responseObject ==== %@", responseObject);
        //        self.qualityDetailModel.reply_list = [JGJQualityDetailReplayListModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        self.replyList = [JGJQualityDetailReplayListModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        
        [self.imagesArray removeAllObjects];
        
        //回复成功之后清楚回复人
        self.replyListModel = nil;
        
        [self.tableView reloadData];
        
        [self scrollowBottom:NO];
        
        [self delDataBaseInfo];
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
}

#pragma mark - 滚动到底部
- (void)scrollowBottom:(BOOL)animated {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        CGFloat offsetY = self.tableView.contentSize.height + self.tableView.contentInset.bottom - CGRectGetHeight(self.tableView.frame);
        
        if (offsetY < -self.tableView.contentInset.top)
            offsetY = -self.tableView.contentInset.top;
        
        [self.tableView setContentOffset:CGPointMake(0, offsetY) animated:animated];
        
    });
    
    
}

#pragma mark - 删除信息
- (void)delDataBaseInfo {
    
    JGJQuaSafeToolReplyModel *pubModel = [JGJQuaSafeToolReplyModel new];
    
    pubModel.group_id = self.proListModel.group_id;
    
    pubModel.class_type = self.qualityDetailModel.class_type;
    
    pubModel.unique_id = [NSString stringWithFormat:@"%@%@",self.listModel.msg_id, self.qualityDetailModel.msg_type];
    
    [JGJQuaSafeTool removeCollecReplyModel:pubModel];
    
}

#pragma mark - 更多按钮按下
- (void)rightItemPressed:(UIBarButtonItem *)item {
    
    if ([self closeGroupShowMessage]) {
        
        return;
    }
    
    [self.view endEditing:YES];
    
    [self showSheetView];
}

- (void)showSheetView{
    
    __weak typeof(self) weakSelf = self;
    JGJCusActiveSheetView *sheetView = [[JGJCusActiveSheetView alloc] initWithTitle:@"" sheetViewType:JGJCusActiveSheetViewBoldPaddingType chageColors:@[@""] buttons:@[@"删除", @"取消"] buttonClick:^(JGJCusActiveSheetView *sheetView, NSInteger buttonIndex, NSString *title) {
        
        if (buttonIndex == 0) {
            
            [weakSelf handleDelQualitySafeLog];
        }
        
    }];
    
    [sheetView showView];
}

#pragma mark - 删除质量安全信息
- (void)handleDelQualitySafeLog {
    
    __weak typeof(self) weakSelf = self;
    
    NSString *commitUid = [TYUserDefaults objectForKey:JLGUserUid];
    
    if (![commitUid isEqualToString:self.qualityDetailModel.uid]) {
        
        return;
    }
    
    JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
    desModel.popDetail = @"你确定要删除该记录吗？";
    desModel.popTextAlignment = NSTextAlignmentCenter;
    desModel.lineSapcing = 3.0;
    JGJCustomPopView *alertView = [JGJCustomPopView showWithMessage:desModel];
    alertView.onOkBlock = ^{
        
        NSDictionary *parameters = @{@"msg_id" : self.qualityDetailModel.msg_id?:@"",
                                     @"msg_type" : self.qualityDetailModel.msg_type?:@""};
        
        [TYLoadingHub showLoadingWithMessage:nil];
        [JLGHttpRequest_AFN PostWithApi:@"v2/quality/delQualitySafeLog" parameters:parameters success:^(id responseObject) {
            
            [TYLoadingHub hideLoadingView];
            
            [weakSelf modifyDetailInfoFreshList];
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
        } failure:^(NSError *error) {
            
            [TYLoadingHub hideLoadingView];
        }];
        
    };
    
}

#pragma mark - 刷新质量列表
- (void)freshQualityList {
    for (UIViewController *vc in self.navigationController.viewControllers) {
        
        if ([vc isKindOfClass:[JGJChatListQualityVc class]]) {
            
            JGJChatListQualityVc *qualityVc = (JGJChatListQualityVc *)vc;
            
            [qualityVc freshTableView];
            break;
        }
    }
    
}

- (void)checkPerInfoModel:(JGJQualityDetailReplayListModel *)listModel {
    
    //去掉限制
    //    NSString *myUid = [TYUserDefaults objectForKey:JLGUserUid];
    //
    //    if ([listModel.user_info.uid isEqualToString:myUid]) {
    //
    //        return;
    //    }
    
    JGJPerInfoVc *perInfoVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJPerInfoVc"];
    
    perInfoVc.jgjChatListModel.uid = listModel.user_info.uid;
    
    JGJTeamMemberCommonModel *commonModel = [JGJTeamMemberCommonModel new];
    
    JGJSynBillingModel *memberModel = [JGJSynBillingModel new];
    
    memberModel.is_active = listModel.user_info.is_active;
    
    memberModel.real_name = listModel.user_info.real_name;
    
    memberModel.telphone = listModel.user_info.telephone;
    
    commonModel.teamModelModel = memberModel;
    
    if ([memberModel.is_active isEqualToString:@"0"]) {
        
        [self handleClickedUnRegisterAlertViewWithCommonModel:commonModel];
    }else {
        
        [self.navigationController pushViewController:perInfoVc animated:YES];
    }
    
}

- (void)handleClickedUnRegisterAlertViewWithCommonModel:(JGJTeamMemberCommonModel *)commonModel {
    
    commonModel.alertViewHeight = 210.0;
    commonModel.alertmessage = @"该用户还未注册,赶紧邀请他下载[吉工宝]一起使用吧！";
    commonModel.alignment = NSTextAlignmentLeft;
    [JGJCustomProInfoAlertVIew alertViewWithCommonModel:commonModel];
    
}


#pragma mark - 选中之后切换项目，首页项目改变
- (void)setIndexProListModel:(JGJMyWorkCircleProListModel *)proListModel {
    
    __weak typeof(self) weakSelf = self;
    
    [JGJChatGetOffLineMsgInfo http_gotoTheGroupHomeVCWithGroup_id:self.qualityDetailModel.group_id?:@"" class_type:self.qualityDetailModel.class_type?:@"" isNeedChangToHomeVC:YES isNeedHttpRequest:YES success:^(BOOL isSuccess) {
       
        [TYShowMessage showSuccess:@"已切换到该项目首页，你可以在首页进行各模块的使用"];
        
        [weakSelf.navigationController popToRootViewControllerAnimated:NO];
        
    }];
    
}

- (void)browsePhotoImageView:(NSArray *)msg_src selImageViews:(NSArray *)imageViews didSelPhotoIndex:(NSInteger)selPhotoIndex {
    
    [JGJCheckPhotoTool browsePhotoImageView:msg_src selImageViews:imageViews didSelPhotoIndex:selPhotoIndex];
    
}


- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = AppFontf1f1f1Color;
        _tableView.hidden = YES;
    }
    
    return _tableView;
    
}

- (void)initialSubView {
    
    [self.view addSubview:self.tableView];
    
    self.view.backgroundColor = AppFontf1f1f1Color;
    
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    
    [self.view addSubview:self.chatInputView];
    
    self.chatInputView.hidden = self.proListModel.isClosedTeamVc;
    
    if (self.proListModel.isClosedTeamVc) {
        
        [self.chatInputView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.bottom.mas_equalTo(self.view);
            
            make.height.mas_equalTo(0);
            
        }];
        
    }else {
        
        [self.chatInputView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.mas_equalTo(self.view);
            
            make.height.mas_equalTo(ChatInputViewH);
            
            make.bottom.mas_equalTo(ChatTabbarSafeBottomMargin);
            
        }];
        
    }
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.mas_equalTo(self.view);
        
        make.bottom.mas_equalTo(self.chatInputView.mas_top);
        
    }];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    
    gestureRecognizer.numberOfTapsRequired = 1;
    
    gestureRecognizer.cancelsTouchesInView = NO;
    
    [self.tableView addGestureRecognizer:gestureRecognizer];
}

#pragma mark - JGJChatInputViewDelegate

- (void)changeHeight:(JGJChatInputView *)chatInputView addHeight:(CGFloat )addHeight{
    
    if (addHeight < 10) {
        
        [self.chatInputView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(ChatInputViewH);
            
        }];
        
    }else {
        
        [self.chatInputView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(ChatInputViewH + addHeight);
            
        }];
        
    }
    
    [self.chatInputView layoutIfNeeded];
    
    
}

#pragma mark - 发送文字
- (void)sendText:(JGJChatInputView *)chatInputView text:(NSString *)text {
    
    self.requstModel.reply_text = text;
    
    [self sendMessageInfos:nil];
}

- (void)changeText:(JGJChatInputView *)chatInputView text:(NSString *)text {
    
    self.requstModel.reply_text = chatInputView.textView.text;
    
}

#pragma mark - 发送图片
- (void)sendPic:(JGJChatInputView *)chatInputView audioInfo:(NSDictionary *)audioInfo {
    
    self.requstModel.reply_text = chatInputView.textView.text;
    
    [self.imagesArray removeAllObjects];
    
    [self.sheet showInView:self.view];
}

- (BOOL)closeGroupShowMessage {
    
    BOOL isClosed = NO;
    
    if (self.proListModel.isClosedTeamVc) {
        
        NSString *showPlaint = [self.proListModel.class_type isEqualToString:@"team"] ? @"项目已关闭，不能执行此操作":@"班组已关闭，不能执行此操作";
        
        [TYShowMessage showPlaint:showPlaint];
        
        isClosed = YES;
    }
    
    return isClosed;
}

- (void)sheetViewWithListModel:(JGJQualityDetailReplayListModel *)listModel  {
    
    TYWeakSelf(self);
    
    NSArray *buttons = @[@"删除",@"取消"];
    
    JGJCusActiveSheetView *sheetView = [[JGJCusActiveSheetView alloc] initWithTitle:@"" sheetViewType:JGJCusActiveSheetViewBoldPaddingType chageColors:@[@""] buttons:buttons buttonClick:^(JGJCusActiveSheetView *sheetView, NSInteger buttonIndex, NSString *title) {
        
        if (buttonIndex == 0) {
            
            [weakself delRepleListModel:listModel];
            
        }
    }];
    
    [sheetView showView];
    
}

#pragma mark - 删除自己回复的消息
- (void)delRepleListModel:(JGJQualityDetailReplayListModel *)listModel {
    
    NSDictionary *parameters = @{@"id" : listModel.id?:@"",
                                 @"msg_type" : listModel.reply_type?:@""
                                 };
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/quality/delReplyMessage" parameters:parameters success:^(id responseObject) {
        
        [self.replyList removeObject:listModel];
        
        [self.tableView reloadData];
        
        [TYShowMessage showSuccess:@"删除成功"];
        
        [self modifyDetailInfoFreshList];
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (NSMutableArray *)localLevelInfos {
    
    if (!_localLevelInfos) {
        
        _localLevelInfos = [NSMutableArray new];
        
        NSArray *desIcons = @[@"quality_address", @"quality_level", @""];
        
        NSArray *desTitles = @[@"隐患部位", @"隐患级别", @"来自:"];
        
        for (NSInteger index = 0; index < desIcons.count; index++) {
            
            JGJQualityLocalModel *model = [JGJQualityLocalModel new];
            
            model.flagIcon = desIcons[index];
            
            model.desTitle = desTitles[index];
            
            [_localLevelInfos addObject:model];
        }
    }
    
    return _localLevelInfos;
}

- (NSMutableArray *)principalInfos {
    
    if (!_principalInfos) {
        
        _principalInfos = [NSMutableArray new];
        
        NSArray *titles = @[@"整改负责人", @"整改完成期限: "];
        
        NSArray *placeholders = @[@"修改", @"修改"];
        
        for (NSInteger indx = 0; indx < titles.count; indx++) {
            
            JGJCreatTeamModel *infoModel = [JGJCreatTeamModel new];
            
            infoModel.title = titles[indx];
            
            infoModel.detailTitle = placeholders[indx];
            
            [_principalInfos addObject:infoModel];
        }
    }
    
    return _principalInfos;
}

-(JGJCreatTeamModel *)modifyInfoModel {
    
    if (!_modifyInfoModel) {
        
        _modifyInfoModel = [JGJCreatTeamModel new];
        
        _modifyInfoModel.title = @"整改措施: ";
        
        _modifyInfoModel.detailTitle = @"修改";
    }
    
    return _modifyInfoModel;
}

- (JGJQualityReplyRequestModel *)requstModel {
    
    if (!_requstModel) {
        
        _requstModel = [JGJQualityReplyRequestModel new];
        
    }
    
    _requstModel.group_id = self.qualityDetailModel.group_id;
    
    _requstModel.msg_id = self.qualityDetailModel.msg_id;
    
    _requstModel.class_type = self.qualityDetailModel.class_type;
    
    _requstModel.reply_type = self.qualityDetailModel.msg_type;
    
    if ([NSString isEmpty:self.qualityDetailModel.msg_type]) {
        
        _requstModel.reply_type = self.commonModel.msg_type;
    }
    
    return _requstModel;
}

- (JGJQualityReplyRequestModel *)modifyRequstModel {
    
    
    if (!_modifyRequstModel) {
        
        _modifyRequstModel = [JGJQualityReplyRequestModel new];
        
        _modifyRequstModel.group_id = self.qualityDetailModel.group_id;
        
        _modifyRequstModel.msg_id = self.qualityDetailModel.msg_id;
        
        _modifyRequstModel.msg_type = self.qualityDetailModel.msg_type;
    }
    
    return _modifyRequstModel;
}

- (JGJSynBillingModel *)principalModel {
    
    if (!_principalModel) {
        
        _principalModel = [JGJSynBillingModel new];
    }
    
    return _principalModel;
    
}

- (NSMutableArray *)qualityDetailModels {
    
    if (!_qualityDetailModels) {
        
        _qualityDetailModels = [NSMutableArray new];
        
        for (NSInteger indx = 0; indx < 2; indx++) {
            
            JGJQualityDetailModel *qualityDetailModel = [JGJQualityDetailModel new];
            
            [_qualityDetailModels addObject:qualityDetailModel];
        }
    }
    
    return _qualityDetailModels;
}

- (JGJChatInputView *)chatInputView {
    
    if (!_chatInputView) {
        
        _chatInputView = [[JGJChatInputView alloc] init];
        
        _chatInputView.chatInputViewKeyBoardType = JGJChatInputViewKeyBoardChangeStatusType;
        
        _chatInputView.delegate = self;
        
        _chatInputView.placeholder = @"请输入回复内容";
        
        __weak typeof(self) weakSelf = self;
        
        _chatInputView.emojiKeyboardBlock = ^(JGJChatInputView *chatInputView) {
            
            [UIView animateWithDuration:0.25 animations:^{
                //显示
                
                [weakSelf.chatInputView mas_updateConstraints:^(MASConstraintMaker *make) {
                    
                    make.bottom.mas_equalTo(weakSelf.view).offset(-EmotionKeyboardHeight);
                    
                }];
                
                [weakSelf.chatInputView layoutIfNeeded];
                
            }completion:^(BOOL finished) {
                
                
            }];
        };
    }
    
    return _chatInputView;
}

- (JGJQuaSafeCommonSysMsgCellModel *)sysMsgCellModel {
    
    if (!_sysMsgCellModel) {
        
        _sysMsgCellModel = [JGJQuaSafeCommonSysMsgCellModel new];
    }
    
    return _sysMsgCellModel;
}

- (void)hideKeyboard {
    
    [self scrollViewWillBeginDragging:self.tableView];
}

- (void)dealloc {
    
    [TYNotificationCenter removeObserver:self];
}

@end

