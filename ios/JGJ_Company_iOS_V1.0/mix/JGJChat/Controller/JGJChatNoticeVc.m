//
//  JGJChatNoticeVc.m
//  mix
//
//  Created by Tony on 2016/8/30.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatNoticeVc.h"
#import "JGJChatRootVc.h"
#import "CALayer+SetLayer.h"
#import "JGJChatNoticeCell.h"
#import "JGJChatNoticeTitleCell.h"
#import "JGJSendNotificationTopTitleCell.h"
#import "JGJTeamMemberCell.h"
#import "NSString+Extend.h"
#import "JLGAddProExperienceTableViewCell.h"
#import "JGJTheDiaryOfRecipientTableViewCell.h"
#import "JGJTextViewTool.h"
#import "JGJAddAdministratorListVc.h"
#import "JGJChatListBaseVc.h"
#import "JGJQuaSafeTool.h"
#import "JGJTaskTracerVc.h"
#import "ACEExpandableTextCell.h"
#import "IQKeyboardManager.h"

#import "JGJChatMsgDBManger.h"

@interface JGJChatNoticeVc ()
<
UITableViewDelegate,
UITableViewDataSource,
UITextViewDelegate,
JGJChatNoticeCellDelegate,
JLGMYProExperienceTableViewCellDelegate,
JGJAddAdministratorListVcDelegate,
JGJTeamMemberCellDelegate,
JGJTaskTracerVcDelegate,
ACEExpandableTableViewDelegate
>
{
    JGJSendNotificationTopTitleCell *_topTitleCell;
    JGJTheDiaryOfRecipientTableViewCell *_recipientCell;
    
    BOOL _isSelectedAllMembers;
    
    CGFloat _cellHeight;
}

@property (nonatomic,copy) NSString *noticeStr;
@property (nonatomic,assign) CGFloat noticeStrCellH;
@property (weak, nonatomic) IBOutlet UIButton *releaseButton;
@property (strong, nonatomic) JGJChatNoticeCell *returnCell;
@property (strong, nonatomic) ACEExpandableTextCell *ACEExpandableTextCell;

//上一次输入的文字，用于判断输入英文@会走两次问题。相同的信息只走一次ACEExpandableTextCell

@property (copy, nonatomic) NSString *lastInputText;

@property (nonatomic, strong) JGJQuaSafeToolReplyModel *repleModel;
// 接收人
@property (nonatomic ,strong) NSMutableArray *membersArr;
@property (nonatomic, strong) NSMutableArray *joinMembers;
@end

@implementation JGJChatNoticeVc

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [IQKeyboardManager sharedManager].enable = YES;
    self.isNeedWatermark = YES;
    _cellHeight = 0.0;
    JGJQuaSafeToolReplyModel *pubModel = [JGJQuaSafeToolReplyModel new];
    
    pubModel.group_id = self.workProListModel.group_id;
    
    pubModel.class_type = self.workProListModel.class_type;
    
    pubModel.subClassType = @"notifyType";
    
    JGJQuaSafeToolReplyModel *replyModel = [JGJQuaSafeTool replyModel:pubModel];
    
    self.repleModel = replyModel;
    
    if (![NSString isEmpty:self.repleModel.replyText]) {
        
        self.noticeStr = self.repleModel.replyText;
    }
    CGFloat cellHeight = [NSString stringWithYYContentWidth:TYGetUIScreenWidth - 10 font:15 lineSpace:0 content:replyModel.replyText];
    
    if (cellHeight > 106.5) {
        
        _cellHeight = cellHeight;
    }
    
    [self.tableView reloadData];
    
    self.releaseButton.backgroundColor = AppFontEB4E4EColor;
    
    [self setBackButton];
    
    [self commonInit];
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.tableView addGestureRecognizer:tapGestureRecognizer];
    self.tableView.backgroundColor = TYColorHex(0xf1f1f1);
    
    //签到的按钮在底部，继承关系
    if (self.chatListType != JGJChatListSign) {
        
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.mas_equalTo(0);
        }];
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    _releaseButton.hidden = YES;
    UIBarButtonItem *barbutton = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(publishNotifications)];
    self.navigationItem.rightBarButtonItem = barbutton;
    
    JGJSynBillingModel *addModel = nil;
    
    if (self.membersArr.count > 0) {
        
        addModel = self.membersArr.lastObject;
        
    }
    
    //数据为空或者最后一个不是添加符号。加上添加符号
    if (self.membersArr.count == 0 || !addModel.isAddModel) {
        
        NSArray *addModels = [JGJTeamMemberCell accordTypeGetMangerModels:ShowAddTeamMemberFlagType];
        
        [self.membersArr addObjectsFromArray:addModels];
        
        [self.tableView reloadData];
    }
}

- (NSMutableArray *)membersArr
{
    if (!_membersArr) {
        
        _membersArr = [NSMutableArray array];
        NSArray *addModels = [JGJTeamMemberCell accordTypeGetMangerModels:ShowAddTeamMemberFlagType];
        [_membersArr addObjectsFromArray:addModels];
    }
    return _membersArr;
}

- (NSMutableArray *)joinMembers {
    
    if (!_joinMembers) {
        
        _joinMembers = [[NSMutableArray alloc] init];
    }
    return _joinMembers;
}

- (void)keyboardHide:(UITapGestureRecognizer*)tap{
    
    [self.view endEditing:YES];
}



- (void)setWorkProListModel:(JGJMyWorkCircleProListModel *)workProListModel{
    _workProListModel = workProListModel;
    [self.tableView reloadData];
}

- (void)commonInit{
    
    [self.releaseButton.layer setLayerCornerRadius:4.0];
    
    switch (self.chatListType) {
        case JGJChatListNotice:
            
            self.title = @"发通知";
            break;
        case JGJChatListSafe:
            
            self.title = @"发安全";
            break;
        case JGJChatListQuality:
            
            self.title = @"发质量";
            break;
        case JGJChatListLog:
            
            self.title = @"发工作日志";
            break;
        case JGJChatListSign:
            
            self.title = @"签到";
            self.isNeedWatermark = YES;
            break;
        default:
            break;
    }
    
}

#pragma mark - tableView
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
}

- (void)tableView:(UITableView *)tableView updatedText:(NSString *)text atIndexPath:(NSIndexPath *)indexPath
{
    self.noticeStr = text;
}

- (void)tableView:(UITableView *)tableView updatedHeight:(CGFloat)height atIndexPath:(NSIndexPath *)indexPath
{
    _cellHeight = height;
}

- (void)textChange:(ACEExpandableTextCell *)cell text:(NSString *)text lastText:(NSString *)lastText {
    
    NSString *atMessage = [JGJTextViewTool inputView:cell.textView handleAtMesage:lastText];
    if (([atMessage isEqualToString:@"@"] && ![self.lastInputText isEqualToString:cell.textView.text]) || (cell.textView.text.length == 1 && [atMessage rangeOfString:@"@"].location != NSNotFound)) {
        
        self.lastInputText = cell.textView.text;
        
        JGJAddAdministratorListVc *atMmemberVc = [[UIStoryboard storyboardWithName:@"JGJCreatTeam" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJAddAdministratorListVc"];
        atMmemberVc.addMemberVcType = JGJAddAtMemberType;
        atMmemberVc.workProListModel = self.workProListModel;
        atMmemberVc.delegate = self;
        [self.navigationController pushViewController:atMmemberVc animated:YES];
    }
}
//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat cellH = 0.0;
    if (indexPath.row == 0) {
        
        cellH = 40;
        
    }else if (indexPath.row == 1) {
        
        cellH = 180;
        
    }else if (indexPath.row == 2){
        JLGAddProExperienceTableViewCell *cell = [JLGAddProExperienceTableViewCell new];
        cellH =  [cell getHeightWithImagesArray:self.imagesArray];
        
    }else if (indexPath.row == 3) {
        
        return 37.5;
    }else {
        
        return [JGJTeamMemberCell calculateCollectiveViewHeight:self.membersArr headerHeight:CheckPlanHeaderHegiht];
    }
    
    return cellH;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    switch (indexPath.row) {
        case 0:
        {
            NSString *ID = NSStringFromClass([JGJSendNotificationTopTitleCell class]);
            
            _topTitleCell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (!_topTitleCell) {
                
                _topTitleCell = [[JGJSendNotificationTopTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            }
            
            _topTitleCell.model = self.workProListModel;
            return _topTitleCell;
            
        }
            break;
        case 1:
        {
            
            ACEExpandableTextCell *cell = [tableView expandableTextCellWithId:@"cellId"];
            
            cell.text = self.noticeStr;
            NSString *placeholderStr = @"";
            if (self.chatListType == JGJChatListNotice) {
                
                placeholderStr = @"输入通知内容";
            }else if(self.chatListType == JGJChatListSafe){
                
                placeholderStr = @"描述安全";
            }else if(self.chatListType == JGJChatListQuality){
                
                placeholderStr = @"描述质量";
            }else if(self.chatListType == JGJChatListLog){
                
                placeholderStr = @"输入日志内容";
            }
            
            cell.textView.placeholder = [NSString stringWithFormat:@"请在此处%@",placeholderStr];
            cell.textView.font = FONT(AppFont30Size);
            return cell;
        }
            break;
        case 2:
        {
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
            
            cell = returnCell;
        }
            break;
        case 3:
        {
            NSString *MyIdentifierID = NSStringFromClass([JGJTheDiaryOfRecipientTableViewCell class]);
            _recipientCell = [tableView dequeueReusableCellWithIdentifier:MyIdentifierID];
            if (!_recipientCell) {
                
                _recipientCell = [[JGJTheDiaryOfRecipientTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifierID];
            }
            
            _recipientCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return _recipientCell;
        }
            break;
        case 4:
        {
            JGJTeamMemberCell *cell = (JGJTeamMemberCell *)[self registerExecuMemberTableView:tableView didSelectRowAtIndexPath:indexPath];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
        default:
            break;
    }
    
    return cell;
}


- (UITableViewCell *)registerExecuMemberTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJTeamMemberCell *cell  = [JGJTeamMemberCell cellWithTableView:tableView];
    
    cell.delegate = self;
    
    cell.isCheckPlanHeader = YES; //使用当前页面的头部高度，内部只做顶部间隔调整
    
    cell.memberFlagType = ShowAddTeamMemberFlagType;
    
    cell.teamMemberModels = self.membersArr;
    
    return cell;
}

- (void)subClassTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
}


#pragma mark - 点击编辑框以后的键盘位置
- (void)CollectionCellTouch{
    [self.view endEditing:YES];
}

#pragma mark - textView的高度改变了
- (void)textChange:(JGJChatNoticeCell *)cell text:(NSString *)text{
    
    self.noticeStr = text;
}


#pragma mark - JGJAddAdministratorListVcDelegate
- (void)addAdminList:(JGJAddAdministratorListVc *)addAdminListVc didSelectedMember:(JGJSynBillingModel *)member {
    
    [JGJTextViewTool inputTextView:self.returnCell.inputView insertTextView:member.full_name?:@""];
}


//- (IBAction)releaseNoticeBtnClick:(id)sender {
//    if ([NSString isEmpty:self.noticeStr] && self.imagesArray.count == 0) {
//        [TYShowMessage showPlaint:@"请输入内容"];
//        return;
//    }
//
//    JGJChatRootVc *chatRootVc = self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2];
//
//    CustomAlertView *alertView = [CustomAlertView showWithMessage:nil leftButtonTitle:nil midButtonTitle:nil rightButtonTitle:nil];
//    [alertView showProgressImageView:@"正在发布..."];
//
//    if (self.imagesArray.count > 0) {//如果有照片就传照片
//        [JLGHttpRequest_AFN uploadImagesWithApi:@"jlupload/upload" parameters:nil imagearray:self.imagesArray success:^(NSArray *responseObject) {
//            [self popVc:chatRootVc imgsAddArr:responseObject];
//            [alertView dismissWithBlcok:nil];
//            [TYShowMessage showSuccess:@"发布成功"];
//
//        } failure:^(NSError *error) {
//            [alertView dismissWithBlcok:nil];
//            [TYShowMessage showError:@"发布失败"];
//        }];
//    }else {//没有照片的情况
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self popVc:chatRootVc imgsAddArr:[NSArray array]];
//            [alertView dismissWithBlcok:nil];
//        });
//    }
//
//    if ([chatRootVc isKindOfClass:[JGJChatListBaseVc class]]) {
//
//        JGJChatListBaseVc *baseVc = (JGJChatListBaseVc *)chatRootVc;
//
//        if (![self isKindOfClass:NSClassFromString(@"JGJChatListAllVc")]) {
//
//            [baseVc.tableView.mj_header beginRefreshing];
//        }
//
//    }
//
//}

- (void)freshDataList {
    
    JGJChatRootVc *chatRootVc = self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2];
    
    if ([chatRootVc isKindOfClass:[JGJChatListBaseVc class]]) {
        
        JGJChatListBaseVc *baseVc = (JGJChatListBaseVc *)chatRootVc;
        
        if (![self isKindOfClass:NSClassFromString(@"JGJChatListAllVc")]) {
            
            [baseVc.tableView.mj_header beginRefreshing];
        }
        
    }
}

- (void)popVc:(JGJChatRootVc *)chatRootVc imgsAddArr:(NSArray *)imgsAddressArr{
    
    [self delDataBaseInfo];
    
    //刷新数据
    [self freshDataList];
    
    // 如果全选则rec_uid传-1，否则传成员id拼接的字符串
    NSDictionary *dataInfo;
    if (_isSelectedAllMembers) {
        
        dataInfo = @{@"chatListType":@(self.chatListType),@"text":self.noticeStr,@"imgsAddressArr":imgsAddressArr,@"rec_uid":@"-1"};
        
    }else {
        
        NSMutableString *idStr = [[NSMutableString alloc] init];
        for (int i = 0; i < self.membersArr.count - 1; i ++) {
            
            JGJSynBillingModel *model = self.membersArr[i];
            if (i == self.membersArr.count - 2) {
                
                [idStr appendString:[NSString stringWithFormat:@"%@",model.uid]];
                
            }else {
                
                [idStr appendString:[NSString stringWithFormat:@"%@,",model.uid]];
            }
            
        }
        dataInfo = @{@"chatListType":@(self.chatListType),@"text":self.noticeStr,@"imgsAddressArr":imgsAddressArr,@"rec_uid":idStr};
    }
    
    [chatRootVc addAllNotice:dataInfo];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)publishNotifications {
    
    if ([NSString isEmpty:self.noticeStr] && self.imagesArray.count == 0) {
        [TYShowMessage showPlaint:@"请输入内容"];
        return;
    }
    
    // 判断是否选择接受人
    if (self.membersArr.count == 1) {
        
        [TYShowMessage showPlaint:@"请选择接收人"];
        return;
    }
    
    // 如果全选则rec_uid传-1，否则传成员id拼接的字符串
    NSDictionary *dataInfo;
    if (_isSelectedAllMembers) {
        
        dataInfo = @{@"msg_type":@"notice",
                     @"msg_text":self.noticeStr?:@"",
                     @"class_type":self.workProListModel.class_type,
                     @"group_id":self.workProListModel.group_id,
                     @"rec_uid":@"-1"};
        
    }else {
        
        NSMutableString *idStr = [[NSMutableString alloc] init];
        for (int i = 0; i < self.membersArr.count - 1; i ++) {
            
            JGJSynBillingModel *model = self.membersArr[i];
            if (i == self.membersArr.count - 2) {
                
                [idStr appendString:[NSString stringWithFormat:@"%@",model.uid]];
                
            }else {
                
                [idStr appendString:[NSString stringWithFormat:@"%@,",model.uid]];
            }
            
        }
        dataInfo = @{@"msg_type":@"notice",
                     @"msg_text":self.noticeStr?:@"",
                     @"class_type":self.workProListModel.class_type,
                     @"group_id":self.workProListModel.group_id,
                     @"rec_uid":idStr};
    }
    
    //    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:dataInfo];
    //
    //    parameters[@"local_id"] = [JGJChatMsgDBManger localID];
    
    CustomAlertView *alertView = [CustomAlertView showWithMessage:nil leftButtonTitle:nil midButtonTitle:nil rightButtonTitle:nil];
    [alertView showProgressImageView:@"正在发布..."];
    [JLGHttpRequest_AFN newUploadImagesWithApi:@"group/pub-notice" parameters:dataInfo imagearray:self.imagesArray otherDataArray:nil dataNameArray:nil success:^(id responseObject) {
        
        [self pubSuccessWithResponse:responseObject];
        
        [self delDataBaseInfo];
        //刷新数据
        [self freshDataList];
        
        [alertView dismissWithBlcok:nil];
        [TYShowMessage showSuccess:@"发布成功"];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
        [alertView dismissWithBlcok:nil];
    }];
    
    //    JGJChatRootVc *chatRootVc = self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2];
    //
    //    CustomAlertView *alertView = [CustomAlertView showWithMessage:nil leftButtonTitle:nil midButtonTitle:nil rightButtonTitle:nil];
    //    [alertView showProgressImageView:@"正在发布..."];
    //
    //    if (self.imagesArray.count > 0) {//如果有照片就传照片
    //        [JLGHttpRequest_AFN uploadImagesWithApi:@"jlupload/upload" parameters:nil imagearray:self.imagesArray success:^(NSArray *responseObject) {
    //
    //            [self popVc:chatRootVc imgsAddArr:responseObject];
    //            [alertView dismissWithBlcok:nil];
    //            [TYShowMessage showSuccess:@"发布成功"];
    //
    //        } failure:^(NSError *error) {
    //            [alertView dismissWithBlcok:nil];
    //            [TYShowMessage showPlaint:@"发布失败"];
    //        }];
    //    }else {//没有照片的情况
    //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //
    //            [self popVc:chatRootVc imgsAddArr:[NSArray array]];
    //            [alertView dismissWithBlcok:nil];
    //        });
    //    }
}

- (void)pubSuccessWithResponse:(NSDictionary *)response {
    
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
    
}

#pragma mark - 删除信息
- (void)delDataBaseInfo {
    
    JGJQuaSafeToolReplyModel *pubModel = [JGJQuaSafeToolReplyModel new];
    
    pubModel.group_id = self.workProListModel.group_id;
    
    pubModel.class_type = self.workProListModel.class_type;
    
    pubModel.subClassType = @"notifyType";
    
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
    
    pubModel.group_id = self.workProListModel.group_id;
    
    pubModel.replyText = self.noticeStr;
    
    pubModel.class_type = self.workProListModel.class_type;
    
    //唯一id发质量安全用类型
    
    pubModel.subClassType = @"notifyType";
    
    [JGJQuaSafeTool addCollectReplyModel:pubModel];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - TeamMemberCellDelegate
- (void)handleJGJTeamMemberCellRemoveIndividualTeamMember:(JGJSynBillingModel *)teamMemberModel {
    
    
    if (self.membersArr.count > 0 && !teamMemberModel.isMangerModel) {
        
        //        [self.membersArr removeObject:teamMemberModel];
        
        //加人换成下面的语句是因为后台会返相同的手机号码人员
        
        NSPredicate *existPredicate = [NSPredicate predicateWithFormat:@"telephone=%@", teamMemberModel.telephone];
        
        NSArray *existMembers = [self.membersArr filteredArrayUsingPredicate:existPredicate];
        
        if (existMembers.count > 0) {
            
            for (JGJSynBillingModel *memberModel in existMembers) {
                
                if ([memberModel isKindOfClass:[JGJSynBillingModel class]]) {
                    
                    memberModel.isSelected = NO;
                }
                
            }
        }
        
        NSInteger index = [self.membersArr indexOfObject:teamMemberModel];
        
        [self.membersArr removeObjectAtIndex:index];
        
        if ([self.joinMembers containsObject:teamMemberModel]) {
            
            teamMemberModel.isSelected = NO;
        }
        
        _isSelectedAllMembers = NO;
        
        
        [self.tableView reloadData];
        
    }
}

- (void)handleJGJTeamMemberCellAddMember:(JGJTeamMemberCommonModel *)commonModel {
    
    JGJTaskTracerVc *taskTracerVc = [[UIStoryboard storyboardWithName:@"JGJTask" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJTaskTracerVc"];
    
    taskTracerVc.taskTracerType = JGJNoticeExecutorTracerType;
    
    taskTracerVc.delegate = self;
    
    if (self.membersArr.count > 0) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isMangerModel == %@", @(YES)];
        
        JGJSynBillingModel *addModel = [self.membersArr filteredArrayUsingPredicate:predicate].lastObject;
        
        if (addModel.isMangerModel) {
            
            [self.membersArr removeObject:addModel];
        }
        
    }
    
    taskTracerVc.proListModel = self.workProListModel;
    taskTracerVc.existedMembers = self.membersArr;
    taskTracerVc.taskTracerModels = self.joinMembers;
    [self.navigationController pushViewController:taskTracerVc animated:YES];

}

- (void)taskTracerVc:(JGJTaskTracerVc *)principalVc didSelelctedMembers:(NSArray *)members isSelectedAllMembers:(BOOL)isSelectedAllMembers {
    
    _isSelectedAllMembers = isSelectedAllMembers;
    self.joinMembers = principalVc.taskTracerModels;
    
    [self.membersArr removeAllObjects];
    
    [self.membersArr addObjectsFromArray:members];
    
    
    //得到最后一个添加模型
    NSArray *addModels = [JGJTeamMemberCell accordTypeGetMangerModels:ShowAddTeamMemberFlagType];
    
    [self.membersArr addObjectsFromArray:addModels];
    
    [self.tableView reloadData];
}


@end

