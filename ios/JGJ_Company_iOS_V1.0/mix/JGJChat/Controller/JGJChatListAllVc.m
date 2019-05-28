//
//  JGJChatListAllVc.m
//  mix
//
//  Created by Tony on 2016/8/31.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatListAllVc.h"
#import "JGJChatNoticeVc.h"
#import "JGJChatSignVc.h"
#import "JGJChatListSignVc.h"
#import "TYInputView.h"
#import "JGJAddAdministratorListVc.h"
#import "JGJTextViewTool.h"
#import "JGJPerInfoVc.h"
#import "JGJTime.h"
#import "JGJJGSSuggestion.h"
#import "JGJShareInstance.h"
#define ChatListBottomViewAddH 16.0
#import "JGJChatMsgDBManger.h"

#import "JGJChatMsgRequestModel.h"

#import "JGJChatMsgDBManger+JGJClearCacheDB.h"

#import "JGJChatListBaseVc+SelService.h"

#import "JGJCustomPopView.h"

#import "JGJWebAllSubViewController.h"

@interface JGJChatListAllVc ()
<
JGJChatInputViewDelegate,
JGJChatBootomViewDelegate,
JGJAddAdministratorListVcDelegate,
jumpScoreWorkdelegate
>
{
    JGJShareInstance *shareinstance;
    
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewConstraintH;

@property (nonatomic,strong) JGJJGSSuggestion *suggestionView;

//测试
@property (strong, nonatomic) NSMutableArray *inputViewInfoArray;

//上一次输入的文字，用于判断输入英文@会走两次问题。相同的信息只走一次

@property (copy, nonatomic) NSString *lastInputText;

@property (assign, nonatomic) CGFloat viewOffsetY;

//漫游请求
@property (strong, nonatomic) JGJChatMsgRequestModel *roamRequest;

//是否已打开At人员控制器，防止重复进入

@property (assign, nonatomic) BOOL is_openAtMemberVc;

@end

@implementation JGJChatListAllVc

- (void)dataInit{
    [super dataInit];
    
    self.msgType = @"all";
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.tableView addGestureRecognizer:tapGestureRecognizer];
    
    _viewOffsetY = TYGetViewY(self.view);
    
    self.bottomViewConstraintB.constant = _viewOffsetY;
    
    
    //2.3.3添加
    __weak typeof(self) weakSelf = self;
    
    _chatInputView.emojiKeyboardBlock = ^(JGJChatInputView *chatInputView) {
        
        [UIView animateWithDuration:0.25 animations:^{
            
            weakSelf.bottomViewConstraintB.constant = EmotionKeyboardHeight;
            
            [weakSelf.bottomView layoutIfNeeded];
            
            weakSelf.chatInputView.emotionKeyboard.y = EmotionKeyboardY;
            
            weakSelf.isCanScroBottom = YES;
            
        }completion:^(BOOL finished) {
            
            [weakSelf tableViewToBottom];
            
        }];
    };
    
}
-(JGJJGSSuggestion *)suggestionView
{
    if (!_suggestionView) {
        
        _suggestionView = [[JGJJGSSuggestion alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
        
    }
    return _suggestionView;
    
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //消失的时候移除表情监听，聊聊进入详情页输入表情会在聊聊同时显示问题
    [self.chatInputView removeObserver];
    
}

#pragma mark - 点击跳转到记工界面
-(void)jumpScoreWorkViewControllerthing
{
    
}
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    
    self.chatInputView.isDefaultChatInputViewType = YES;
    
    [self.view endEditing:YES];
    
    //拖拽的时候隐藏底部、相册、拍摄、我的名片视图
    
    [self dissMediaView];
    
}

- (void)setBottomViewData:(JGJMyWorkCircleProListModel *)workProListModel{
    
}

- (void)setWorkProListModel:(JGJMyWorkCircleProListModel *)workProListModel{
    
    [super setWorkProListModel:workProListModel];
    
    self.chatInputView.workProListModel = workProListModel;
    
    self.chatBottomView.delegate = self;
    self.chatInputView.delegate = self;
    self.chatInputView.workProListModel = self.workProListModel;
    
    if (self.workProListModel.workCircleProType != WorkCircleExampleProType) {
        
        [TYNotificationCenter addObserver:self selector:@selector(chatListKeyboardDidHiddenFrame:) name:UIApplicationWillResignActiveNotification object:nil];
        
        [TYNotificationCenter addObserver:self selector:@selector(chatListDownVoiceSuccess:) name:JGJChatListDownVoiceSuccess object:nil];
        
    }else{
        
        self.chatInputView.textView.userInteractionEnabled = NO;
        
        self.chatInputView.recordLabel.userInteractionEnabled = NO;
        
        //添加单击手势
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exampleProSingleTap:)];
        
        [self.chatInputView addGestureRecognizer:singleTap];
        
    }
    
    //2.2.0处理高度问题普通聊天。底部界面右边的加号隐藏了，和底部已经隐藏。
    
    if (self.workProListModel.isClosedTeamVc) {
        
        self.bottomRootViewConstraintH.constant = 0;
        
        //关闭标识
        [self closeProFlag];
        
    }else {
        
        self.bottomViewConstraintH.constant = 0;
        
        self.bottomRootViewConstraintH.constant = ChatInputViewH;
    }
    
    [self.bottomView layoutIfNeeded];
    
    _bottomRootViewOldH = self.bottomRootViewConstraintH.constant;
    
    //    [self.tableView.mj_header beginRefreshing];
    
    //加载数据
    [self loadChatLocalData];
}

- (void)exampleProSingleTap:(UITapGestureRecognizer *)sender{
    if(self.workProListModel.workCircleProType == WorkCircleExampleProType){
        [TYShowMessage showPlaint:@"创建班组以后点击这里组里人员可以任意交流\n这是示范数据，点击无效！"];
    }
}

- (void)setChatListRequestModel:(JGJChatRootRequestModel *)chatListRequestModel{
    
    [super setChatListRequestModel:chatListRequestModel];
    
}

#pragma mark - 首次进入页面加载聊天数据设置数据的地方WCDBYJ,这里加载不会闪烁

- (void)loadChatLocalData {
    
    JGJChatMsgListModel *msgModel = [JGJChatMsgListModel new];
    
    msgModel.group_id = self.workProListModel.group_id;
    
    msgModel.class_type = self.workProListModel.class_type;
    
    NSArray *msgList = [self getDBMsgListWithMsgModel:msgModel];
    
    self.isCanScroBottom = YES;
    
    [self addSourceArr:msgList];
    
    if ([self.workProListModel.class_type isEqualToString:@"singleChat"]) {
        
        JGJChatMsgListModel *findJobMsg = [self handleProDetailInfoInsertLastMsg];
        
        if (findJobMsg) {
            
            [self.dataSourceArray addObject:findJobMsg];
            
        }
    }
    
    [self tableViewToBottom];
    
    NSString *myUid = [TYUserDefaults objectForKey:JLGUserUid];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"msg_sender == %@", myUid];
    
    NSArray *mySendMsgs = [self.dataSourceArray filteredArrayUsingPredicate:predicate];
    
    //找出自己数据用于替换用
    [self.muSendMsgArray addObjectsFromArray:mySendMsgs];
    
    if (msgList.count == 0) {
        
        [self.tableView.mj_header beginRefreshing];
        
    }
    
}

//2.1.2-yj 插入最后一条信息
- (JGJChatMsgListModel *)handleProDetailInfoInsertLastMsg {
    
    JGJChatMsgListModel *findJobMsgModel = nil;
    
    JGJChatFindJobModel *chatfindJobModel = self.workProListModel.chatfindJobModel;
    
    BOOL isVertify = NO;
    
    if (![NSString isEmpty:chatfindJobModel.verified]) {
        
        isVertify = ![chatfindJobModel.verified isEqualToString:@"3"];
        
        if (isVertify) {
            
            if (!chatfindJobModel) {
                
                chatfindJobModel = [[JGJChatFindJobModel alloc] init];
                
                chatfindJobModel.group_id = self.workProListModel.group_id;
                
                chatfindJobModel.class_type = self.workProListModel.class_type;
                
            }
            
        }
    }
    
    JGJChatRecruitMsgModel *chatRecruitMsgModel = self.workProListModel.chatRecruitMsgModel;
    
    if (chatRecruitMsgModel) {
        findJobMsgModel = [JGJChatMsgListModel new];
        //        findJobMsgModel.chatListType = JGJChatRecruitMsgType;
        //        findJobMsgModel.msg_prodetail = self.workProListModel.chatfindJobModel;
        findJobMsgModel.recruitMsgModel = chatRecruitMsgModel;
        findJobMsgModel.is_find_job = self.workProListModel.is_find_job;
        findJobMsgModel.msg_text = @"";
        if ([chatRecruitMsgModel.click_type isEqualToString:@"1"]) { //名片
            
            
            findJobMsgModel.local_msg_type = @"local_postcard";
            
        }else if ([chatRecruitMsgModel.click_type isEqualToString:@"2"]) { //招聘
            
            
            findJobMsgModel.local_msg_type = @"local_recruitment";
        }
        
        // 代表该消息不是名片/h招聘消息 需要显示一个临时 是否认证消息
        if ([NSString isEmpty:chatRecruitMsgModel.click_type]) {
            
            findJobMsgModel.local_msg_type = @"local_verified";
            
        }
        
        findJobMsgModel.group_id = self.workProListModel.group_id;
        findJobMsgModel.local_id = [JGJChatListTool localID];
        findJobMsgModel.belongType = JGJChatListBelongMine;
        self.findJobTemporaryMsgModel = findJobMsgModel;
        
    }
    
    TYLog(@"findJobMsgModel-----%@", [findJobMsgModel.msg_prodetail mj_JSONString]);
    
    return findJobMsgModel;
}

#pragma mark - 获取数据库消息列表
- (NSArray *)getDBMsgListWithMsgModel:(JGJChatMsgListModel *)msgModel {
    
    JGJChatClearCacheModel *cacheModel = [JGJChatClearCacheModel mj_objectWithKeyValues:[msgModel mj_keyValuesWithKeys:@[@"class_type",@"group_id"]]];
    
    //有缓存的时候去的消息id一定是大于清除缓存的前的消息id,这里只是为了防止拉离线消息的时候，出现大于清除缓存的消息id
    
    if (![NSString isEmpty:cacheModel.msg_id]) {
        
        msgModel.msg_id = cacheModel.msg_id;
    }
    
    NSArray *msgList = [JGJChatMsgDBManger getMsgModelsWithChatMsgListModel:msgModel];
    
//    //回执已读的消息给服务器
//    [self readedPullMsgs:msgList];
    
    //未读人数处理
    [self freshMyMsgUnreadNum:msgList];
    
    return msgList;
}

- (void)closeProFlag {
    
    if (self.workProListModel.isClosedTeamVc) {
        
        if (![self.view.subviews containsObject:self.clocedImageView]) {
            
            [self.view addSubview:self.clocedImageView];
        }
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self chatListAddKeyBoardObserver];
    
    //防止重复进入@人员列表，每次显示的时候清除标识
    
    self.is_openAtMemberVc = NO;
    
}

- (void)dealloc{
    [self chatListRemoveKeyBoardObserver];
    [TYNotificationCenter removeObserver:self];
}

#pragma mark - 键盘监控
- (void)chatListAddKeyBoardObserver{
    [TYNotificationCenter addObserver:self selector:@selector(chatListKeyboardDidShowFrame:) name:UIKeyboardWillShowNotification object:nil];
    [TYNotificationCenter addObserver:self selector:@selector(chatListKeyboardDidHiddenFrame:) name:UIKeyboardWillHideNotification object:nil];
    //初始耍是隐藏的
    self.isCanScroBottom = NO;
}

- (void)chatListRemoveKeyBoardObserver{
    [TYNotificationCenter removeObserver:self];
}

- (void)chatListKeyboardDidShowFrame:(NSNotification *)notification{
    
    // 如果正在切换键盘，就不要执行后面的代码
    //    if (self.chatInputView.switchingKeybaord) return;
    
    self.isCanScroBottom = YES;
    
    NSDictionary *userInfo = notification.userInfo;
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect endKeyboardRect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat yEndOffset = TYGetUIScreenHeight - endKeyboardRect.origin.y + _viewOffsetY;
    
    if (yEndOffset == 0) {
        return;
    }
    
    //增加高度
    [UIView animateWithDuration:duration animations:^{
        
        CGFloat offset = yEndOffset - TYGetViewH(self.chatBottomView) - (JGJ_IphoneX_Or_Later ? 34 : 0);
        
        self.bottomViewConstraintB.constant = offset;
        
        [self.bottomView layoutIfNeeded];
        
    }completion:^(BOOL finished) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self tableViewToBottom];
            
        });
        
    }];
    
}


//恢复
- (void)chatListKeyboardDidHiddenFrame:(NSNotification *)notification{
    
    //    NSDictionary *userInfo = notification.userInfo;
    double duration = 0.25;
    
    //如果正在切换相册、拍照、我的名片
    if (self.chatInputView.switchingMediaViewKeybaord) {
        
        return;
    }
    
    // 如果正在切换键盘，就不要执行后面的代码
    if (self.chatInputView.switchingKeybaord){
        
        //增加高度
        [UIView animateWithDuration:duration animations:^{
            
            self.bottomViewConstraintB.constant = EmotionKeyboardHeight;
            
            [self.bottomView layoutIfNeeded];
            
        }];
        
        return;
    }
    
    self.isCanScroBottom = NO;
    
    //增加高度
    [UIView animateWithDuration:duration animations:^{
        
        self.bottomViewConstraintB.constant = _viewOffsetY;
        
        [self.bottomView layoutIfNeeded];
        
        self.chatInputView.emotionKeyboard.y = TYGetUIScreenHeight;
        
    } completion:^(BOOL finished) {
        
        if (self.chatInputView.emotionKeyboard) {
            
            [self.chatInputView.emotionKeyboard removeFromSuperview];
        }
    }];
    
    //这句话写上退到后台关闭键盘
    if ([self.chatInputView.textView isFirstResponder]) {
        
        [self.view endEditing:YES];
        
    }
    
    //隐藏的时候，如果底部拍照、相册、我的名片一起隐藏
    
    if (self.mediaView) {
        
        [self dissMediaView];
    }
}

//滑动就结束编辑
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (!self.chatInputView.isDefaultChatInputViewType) {
        
        self.chatInputView.isDefaultChatInputViewType = YES;
        
    }
    
    self.chatInputView.switchingKeybaord = NO;
    
    [self.view endEditing:YES];
    
    //拖拽的时候隐藏底部、相册、拍摄、我的名片视图
    
    [self dissMediaView];
    
    [self chatListKeyboardDidHiddenFrame:nil];
    
}

#pragma mark - inputView的Delegate
#pragma mark 文字相关
- (void)changeHeight:(JGJChatInputView *)chatInputView addHeight:(CGFloat )addHeight{
    
    TYLog(@"1111_bottomRootViewOldH === %@  %@", @(_bottomRootViewOldH), @(addHeight));
    if (addHeight < 10) {
        self.bottomRootViewConstraintH.constant = _bottomRootViewOldH;
    }else{
        self.bottomRootViewConstraintH.constant = _bottomRootViewOldH + addHeight;
        _bottomRootViewAddH = addHeight;
    }
    
    TYLog(@"22222_bottomRootViewOldH === %@  %@", @(_bottomRootViewOldH), @(addHeight));
    
    [self scrollToBottom];
    
    [self.bottomView layoutIfNeeded];
    
    TYLog(@"3333_bottomRootViewOldH === %@   %@", @(_bottomRootViewOldH), @(addHeight));
}

- (void)scrollToBottom
{
    [self.tableView reloadData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        CGFloat offset = self.tableView.contentSize.height - self.tableView.height;
        
        [self.tableView setContentOffset:CGPointMake(0, offset) animated:YES];
        
    });
    
}

- (void)sendText:(JGJChatInputView *)chatInputView text:(NSString *)text{
    
    NSMutableString *mergeAtuidStr = [NSMutableString new];
    
    if (self.chatInputView.at_uid_arr.count > 0) {
        
        NSArray *atContactModels = self.chatInputView.at_uid_arr.copy;
        
        for (JGJSynBillingModel *contactModel in atContactModels) {
            
            NSString *atMemberName = [NSString stringWithFormat:@"@%@", contactModel.real_name];
            
            if (![chatInputView.textView.text containsString:atMemberName]) {
                
                [self.chatInputView.at_uid_arr removeObject:contactModel];
            }else {
                
                [mergeAtuidStr appendString:contactModel.uid?:@""];
            }
            
        }
    }
    
    [self addTextMessage:text at_uid:mergeAtuidStr];
    
    self.chatInputView.at_uid_arr = nil;
    
    self.bottomRootViewConstraintH.constant = _bottomRootViewOldH;
}

#pragma mark - 判断字符串的变化，是否有@
- (void)changeText:(JGJChatInputView *)chatInputView text:(NSString *)text{
    
    
    NSString *atMessage = [JGJTextViewTool inputView:self.chatInputView.textView handleAtMesage:text];
    /*
     if ([atMessage isEqualToString:@"@"]&&chatInputView.textView.text.length<=1) {
     JGJAddAdministratorListVc *atMmemberVc = [[UIStoryboard storyboardWithName:@"JGJCreatTeam" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJAddAdministratorListVc"];
     atMmemberVc.addMemberVcType = JGJAddAtMemberType;
     atMmemberVc.workProListModel = self.workProListModel;
     atMmemberVc.delegate = self;
     [self.navigationController pushViewController:atMmemberVc animated:YES];
     if (self.skipToNextVc) {
     self.skipToNextVc(atMmemberVc);
     }
     }
     */
    
    if ([self.workProListModel.class_type isEqualToString:@"singleChat"] || chatInputView.textView.isDelStatus) {
        
        return;
    }
    
    //是否已打开At人员控制器，防止重复进入
    
    if (self.is_openAtMemberVc) {
        
        return;
    }
    
    //当前不是删除状态isDelStatus，因为删除状态会遇见@
    if (([atMessage rangeOfString:@"@"].location !=NSNotFound && ![self.workProListModel.class_type isEqualToString:@"singleChat"] && !chatInputView.textView.isDelStatus && ![self.lastInputText isEqualToString:chatInputView.textView.text]) || (chatInputView.textView.text.length == 1 && [atMessage rangeOfString:@"@"].location !=NSNotFound && !chatInputView.textView.isDelStatus)) {
        
        self.is_openAtMemberVc = YES;
        
        //判断两次类容一样只跳转一次
        self.lastInputText = chatInputView.textView.text;
        
        JGJAddAdministratorListVc *atMmemberVc = [[UIStoryboard storyboardWithName:@"JGJCreatTeam" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJAddAdministratorListVc"];
        atMmemberVc.addMemberVcType = JGJAddAtMemberType;
        atMmemberVc.workProListModel = self.workProListModel;
        atMmemberVc.delegate = self;
        [self.navigationController pushViewController:atMmemberVc animated:YES];
        if (self.skipToNextVc) {
            self.skipToNextVc(atMmemberVc);
        }
        
    }
    
}

- (void)deleteText:(JGJChatInputView *)chatInputView text:(NSString *)text{
    
    
    
}

#pragma mark - JGJAddAdministratorListVcDelegate
- (void)addAdminList:(JGJAddAdministratorListVc *)addAdminListVc didSelectedMember:(JGJSynBillingModel *)member {
    [self.chatInputView.at_uid_arr addObject:member];
    [JGJTextViewTool inputTextView:self.chatInputView.textView insertTextView:member.full_name?:@""];
    
}


- (void)longTouchAvatar:(JGJChatListBaseCell *)chatListCell{
    NSString *atName = chatListCell.jgjChatListModel.user_info.full_name;
    //at人名字后台处理，此时输入框的显示使用后台处理
    
    NSString *myUid = [TYUserDefaults objectForKey:JLGUserUid];
    
    BOOL is_at_me = [myUid isEqualToString:chatListCell.jgjChatListModel.msg_sender];
    
    if ([self.workProListModel.class_type isEqualToString:@"singleChat"] || is_at_me) {
        return;
    }
    
    if ([NSString isEmpty:atName]) {
        
        atName = chatListCell.jgjChatListModel.user_info.real_name;
    }
    
    JGJSynBillingModel *atMemberModel = [JGJSynBillingModel new];
    atMemberModel.uid = chatListCell.jgjChatListModel.user_info.uid;
    
    atMemberModel.real_name = atName;
    [self.chatInputView.at_uid_arr addObject:atMemberModel];
    [JGJTextViewTool inputTextView:self.chatInputView.textView insertTextView:[NSString stringWithFormat:@"@%@",atName]];
    
    [self.chatInputView.textView becomeFirstResponder];
}

- (void)tapTouchAvatar:(JGJChatListBaseCell *)chatListCell {
    TYLog(@"%s ---进入个人详情页", __FUNCTION__);
    //    JGJPerInfoVc *perInfoVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJPerInfoVc"];
    //    perInfoVc.workProListModel = self.workProListModel;
    //    perInfoVc.jgjChatListModel.group_id = self.workProListModel.group_id;
    //    perInfoVc.jgjChatListModel.class_type = self.workProListModel.class_type;
    //    perInfoVc.jgjChatListModel.uid = chatListCell.jgjChatListModel.user_info.uid;
    //    if (self.skipToNextVc) {
    //        self.skipToNextVc(perInfoVc);
    //    }
    
    [self handleClickAvatarWithMsgModel:chatListCell.jgjChatListModel];
}

#pragma mark - 菜单栏显示，当前页面不滚动，隐藏则滚动
- (void)chatListBaseCell:(JGJChatListBaseCell *)chatListCell showMenu:(BOOL)isShowMenu {
    
    self.isMenuShow = isShowMenu;
    
}

#pragma mark - 点击了添加按钮
- (void)addBtnClick{
    if (self.bottomViewConstraintB.constant > 0) {
        return ;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.bottomViewConstraintB.constant = self.bottomViewConstraintB.constant == -self.bottomViewConstraintH.constant?0:(-self.bottomViewConstraintH.constant);
        [self.view layoutIfNeeded];
    }];
}

#pragma mark 成功添加录音
- (void)sendAudio:(JGJChatInputView *)chatInputView audioInfo:(NSDictionary *)audioInfo{
    if (audioInfo.allKeys.count == 0) {
        return ;
    }
    
    /**
     *  amrFilePath:amr文件的url路径
     *  fileName:amr文件的名字
     *  filePath:wav文件的路径
     *  fileName:amr文件的路径
     *  fileSize:文件的大小
     *  fileTime:文件的时间
     */
    NSInteger fileTime = [audioInfo[@"fileTime"] integerValue];
    //    if (fileTime != 0) {//长度不为0的录音
    //        [JLGHttpRequest_AFN uploadImagesWithApi:@"jlupload/upload" parameters:nil imagearray:nil otherDataArray:@[audioInfo[@"amrFilePath"]] dataNameArray:@[@"voice"] success:^(NSArray *responseObject) {
    //
    //            NSMutableDictionary *audioDic = audioInfo.mutableCopy;
    //            audioDic[@"msg_src"] = responseObject;
    //            [self addAudioMessage:audioDic];
    //        } failure:nil];
    //    }
    
    if (fileTime != 0) {//长度不为0的录音
        [JLGHttpRequest_AFN uploadImagesWithApi:@"jlupload/upload" parameters:nil imagearray:nil otherDataArray:@[audioInfo[@"amrFilePath"]] dataNameArray:@[@"voice"] success:^(NSArray *responseObject) {
            
            NSMutableDictionary *audioDic = audioInfo.mutableCopy;
            audioDic[@"msg_src"] = responseObject;
            [self addAudioMessage:audioDic];
        } failure:^(NSError *error) {
#pragma mark -此处修改无网络时显示加载数据 LYQ
            //            NSMutableDictionary *audioDic = audioInfo.mutableCopy;
            //            audioDic[@"msg_src"] = @[@""];
            //            [self addAudioMessage:audioDic];
            
        }];
    }
    
}

- (void)sendPic:(JGJChatInputView *)chatInputView audioInfo:(NSDictionary *)audioInfo{
    //    if (self.delegate && [self.delegate respondsToSelector:@selector(chatListVc:sendPic:)]) {
    //        [self.delegate chatListVc:self sendPic:audioInfo];
    //    }
    
    self.chatInputView.switchingMediaViewKeybaord = YES;
    
    //切换表情键盘取消
    self.chatInputView.switchingKeybaord = NO;
    
    [self.view addSubview:self.mediaView];
    
    //增加高度
    [UIView animateWithDuration:0.25 animations:^{
        
        CGFloat height = [JGJCusAddMediaView meidaViewHeight] + JGJ_IphoneX_BarHeight;
        
        CGFloat oriY = TYGetUIScreenHeight - [JGJCusAddMediaView meidaViewHeight] - JGJ_NAV_HEIGHT;
        
        self.bottomViewConstraintB.constant = [JGJCusAddMediaView meidaViewHeight];
        
        [self.bottomView layoutIfNeeded];
        
        self.mediaView.y =  TYGetUIScreenHeight - height - JGJ_NAV_HEIGHT;
        
    }completion:^(BOOL finished) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            self.chatInputView.switchingMediaViewKeybaord = NO;
            
            [self tableViewToBottom];
            
        });
        
    }];
}

#pragma mark 切换状态
- (void)changeStatus:(JGJChatInputView *)chatInputView statusType:(ChatInputType )statusType{
    if (statusType == ChatInputAudio) {
        self.bottomRootViewConstraintH.constant = _bottomRootViewOldH;
        [self.chatInputView.textView resignFirstResponder];
    }else{
        
        self.bottomRootViewConstraintH.constant = _bottomRootViewOldH + _bottomRootViewAddH;
        
        if ([NSString isEmpty:chatInputView.textView.text]) {
            
            self.bottomRootViewConstraintH.constant = _bottomRootViewOldH;
        }
        
        if (self.workProListModel.workCircleProType != WorkCircleExampleProType) {
            [self.chatInputView.textView becomeFirstResponder];
        }
    }
    
    [self.bottomView layoutIfNeeded];
    
    [self dissMediaView];
}

#pragma mark - 点击了底部的按钮
- (void)chatBottomBtnClick:(JGJChatBootomView *)chatBootomView button:(UIButton *)button{
    NSInteger selectedTag = button.tag;
    
    if ([self.workProListModel.class_type isEqualToString:@"team"]) {
        [self configTeamVc:selectedTag];
    }else{
        
        [self configGroupVc:selectedTag];
    }
    
    //    TYLog(@"点击了底部的第%@个",@(selectedTag));
}

//班组的配置
- (void)configGroupVc:(NSInteger )selectedTag{
    //    NSInteger baseIndex = [self.workProListModel.myself_group isEqualToString:@"1"]?0:1;
    NSInteger baseIndex = 0;
    NSString *exampleHUBStr = @"";
    NSInteger selectedIndex = selectedTag + baseIndex;
    if (self.workProListModel.workCircleProType == WorkCircleExampleProType) {
        if (selectedIndex == 0) {
            exampleHUBStr = @"发布工作通知";
        }else if(selectedIndex == 1){
            
            exampleHUBStr = @"发布质量";
        }else if(selectedIndex == 2){
            
            exampleHUBStr = @"发布安全";
        }else if(selectedIndex == 3){
            
            exampleHUBStr = @"记工记账";
        }
        
        
        exampleHUBStr = [NSString stringWithFormat:@"创建班组后点击这里可以%@\n这是示范数据，点击无效！",exampleHUBStr];
        [TYShowMessage showPlaint:exampleHUBStr];
        
        return ;
    }
    
    UIViewController *nextVc;
    switch (selectedIndex) {
        case 0:
        {
            JGJChatNoticeVc *chatNoticeVc= [[UIStoryboard storyboardWithName:@"JGJChat" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJChatNoticeVc"];
            
            chatNoticeVc.workProListModel = self.workProListModel;
            chatNoticeVc.chatListType = JGJChatListNotice;
            chatNoticeVc.pro_name = self.workProListModel.pro_name;
            nextVc = chatNoticeVc;
        }
            break;
            
        case 1:
        {
            JGJChatNoticeVc *chatNoticeVc= [[UIStoryboard storyboardWithName:@"JGJChat" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJChatNoticeVc"];
            
            chatNoticeVc.workProListModel = self.workProListModel;
            chatNoticeVc.chatListType = JGJChatListSafe;
            chatNoticeVc.pro_name = self.workProListModel.pro_name;
            
            nextVc = chatNoticeVc;
        }
            break;
            
        case 2:
        {
            JGJChatNoticeVc *chatNoticeVc= [[UIStoryboard storyboardWithName:@"JGJChat" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJChatNoticeVc"];
            
            chatNoticeVc.workProListModel = self.workProListModel;
            chatNoticeVc.chatListType = JGJChatListQuality;
            chatNoticeVc.pro_name = self.workProListModel.pro_name;
            nextVc = chatNoticeVc;
        }
            break;
            
        default:
            break;
    }
    
    if (self.skipToNextVc) {
        self.skipToNextVc(nextVc);
    }
}

//项目组的配置
- (void)configTeamVc:(NSInteger )selectedTag{
    //    NSInteger baseIndex = [self.workProListModel.myself_group isEqualToString:@"1"]?0:-1;
    NSInteger baseIndex = 0;
    NSString *exampleHUBStr = @"";
    if(selectedTag == 4 + baseIndex){
        if (self.workProListModel.workCircleProType == WorkCircleExampleProType) {
            exampleHUBStr = @"签到";
            exampleHUBStr = [NSString stringWithFormat:@"创建项目组后点击这里可以%@\n这是示范数据，点击无效！",exampleHUBStr];
            
            [TYShowMessage showPlaint:exampleHUBStr];
            return;
        }
        JGJChatSignVc *signVc= [[UIStoryboard storyboardWithName:@"JGJChat" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJChatSignVc"];
        signVc.signVcType = JGJChatSignVcUseType;
        signVc.workProListModel = self.workProListModel;
        signVc.chatListType = JGJChatListSign;
        if (self.parentVc) {
            JGJChatListSignVc *chatListSignVc = (JGJChatListSignVc *)[self.parentVc getChildVcWithType:JGJChatListSign];
            signVc.chatSignModel = chatListSignVc.chatSignModel;
            
            if (self.skipToNextVc) {
                self.skipToNextVc(signVc);
            }
        }
        return;
    }
    
    JGJChatNoticeVc *chatNoticeVc= [[UIStoryboard storyboardWithName:@"JGJChat" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJChatNoticeVc"];
    if (self.workProListModel.workCircleProType == WorkCircleExampleProType) {
        if (selectedTag == 0 + baseIndex) {
            chatNoticeVc.chatListType = JGJChatListNotice;
            exampleHUBStr = @"发布工作通知";
        }else if(selectedTag == 1 + baseIndex){
            chatNoticeVc.chatListType = JGJChatListSafe;
            exampleHUBStr = @"发布安全";
        }else if(selectedTag == 2 + baseIndex){
            chatNoticeVc.chatListType = JGJChatListQuality;
            exampleHUBStr = @"发布质量";
        }else if(selectedTag == 3 + baseIndex){
            chatNoticeVc.chatListType = JGJChatListLog;
            exampleHUBStr = @"发布工作日志";
        }
        
        exampleHUBStr = [NSString stringWithFormat:@"创建项目组后点击这里可以%@\n这是示范数据，点击无效！",exampleHUBStr];
        
        [TYShowMessage showPlaint:exampleHUBStr];
        
        return ;
    }
    
    chatNoticeVc.pro_name = self.workProListModel.pro_name;
    
    if (selectedTag == 0 + baseIndex) {
        chatNoticeVc.chatListType = JGJChatListNotice;
    }else if(selectedTag == 1 + baseIndex){
        chatNoticeVc.chatListType = JGJChatListSafe;
    }else if(selectedTag == 2 + baseIndex){
        chatNoticeVc.chatListType = JGJChatListQuality;
    }else if(selectedTag == 3 + baseIndex){
        chatNoticeVc.chatListType = JGJChatListLog;
    }else if(selectedTag == 4 + baseIndex){
        chatNoticeVc.chatListType = JGJChatListSign;
    }
    
    chatNoticeVc.workProListModel = self.workProListModel;
    
    if (self.skipToNextVc) {
        self.skipToNextVc(chatNoticeVc);
    }
}

#pragma mark - 监听下载音频的事件
- (void)chatListDownVoiceSuccess:(NSNotification *)notification {
    //如果下载完音频，就更新本地缓存
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //        if ([[notification object] isKindOfClass:[JGJChatMsgListModel class]]) {
    //            JGJChatMsgListModel *chatMsgListModel = (JGJChatMsgListModel *)[notification object];
    //            [self replaceSourceArrObject:chatMsgListModel];
    //        }
    //    });
    
    
    if ([[notification object] isKindOfClass:[JGJChatMsgListModel class]]) {
        JGJChatMsgListModel *chatMsgListModel = (JGJChatMsgListModel *)[notification object];
        [self replaceSourceArrObject:chatMsgListModel];
    }
}

- (void)setSuper_textView:(JGJChatListBaseCell *)baseCell{
    baseCell.super_textView = self.chatInputView.textView;
}

- (void)dissMediaView {
    
    if (self.mediaView) {
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.mediaView.y = TYGetUIScreenHeight;
            
        }];
    }
}

#pragma mark - JGJCusAddMediaViewDelegate 选择相册、拍摄、我的名片

- (void)cusAddMediaView:(JGJCusAddMediaView *)mediaView didSelBtnType:(JGJCusAddMediaViewBtnType)type {
    
    switch (type) {
            
        case JGJCusAddMediaViewPhotoAlbumBtnType: //相册
            
            break;
            
        case JGJCusAddMediaViewShootBtnType: //拍摄
            
            break;
            
        case JGJCusAddMediaViewPostCardType:{ //我的名片
            
            TYWeakSelf(self);
            
            [self getUserPostCard:^(id response) {
                
                JGJChatRecruitMsgModel *recruitMsgModel = [JGJChatRecruitMsgModel mj_objectWithKeyValues:response];
                
                JGJChatMsgListModel *msgModel = [JGJChatMsgListModel new];
                
                msgModel.recruitMsgModel = recruitMsgModel;
                
                msgModel.msg_text_other = [recruitMsgModel mj_JSONString];
                
                msgModel.group_id = weakself.workProListModel.group_id;
                
                msgModel.class_type = weakself.workProListModel.class_type;
                
                msgModel.msg_type = @"postcard";
                
                msgModel.send_time = [JGJChatMsgDBManger localTime];
                
                msgModel.local_id = [JGJChatMsgDBManger localID];
                
                //没有完成名片信息弹框提示
                
                if ([recruitMsgModel.is_info isEqualToString:@"0"]) {
                    
                    [weakself complePostCardInfo];
                    
                }else {
                    
                    [weakself sendPostCardWithMsgModel:msgModel];
                    
                }
                
            }];
            
        }
            
            break;
            
        default:
            break;
    }
    
    //这里处理 相册、拍摄
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatListVc:sendPic:)]) {
        
        [self.delegate chatListVc:self sendPic:nil];
        
    }
    
}

- (void)sendPostCardWithMsgModel:(JGJChatMsgListModel *)msgModel {
    
    //发送消息
    
    [self sendMsgToServicer:msgModel];
}

#pragma mark - 获取名片内容

- (void)getUserPostCard:(void (^)(id response))success {
    
    [JLGHttpRequest_AFN PostWithNapi:@"user/get-work-info-pro-info" parameters:nil success:^(id responseObject) {
        
        if (success) {
            
            success(responseObject);
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

- (void)complePostCardInfo {
    
    JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
    
    desModel.popDetail = @"你还未完善名片信息，无法发送名片";
    
    desModel.leftTilte = @"取消";
    
    desModel.rightTilte = @"现在去完善";
    
    desModel.messageFont = [UIFont systemFontOfSize:AppFont28Size];
    
    desModel.contentViewHeight = 131;
    
    JGJCustomPopView *alertView = [JGJCustomPopView showWithMessage:desModel];
    
    __weak typeof(self) weakSelf = self;
    
    alertView.onOkBlock = ^{
        
        [weakSelf handleCompleInfo];
    };
    
}

- (void)handleCompleInfo {
    
    //    http://nm.test.jgjapp.com/my/resume
    
    NSString *resumeUrl = [NSString stringWithFormat:@"%@my/resume",JGJWebDiscoverURL];
    
    JGJWebAllSubViewController *webVc =  [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:resumeUrl];
    
    if (self.skipToNextVc) {
        
        self.skipToNextVc(webVc);
        
    }
    
    
}


- (NSMutableArray *)inputViewInfoArray {
    if (!_inputViewInfoArray) {
        _inputViewInfoArray = [NSMutableArray array];
    }
    return _inputViewInfoArray;
}

- (JGJChatMsgRequestModel *)roamRequest {
    
    if (!_roamRequest) {
        
        _roamRequest = [[JGJChatMsgRequestModel alloc] init];
        
        _roamRequest.class_type = self.workProListModel.class_type;
        
        _roamRequest.group_id = self.workProListModel.group_id;
        
        _roamRequest.pagesize = JGJChatPageSize;
        
        _roamRequest.msg_id = @"0";
    }
    
    return _roamRequest;
}

@end

