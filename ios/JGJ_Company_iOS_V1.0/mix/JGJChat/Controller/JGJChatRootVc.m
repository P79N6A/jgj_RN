//
//  JGJChatRootVc.m
//  mix
//
//  Created by Tony on 2016/8/24.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatRootVc.h"

#import "TYBaseTool.h"
#import "SegmentTapView.h"
#import "HMSegmentedControl.h"
#import "IQKeyboardManager.h"
#import "CAGradientLayer+Mask.h"
#import "JGJChatSignVc.h"

//子vc
#import "JGJChatListBaseVc.h"
#import "JGJChatListAllVc.h"
#import "JGJChatListRecordVc.h"
#import "JGJChatListSafeVc.h"
#import "JGJChatListNoticeVc.h"
#import "JGJChatListQualityVc.h"
#import "JGJChatNoticeVc.h"
#import "JGJChatListLogVc.h"
#import "JGJChatListSignVc.h"
#import "NSString+Extend.h"
#import "JGJWebAllSubViewController.h"
#import "AFNetworkReachabilityManager.h"
#import "JGJTabBarViewController.h"
#import "JGJQuaSafeTool.h"
//3.4添加
#import "JGJSocketRequest+ChatMsgService.h"

#import "JGJChatMsgDBManger.h"

#import "NSDate+Extend.h"
#import "JGJDataManager.h"


@implementation JGJChatRootVcRedModel

@end

static const NSInteger kJGJChatRootVcSegmentY = 0;
static const NSInteger kJGJChatRootVcSegmentH = 40;

@implementation JGJChatRootChildVcModel
{
    
}
@end

typedef void(^HandleUnReadInfoBlock)();

@interface JGJChatRootVc ()
<
JGJChatListBaseVcDelegate,
HMSegmentedControlDelegate,
JGJWebViewDelegate

>

@property (weak, nonatomic) IBOutlet UIButton *releaseButton;

@property (nonatomic,strong) NSIndexPath *selectedCellIndexPath;

//标题数组
@property(strong, nonatomic) NSArray<NSString *> *titles;

//是否显示红点
@property(strong, nonatomic) NSMutableArray *showRedPointArray;

//记录选中的子控件索引值
@property(assign, nonatomic) NSInteger selectedSubVcIndex;

@property (strong, nonatomic) HMSegmentedControl *segmentTapView;

@property (nonatomic,assign) JGJChatListBelongType belongType;

//记录是否选择了单独的图片
@property (nonatomic,assign) BOOL isSelecetedPicCell;

@property (nonatomic,strong) UIButton *leftArrowButton;

@property (nonatomic,strong) UIButton *rightArrowButton;

@property (nonatomic,assign) JGJChatListIdentityType chatListIDType;

@property (nonatomic, copy) HandleUnReadInfoBlock handleUnReadInfoBlock; //处理未读消息

@property (nonatomic, strong) NSTimer *unReadInfoTimer;

@property (nonatomic, strong) UILabel *titleLable;

//是否正在读消息
@property (nonatomic, assign) BOOL isReaded;

@end

@implementation JGJChatRootVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self commonSet];
    
    // 添加已读回执的监控
    [self socketRequestReadedToSender];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive)
                                                 name:UIApplicationWillResignActiveNotification object:nil];
    
//    //是否进入聊天页面，锁屏后返回首页
//    [TYUserDefaults setBool:YES forKey:JGJIsChatLockScreen];
    // 设置群聊(一般群聊,班组,项目)的好友来源类型
    [self setFriendAddFromTypeOfGroupChat];
    
}

/**
 设置群聊(一般群聊,班组,项目)的好友来源类型
 */
- (void)setFriendAddFromTypeOfGroupChat
{
    if ([self.workProListModel.class_type isEqualToString:@"groupChat"]
        
        ) { // 群聊
        [JGJDataManager sharedManager].addFromType = JGJFriendAddFromGroupChat;
        
    } else if ([self.workProListModel.class_type isEqualToString:@"group"]){
        // 班组
        [JGJDataManager sharedManager].addFromType = JGJFriendAddFromtTeam;
        
    } else if ([self.workProListModel.class_type isEqualToString:@"team"]){
        // 项目
        [JGJDataManager sharedManager].addFromType = JGJFriendAddFromProject;
    }
}


- (void)setWorkProListModel:(JGJMyWorkCircleProListModel *)workProListModel{
    _workProListModel = workProListModel;
    //设置请求数据
    self.chatRootRequestModel = [JGJChatRootRequestModel new];
    self.chatRootRequestModel.group_id = _workProListModel.group_id;
    //    self.chatRootRequestModel.action = @"groupMessageList";
    self.chatRootRequestModel.class_type = _workProListModel.class_type;
    
    [self MultipleChoiceTableView];
    
    //  显示草稿信息
    [self showSendMessageDraft];
    
}

- (void)dealloc {
    
    [TYNotificationCenter removeObserver:self];
    
    TYLog(@"Chat销毁了");
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [IQKeyboardManager sharedManager].enable = YES;
    
    JGJChatListBaseVc *baseVc = [self.getChildVcs firstObject]; //2.1.0-yj
    [baseVc audioStopPlay];
    
    JGJChatListAllVc *firstVc = (JGJChatListAllVc *)self.childVcs[0].vc;
    
    if ([firstVc isKindOfClass:[JGJChatListAllVc class]]) {
        
        [self saveSendMessageDraft];
        
    }
//    
//    //是否进入聊天页面，锁屏后返回首页
//    [TYUserDefaults removeObjectForKey:JGJIsChatLockScreen];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self handleIsReadMsg:YES];
            
        });
        
    });
    
    //在聊天过程中，涉及到招工找活方面的关键词“找工作、招聘、招工、找活、包工” 是否显示提示防骗消息
    
    if ([NSString isEmpty:self.workProListModel.extent_msg]) {
        
        self.workProListModel.is_show_job_alertMsg = YES;
        
    }else {
        
        NSDate *extent_date = [NSDate timeSpStringToNSDate:self.workProListModel.extent_msg];
        
        self.workProListModel.is_show_job_alertMsg = !extent_date.isToday;
        
    }
}

#pragma mark - 处理进入页面开始读消息
-(void)handleIsReadMsg:(BOOL)isRead {
    
    //没读当前组的消息了
    self.isReaded = isRead;
    
    JGJChatMsgListModel *msgModel = [[JGJChatMsgListModel alloc] init];
    
    msgModel.group_id = self.workProListModel.group_id;
    
    msgModel.class_type = self.workProListModel.class_type;
    
    JGJChatMsgListModel *exsitMsgModel = [JGJChatMsgDBManger maxMsgListModelWithChatMsgListModel:msgModel];
    
    if ([NSString isEmpty:exsitMsgModel.msg_id]) {
        
        //是否正在读消息
        [JGJSocketRequest readedMsgModel:msgModel isReaded:isRead];
        
    }else {
        
        //是否正在读消息
        [JGJSocketRequest readedMsgModel:exsitMsgModel isReaded:isRead];
        
    }
    
}

#pragma mark - 保存发送的消息草稿
- (void)saveSendMessageDraft {
    
    JGJChatListAllVc *firstVc = (JGJChatListAllVc *)self.childVcs[0].vc;
    
    if ([firstVc isKindOfClass:[JGJChatListAllVc class]]) {
        
        JGJQuaSafeToolReplyModel *pubModel = [JGJQuaSafeToolReplyModel new];
        
        pubModel.group_id = self.workProListModel.group_id;
        
        pubModel.replyText = firstVc.chatInputView.textView.text?:@"";
        
        pubModel.class_type = self.workProListModel.class_type;
        
        pubModel.unique_id = [NSString stringWithFormat:@"%@%@%@", @"chat",self.workProListModel.class_type, self.workProListModel.group_id];
        
        [JGJQuaSafeTool addCollectReplyModel:pubModel];
        
    }
    
}

#pragma mark - 显示草稿消息
- (void)showSendMessageDraft {
    
    JGJChatListAllVc *firstVc = (JGJChatListAllVc *)self.childVcs[0].vc;
    
    firstVc.chatInputView.textView.text = @"";
    
    if ([firstVc isKindOfClass:[JGJChatListAllVc class]]) {
        
        JGJQuaSafeToolReplyModel *pubModel = [JGJQuaSafeToolReplyModel new];
        
        pubModel.group_id = self.workProListModel.group_id;
        
        pubModel.class_type = self.workProListModel.class_type;
        
        pubModel.unique_id = [NSString stringWithFormat:@"%@%@%@", @"chat",self.workProListModel.class_type, self.workProListModel.group_id];
        
        JGJQuaSafeToolReplyModel *replyModel = [JGJQuaSafeTool replyModel:pubModel];
        
        if (![NSString isEmpty:replyModel.replyText]) {
            
            firstVc.chatInputView.textView.text = replyModel.replyText;
            
            firstVc.chatInputView.textView.isShowDraft = YES;
            
        }
        
    }
    
}

#pragma mark - 接收消息的监控
- (void)socketRequestReciveMessage{
    
    JGJSocketRequest *shareSocket = [JGJSocketRequest shareSocketConnect];
    
    TYWeakSelf(self);
    
    shareSocket.receivedMsgCallback = ^(JGJChatMsgListModel *msgModel) {
        
        JGJChatListAllVc *firstVc = (JGJChatListAllVc *)self.childVcs[0].vc;
        
        //获取已存在的消息
        
        NSArray *msgs = firstVc.dataSourceArray;
        
        if (msgs.count > 0) {
            
            JGJChatMsgListModel *maxMsgModel = msgs.lastObject;
            
            //            NSArray *existMsgs = [JGJChatMsgDBManger getChatMsgModel:maxMsgModel];
            
            NSArray *existMsgs = @[msgModel];
            
            JGJChatMsgListModel *minMsgModel = msgs.firstObject;
            
            if (existMsgs.count > 0) {
                
                if (existMsgs.count == 1) {
                    
                    //当前消息进来的时间大于等于当前最小时间
                    
                    if (![NSString isEmpty:msgModel.send_time] && ![NSString isEmpty:minMsgModel.send_time]) {
                        
                        if ([msgModel.send_time integerValue] < [minMsgModel.send_time integerValue]) {
                            
                            return ;
                        }
                    }
                    
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"msg_id=%@",msgModel.msg_id];
                    
                    NSArray *filterMsgs = [msgs filteredArrayUsingPredicate:predicate];
                    
                    //如果是撤回类型替换数据
                    
                    if ([msgModel.msg_type isEqualToString:@"recall"]) {
                        
                        for (JGJChatMsgListModel *existMsgModel in filterMsgs) {
                            
                            existMsgModel.msg_text = msgModel.msg_text;
                            
                            existMsgModel.msg_type = msgModel.msg_type;
                            
                            [firstVc.tableView reloadData];
                            
                            break;
                        }
                        
                    }
                    
                    //已存在的消息，这不添加.除了撤回lei'ixng
                    
                    if (filterMsgs.count > 0 && ![msgModel.msg_type isEqualToString:@"recall"]) {
                        
                        return ;
                    }
                    
                    //添加显示的消息
                    [weakself addMsglistModel:existMsgs.lastObject];
                    
                    JGJChatMsgListModel *moneyModel = [JGJChatMsgDBManger containSpecialWordsWithMsgModel:existMsgs.lastObject];
                    
                    //包含金钱、转账等处理
                    if (moneyModel) {
                        
                        [weakself addMsglistModel:moneyModel];
                        
                    }
                    
                    //招工信息提示框
                    
                    if ([self.workProListModel.class_type isEqualToString:@"groupChat"] && self.workProListModel.is_show_job_alertMsg) {
                        
                        JGJChatMsgListModel *jobSpecialMsgModel = [JGJChatMsgDBManger jobContainSpecialWordsWithMsgModel:existMsgs.lastObject];
                        
                        //包含金钱、转账等处理
                        if (jobSpecialMsgModel) {
                            
                            [weakself addMsglistModel:jobSpecialMsgModel];
                            
                            self.workProListModel.is_show_job_alertMsg = NO;
                            
                            //今天已经出现了招工提示信息 (每人每天第一次聊天出现这类词时，提示防骗消息；)
                            
                            NSString *time = [NSDate date].timestamp;
                            
                            self.workProListModel.extent_msg = time;
                            
                            [self updateGroupChatWithProListModel:self.workProListModel extent_msg:time];
                            
                        }
                    }
                    
                }else {
                    
                    //多条消息直接显示
                    
                    [firstVc.dataSourceArray addObjectsFromArray:existMsgs];
                    
                    //接收到消息是否滚动到顶部
                    [self tabScroTop];
                    
                    [firstVc tableViewToBottom];
                    
                }
                
            }
            
        }
        
    };
    
}

#pragma mark - 更新 extent_msg是昨天或者是空的信息就显示。

- (void)updateGroupChatWithProListModel:(JGJMyWorkCircleProListModel *)proListModel extent_msg:(NSString *)extent_msg {
    
    JGJChatGroupListModel *chatGroupModel = [JGJChatMsgDBManger getChatGroupListModelWithGroup_id:proListModel.group_id classType:proListModel.class_type];
    
    chatGroupModel.extent_msg = extent_msg;
    
    [JGJChatMsgDBManger updateExtentMsgWithChatGroupListModel:chatGroupModel];
    
}

- (void)addMsglistModel:(JGJChatMsgListModel *)chatMsgListModel {
    
    if (![self isSameIDAndGroup:chatMsgListModel]) {
        
        return ;
    }
    
//    if (chatMsgListModel.work_message == 1 ) {
//        
//        NSString *error = [NSString stringWithFormat:@"%@ %@  %@",  chatMsgListModel.class_type, chatMsgListModel.group_id ,chatMsgListModel.msg_id];
//        
//        TYLog(@"error == %@", error);
//        
//        [TYShowMessage showHUDOnly:error];
//        
//        return;
//    }
    
    //    //uid为空不显示
    //    if ([NSString isEmpty:chatMsgListModel.user_info.uid] || [chatMsgListModel.user_info.uid isEqualToString:@"0"]) {
    //
    //        return;
    //    }
    
    //二维码扫描接收的信息不添加
    if (chatMsgListModel.is_qr_code) {
        return;
    }
    
    JGJChatListAllVc *firstVc = (JGJChatListAllVc *)self.childVcs[0].vc;
    
    //暂时去掉排重数据
    
    //    BOOL is_eliminate = NO;
    
    //    //重复的数据不添加 2.3.2添加
    //
    //    if (chatMsgListModel.chatListType != JGJChatListRecall && ![chatMsgListModel.msg_text isEqualToString:JGJSpecialWords]) {
    //
    //        return;
    //    }
    
    //接收到消息是否滚动到顶部
    [self tabScroTop];
    
    [firstVc addReceiveSourceArrWith:chatMsgListModel];
    
}

//接收到消息是否滚动到顶部
- (void)tabScroTop {
    
    JGJChatListAllVc *firstVc = (JGJChatListAllVc *)self.childVcs[0].vc;
    
    CGPoint offset = firstVc.tableView.contentOffset;
    CGRect bounds = firstVc.tableView.bounds;
    CGSize size = firstVc.tableView.contentSize;
    UIEdgeInsets inset = firstVc.tableView.contentInset;
    CGFloat currentOffset = offset.y + bounds.size.height - inset.bottom;
    CGFloat maximumOffset = size.height;
    
    //当前距离在屏幕中间时接收到消息不滚动，键盘显示滚动到最新消息
    
    CGFloat topScroOffset = maximumOffset - currentOffset;
    
    //收到新消息滚动到顶部
    firstVc.isCanScroBottom = topScroOffset < 200;
    
}

#pragma mark - 已读回执的监控
- (void)socketRequestReadedToSender{
    
    __weak typeof(self) weakSelf = self;
    
    JGJSocketRequest *shareSocket = [JGJSocketRequest shareSocketConnect];
    
    shareSocket.messageReadedCallback = ^(JGJChatMsgListModel *readedMsgModel) {
        
        JGJChatMsgListModel *readMsgList = readedMsgModel;
        
        //保存已读人员信息
        
        JGJChatListAllVc *firstVc = (JGJChatListAllVc *)self.childVcs[0].vc;
    
        NSArray *messageReadeds = firstVc.messageReadedToSenderTask.copy;
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"msg_id == %@", readMsgList.msg_id];
        
        JGJChatMsgListModel *msgModel = [messageReadeds filteredArrayUsingPredicate:predicate].lastObject;
        
        //不存在就添加
        if ([NSString isEmpty:msgModel.msg_id]) {
            
            [firstVc.messageReadedToSenderTask addObject:readMsgList];
            
        }else {
            
            //相同消息保留最后一个
            
            if (msgModel) {
                
                [firstVc.messageReadedToSenderTask removeObject:msgModel];
            }
            
        }
        
        //开启timer
        [self unReadInfoTimer];
        
        if (![weakSelf isSameIDAndGroup:readMsgList] && ![self.workProListModel.class_type isEqualToString:@"singleChat"]) {
            return ;
        }
        
        self.handleUnReadInfoBlock = ^{
            
            if (firstVc.messageReadedToSenderTask.count > 0) {
                
                JGJChatMsgListModel *senderTaskmsgModel = firstVc.messageReadedToSenderTask.lastObject;
                
                [firstVc readedMsgWith:senderTaskmsgModel];
                
                //更新未读消息人数
                [JGJChatMsgDBManger updateSendMessageUnreadNumWithMsgModel:senderTaskmsgModel];
                
            }else {
                
                [weakSelf unReadInfoTimerInvalidate];
            }
            
        };
        
    };
    
}

#pragma mark - 是否是相同的组和ID
- (BOOL )isSameIDAndGroup:(JGJChatMsgListModel *)chatMsgListModel{
    if ([NSString isEmpty:chatMsgListModel.group_id]) {
        return NO;
    }
    
    BOOL isSameGroup_id = [chatMsgListModel.group_id isEqualToString:self.workProListModel.group_id];
    BOOL isSameGroup_type = [chatMsgListModel.class_type isEqualToString:self.workProListModel.class_type];
    
    return isSameGroup_id && isSameGroup_type;
}

- (void )commonSet{
    
    self.belongType = [self.workProListModel.myself_group boolValue]?JGJChatListBelongMine:JGJChatListBelongOther;
    
    //必要的设置, 如果没有设置可能导致内容显示不正常
    self.automaticallyAdjustsScrollViewInsets = NO;
    //    group_chat_icon
    BOOL isSingleChat = [self.workProListModel.class_type isEqualToString:@"singleChat"];
    NSString *imageStr = isSingleChat ? @"icon_single_right" :  @"icon_group_right";
    if (isSingleChat) {
        self.rightItem.title = nil;
    }
    self.rightItem.image = [UIImage imageNamed:imageStr];
    
     [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    
    //设置action
    self.chatRootRequestModel.ctrl = @"message";
    
    self.chatRootRequestModel.pageturn = @"next";
    
    self.maxImageCount = 9;
    
    self.view.backgroundColor = AppFontF6F6F6Color;
}

- (void)setNavigationLeftButtonItem {
    SEL getLeftButton = NSSelectorFromString(@"getLeftNoTargetButton");
    IMP imp = [self.navigationController methodForSelector:getLeftButton];
    UIButton* (*func)(id, SEL) = (void *)imp;
    UIButton *leftButton = func(self.navigationController, getLeftButton);
    
    [leftButton addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
}

- (void)backBtnClick:(id)sender{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self handleIsReadMsg:NO];
            
        });
        
    });
    
    [_unReadInfoTimer invalidate];
    
    _unReadInfoTimer = nil;
    
    //更新正在发送的消息状态
    
    [self updateSendMsgStatus];
    
    __block UIViewController *notifyVC = nil;
    
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSClassFromString(@"JGJNewNotifyVC")]) {
            notifyVC = obj;
            *stop = YES;
        }
    }];
    
    //包含就返回
    if (notifyVC) {
        
        [self.navigationController popToViewController:notifyVC animated:YES];
        
    }else if (self.workProListModel.chatfindJobModel || self.workProListModel.isDynamic) {
        
        if (self.chatRootBackBlock) {
            
            self.chatRootBackBlock();
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        
        //关掉 返回的JGJQRCodeVc、JGJJoinGroupVc这两个页面4.0.0只改吉工家
        NSInteger popIndex = 1;

        for (UIViewController *vc in self.navigationController.viewControllers) {

            if ([vc isKindOfClass:NSClassFromString(@"JGJQRCodeVc")] || [vc isKindOfClass:NSClassFromString(@"JGJJoinGroupVc")]) {

                popIndex++;
            }

        }
        
        NSInteger vcCount = self.navigationController.viewControllers.count;

        popIndex = vcCount - popIndex - 1;

        if (popIndex >= 0) {

            UIViewController *vc = self.navigationController.viewControllers[popIndex];

            [self.navigationController popToViewController:vc animated:YES];

        }else {

            [self.navigationController popToRootViewControllerAnimated:YES];

        }
        
//         [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
    
//    //页面返回强制显示
//
//    [self viewWillHiddenTabbar:NO];
}

#pragma mark - 更新发送消息状态
- (void)updateSendMsgStatus {
    
    JGJChatMsgListModel *msgModel = [[JGJChatMsgListModel alloc] init];
    
    msgModel.group_id = self.workProListModel.group_id;
    
    msgModel.class_type = self.workProListModel.class_type;
    
    msgModel.sendType = JGJChatListSendFail;
    
    [JGJChatMsgDBManger updateUnreadMsgSendTypePropertyWithJGJChatMsgListModel:msgModel propertyListType:JGJChatMsgDBUpdateSendMsgStatusPropertyType];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [IQKeyboardManager sharedManager].enable = NO;
    
    //添加接收消息的监控
    [self socketRequestReciveMessage];
    
    //设置标题
    [self setTitleInfo];
    
    [self.childVcs enumerateObjectsUsingBlock:^(JGJChatRootChildVcModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.vc viewWillAppear:animated];
    }];
    
    [self setNavigationLeftButtonItem];
    
    if (self.workProListModel.chatfindJobModel) {
        
        for (UIViewController *curVc in self.navigationController.viewControllers) {
            
            if ([curVc isKindOfClass:[JGJTabBarViewController class]]) {
                JGJTabBarViewController *tabBarVc = (JGJTabBarViewController *)curVc;
                
                for (UIViewController *curWebVc in tabBarVc.viewControllers) {
                    
                    if ([curWebVc isKindOfClass:[JGJWebAllSubViewController class]]) {
                        
                        JGJWebAllSubViewController *webVc = (JGJWebAllSubViewController *)curWebVc;
                        webVc.isUnlogin = YES;
                    }
                    
                }
            }
        }
    }
    
    //显示草稿信息
    //    [self showSendMessageDraft];
    
    //添加表情监听
    
    JGJChatListAllVc *firstVc = (JGJChatListAllVc *)self.childVcs[0].vc;
    
    if ([firstVc isKindOfClass:[JGJChatListAllVc class]]) {
        
        [firstVc.chatInputView addObserver];
        
    }
    
    //页面显示强制隐藏底部
    
    [self viewWillHiddenTabbar:YES];
}
#pragma mark - 页面显示强制，隐藏底部，这里为了处理异常显示底部

- (void)viewWillHiddenTabbar:(BOOL)isHidden {
    
    for (UIViewController *contactVc in self.navigationController.viewControllers) {
        
        if ([contactVc isKindOfClass:NSClassFromString(@"JGJContactedListVc")]) {
            
            JGJTabBarViewController *tabBarVc = (JGJTabBarViewController *)contactVc.tabBarController;
            
            if ([tabBarVc isKindOfClass:NSClassFromString(@"JGJTabBarViewController")]) {
                
                tabBarVc.tabBar.hidden = isHidden;
                
            }
            break;
        }
        
    }
}

-(void)MultipleChoiceTableView{
    
    __weak typeof(self) weakSelf = self;
    
    if ([self.view.subviews containsObject:self.mulChoiceView]) {
        
        return;
    }
    
    self.childVcs = [[NSMutableArray alloc] init];
    
    //添加子控制器
    JGJChatListAllVc *allVc = [[UIStoryboard storyboardWithName:@"JGJChat" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJChatListAllVc"];
    
    
    JGJChatRootChildVcModel *childVcModel = [JGJChatRootChildVcModel new];
    
    childVcModel.vc = allVc;
    
    childVcModel.vcType = [self.workProListModel.class_type isEqualToString:@"singleChat"] ? JGJChatListSingleChat :JGJChatListGroupChat;
    
    [self.childVcs addObject:childVcModel];
    
    //配置子控制器
    [self.childVcs enumerateObjectsUsingBlock:^(JGJChatRootChildVcModel *childVcModel, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController *obj = childVcModel.vc;
        __strong typeof(weakSelf) strongSelf = weakSelf;
        obj.view.tag = idx + 1;
        
        if ([obj isKindOfClass:[JGJChatListBaseVc class]]) {
            JGJChatListBaseVc *baseVc = (JGJChatListBaseVc *)obj;
            baseVc.delegate = self;
            baseVc.workProListModel = strongSelf.workProListModel;
            baseVc.chatListRequestModel = strongSelf.chatRootRequestModel;
            baseVc.parentVc = strongSelf;
            
            //进入下一个界面
            baseVc.skipToNextVc = ^(UIViewController *nextVc){
                [weakSelf.navigationController pushViewController:nextVc animated:YES];
            };
        }
    }];
    
    CGFloat height = TYGetUIScreenHeight - 64 - JGJ_IphoneX_BarHeight;
    
    CGFloat mulChoiceY = 0;
    self.mulChoiceView = [[MultipleChoiceTableView alloc] initWithFrame:CGRectMake(0, mulChoiceY, TYGetUIScreenWidth, height) withArray:[self getChildVcs] inView:self.view];
    self.mulChoiceView.delegate = self;
    
}

- (NSArray *)getChildVcs{
    NSMutableArray *childVcs = [NSMutableArray new];
    for (JGJChatRootChildVcModel *childVcModel in self.childVcs) {
        [childVcs addObject:childVcModel.vc];
    }
    
    return childVcs.copy;
}

- (UIViewController *)getChildVcWithType:(JGJChatListType )chatListType{
    __block UIViewController *childVc = nil;
    [self.childVcs enumerateObjectsUsingBlock:^(JGJChatRootChildVcModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.vcType == chatListType) {
            childVc = obj.vc;
            *stop = YES;
        }
    }];
    return childVc;
}

- (NSInteger )getChildVcIndexWithType:(JGJChatListType )chatListType{
    __block NSInteger index = 0;
    [self.childVcs enumerateObjectsUsingBlock:^(JGJChatRootChildVcModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.vcType == chatListType) {
            index = idx;
            *stop = YES;
        }
    }];
    return index;
}

#pragma mark - cell的delegate
#pragma mark 点击了图片
- (void)chatListVc:(JGJChatListBaseVc *)listVc selectedPhoto:(id )chatListCell index:(NSInteger)index image:(UIImage *)image{
    
    [self checkImageHiddenNav];
    
    self.imageSelectedIndex = index;
    self.selectedSubVcIndex = listVc.view.tag - 1;
    
    if ([chatListCell isKindOfClass:[JGJChatListBaseCell class]]) {
        JGJChatListBaseCell *chatListBaseCell = chatListCell;
        self.selectedCellIndexPath = chatListBaseCell.indexPath;
    }else if([chatListCell isKindOfClass:[JGJChatOtherListell class]]){
        JGJChatOtherListell *chatOtherListell = chatListCell;
        self.selectedCellIndexPath = chatOtherListell.indexPath;
    }
    
    self.isSelecetedPicCell = NO;
    [self pushPhotoBroswerWithStyle:LGShowImageTypeImageURL];
    
    
}

#pragma mark - 查看图片隐藏导航栏问题
- (void)checkImageHiddenNav {
    
    for (UIViewController *contactVc in self.navigationController.viewControllers) {
        
        if ([contactVc isKindOfClass:NSClassFromString(@"JGJContactedListVc")]) {
            
            JGJTabBarViewController *tabBarVc = (JGJTabBarViewController *)contactVc.tabBarController;
            
            if ([tabBarVc isKindOfClass:NSClassFromString(@"JGJTabBarViewController")]) {
                
                tabBarVc.is_HiddenNav = YES;
                
            }
            break;
        }
        
    }
}

- (void)chatListVc:(JGJChatListBaseVc *)listVc readMessage:(NSDictionary *)readMessage{
    
}

- (void)chatListVc:(JGJChatListBaseVc *)listVc seletctedPicCell:(NSIndexPath *)indexPath{
    self.selectedSubVcIndex = listVc.view.tag - 1;
    self.selectedCellIndexPath = indexPath;
    
    [self.imagesArray removeAllObjects];
    JGJChatListBaseVc *baseVc = (JGJChatListBaseVc *)self.childVcs[0].vc;
    
    TYWeakSelf(self);
    [baseVc.dataSourceArray enumerateObjectsUsingBlock:^(JGJChatMsgListModel *chatMsgListModel, NSUInteger idx, BOOL * _Nonnull stop) {
        if (chatMsgListModel.chatListType == JGJChatListPic) {
            if (chatMsgListModel.picImage) {
                [weakself.imagesArray addObject:chatMsgListModel.picImage];
            }else{
                
                if (chatMsgListModel.msg_src.count > 0) {
                    
                    [weakself.imagesArray addObject:[chatMsgListModel.msg_src firstObject]];
                    
                }

            }
            
            if (indexPath.row == idx) {
                weakself.imageSelectedIndex = weakself.imagesArray.count - 1;
            }
        }
    }];
    
    if (self.imagesArray.count > 0) {
        
        self.isSelecetedPicCell = YES;
        
        [self pushPhotoBroswerWithStyle:LGShowImageTypeImageURL];
        
    }
    
}

#pragma mark - LGPhotoPickerBrowserViewControllerDataSource
- (NSInteger)photoBrowser:(LGPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
    JGJChatListBaseVc *baseVc = (JGJChatListBaseVc *)self.childVcs[self.selectedSubVcIndex].vc;
    
    if (!self.isSelecetedPicCell) {
        JGJChatMsgListModel *chatListModel;
        if ([baseVc isKindOfClass:[JGJChatOhterListBaseVc class]]) {
            JGJChatOtherMsgListModel *chatOtherMsgListModel = baseVc.dataSourceArray[self.selectedCellIndexPath.section];
            
            chatListModel = chatOtherMsgListModel.list[self.selectedCellIndexPath.row];
        }else{
            chatListModel = baseVc.dataSourceArray[self.selectedCellIndexPath.row];
        }
        
        
        return chatListModel.msg_src.count;
    }else{
        JGJChatMsgListModel *chatListModel = chatListModel = baseVc.dataSourceArray[self.selectedCellIndexPath.row];
        
        return self.imagesArray.count;
    }
}

- (id<LGPhotoPickerBrowserPhoto>)photoBrowser:(LGPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath{
    
    JGJChatListBaseVc *baseVc = (JGJChatListBaseVc *)self.childVcs[self.selectedSubVcIndex].vc;
    
    JGJChatMsgListModel *chatListModel;
    
    NSMutableArray *imagesArr = [NSMutableArray array];
    
    if (!self.isSelecetedPicCell) {
        if ([baseVc isKindOfClass:[JGJChatOhterListBaseVc class]]) {
            JGJChatOtherMsgListModel *chatOtherMsgListModel = baseVc.dataSourceArray[self.selectedCellIndexPath.section];
            
            chatListModel = chatOtherMsgListModel.list[self.selectedCellIndexPath.row];
        }else{
            chatListModel = baseVc.dataSourceArray[self.selectedCellIndexPath.row];
        }
        
        imagesArr = chatListModel.msg_src.mutableCopy;
    }else{
        imagesArr = self.imagesArray.mutableCopy;
    }
    
    NSMutableArray *LGPhotoPickerBrowserURLArray = [[NSMutableArray alloc] init];
    for (id pic in imagesArr) {
        LGPhotoPickerBrowserPhoto *photo = [[LGPhotoPickerBrowserPhoto alloc] init];
        
        if ([pic isKindOfClass:[NSString class]]) {
            photo.photoURL = [NSURL URLWithString:[JLGHttpRequest_IP stringByAppendingString:pic  ]];
        }else if([pic isKindOfClass:[UIImage class]]){
            photo.photoImage = pic;
        }
        
        [LGPhotoPickerBrowserURLArray addObject:photo];
    }
    return [LGPhotoPickerBrowserURLArray objectAtIndex:indexPath.item];
}

#pragma mark - 增加通知类内容
- (void)addAllNotice:(NSDictionary *)dataInfo{
    
    NSMutableArray <JGJChatListBaseVc *>*subVcsArr = @[self.childVcs[0].vc].mutableCopy;
    JGJChatListType chatListType = (JGJChatListType )[dataInfo[@"chatListType"] integerValue];
    
    if (chatListType != JGJChatListRecord && chatListType != JGJChatListSign && chatListType !=  JGJChatListCount) {
        [self.childVcs enumerateObjectsUsingBlock:^(JGJChatRootChildVcModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (chatListType == obj.vcType) {
                JGJChatListBaseVc *baseVc = (JGJChatListBaseVc *)obj.vc;
                [baseVc.tableView.mj_header beginRefreshing];
                [subVcsArr addObject:(JGJChatListBaseVc *)obj.vc];
            }
        }];
    }
    
    [self addAllNotice:dataInfo subVcs:subVcsArr.copy];
}

- (void)addAllNotice:(NSDictionary *)dataInfo subVcs:(NSArray <JGJChatListBaseVc *>*)subVcsArr{
    //在外面处理的目的就是只发一次
    JGJChatListBaseVc *chatListBaseVc  = [subVcsArr firstObject];//因为第一个的参数都是有的
    
    JGJChatMsgListModel *listModel = [chatListBaseVc cofigAllNotice:dataInfo];
    
    listModel = [chatListBaseVc cofigMineCommonData:listModel];
    
    //增加数据
    [subVcsArr enumerateObjectsUsingBlock:^(JGJChatListBaseVc * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj addSourceArrWith:listModel];
    }];
    
    [self sendSocket:chatListBaseVc listModel:listModel subVcs:subVcsArr];
}

- (void)sendSocket:(JGJChatListBaseVc *)chatListBaseVc listModel:(JGJChatMsgListModel *)listModel subVcs:(NSArray <JGJChatListBaseVc *>*)subVcsArr{
    
    //发送到服务器
    NSDictionary *parameters = [chatListBaseVc configParameters:listModel];
    
    [JGJSocketRequest WebSocketWithParameters:parameters success:^(id responseObject) {
        
        JGJChatMsgListModel *chatMsgListModel= [JGJChatMsgListModel mj_objectWithKeyValues:responseObject];
        
        chatMsgListModel.sendType = JGJChatListSendSuccess;
        
        //替换数据
        [subVcsArr enumerateObjectsUsingBlock:^(JGJChatListBaseVc * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj replaceSourceArrObject:chatMsgListModel];
        }];
    } failure:nil];
}

#pragma mark - 进入班组管理班组信息界面
- (IBAction)skipToManagerVc:(id)sender {
    JGJChatListBaseVc *chatListBaseVc  = (JGJChatListBaseVc *)self.childVcs[0].vc;
    [chatListBaseVc.view endEditing:YES];
    
    //    self.workProListModel.class_type == group 调用 teamMangerVC
    //    self.workProListModel.class_type == team 调用 JGJGroupMangerVC  不好意思ShocDoc有些地方名称写反了，我的控制器名字也反了后面更改
    NSString *vcIdentifier = [self.workProListModel.class_type isEqualToString:@"group"] ? @"JGJTeamMangerVC" : @"JGJGroupMangerVC";
    UIViewController *mangerVC = [[UIStoryboard storyboardWithName:@"JGJTeamManger" bundle:nil] instantiateViewControllerWithIdentifier:vcIdentifier];
    [mangerVC setValue:self.workProListModel forKey:@"workProListModel"];
    
    
    [self.navigationController pushViewController:mangerVC animated:YES];
}

#pragma mark - 图片相关 这里父类只处理相册和拍摄。延用之前的逻辑
- (void)chatListVc:(JGJChatListBaseVc *)listVc sendPic:(NSDictionary *)readMessage{
    
    //    [self.sheet showInView:self.view];
    
    JGJCusAddMediaViewBtnType btntye = listVc.mediaView.btnType;
    
    switch (btntye) {
            
        case JGJCusAddMediaViewPhotoAlbumBtnType:{ //相册
            
            [self selPhotoAlbum];
        }
            
            break;
            
        case JGJCusAddMediaViewShootBtnType: {//拍摄
            
            [self selTakePhoto];
        }
            
            break;
            
        default:
            break;
    }
    
}

- (void)applicationWillResignActive {
    
    if (self.sheet) {
        
        [self.sheet dismissWithClickedButtonIndex:self.sheet.cancelButtonIndex animated:YES];
        
    }
}

#pragma mark - 选取了图片
- (void)phoneVc:(UIPhotoViewController *)phoneVc imagesArrayAddEnd:(NSArray *)imagesArr{
    
    NSMutableArray *images = [NSMutableArray new];
    
    //当查看图片之后再拍照，imageArr有图片地址。
    for (UIImage *image in imagesArr) {
        
        if ([image isKindOfClass:[UIImage class]]) {
            
            [images addObject:image];
        }
    }
    
    imagesArr = images;
    
    [self.imagesArray removeAllObjects];
    [self.selectedAssets removeAllObjects];
    
    //    //2.1.0-yj----网络连接不可用处理开始
    //    AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
    //    AFNetworkReachabilityStatus status = manger.networkReachabilityStatus;
    //    BOOL isReachableStatus = status == AFNetworkReachabilityStatusNotReachable;
    //    //没有网络标红
    //    if (isReachableStatus) {
    //        return;
    //    }
    //2.1.0-yj----网络连接不可用处理结束
    
    if ([self.childVcs[0].vc isKindOfClass:[JGJChatListAllVc class]]) {
        JGJChatListAllVc *chatListAllVc  = (JGJChatListAllVc *)self.childVcs[0].vc;
        
        //3.4添加选择的图片
        chatListAllVc.chatSelAssets = self.chatSelAssets;
        
        [chatListAllVc addPicMessage:imagesArr];
        
    }
}

#pragma mark - 网页添加数据来源人
- (void)webViewAddSource:(JGJWebAllSubViewController *)webView{
    [self skipToManagerVc:nil];
}

- (NSTimer *)unReadInfoTimer {
    
    JGJChatListAllVc *firstVc = (JGJChatListAllVc *)self.childVcs[0].vc;
    
    if (!_unReadInfoTimer) {
        
        // 调用了scheduledTimer返回的定时器，已经自动被添加到当前runLoop中，而且是NSDefaultRunLoopMode
        //间隔0.1s执行下一个任务
        _unReadInfoTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(freshProgress:) userInfo:nil repeats:YES];
        
        // 修改模式
        [[NSRunLoop currentRunLoop] addTimer:_unReadInfoTimer forMode:NSRunLoopCommonModes];
    }
    
    return _unReadInfoTimer;
}

- (void)freshProgress:(NSTimer *)timer {
    
    if (self.handleUnReadInfoBlock) {
        
        self.handleUnReadInfoBlock();
    }
    
    //    TYLog(@"freshProgress");
    
    [self unReadInfoTimerInvalidate];
    
}

- (void)unReadInfoTimerInvalidate {
    
    JGJChatListAllVc *firstVc = (JGJChatListAllVc *)self.childVcs[0].vc;
    
    if (firstVc.messageReadedToSenderTask.count == 0 || !firstVc.messageReadedToSenderTask) {
        
        [_unReadInfoTimer invalidate];
        
        _unReadInfoTimer = nil;
        
        TYLog(@"未读人数--Timerinvalidate");
        
    }
    
}

#pragma mark - 排除重复数据
- (BOOL)eliminateDuplicateDataWithChatMsgListModel:(JGJChatMsgListModel *)chatMsgListModel {
    
    BOOL isDupMsg = NO; //是否是重复消息
    
    JGJChatListAllVc *firstVc = (JGJChatListAllVc *)self.childVcs[0].vc;
    
    NSArray *subArray = nil;
    
    NSRange subRange = NSMakeRange(0, 0);
    
    NSInteger subLength = 10;
    
    if (firstVc.dataSourceArray.count >= subLength) {
        
        subRange = NSMakeRange(firstVc.dataSourceArray.count - subLength, subLength);
        
    }else {
        
        subRange = NSMakeRange(0, firstVc.dataSourceArray.count);
        
    }
    
    subArray = [firstVc.dataSourceArray subarrayWithRange:subRange];
    
    //循环小于等于10次
    //重复情况二 聊天过程中发一条收一条消息
    
    if (subArray.count > 0) {
        
        for (JGJChatMsgListModel * subChatMsgListModel in subArray) {
            
            if ([subChatMsgListModel.msg_id isEqualToString:chatMsgListModel.msg_id]) {
                
                isDupMsg = YES;
                
                break;
            }
            
        }
        
    }
    
    return isDupMsg;
    
}

#pragma mark 3.2.0优化接口

- (void)setTitleInfo {
    
    if (self.workProListModel.workCircleProType == WorkCircleExampleProType) {
        return;
    }
    
    NSString *members_num = @"";
    
    if (![self.workProListModel.class_type isEqualToString:@"singleChat"]) {
        
        members_num = [NSString stringWithFormat:@"(%@)", self.workProListModel.members_num];
        
    }
    
    self.titleLable.text = [NSString stringWithFormat:@"%@%@",self.workProListModel.group_name,members_num];
    
    self.navigationItem.titleView = self.titleLable;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleModifyNameNotify:) name:JGJAddObserverModifyNameNotify object:nil];
    
}

- (void)handleModifyNameNotify:(NSNotification *)notify {
    
    JGJChatPerInfoModel *perInfoModel = notify.object;
    
    if ([self.workProListModel.class_type isEqualToString:@"singleChat"] && ![NSString isEmpty:perInfoModel.comment_name]) {
        
        self.workProListModel.group_name = perInfoModel.comment_name;
        
        self.titleLable.text = [NSString stringWithFormat:@"%@",self.workProListModel.group_name];
        
        self.navigationItem.titleView = self.titleLable;
        
    }
    
}

- (UILabel *)titleLable {
    
    if (!_titleLable) {
        
        _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth - 100, 30)];
        
        _titleLable.textColor = AppFontffffffColor;
        
        _titleLable.font = [UIFont systemFontOfSize:JGJNavBarFont];
        
        _titleLable.textAlignment = NSTextAlignmentCenter;
        
        _titleLable.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    
    return _titleLable;
}

@end

