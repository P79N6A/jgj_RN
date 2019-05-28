//
//  JGJChatListBaseVc.m
//  mix
//
//  Created by Tony on 2016/8/25.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatListBaseVc.h"

#import "Masonry.h"
#import "UITableViewCell+Extend.h"
#import "JGJChatListMineCell.h"

#import "JGJChatListMinePicCell.h"
#import "JGJChatListOtherPicCell.h"
#import "JGJChatListDefaultTextCell.h"
#import "JGJReadRootInfoVc.h"
#import "NSDate+Extend.h"
#import "JGJMarkBillBaseVc.h"
#import "NSString+JSON.h"
#import "JGJChatListAllDetailVc.h"
#import "JGJDetailViewController.h"

//2.1.2-yj
#import "JGJChatWorkTypeAllInfoCell.h"
#import "JGJPerInfoVc.h"
#import "JGJWebAllSubViewController.h"

#import "JGJQualityDetailVc.h"

#import "JGJQuaSafeTool.h"

//测试新版聊天cell
#import "JGJChatMsgBaseCell.h"

#import "JGJActivityMsgCell.h"
#import "JGJCheckPhotoTool.h"

#import "JGJChatSynInfoCell.h"

#import "AudioRecordingServices.h"

#import "NSString+Extend.h"
#import "JGJChatMyTextCell.h"

#import "JGJChatOutTextCell.h"

#import "YYFPSLabel.h"

#import "JGJChatMsgRecruitCell.h"

#import "JGJChatMsgDBManger.h"

#import <Photos/PHAssetResource.h>

#import <Photos/Photos.h>

#import "JGJChatMsgRequestModel.h"

#import "JGJChatMsgDBManger+JGJClearCacheDB.h"
#import "JGJChatListBaseVc+VoiceAndPicService.h"

#import "AFNetworkReachabilityManager.h"

#import "JGJChatListBaseVc+SelService.h"

#import "JGJSocketRequest+ChatMsgService.h"

#import "JGJSendMessageTool.h"

// v4.0.1 招工相关cell
#import "JGJChatWorkMyRecruitInfoCell.h"
#import "JGJChatWorkOtherRecruitInfoCell.h"
#import "JGJChatWorkMyBusinessCardCell.h"
#import "JGJChatWorkOtherBusinessCardCell.h"
#import "JGJChatWorkAuthTypeCell.h"
#import "JGJChatWorkSendBusinessCardCell.h"
#import "JGJChatWorkSendRecruitInfoCell.h"
#import "JGJChatMyShareLinkCell.h"
#import "JGJChatOtherShareLinkCell.h"
#import "JGJConversationSelectionVc.h"
#import "JGJChatWorkLoaclVerifiedCell.h"

typedef void(^HandleUpLoadProgressBlock)();

//发送消息成功

typedef void(^SendMsgSuccessBlock)(id response);

@interface JGJChatListBaseVc ()
<
    JGJChatListOtherCellDelegate,
    JGJChatWorkTypeAllInfoCellDelegate,
    JGJChatListMinePicCellDelegate,
    JGJChatNoDataDefaultViewDelegate,
    AudioRecordingServicesDelegate,
    JGJChatMsgTopTimeViewDelegate,
    JGJBaseOutMsgViewDelegate,
    JGJCusAddMediaViewDelegate,
    JGJChatWorkSendBusinessCardCelldelegate,
    JGJChatWorkSendRecruitInfoCelldelegate,
    JGJChatWorkLoaclVerifiedCelldelegate
>


@property (nonatomic,strong) NSIndexPath *lastIndexPath;
@property (nonatomic,strong) UIButton *scrollTopButton;
@property (nonatomic, assign) BOOL isScroBottom;

@property (nonatomic, strong) NSTimer *progressTimer; //上传图片进度时间比较

@property (nonatomic, strong) NSMutableArray *upMediaMsgModels;//保存上传图片模型

@property (nonatomic, copy) HandleUpLoadProgressBlock handleUpLoadProgressBlock; //上传图片进度使用

@property (nonatomic, assign) CGFloat timeInterVal;//时间间隔，根据上传图片张数间隔增加

@property (nonatomic, strong) NSTimer *unReadInfoTimer;

@property (nonatomic, strong) UIImageView *clocedImageView;

//我的用户信息用于发消息，展示用
@property (nonatomic, strong) JGJChatMsgListModel *myMsgModel;

//漫游请求
@property (strong, nonatomic) JGJChatMsgRequestModel *roamRequest;

//是否已添加找工作信息，作为开关用
@property (assign, nonatomic) BOOL is_added_jobMsg;

//撤回按钮
@property (strong, nonatomic) UIButton *cusMenuBtn;

//保存之前的撤回按钮
@property (strong, nonatomic) UIButton *lastCusMenuBtn;

//发送消息成功刷新当前发送名片状态

@property (copy, nonatomic) SendMsgSuccessBlock sendMsgSuccessBlock;

//是否点击了发送名片

@property (assign, nonatomic) BOOL isClickPost;

/**
 未读消息定位按钮
 */
@property (nonatomic, weak) UIButton *chatLocateBtn;

/**
 未读消息定位提示消息--"以下为新消息"的indexPath
 */
@property (nonatomic, strong) NSIndexPath *chatLocateMsgIndexPath;

@end

@implementation JGJChatListBaseVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化当前组排重数据
    
    [JGJChatMsgDBManger initialRepetMutableSet];
    
    [self dataInit];
    
    //注册修改用户姓名
    
    [self registerAddObserverModifyNameNotify];
    
    //CC的初始化
    
    _lastVoiceCell = [[JGJChatListOtherCell alloc] init];
    
    _currentVoiceCell = [[JGJChatListOtherCell alloc] init];
    
    self.tableView.estimatedRowHeight = 0;
    
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.estimatedSectionHeaderHeight = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageDidSend:) name:JGJConversationSelectionVcMessageDidSendNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageSendSuccessed:) name:JGJConversationSelectionVcMessageSendSuccessedNotification object:nil];
    
}
- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

    if ([self isMemberOfClass:NSClassFromString(@"JGJChatListAllVc")] || [self isMemberOfClass:NSClassFromString(@"JGJChatListCommonVc")]) {
        
        [self getDBUserUserInfo];
        
    }

    TYLog(@"self.view.window.rootViewController===%@", self.view.window.rootViewController);
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self hiddenCusMenuBtn:self.cusMenuBtn];
    
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setWorkProListModel:(JGJMyWorkCircleProListModel *)workProListModel
{
    _workProListModel = workProListModel;
    
    // 添加未读消息定位按钮
    if (self.workProListModel.unreadMsgCount > JGJChatPageSize) {
        [self addChatLocateBtn];
    }
}

/**
 添加未读消息定位按钮
 */
- (void)addChatLocateBtn
{
    UIButton *chatLocateBtn = [[UIButton alloc] init];
    chatLocateBtn.backgroundColor = [UIColor whiteColor];
    [chatLocateBtn setTitleColor:AppFontEB4E4EColor forState:(UIControlStateNormal)];
    chatLocateBtn.titleLabel.font = [UIFont systemFontOfSize:AppFont26Size];
    NSString *title = [NSString stringWithFormat:@"%zd条新消息",self.workProListModel.unreadMsgCount];
    [chatLocateBtn setTitle:title forState:(UIControlStateNormal)];
    [chatLocateBtn setImage:[UIImage imageNamed:@"chat-locate-arrow"] forState:(UIControlStateNormal)];
    [chatLocateBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [chatLocateBtn addTarget:self action:@selector(chatLocateBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:chatLocateBtn];
    self.chatLocateBtn = chatLocateBtn;
    
    [chatLocateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(40);
        make.right.mas_equalTo(self.view);
        make.width.mas_equalTo(105);
        make.height.mas_equalTo(32);
    }];
    // 设置左上和左下圆角
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 105, 32) byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft) cornerRadii:CGSizeMake(16, 16)];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    chatLocateBtn.layer.mask = layer;
}
/**
 点击未读消息定位按钮
 */
- (void)chatLocateBtnClicked:(UIButton *)button
{
    button.enabled = NO;
    [self loadMessagesForChatLocate];
}


#pragma mark - 获取用户的最新信息,发消息先展示
- (void)getDBUserUserInfo {
    
    JGJChatMsgListModel *myMsgModel = [[JGJChatMsgListModel alloc] init];
    
    myMsgModel.group_id = self.workProListModel.group_id;
    
    myMsgModel.class_type = self.workProListModel.class_type;
    
//    myMsgModel = [JGJChatMsgDBManger maxMsgModelWithMyMsgModel:myMsgModel];
    
    myMsgModel.members_num = self.workProListModel.members_num;
    
    myMsgModel.unread_members_num = [self.workProListModel.members_num integerValue];
    
    JGJChatUserInfoModel *user_info = [JGJChatUserInfoModel new];
    
    NSString *head_pic = [TYUserDefaults objectForKey:JLGHeadPic];
    
    NSString *name = [TYUserDefaults objectForKey:JGJUserName];
    
    NSString *uid = [TYUserDefaults objectForKey:JLGUserUid];
    
    user_info.head_pic = head_pic;
    
    user_info.real_name = name;
    
    user_info.uid = uid;
    
    myMsgModel.user_info = user_info;
    
    myMsgModel.user_name = name;
    
    myMsgModel.head_pic = head_pic;
    
    self.myMsgModel = myMsgModel;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

- (void)dataInit{
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.msgType = @"all";
    
    self.tableView.mj_header = [LZChatRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(chatListLoadUpData)];
    
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    
    self.view.backgroundColor = AppFontF6F6F6Color;
    
}




#pragma mark - 数据加载

/**
 点击未读消息定位按钮加载更多消息
 */
- (void)loadMessagesForChatLocate
{
    if (![self.msgType isEqualToString:@"all"]) return;
    // 创建fromMessage消息对象
    JGJChatMsgListModel *fromMessage = [JGJChatMsgListModel new];
    fromMessage.msg_total_type = JGJChatNormalMsgType;
    fromMessage.class_type = self.workProListModel.class_type;
    fromMessage.group_id = self.workProListModel.group_id;
    fromMessage.msg_id = self.workProListModel.maxReadeRdMsgId ?: @"0";
    
    // 创建toMessage消息对象
    JGJChatMsgListModel *toMessage = [JGJChatMsgListModel new];
    toMessage.msg_total_type = JGJChatNormalMsgType;
    toMessage.class_type = self.workProListModel.class_type;
    toMessage.group_id = self.workProListModel.group_id;
    
    if (self.dataSourceArray.count == 0) {
        toMessage.msg_id = @"0";
    } else {
        //当前id为空的时候，找下一个
        for (JGJChatMsgListModel *message in self.dataSourceArray) {
            if (![NSString isEmpty:message.msg_id] && ![message.msg_id isEqualToString:@"0"]) {
                toMessage = message;
                break;
            }
        }
    }
    
    __block CGSize beforeContentSize = self.tableView.contentSize;
    
    NSArray *messages = [JGJChatMsgDBManger getMessagesFromMessage:fromMessage toMessage:toMessage];

    TYLog(@"===已读消息最大id(查询起始ID)===>%@",self.workProListModel.maxReadeRdMsgId);
    TYLog(@"===当前页面最小id(查询终止ID)===>%@",toMessage.msg_id);

    for (JGJChatMsgListModel *message in messages) {
        TYLog(@"==数据库查询id==>%@",message.msg_id);
    }
    
    if (messages.count == 0) {
        [self.chatLocateBtn removeFromSuperview];
        return;
    }
    // 创建定位提示消息
    JGJChatMsgListModel *chatLocateMsg = [self createChatLocateMsg];

    NSMutableArray *newMessages = [messages mutableCopy];
    [newMessages insertObject:chatLocateMsg atIndex:1];

    self.dataSourceArray = [newMessages arrayByAddingObjectsFromArray:self.dataSourceArray].mutableCopy;

    //数据库数据获取后刷新未读人数
    [self freshMyMsgUnreadNum:messages];

    [self.tableView reloadData];
    
    // 滑动到未读消息定位的地方
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:(UITableViewScrollPositionTop) animated:YES];
    // 删除消息定位按钮
    [self.chatLocateBtn removeFromSuperview];
    
    //获取自己发的消息
    [self getMysendMsgs:self.dataSourceArray];

    //回执消息给服务器
    [self readedPullMsgs:messages];

}

/**
 下拉加载更多消息
 */
- (void)chatListLoadUpData {
    
    if (![self.msgType isEqualToString:@"all"]) return;
    
    // 创建chatMsgListModel消息对象
    JGJChatMsgListModel *chatMsgListModel = [JGJChatMsgListModel new];
    chatMsgListModel.msg_total_type = JGJChatNormalMsgType;
    chatMsgListModel.class_type = self.workProListModel.class_type;
    chatMsgListModel.group_id = self.workProListModel.group_id;
    
    // 创建cacheModel对象
    JGJChatClearCacheModel *cacheModel = [[JGJChatClearCacheModel alloc] init];
    cacheModel.class_type = chatMsgListModel.class_type;
    cacheModel.group_id = chatMsgListModel.group_id;
    
    // 数据库中获取JGJChatClearCacheModel对象
    cacheModel = [JGJChatMsgDBManger cacheModel:cacheModel];
    
    if (self.dataSourceArray.count == 0) {
        chatMsgListModel.msg_id = @"0";
    } else {
        //当前id为空的时候，找下一个
        for (JGJChatMsgListModel *minMsgModel in self.dataSourceArray) {
            if (![NSString isEmpty:minMsgModel.msg_id] && ![minMsgModel.msg_id isEqualToString:@"0"]) {
                chatMsgListModel = minMsgModel;
                break;
            }
        }
    }
    
   __block CGSize beforeContentSize = self.tableView.contentSize;
    
    //有缓存的时候去的消息id一定是大于清除缓存的前的消息id
    
    if (cacheModel && ![NSString isEmpty:cacheModel.msg_id]) {
        
        chatMsgListModel.msg_id = cacheModel.msg_id;
    }
    
    // 从数据库中加载聊天消息
    NSArray *dataSourceArr = [JGJChatMsgDBManger getMsgModelsWithChatMsgListModel:chatMsgListModel];
    
    if (dataSourceArr.count > 0) {
        
        self.dataSourceArray = [dataSourceArr arrayByAddingObjectsFromArray:self.dataSourceArray].mutableCopy;
        
        //数据库数据获取后刷新未读人数
        [self freshMyMsgUnreadNum:dataSourceArr];
        
        [self.tableView reloadData];
        
        //获取自己发的消息
        [self getMysendMsgs:self.dataSourceArray];
        
        //回执消息给服务器
        [self readedPullMsgs:dataSourceArr];
        
        //处理下拉刷新偏移问题
        [self handleTableViewOffset:beforeContentSize];
        
        [self.tableView.mj_header endRefreshing];
        
        // 如果消息定位按钮存在,插入定位提示消息
        if (self.chatLocateBtn) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"msg_id=%@",self.workProListModel.maxReadeRdMsgId];
            NSArray *results = [self.dataSourceArray filteredArrayUsingPredicate:predicate];
            if (results.count) {
                // 创建定位提示消息
                JGJChatMsgListModel *chatLocateMsg = [self createChatLocateMsg];
                
                NSInteger index = [self.dataSourceArray indexOfObject:results.lastObject];
                [self.dataSourceArray insertObject:chatLocateMsg atIndex:(index+1)];
                [self.tableView reloadData];
                // 设置定位提示消息indexPath
                self.chatLocateMsgIndexPath = [NSIndexPath indexPathForRow:index+1 inSection:0];
                // 移除消息定位按钮
                NSArray *indexPaths = [self.tableView indexPathsForVisibleRows];
                if ([indexPaths containsObject:self.chatLocateMsgIndexPath]) {
                    [self.chatLocateBtn removeFromSuperview];
                }
                
            }
        }

        //首次进入页面滚动到底部
        if ([chatMsgListModel.msg_id isEqualToString:@"0"]) {
            
            [self tableViewToBottom];
        }
        
    } else {
        //小于分页则拉去服务器数据
        
        self.roamRequest.msg_id = chatMsgListModel.msg_id;
        
        // 如果缓存表里面有值且是当前组的group_id那么就不拉漫游消息
        if (![NSString isEmpty:cacheModel.group_id]) {
            [self.tableView.mj_header endRefreshing];
        } else {
            TYWeakSelf(self);
            [self loadMoreRoamMsgListCallBack:^(NSArray *msgs) {
                
                //刷新未读人数
                
                [weakself freshMyMsgUnreadNum:msgs];
                
                beforeContentSize = weakself.tableView.contentSize;
                
                weakself.dataSourceArray = [msgs arrayByAddingObjectsFromArray:weakself.dataSourceArray].mutableCopy;
                
                //获取自己发的消息
                [weakself getMysendMsgs:weakself.dataSourceArray];
                
                //回执消息给服务器
                [weakself readedPullMsgs:msgs];
                
                [weakself.tableView reloadData];
                //处理下拉刷新偏移问题
                [weakself handleTableViewOffset:beforeContentSize];
                
                [weakself.tableView.mj_header endRefreshing];
                
            }];
        }
        
        
    }

}

/**
 创建未读消息定位提示消息
 */
- (JGJChatMsgListModel *)createChatLocateMsg
{
    JGJChatMsgListModel *chatLocateMsg = [JGJChatMsgListModel new];
    chatLocateMsg.msg_total_type = JGJChatNormalMsgType;
    chatLocateMsg.class_type = self.workProListModel.class_type;
    chatLocateMsg.group_id = self.workProListModel.group_id;
    chatLocateMsg.msg_type = @"chatlocate";
    chatLocateMsg.msg_text = @"————  以下为新消息  ————";
    return chatLocateMsg;
}


//2.1.2-yj 插入最后一条信息
- (JGJChatMsgListModel *)handleProDetailInfoInsertLastMsg {
    
    JGJChatMsgListModel *findJobMsgModel = nil;
    
    JGJChatRecruitMsgModel *chatRecruitMsgModel = self.workProListModel.chatRecruitMsgModel;
    
    if (chatRecruitMsgModel) {
        findJobMsgModel = [JGJChatMsgListModel new];
        findJobMsgModel.recruitMsgModel = chatRecruitMsgModel;
        findJobMsgModel.is_find_job = self.workProListModel.is_find_job;
        findJobMsgModel.msg_text = @"";
//        local_recruitment (临时招聘类型)、local_postcard(临时图片)
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

- (void)getMysendMsgs:(NSArray *)msgs {
    
    if (msgs.count > 0) {
        
        NSString *myUid = [TYUserDefaults objectForKey:JLGUserUid];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"msg_sender == %@", myUid];
        
        NSArray *mySendMsgs = [msgs filteredArrayUsingPredicate:predicate];
        
        //找出自己数据用于替换
        [self.muSendMsgArray addObjectsFromArray:mySendMsgs];
        
    }
    
}

#pragma mark - 获取自己发消息的未读人数

- (void)freshMyMsgUnreadNum:(NSArray *)myMsgs {
    
    if ([self.workProListModel.class_type isEqualToString:@"singleChat"]) {
        
        return;
    }
    
    NSString *myUid = [TYUserDefaults objectForKey:JLGUserUid];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"msg_sender == %@", myUid];
    
    NSArray *mySendMsgs = [myMsgs filteredArrayUsingPredicate:predicate];
    
    NSMutableArray *reqUnreadMsgs = [[NSMutableArray alloc] init];
    
    for (JGJChatMsgListModel *msgModel in mySendMsgs) {
        
        if (msgModel.is_normal_msg) {
            
            [reqUnreadMsgs addObject:msgModel];
            
        }
    }
    
    if (reqUnreadMsgs.count == 0) {
        
        return;
    }
    
    TYWeakSelf(self);

    [JGJSocketRequest chatMessageReadedNumWithMyMsgs:reqUnreadMsgs callback:^(NSArray *msgs) {

        [weakself.tableView reloadData];

    }];
    
}

#pragma mark - 拉去漫游消息
- (void)loadMoreRoamMsgListCallBack:(void(^)(NSArray *msgs))callBack {
    
    NSDictionary *parameters = [self.roamRequest mj_keyValues];
    
    [JLGHttpRequest_AFN PostWithNapi:@"chat/get-roam-message-list" parameters:parameters success:^(id responseObject) {
        
        NSArray *msgs = [JGJChatMsgListModel mj_objectArrayWithKeyValuesArray:responseObject];
        
        if (msgs.count > 0) {
            
            JGJChatMsgListModel *minMsgModel = self.dataSourceArray.firstObject;
            
            self.roamRequest.msg_id = minMsgModel.msg_id;
        }
        
        msgs = [JGJChatMsgDBManger sortMsgList:msgs];
        
        if (callBack) {
            
            callBack(msgs);
        }
        
        [self insertMsgDBWithMsgs:msgs];
        
//        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
        
    }];
    
}

#pragma mark - 漫游消息存到数据库
- (void)insertMsgDBWithMsgs:(NSArray *)msgs {
    
    NSMutableArray *msgArr = [NSMutableArray array];
    
    JGJChatMsgDBManger *DBManger = [JGJChatMsgDBManger shareManager];
    
    for (JGJChatMsgListModel *msgModel in msgs) {
        
        msgModel.sendType = JGJChatListSendSuccess;
        
        msgModel.user_unique = [TYUserDefaults objectForKey:JLGUserUid];
        
        NSString *wcdb_user_info = [msgModel.user_info mj_JSONString];
        
        msgModel.wcdb_msg_id = [msgModel.msg_id longLongValue];
        
        //已显示的数据,加入排重的Set中
        
        if (![NSString isEmpty:msgModel.msg_id]) {
            
            [DBManger.existMsgIdsSet addObject:msgModel.msg_id];
    
        }
                
        [msgArr addObject:msgModel];
        
        [JGJChatMsgDBManger insertAllPropertyChatMsgListModel:msgModel];
    }
    
}

#pragma mark - 下拉的消息表示已读，回执给服务器
- (void)readedPullMsgs:(NSArray *)msgs {
    
    if (self.dataSourceArray.count > 0) {
        
        //        NSArray *maxMinMsgs = [JGJChatMsgDBManger sortMsgList:self.dataSourceArray];
        
        JGJChatMsgListModel *minMsgModel = self.dataSourceArray.lastObject;
        
        if (![NSString isEmpty:minMsgModel.msg_id] && ![minMsgModel.msg_id isEqualToString:@"0"]) {
            
            [JGJSocketRequest pullRoamMsgCallBackServiceWithMsgs:@[minMsgModel] proListModel:self.workProListModel];
            
        }
        
    }
    
}


#pragma mark - 首次进入页面加载聊天数据设置数据的地方WCDBYJ

- (void)loadChatLocalData {
    
    JGJChatMsgListModel *msgModel = [JGJChatMsgListModel new];
    
    msgModel.group_id = self.workProListModel.group_id;
    
    msgModel.class_type = self.workProListModel.class_type;
    
    NSArray *msgList = [self getDBMsgListWithMsgModel:msgModel];
    
    self.isCanScroBottom = YES;
    
    [self addSourceArr:msgList];
    
    [self tableViewToBottom];
    
    NSString *myUid = [TYUserDefaults objectForKey:JLGUserUid];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"msg_sender == %@", myUid];
    
    NSArray *mySendMsgs = [self.dataSourceArray filteredArrayUsingPredicate:predicate];
    
    //找出自己数据用于替换用
    [self.muSendMsgArray addObjectsFromArray:mySendMsgs];
    
}

#pragma mark - 获取数据库消息列表
- (NSArray *)getDBMsgListWithMsgModel:(JGJChatMsgListModel *)msgModel {
    
    NSArray *msgList = [JGJChatMsgDBManger getMsgModelsWithChatMsgListModel:msgModel];
    
    //回执已读的消息给服务器
    [self readedPullMsgs:msgList];
    
    return msgList;
}

#pragma mark - 处理tableView下拉刷新偏移问题
- (void)handleTableViewOffset:(CGSize)beforeContentSize {
    
    //先刷新获取最新的大小
    [self.tableView reloadData];
    
    CGSize afterContentSize = self.tableView.contentSize;
    CGPoint afterContentOffset = self.tableView.contentOffset;
    CGPoint newContentOffset = CGPointMake(afterContentOffset.x, afterContentOffset.y + afterContentSize.height - beforeContentSize.height);
    [self.tableView setContentOffset:newContentOffset animated:NO] ;
}


#pragma mark - 过滤数据
- (void)filterByChatListType:(JGJChatListType )chatListType{
    if (![self.msgType isEqualToString:@"all"]) {
        return;
    }
    
    NSMutableArray <JGJChatMsgListModel*>*dataSourceArray = [NSMutableArray array];
    
    [self.dataSourceArray enumerateObjectsUsingBlock:^(JGJChatMsgListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.chatListType == chatListType) {
            [dataSourceArray addObject:obj];
        }
    }];
    
    self.dataSourceArray = dataSourceArray.mutableCopy;
}

- (void)addSourceArr:(NSArray *)dataSourceArr{
    [self addDataSourceArr:dataSourceArr isAdd:YES];
}

- (void)addDataSourceArr:(NSArray *)dataSourceArr isAdd:(BOOL )add{
    [self addMySourceArr:dataSourceArr isAdd:add scrollToBottom:add];
}

- (void)addMySourceArr:(NSArray *)dataSourceArr isAdd:(BOOL )add scrollToBottom:(BOOL)scrollToBottom{
    if (![self.msgType isEqualToString:@"all"]) {
        return ;
    }
    
    //保存到本地
    if (dataSourceArr.count) {
        if (add) {
            [self.dataSourceArray addObjectsFromArray:dataSourceArr];
        }

    }else{
        return ;
    }
    
    [self.tableView reloadData];
}

- (void)addSourceArrWith:(JGJChatMsgListModel *)msgListModel{
    
    if (![self.msgType isEqualToString:@"all"]) {
        
        return;
    }

    //保存到本地
    if (msgListModel) {

        [self.dataSourceArray addObject:msgListModel];

        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataSourceArray.count - 1 inSection:0];
        
        [self.tableView beginUpdates];
        
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        [self.tableView endUpdates];
        
        //自己发的消息能滚动到底部，主要是解决偏移底部一段距离的问题
        self.isCanScroBottom = YES;
        
        [self tableViewToBottom];
    }
    
}

#pragma mark - 接收数据添加，不需要查重，接收到就显示
- (void)addReceiveSourceArrWith:(JGJChatMsgListModel *)msgListModel {
    
    if (![self.msgType isEqualToString:@"all"]) {
        return;
    }
    
    if (msgListModel) {
        
        if (msgListModel.chatListType == JGJChatListRecall && self.dataSourceArray.count > 0) {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"msg_id == %@", msgListModel.msg_id];
            
            JGJChatMsgListModel *recallMsgModel = [self.dataSourceArray filteredArrayUsingPredicate:predicate].lastObject;
            
            recallMsgModel.msg_text = msgListModel.msg_text;
            
            recallMsgModel.msg_type = msgListModel.msg_type;
            
            recallMsgModel.cellHeight = 0;
            
            
            
            [self.tableView reloadData];

        }else {
            
            [self.dataSourceArray addObject:msgListModel];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataSourceArray.count - 1 inSection:0];
            [self.tableView beginUpdates];

            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];

            [self.tableView endUpdates];
            
        }
        
        [self tableViewToBottom];
        
    }
    
}

- (void)replaceSourceArrObject:(JGJChatMsgListModel *)chatMsgListModel{
    [self replaceSourceArrObject:chatMsgListModel needReload:NO];
}

- (void)replaceSourceArrObject:(JGJChatMsgListModel *)chatMsgListModel needReload:(BOOL )needReload{
    if (![self.msgType isEqualToString:@"all"]) {
        return;
    }
    
    __block NSInteger index = 0;
    __weak typeof(self) weakSelf = self;
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if (chatMsgListModel.chatListType == JGJChatListAudio) {
            
            //是自己的消息才替换状态
            if (chatMsgListModel.belongType != JGJChatListBelongMine || self.dataSourceArray.count == 0) {
                
                return ;
            }
            
            //这里只需要判断msg_id 和local_id是否有一个相等就可以
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(msg_id == %@ or local_id == %@) AND msg_type == %@", chatMsgListModel.msg_id, chatMsgListModel.local_id, chatMsgListModel.msg_type];
            
            
            JGJChatMsgListModel *audioMsgModel = [self.dataSourceArray filteredArrayUsingPredicate:predicate].lastObject;
            
            if (audioMsgModel) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    audioMsgModel.msg_id = chatMsgListModel.msg_id;
                    
                    audioMsgModel.sendType = JGJChatListSendSuccess;
                    
                    audioMsgModel.unread_members_num = chatMsgListModel.unread_members_num;
                    
                    if (self.dataSourceArray.count > 0) {
                        
                        [self.dataSourceArray replaceObjectAtIndex:audioMsgModel.msgIndexPath.row withObject:audioMsgModel];
                    }
                                        
                    [self.tableView reloadData];
                    
                });
            }
            
        }else {
            
            [self.muSendMsgArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(JGJChatMsgListModel *   _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                BOOL isSame_Local_id = [obj.local_id isEqualToString:chatMsgListModel.local_id];
                
                BOOL isSame_Group_id = [weakSelf.workProListModel.group_id isEqualToString:chatMsgListModel.group_id];
                BOOL isSame_Class_type = [weakSelf.workProListModel.class_type isEqualToString:chatMsgListModel.class_type];
                
                if (isSame_Class_type && isSame_Group_id && isSame_Local_id) {
                    
                    index =  obj.msgIndexPath.row;
                    
                    chatMsgListModel.sendType = JGJChatListSendSuccess;
                    
                    obj.sendType = JGJChatListSendSuccess;
                    
                    NSInteger msgDataArrayLoc = obj.msgIndexPath.row;
                    
                    obj.msg_id = chatMsgListModel.msg_id; //复试消息id，用于未读的使用
                    
                    if (self.dataSourceArray.count > 0) {
                        
                        JGJChatMsgListModel *msgChatListModel = self.dataSourceArray[msgDataArrayLoc];
                        
                         TYLog(@"msgChatListModel ========%@  msgIndexPath.row ===== %@  serviceMsgListModel %@", msgChatListModel.msg_text, @(obj.msgIndexPath.row), chatMsgListModel.msg_text);
                    }

                    *stop = YES;
                }
                
            }];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self replaceSourceArrObject:chatMsgListModel index:index needReload:needReload];
                
            });
            
        }
        
    });
}

- (void)replaceSourceArrObject:(JGJChatMsgListModel *)chatMsgListModel index:(NSUInteger )index{
    [self replaceSourceArrObject:chatMsgListModel index:index needReload:NO];
}

- (void)replaceSourceArrObject:(JGJChatMsgListModel *)chatMsgListModel index:(NSUInteger )index needReload:(BOOL )needReload{

    //2.3.0添加
    if (![self.msgType isEqualToString:@"all"] || self.dataSourceArray.count == 0) {
        return;
    }
    //2.3.0添加结束
    
    if (chatMsgListModel && self.dataSourceArray.count > 0 && index < self.dataSourceArray.count) {
        
        JGJChatMsgListModel *replaceMsgModel = self.dataSourceArray[index];
        
        if ([replaceMsgModel.msg_id isEqualToString:chatMsgListModel.msg_id]) {
            
            [self.dataSourceArray replaceObjectAtIndex:index withObject:chatMsgListModel];
            
        }
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        
        if (chatMsgListModel.chatListType != JGJChatListAudio || chatMsgListModel.isFailed == YES || needReload) {
            
            if (chatMsgListModel.isFailed == YES) {
                
                chatMsgListModel.isFailed = NO;
            }
            
            [self.tableView beginUpdates];
            
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            [self.tableView endUpdates];
        }

    }
    
}

- (void)readedMsgWith:(JGJChatMsgListModel *)chatMsgListModel{
    
    //2.3.0添加开始
    if (self.muSendMsgArray.count == 0) {
        
        return;
    }
    
    //第一种未读人数处理
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"msg_id=%@",chatMsgListModel.msg_id];
    
    NSArray *filterMsgs = [self.dataSourceArray filteredArrayUsingPredicate:predicate];
    
    for (NSInteger index = 0; index < filterMsgs.count; index++) {
        
        JGJChatMsgListModel  *msgModel = filterMsgs[index];
        
        if ([msgModel.msg_id isEqualToString:chatMsgListModel.msg_id]) {
            
            msgModel.unread_members_num = chatMsgListModel.unread_members_num;
            
            if (msgModel.msgIndexPath) {
                
                if (msgModel.msgIndexPath.row < self.dataSourceArray.count) {
                    
                    [self.tableView beginUpdates];
                    
                    [self.tableView reloadRowsAtIndexPaths:@[msgModel.msgIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                    
                    [self.tableView endUpdates];
                    
                }
            }
            
            break;
        }
        
    }
    
    //移除任务
    
    if (self.messageReadedToSenderTask.count > 0) {
        
        [self.messageReadedToSenderTask removeObject:chatMsgListModel];
        
    }
    
/*
    
    //2.3.0添加结束 (第二种未读人数处理)
    
    __block JGJChatMsgListModel *sendedChatMsglistModel = [JGJChatMsgListModel new];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSArray *sendMsgArray = self.muSendMsgArray.copy;
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"msg_id == %@", chatMsgListModel.msg_id];
        
        sendedChatMsglistModel = [sendMsgArray filteredArrayUsingPredicate:predicate].lastObject;
        
        // 更新界面
        
        if (![NSString isEmpty:sendedChatMsglistModel.msg_id]) {
            
            sendedChatMsglistModel.is_readed = @"1"; //标记已读
            
            sendedChatMsglistModel.unread_members_num = chatMsgListModel.unread_members_num;
            
            //未读人数为0删除当前模型
            
            if (chatMsgListModel.unread_members_num == 0) {
                
                [self.muSendMsgArray removeObject:sendedChatMsglistModel];
            }
            
            //移除任务
            if (self.messageReadedToSenderTask.count > 0) {
                
                [self.messageReadedToSenderTask removeObject:chatMsgListModel];
            }
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (sendedChatMsglistModel.msgIndexPath) {
                
                [self replaceSourceArrObject:sendedChatMsglistModel index:sendedChatMsglistModel.msgIndexPath.row];
                
            }
            
        });
    });
 
 */
    
}

//给子类使用来设置baseCell的super_textView
- (void)setSuper_textView:(UITableViewCell *)baseCell{
    
}

#pragma mark - tableView
#pragma mark dataSource
#ifdef UseTableView_FDTHeight
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    JGJChatMsgListModel *chatListModel = (JGJChatMsgListModel *)self.dataSourceArray[indexPath.row];
    
    chatListModel.is_normal = YES;

    chatListModel.msgIndexPath = indexPath;

    CGFloat height = chatListModel.cellHeight;
    
    // 本地的名片消息或者招工消息 正常计算高度
    BOOL isLocalPostCardOrRecruitment = [chatListModel.local_msg_type isEqualToString:@"local_postcard"] || [chatListModel.local_msg_type isEqualToString:@"local_recruitment"] || [chatListModel.local_msg_type isEqualToString:@"local_verified"];

    if (!chatListModel.isDefaultText && !chatListModel.is_normal_msg && !isLocalPostCardOrRecruitment) {

        height = CGFLOAT_MIN;
    }

    return height;
    
}
#endif

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = self.dataSourceArray.count;
    
//    [self handleFirstScroBottom];

    return count;
}

#pragma mark - 处理首次进入聊天页面滚动到底部闪烁问题
- (void)handleFirstScroBottom {
    
    if (!self.isScroBottom) {
        if (self.dataSourceArray.count > 0 && self.tableView.contentSize.height - 64 > TYGetViewH(self.view)) {
            self.isScroBottom = YES;
            [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height - TYGetViewH(self.tableView)) animated:YES];
        }
    
        
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    
    cell = [self registerCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell;

}

- (UITableViewCell *)registerCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell;
    if (self.dataSourceArray.count == 0) {//没有数据
        cell = [UITableViewCell getNilViewCell:tableView indexPath:indexPath];
    }else{//有数据
        
        //撤回
        JGJChatMsgListModel *chatListModel = (JGJChatMsgListModel *)self.dataSourceArray[indexPath.row];
        
        if ([chatListModel.msg_type isEqualToString:@"voice"] && ![NSString isEmpty:chatListModel.msg_text]) {
            
            if ([chatListModel.msg_text containsString:@"撤回一条消息"]) {
                
                chatListModel.msg_type = @"recall";
                
            }
            
        }
        
        // 招工样式
        if ([chatListModel.local_msg_type isEqualToString:@"local_postcard"]) {// 本地名片
            
            JGJChatWorkSendBusinessCardCell *businessCardCell = [JGJChatWorkSendBusinessCardCell cellWithTableView:tableView];
            businessCardCell.delegate = self;
            businessCardCell.chatListModel = chatListModel;
            
            cell = businessCardCell;
            
            return cell;
            
        }else if ([chatListModel.local_msg_type isEqualToString:@"local_recruitment"]) {
            
            JGJChatWorkSendRecruitInfoCell *sendVerbInfoCell = [JGJChatWorkSendRecruitInfoCell cellWithTableView:tableView];
            sendVerbInfoCell.delegate = self;
            sendVerbInfoCell.chatListModel = chatListModel;
            
            cell = sendVerbInfoCell;
            return cell;
            
        }else if ([chatListModel.local_msg_type isEqualToString:@"local_verified"]) {
            
            JGJChatWorkLoaclVerifiedCell *localVerifiedCell = [JGJChatWorkLoaclVerifiedCell cellWithTableView:tableView];
            localVerifiedCell.chatListModel = chatListModel;
            localVerifiedCell.delegate = self;
            cell = localVerifiedCell;
            if ([chatListModel.recruitMsgModel.verified isEqualToString:@"3"]) {
                
                cell.hidden = YES;
                
            }else {
                
                cell.hidden = NO;
            }

            return cell;
            
        }
        
        // 发送成功和接受消息找活名片
        if ([chatListModel.msg_type isEqualToString:@"postcard"]) {
            
            JGJChatListBelongType belongType = chatListModel.belongType;
            if (belongType == JGJChatListBelongMine) {
                
                JGJChatWorkMyBusinessCardCell *myPostCardCell = [JGJChatWorkMyBusinessCardCell cellWithTableView:tableView];
                myPostCardCell.delegate = self;
                myPostCardCell.chatListModel = chatListModel;
                myPostCardCell.jgjChatListModel = chatListModel;
                
                cell = myPostCardCell;
                return cell;
                
            }else {
                
                JGJChatWorkOtherBusinessCardCell *otherPostCardCell = [JGJChatWorkOtherBusinessCardCell cellWithTableView:tableView];
                otherPostCardCell.delegate = self;
                otherPostCardCell.chatListModel = chatListModel;
                otherPostCardCell.jgjChatListModel = chatListModel;
                cell = otherPostCardCell;
                
                return cell;
                
            }
            
        }
        
        // 发送成功和接受消息招工信息
        if ([chatListModel.msg_type isEqualToString:@"recruitment"]) {
            
            JGJChatListBelongType belongType = chatListModel.belongType;
            if (belongType == JGJChatListBelongMine) {
                
                JGJChatWorkMyRecruitInfoCell *myRecruitInfoCell = [JGJChatWorkMyRecruitInfoCell cellWithTableView:tableView];
                myRecruitInfoCell.delegate = self;
                myRecruitInfoCell.chatListModel = chatListModel;
                myRecruitInfoCell.jgjChatListModel = chatListModel;
                cell = myRecruitInfoCell;
                return cell;
                
            }else {
                
                JGJChatWorkOtherRecruitInfoCell *otherRecruitInfoCell = [JGJChatWorkOtherRecruitInfoCell cellWithTableView:tableView];
                otherRecruitInfoCell.delegate = self;
                otherRecruitInfoCell.chatListModel = chatListModel;
                otherRecruitInfoCell.jgjChatListModel = chatListModel;
                cell = otherRecruitInfoCell;
                return cell;
                
            }
            
        }
        
        // 认证消息类型
        if (chatListModel.chatListType == JGJChatAuthType && chatListModel.belongType != JGJChatListBelongMine) {// 认证消息类型 自己的未认证消息不显示
            
            JGJChatWorkAuthTypeCell *authTypeCell = [JGJChatWorkAuthTypeCell cellWithTableView:tableView];
            authTypeCell.chatListModel = chatListModel;
            cell = authTypeCell;
            return cell;
        }
        
        // 链接消息类型
        if (chatListModel.chatListType == JGJChatListLinkType) {
            
            JGJChatListBelongType belongType = chatListModel.belongType;
            if (belongType == JGJChatListBelongMine) {
                
                JGJChatMyShareLinkCell *myShareLinkCell = [JGJChatMyShareLinkCell cellWithTableView:tableView];
                myShareLinkCell.delegate = self;
                myShareLinkCell.chatListModel = chatListModel;
                myShareLinkCell.jgjChatListModel = chatListModel;
                cell = myShareLinkCell;
                return cell;
                
            }else {
                
                JGJChatOtherShareLinkCell *otherShareLinkCell = [JGJChatOtherShareLinkCell cellWithTableView:tableView];
                otherShareLinkCell.delegate = self;
                otherShareLinkCell.chatListModel = chatListModel;
                otherShareLinkCell.jgjChatListModel = chatListModel;
                cell = otherShareLinkCell;
                return cell;
            }
        }
        
        //2.1.2-yj添加找工作相关信息
        if ([chatListModel.msg_type isEqualToString:@"proDetail"]) {
            JGJChatWorkTypeAllInfoCell *workTypeAllInfoCell = [JGJChatWorkTypeAllInfoCell cellWithTableView:tableView];
            workTypeAllInfoCell.chatWorkTypeDelegate = self;
            workTypeAllInfoCell.chatListModel = chatListModel;
            cell = workTypeAllInfoCell;
            return cell;
        }
        if (chatListModel.isDefaultText) {
            JGJChatListDefaultTextCell  *chatListDefaultTextCell = [JGJChatListDefaultTextCell cellWithTableView:tableView];
            chatListDefaultTextCell.jgjChatListModel = chatListModel;
            chatListDefaultTextCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return chatListDefaultTextCell;
        }

        JGJChatListBelongType belongType = chatListModel.belongType;

        JGJChatListBaseCell *chatListBaseCell;
        if (belongType == JGJChatListBelongMine) {//我的
            if (chatListModel.chatListType == JGJChatListPic) {
                chatListBaseCell = [JGJChatListMinePicCell cellWithTableView:tableView];
            }else{
                chatListBaseCell = [JGJChatListMineCell cellWithTableView:tableView];
            }

        }else if(belongType == JGJChatListBelongOther || belongType == JGJChatListBelongGroupOut){//其他人发的
            
            if (chatListModel.chatListType == JGJChatListPic) {
                
                chatListBaseCell = [JGJChatListOtherPicCell cellWithTableView:tableView];
                chatListBaseCell.tableView = self.tableView;
                
            }else{
                
                JGJChatListOtherCell *otherCell = [JGJChatListOtherCell cellWithTableView:tableView];

                if (!otherCell.otherCellDelegate) {
                    otherCell.otherCellDelegate = self;
                }

                chatListBaseCell = otherCell;
            }
        }

        chatListBaseCell.selectionStyle = UITableViewCellSelectionStyleNone;

        if (chatListModel.belongType == JGJChatListBelongMine && ![NSString isEmpty:self.myUsername]) {

            chatListModel.user_name = self.myUsername;
        }

        chatListBaseCell.indexPath = indexPath;
        
        chatListBaseCell.jgjChatListModel = chatListModel;

        //设置delegate
        if (!chatListBaseCell.delegate) {
            
            chatListBaseCell.delegate = self;
        }

        if (!chatListBaseCell.topTitleView.delegate) {
            
            chatListBaseCell.topTitleView.delegate = self;
        }

        if ([chatListBaseCell isKindOfClass:[JGJChatListOtherCell class]]) {
            
            JGJChatListOtherCell *otherCell = (JGJChatListOtherCell *)chatListBaseCell;
            otherCell.otherCellDelegate = self;
        }


        //图片类型
        if ([chatListBaseCell isKindOfClass:[JGJChatListMinePicCell class]]) {

            JGJChatListMinePicCell *picCell = (JGJChatListMinePicCell *)chatListBaseCell;

            picCell.picCellDelegate = self;
        }

        if ([chatListBaseCell isKindOfClass:[JGJChatListOtherPicCell class]]) {

            JGJChatListOtherPicCell *otherPicCell = (JGJChatListOtherPicCell *)chatListBaseCell;

            otherPicCell.otherPicDelegate = self;
        }

        cell = chatListBaseCell;

        [self setSuper_textView:chatListBaseCell];
    }

    return cell;
}

#pragma mark - JGJChatWorkSendBusinessCardCelldelegate 发送名片 cell相关操作
- (void)sendBusinessCardMsgWithChatListModel:(JGJChatMsgListModel *)chatListModel cell:(JGJChatWorkSendBusinessCardCell *)cell {
    
    //发送名片逻辑。发招工、名片、认证(verified = 3是已认证)
    [self sendRecruitMsgModelWithIsClickPost:YES];
    
}

#pragma - mark - 立即认证
- (void)gotoRealNameAuthenticationWithChatListModel:(JGJChatMsgListModel *)chatListModel cell:(JGJChatWorkSendBusinessCardCell *)cell {
    
    NSString  *proDetailStr = [NSString stringWithFormat:@"%@%@",JGJWebDiscoverURL, @"my/idcard"];

    JGJWebAllSubViewController *proDetailWebView = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeProDetailType URL:proDetailStr];
    if (self.skipToNextVc) {
        
        self.skipToNextVc(proDetailWebView);
    }
}

- (void)recruitCellGotoRealNameAuthenticationWithChatListModel:(JGJChatMsgListModel *)chatListModel cell:(JGJChatWorkSendRecruitInfoCell *)cell {
    
    NSString  *proDetailStr = [NSString stringWithFormat:@"%@%@",JGJWebDiscoverURL, @"my/idcard"];
    
    JGJWebAllSubViewController *proDetailWebView = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeProDetailType URL:proDetailStr];
    if (self.skipToNextVc) {
        
        self.skipToNextVc(proDetailWebView);
    }
}

- (void)loaclVerifiedCellGotoRealNameAuthenticationWithChatListModel:(JGJChatMsgListModel *)chatListModel cell:(JGJChatWorkLoaclVerifiedCell *)cell {
    
    NSString  *proDetailStr = [NSString stringWithFormat:@"%@%@",JGJWebDiscoverURL, @"my/idcard"];
    
    JGJWebAllSubViewController *proDetailWebView = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeProDetailType URL:proDetailStr];
    if (self.skipToNextVc) {
        
        self.skipToNextVc(proDetailWebView);
    }
}

#pragma mark - JGJChatWorkSendVerbInfoCelldelegate 发送招工信息相关操作
- (void)sendRecruitInfoMsgWithChatListModel:(JGJChatMsgListModel *)chatListModel cell:(JGJChatWorkSendRecruitInfoCell *)cell {
    
    [self sendRecruitMsgModelWithIsClickPost:NO];

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    [self handleScrollTop:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(!decelerate){
        
    }
}

#pragma mark - 处理滚动到顶部
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (!self.cusMenuBtn.isHidden) {
        
        [self hiddenCusMenuBtn:self.cusMenuBtn];
        
        [self hiddenCusMenuBtn:self.lastCusMenuBtn];
    }
    // 处理chatLocateBtn的消失
    if (!self.chatLocateMsgIndexPath) return;
    if (!self.chatLocateBtn) return;
    NSArray *indexPaths = [self.tableView indexPathsForVisibleRows];
    if ([indexPaths containsObject:self.chatLocateMsgIndexPath]) {
        [self.chatLocateBtn removeFromSuperview];
    }
}

- (void)hiddenCusMenuBtn:(UIButton *)cusMenuBtn {
    
    [UIView animateWithDuration:0.2 animations:^{
        
        if (cusMenuBtn) {
         
            cusMenuBtn.alpha = 0;
            
            cusMenuBtn.hidden = YES;
            
            [cusMenuBtn removeFromSuperview];
            
        }
        
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    JGJChatMsgListModel *selectedChatModel = self.dataSourceArray[indexPath.row];
//    if (selectedChatModel.chatListType == JGJChatListPic) {
//        
//        //点击需要结束编辑
//        [self.view endEditing:YES];
//        
//        NSMutableArray *picList = [NSMutableArray array];
//        
//        for (int i = 0; i < self.dataSourceArray.count; i ++) {
//            
//            JGJChatMsgListModel *chatModel = self.dataSourceArray[i];
//            
//            if (chatModel.chatListType == JGJChatListPic && chatModel.msg_src.count > 0) {
//                
//                [picList addObject:[chatModel.msg_src firstObject]];
//            }
//        }
//        
//        if (selectedChatModel.msg_src.count > 0) {
//         
//            NSInteger currentPicIndex = [picList indexOfObject:[selectedChatModel.msg_src firstObject]];
//            
//            [JGJCheckPhotoTool chatViewWebBrowsePhotoImageView:picList selImageViews:nil didSelPhotoIndex:currentPicIndex];
//            
//        }
//        
//    }
    
}


- (AudioRecordingServices *)audioRecordingServices {
    
    if (!_audioRecordingServices) {
        
        _audioRecordingServices = [[AudioRecordingServices alloc] init];
        _audioRecordingServices.delegate = self;
    }
    return _audioRecordingServices;
}

#pragma mark - AudioRecordingServicesDelegate
- (void)isPlayEnd {
    
    
}
#pragma mark - JGJChatListMinePicCellDelegate
- (void)chatListMinePicCell:(JGJChatListMinePicCell *)cell {
    
    [self checkSingleImageViewCell:cell];
    
}

- (void)chatListOtherPicCell:(JGJChatListOtherPicCell *)cell {
    
    [self checkSingleImageViewCell:cell];
}

- (void)checkSingleImageViewCell:(UITableViewCell *)cell
{
    //点击需要结束编辑
    [self.view endEditing:YES];
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    JGJChatMsgListModel *chatListModel;
    if (indexPath.row <= self.dataSourceArray.count - 1) {
        chatListModel = (JGJChatMsgListModel *)self.dataSourceArray[indexPath.row];
    }
    
    //如果是记账消息，有2种情况可以查看记账，一种是自己发的，一种是我是创建者
    if (chatListModel.chatListType == JGJChatListRecord) {
        if (chatListModel.belongType == JGJChatListBelongMine ||
            [self.workProListModel.myself_group isEqualToString:@"1"]) {
            [self skipToRecordVcWithBillID:chatListModel.bill_id accounts_type:chatListModel.accounts_type];
        }
    }else if (chatListModel.chatListType == JGJChatListPic) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(chatListVc:seletctedPicCell:)]) {
            [self.delegate chatListVc:self seletctedPicCell:indexPath];
        }
    }
}

#pragma mark - cell的delegate
#pragma mark 点击了图片
- (void)DidSelectedPhoto:(JGJChatListBaseCell *)chatListCell index:(NSInteger )index image:(UIImage *)image{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatListVc:selectedPhoto:index:image:)]) {
        [self.delegate chatListVc:self selectedPhoto:chatListCell index:index image:image];
    }
}

#pragma mark - 点击查看详情或者未读
- (void)topTimeViewSelected:(JGJChatListCellTopTimeView *)topTimeView{
    if (topTimeView.topTimeModel.listType == JGJChatListReadInfo) {//未读消息的显示
        JGJReadRootInfoVc *readRootInfoVc = [JGJReadRootInfoVc new];
//        readRootInfoVc.read_info = topTimeView.topTimeModel.chatMsgListModel.read_info;
        
        JGJChatMsgListModel *chatMsgListModel = topTimeView.topTimeModel.chatMsgListModel;
        
        if ([NSString isEmpty:chatMsgListModel.msg_id]) {
            
            return;
        }
        
        readRootInfoVc.chatMsgListModel = chatMsgListModel;
        
        if (self.skipToNextVc) {
            
            self.skipToNextVc(readRootInfoVc);
            
        }
    }else if(topTimeView.topTimeModel.listType == JGJChatListRecord){
        [self skipToRecordVcWithBillID:topTimeView.topTimeModel.chatMsgListModel.bill_id accounts_type:topTimeView.topTimeModel.chatMsgListModel.accounts_type];
    }
}

#pragma mark - 播放完毕
- (void)playAudioBegin:(NSIndexPath *)indexPath chatListModel:(JGJChatMsgListModel *)chatListModel{
    
    [self clickVoiceCellWithChatMsgModel:chatListModel];
}

- (void)skipToRecordVcWithBillID:(NSString *)bill_id accounts_type:(NSString *)accounts_type{
    MateWorkitemsItems *mateWorkitemsItem = [MateWorkitemsItems new];
    mateWorkitemsItem.id = [bill_id integerValue];
    mateWorkitemsItem.accounts_type.code = [accounts_type integerValue];

    JGJChatListBelongType belongType =[self.workProListModel.myself_group boolValue]?JGJChatListBelongMine:JGJChatListBelongOther;
    mateWorkitemsItem.role = belongType == JGJChatListBelongMine?2:1;
    
    JGJMarkBillBaseVc *workerGetBillVc = [JGJMarkBillBaseVc getSubVc:mateWorkitemsItem];
    
    workerGetBillVc.isChat = YES;
    workerGetBillVc.markBillType = MarkBillTypeEdit;
    workerGetBillVc.selectedDate = [NSDate date];
    workerGetBillVc.mateWorkitemsItems = mateWorkitemsItem;
    workerGetBillVc.mateWorkitemsItems.pid = mateWorkitemsItem.pid;
    workerGetBillVc.mateWorkitemsItems.pro_name = self.workProListModel.pro_name;
    
    workerGetBillVc.workProListModel = self.workProListModel;
    
    if (self.skipToNextVc) {
        self.skipToNextVc(workerGetBillVc);
    }
}

- (void)addTextMessage:(NSString *)textStr at_uid:(NSString *)at_uid{
    
    JGJChatMsgListModel *listModel = [self cofigMsgWithText:textStr at_uid:at_uid];
    
    //添加消息
    [self addMineMessage:listModel];
}

- (void)addAudioMessage:(NSDictionary *)audioInfo{
    
    JGJChatMsgListModel *listModel = [self cofigMsgWithAudio:audioInfo];

    //添加消息
    [self addMineMessage:listModel];
}

- (void)addAllNotice:(NSDictionary *)dataInfo{
    JGJChatMsgListModel *listModel = [self cofigAllNotice:dataInfo];

    //添加消息
    [self addMineMessage:listModel];
}

- (void)addPicMessage:(NSArray *)imagesArr{
    
    TYWeakSelf(self);
    
    JGJSendMessageTool *tool = [JGJSendMessageTool shareSendMessageTool];
    
    //初始的发送信息
    
    tool.myMsgModel = self.myMsgModel;
    
    //获取组信息
    
    tool.workProListModel = self.workProListModel;
    
    //添加图片，统一组装发送数据 imagesArr(image)、chatSelAssets图片唯一标识。用于失败显示用
    
    

    [tool addPicMessage:imagesArr assets:self.chatSelAssets sendMessageSelPicBlock:^(JGJChatMsgListModel *msgModel) {
        //显示数据
        [weakself addSourceArrWith:msgModel];
        
    } sendMessageSuccessBlock:^(JGJChatMsgListModel *msgModel) {
       
        //发送消息成功回调替换数据
        
        [weakself replaceSendPicWithMsgModel:msgModel];
        
    }];
    
}

#pragma mark - 替换发送的图片msg_id

- (void)replaceSendPicWithMsgModel:(JGJChatMsgListModel *)msgModel {
    
    TYWeakSelf(self);
    
    [self.dataSourceArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(JGJChatMsgListModel  *oldMsgModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([oldMsgModel.local_id isEqualToString:msgModel.local_id]) {
            
            oldMsgModel.sendType = JGJChatListSendSuccess;
        
            oldMsgModel.msg_id = msgModel.msg_id;
            
            *stop = YES;
        }
        
    }];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"send_time" ascending:YES];
    
    self.dataSourceArray = [self.dataSourceArray sortedArrayUsingDescriptors:@[sortDescriptor]].mutableCopy;
    
    [weakself.tableView reloadData];
    
}

#pragma mark - 替换转发的消息

- (void)replaceForwardMsgModel:(JGJChatMsgListModel *)msgModel {
    
    TYWeakSelf(self);
    
    //转发倒序遍历较快
    
    [self.dataSourceArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(JGJChatMsgListModel  *oldMsgModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([oldMsgModel.local_id isEqualToString:msgModel.local_id]) {
            
            oldMsgModel.sendType = JGJChatListSendSuccess;

            oldMsgModel.msg_id = msgModel.msg_id;
            
            oldMsgModel.unread_members_num = msgModel.unread_members_num;
            
            *stop = YES;
        }
        
    }];
    
    [self.tableView reloadData];
    
}

- (void)requestWithArray:(NSArray*)imagesArr listModelsArr:(NSArray *)listModelsArr index:(NSInteger)index completion:(void (^)(void))completion {
    if (index >= imagesArr.count) {
        if (completion) {
            completion();
        }
        return;
    }
    
    TYWeakSelf(self);
    NSArray *dataArr = listModelsArr[index];
    __block NSMutableDictionary *dataInfo = [dataArr firstObject];
    __block JGJChatMsgListModel *listModel = [dataArr lastObject];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"local_id == %@", listModel.local_id];
    
    NSArray *sendMsgArray = self.muSendMsgArray.copy;
    
    JGJChatMsgListModel *sendedChatMsglistModel = [sendMsgArray filteredArrayUsingPredicate:predicate].lastObject;
    
    [self progressTimer];
    
    [JLGHttpRequest_AFN uploadImageWithApi:@"jlupload/upload" parameters:nil image:imagesArr[index] progress:^(NSProgress *uploadProgress) {
        
        TYStrongSelf(self);
        
        listModel.progress = uploadProgress.fractionCompleted;
        listModel.sendType = JGJChatListSending;
    
    } success:^(id responseObject) {
        TYStrongSelf(self);
        
        NSArray *imagesUrls = responseObject;
        
        dataInfo[@"msg_src"] = imagesUrls;
        
        SDWebImageManager *sdManger = [SDWebImageManager sharedManager];
        
        if (imagesUrls.count > 0) {
            
            NSString *URL = [NSString stringWithFormat:@"%@%@", JLGHttpRequest_IP, imagesUrls.firstObject];
            
            NSURL *imageUrl = [NSURL URLWithString:URL];
            
            [sdManger saveImageToCache:imagesArr[index] forURL:imageUrl];
            
        }
        
        listModel = [strongself cofigMsgWithPic:dataInfo listModel:listModel];
        listModel.progress = 1.0;
        listModel.sendType = JGJChatListSendSuccess;
        
        self.handleUpLoadProgressBlock = ^{
            
            [weakself.tableView beginUpdates];
            
            [weakself.tableView reloadRowsAtIndexPaths:@[sendedChatMsglistModel.msgIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            [weakself.tableView endUpdates];
        };
        
        if (self.upMediaMsgModels > 0 ) {
            
            [self.upMediaMsgModels removeObject:listModel];
            
        }
        
        //添加消息
        [strongself addMineMessage:listModel];
        
        [strongself requestWithArray:imagesArr listModelsArr:listModelsArr index:index + 1 completion:completion];
        
    } failure:^(NSError *error) {
        TYStrongSelf(self);
        [strongself sendMessageFail:listModel];
        
        [strongself requestWithArray:imagesArr listModelsArr:listModelsArr index:index + 1 completion:completion];
    }];
}

- (void)addMineMessage:(JGJChatMsgListModel *)listModel{
    [self addMineMessage:listModel needToService:YES];
}

- (void)addMineMessage:(JGJChatMsgListModel *)listModel needToService:(BOOL )needToService{
    
    //找工作进入
    if (self.workProListModel.is_find_job) {
        
        JGJChatRecruitMsgModel *chatRecruitMsgModel = self.workProListModel.chatRecruitMsgModel;
        
        //名片进入的时候发消息才带名片和招工信息
        if ([chatRecruitMsgModel.click_type isEqualToString:@"1"]) {
            
            //发送招聘消息
            [self sendRecruitMsgModelWithIsClickPost:NO];
        }
        
    }
    
    listModel = [self cofigMineCommonData:listModel];
    //发送到服务器
    [self sendMsgToServicer:listModel needToService:needToService];

}

- (void)sendMsgToServicer:(JGJChatMsgListModel *)listModel{
    [self sendMsgToServicer:listModel needToService:YES];
}

- (void)sendMsgToServicer:(JGJChatMsgListModel *)listModel needToService:(BOOL )needToService{
    
    //   失败的消息删除原数据，重新发送，并添加显示
    
    if (listModel.sendType == JGJChatListSendFail && [listModel.msg_type isEqualToString:@"text"]) {

        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"local_id=%@",listModel.local_id];

        NSArray *failMsgs = [self.dataSourceArray filteredArrayUsingPredicate:predicate];

        if (failMsgs.count > 0) {

            JGJChatMsgListModel *failMsg = failMsgs.firstObject;

            [self.dataSourceArray removeObject:failMsg];

            [self.tableView reloadData];

            [JGJChatMsgDBManger delSendFailureMsgWithJGJChatMsgListModel:failMsg];

        }
    }
    
    AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];

    AFNetworkReachabilityStatus status = manger.networkReachabilityStatus;

    BOOL isReachableStatus = status == AFNetworkReachabilityStatusNotReachable;

    if (isReachableStatus) {

        [TYShowMessage showPlaint:@"当前网络不可用"];
        
        return;

    }
    
    NSDictionary *parameters = [self configParameters:listModel];
    
    //自己发的消息
    listModel.belongType = JGJChatListBelongMine;
    
    //自己的消息注意uid要先复制,不然人多的时候，替换较慢。所以会产生uid没有的情况
    
    if ([self.myMsgModel.members_num integerValue] > 0) {
        
        listModel.unread_members_num = [self.myMsgModel.members_num integerValue] - 1; //去掉自己
    }
    
    listModel.user_info = self.myMsgModel.user_info;
    
    NSString *real_name = self.myMsgModel.user_info.real_name;
    
    if (![NSString isEmpty:real_name]) {
        
        listModel.user_name = real_name;
        
    }else {
        
        listModel.user_name = [TYUserDefaults objectForKey:JGJUserName]?:@"";
    }
    
    listModel.send_time = [JGJChatMsgDBManger localTime];
    NSString *myUid = [TYUserDefaults objectForKey:JLGUserUid];
    
    listModel.uid = myUid;
    
    listModel.msg_sender = myUid;
    
    listModel.class_type = self.workProListModel.class_type;
    
    //发送的时候先保存数据到数据库, 显示到最后

    //自己这边如果是未认证，这边最后发的auth消息不显示。
    if (listModel.sendType != JGJChatListSendFail && listModel.chatListType != JGJChatAuthType) {

        [self sendMsgInsertMsgDBWithMsgModel:listModel];

    }else if (listModel.sendType == JGJChatListSendFail) {

        [self addSourceArrWith:listModel];

    }
    
    //先增加 2.1.2-yj
    //保存自己发送的消息，用于发送成功自后遍历，节省时间,图片加了几次，只保存一次就可以。刷新状态
    if (listModel.chatListType == JGJChatListPic) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"local_id == %@", listModel.local_id];
        
        NSArray *sendMsgArray = self.muSendMsgArray.copy;
        
        JGJChatMsgListModel *sendedMediaChatMsglistModel = [sendMsgArray filteredArrayUsingPredicate:predicate].lastObject;
        
        if (![sendedMediaChatMsglistModel.local_id isEqualToString:listModel.local_id]) {

            [self.muSendMsgArray addObject:listModel];

            [self addSourceArrWith:listModel];

        }
        
    }else {
        
        if (listModel) {
            
            //失败消息这里表示重发，不重新添加消息
            
            if (listModel.sendType != JGJChatListSendFail && listModel.chatListType != JGJChatAuthType) {
                
                [self.muSendMsgArray addObject:listModel];
                
                if (![listModel.msg_type isEqualToString:@"proDetail"] && listModel.chatListType != JGJChatAuthType) {
                    
                    [self addSourceArrWith:listModel];
                }
                
            }
            
        }
        
    }
    
    //失败的消息更改状态3.5.0添加
    
    if (listModel.sendType == JGJChatListSendFail) {
        
        listModel.sendType = JGJChatListSendStart;
        
        [self.tableView reloadData];
        
    }
    
    __weak typeof(self) weakSelf = self;
    if (needToService) {
        [JGJSocketRequest WebSocketWithParameters:parameters success:^(id responseObject) {
            
            JGJChatMsgListModel *chatMsgListModel= [JGJChatMsgListModel mj_objectWithKeyValues:responseObject];
            
            if ([chatMsgListModel.msg_type isEqualToString:@"recruitment"] || [chatMsgListModel.msg_type isEqualToString:@"postcard"] || [chatMsgListModel.msg_type isEqualToString:@"auth"]) {
                
                [self replaceRecruteMsgModel:chatMsgListModel];
                
            }
            
            //这里有个逻辑是重发失败的消息移除后添加新的消息
            
            chatMsgListModel.sendType = JGJChatListSendSuccess;
            
            if ([chatMsgListModel.msg_sender isEqualToString:[TYUserDefaults objectForKey:JLGUserUid]]) {

                NSString *member_num = weakSelf.myMsgModel.members_num;
                
                weakSelf.myMsgModel = chatMsgListModel;
                
                weakSelf.myMsgModel.members_num = member_num;
                
            }
            
            if (listModel.picImage) {
                
                chatMsgListModel.picImage = listModel.picImage;
            }
          //因为普通文字先存储，这里要发送成功才存储
            if (chatMsgListModel.chatListType == JGJChatListProDetailType) {
                
                [weakSelf replaceSourceArrObject:chatMsgListModel needReload:YES];
                
                //插入工作、招聘消息
                
                [weakSelf insertJobMsg:chatMsgListModel];
                
        
            } else if (!listModel.isFailed) {
                
                [weakSelf replaceSourceArrObject:chatMsgListModel needReload:YES];
            }
            
            //删除草稿消息
            [weakSelf delSendMessageDraftInfo];
            
        } failure:^(NSError *error, id values) {
            
            [weakSelf sendMessageFail:listModel];
            
        }];
    }
    
}

#pragma mark - 替换招聘、名片、认证信息

- (void)replaceRecruteMsgModel:(JGJChatMsgListModel *)chatMsgListModel {
    
    if ([chatMsgListModel.msg_type isEqualToString:@"recruitment"] || [chatMsgListModel.msg_type isEqualToString:@"postcard"] || [chatMsgListModel.msg_type isEqualToString:@"auth"]) {
        
        //这里只需要判断msg_id 和local_id是否有一个相等就可以
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(local_msg_type == %@ or local_msg_type == %@)", @"local_recruitment", @"local_postcard"];
        
        JGJChatMsgListModel *recruMsgModel = [self.dataSourceArray filteredArrayUsingPredicate:predicate].lastObject;
        
        recruMsgModel.is_send_success = YES;
        
        recruMsgModel.cellHeight = 0;

        [self replaceSourceArrObject:chatMsgListModel needReload:YES];
        [self.tableView reloadData];
        
    }
}

#pragma mark - 点击发送的时候存入数据库，根据local_id替换消息
- (void)sendMsgInsertMsgDBWithMsgModel:(JGJChatMsgListModel *)msgModel {
    
    msgModel.class_type = self.workProListModel.class_type;
    
    msgModel.group_id = self.workProListModel.group_id;
    
    JGJChatUserInfoModel *user_info = [[JGJChatUserInfoModel alloc] init];
    
    user_info.real_name = self.myMsgModel.user_name;
    
    msgModel.members_num = self.workProListModel.members_num;
    
//    msgModel.unread_members_num = [self.workProListModel.members_num integerValue] - 1; //去掉自己
    
    //这里设置用户的姓名、当前用户的姓名
    user_info.real_name = [TYUserDefaults objectForKey:JGJUserName];
    
    user_info.head_pic = [TYUserDefaults objectForKey:JLGHeadPic];
    
    user_info.uid = msgModel.msg_sender;
    
    NSString *wcdb_user_info = [user_info mj_JSONString];
    
    msgModel.wcdb_user_info = wcdb_user_info;
    
    //招工信息
    if (msgModel.chatListType == JGJChatListProDetailType) {
        //工作消息字段
        msgModel.job_detail = [msgModel.msg_prodetail mj_JSONString];
        
    }
    
    //这里是在同一时刻发的消息直接插入
    
    else if ([msgModel.msg_type isEqualToString:@"recruitment"] || [msgModel.msg_type isEqualToString:@"postcard"] || [msgModel.msg_type isEqualToString:@"auth"]) {

        [JGJChatMsgDBManger insertAllPropertyChatMsgListModel:msgModel];
        
    }else {
        
        [JGJChatMsgDBManger insertToSendMessageMsgTableWithJGJChatMsgListModel:msgModel propertyListType:JGJChatMsgDBUpdateAllPropertyType];
    }
    
}

#pragma mark - 插入工作、招聘 消息

- (void)insertJobMsg:(JGJChatMsgListModel *)jobMsg {
    
    jobMsg.class_type = self.workProListModel.class_type;
    
    jobMsg.group_id = self.workProListModel.group_id;
    
    JGJChatUserInfoModel *user_info = [[JGJChatUserInfoModel alloc] init];
    
    user_info.real_name = self.myMsgModel.user_name;
    
    jobMsg.members_num = self.workProListModel.members_num;
    
    //这里设置用户的姓名、当前用户的姓名
    user_info.real_name = [TYUserDefaults objectForKey:JGJUserName];
    
    user_info.head_pic = [TYUserDefaults objectForKey:JLGHeadPic];
    
    user_info.uid = jobMsg.msg_sender;
    
    NSString *wcdb_user_info = [user_info mj_JSONString];
    
    jobMsg.wcdb_user_info = wcdb_user_info;
    
    //工作消息字段
    jobMsg.job_detail = [jobMsg.msg_prodetail mj_JSONString];
    
    BOOL is_success = [JGJChatMsgDBManger insertToChatMsgTableWithJGJChatMsgListModel:jobMsg propertyListType:JGJChatMsgDBUpdateAllPropertyType];
    
    TYLog(@"-----%@", is_success?@"插入H5信息成功": @"插入H5信息失败");
}

- (void)sendMessageFail:(JGJChatMsgListModel *)listModel{
    
    [self replaceSourceArrObject:listModel];
    
    //没有网络的时候这里失败的状态没有改到
    listModel.isFailed = YES;
    
    listModel.sendType = JGJChatListSendFail;

}

- (NSDictionary *)configParameters:(JGJChatMsgListModel *)listModel {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"ctrl"] = @"message";
    parameters[@"action"] = @"sendMessage";
    parameters[@"msg_type"] = listModel.msg_type;
    parameters[@"class_type"] = self.workProListModel.class_type;
    
    JGJChatFindJobModel *chatfindJobModel = self.workProListModel.chatfindJobModel;
    
    BOOL isVertify = NO;
    
    if (![NSString isEmpty:chatfindJobModel.verified]) {
        
        isVertify = ![chatfindJobModel.verified isEqualToString:@"3"];
        
        
    }
    
    JGJChatRecruitMsgModel *chatRecruitMsgModel = self.workProListModel.chatRecruitMsgModel;
    
    //招聘进入聊天4.0.1添加
    if (chatRecruitMsgModel && self.workProListModel.is_find_job) {
        
        parameters[@"is_find_job"] = @"1";
        
    }
    
    if (![NSString isEmpty:chatRecruitMsgModel.is_resume]) {
        
        parameters[@"is_resume"] = chatRecruitMsgModel.is_resume;
        
    }
    // 招聘进入聊天，用接口请求回来的名片参数，不用H5回调给我们的（self.workProListModel.chatRecruitMsgModel）
    if (listModel.recruitMsgModel) {
        
        //招聘、名片。msg_text_other 赋值
        if (listModel.chatListType != JGJChatAuthType) {
            
            parameters[@"msg_text_other"] = [listModel.recruitMsgModel mj_JSONString];
            
            listModel.msg_text_other = parameters[@"msg_text_other"];
            
        }
        
        parameters[@"msg_type"] = listModel.msg_type;
    }
    
    //招聘进入聊天4.0.1添加（chatRecruitMsgModel）
    if (self.workProListModel.chatfindJobModel.is_chat || chatRecruitMsgModel.is_chat) {
        
        parameters[@"is_find_job"] = @"1";
    }
    
    if ([self.workProListModel.class_type isEqualToString:@"group"]) {
        parameters[@"group_id"] = listModel.group_id;
    }else if([self.workProListModel.class_type isEqualToString:@"team"]){
        parameters[@"group_id"] = listModel.group_id;
    }else {
        parameters[@"group_id"] = listModel.group_id; //yj添加单聊群聊添加
    }
    
    //语音可不传
    parameters[@"msg_text"] = listModel.msg_text;
    
    if (listModel.msg_src.count) {
        parameters[@"msg_src"] = listModel.msg_src;
    }
    
    if (listModel.voice_long) {
        parameters[@"voice_long"] = listModel.voice_long;
    }
    
    if (listModel.bill_id) {
        parameters[@"bill_id"] = listModel.bill_id;
    }
    
    if (listModel.sign_id) {
        parameters[@"sign_id"] = listModel.sign_id;
    }
    
    if (listModel.pic_w_h) {
        parameters[@"pic_w_h"] = listModel.pic_w_h;
    }
    
    if (listModel.at_uid) {
        parameters[@"at_uid"] = listModel.at_uid;
    }
    
    parameters[@"local_id"] = listModel.local_id;
    
    //质量安全 2.2.3添加

    if (![NSString isEmpty:listModel.is_rectification]) {
        
        parameters[@"is_rectification"] = listModel.is_rectification;
    }
    
    if (![NSString isEmpty:listModel.severity]) {
        
        parameters[@"severity"] = listModel.severity;
    }
    
    if (![NSString isEmpty:listModel.location]) {
        
        parameters[@"location"] = listModel.location;
    }
    
    if (![NSString isEmpty:listModel.location_id]) {
        
        parameters[@"location_id"] = listModel.location_id;
    }
    
    if (![NSString isEmpty:listModel.principal_uid]) {
        
        parameters[@"principal_uid"] = listModel.principal_uid;
    }
    
    if (![NSString isEmpty:listModel.finish_time]) {
        
        parameters[@"finish_time"] = listModel.finish_time;
    }
    
    if (![NSString isEmpty:listModel.statu]) {
        
        parameters[@"statu"] = listModel.statu;
    }
    
    //2.3.0添加检查分项
    if (![NSString isEmpty:listModel.insp_id]) {
        
        parameters[@"insp_id"] = listModel.insp_id;
    }
    
    if (![NSString isEmpty:listModel.pu_inpsid]) {
        
        parameters[@"pu_inpsid"] = listModel.pu_inpsid;
    }

    
    if (![NSString isEmpty:listModel.rec_uid]) {
        
        parameters[@"rec_uid"] = listModel.rec_uid;
    }
    
    return parameters.copy;
}


#pragma mark 配置文本消息
- (JGJChatMsgListModel *)cofigMsgWithText:(NSString *)text at_uid:(NSString *)at_uid
{
    JGJChatMsgListModel *listModel = [JGJChatMsgListModel new];
    listModel.msg_text = text;
    listModel.chatListType = JGJChatListText;
    listModel.at_uid = at_uid;
    
    return listModel;
}

#pragma mark 配置语音消息
- (JGJChatMsgListModel *)cofigMsgWithAudio:(NSDictionary *)audioInfo
{
    JGJChatMsgListModel *listModel = [JGJChatMsgListModel new];

    listModel.chatListType = JGJChatListAudio;
    
    listModel.voice_filePath = audioInfo[@"filePath"];
    
    listModel.voice_long = audioInfo[@"fileTime"];
    
    if (audioInfo[@"msg_src"]) {
        listModel.msg_src = audioInfo[@"msg_src"];
    }

    return listModel;
}

#pragma mark 配置通知类消息
- (JGJChatMsgListModel *)cofigAllNotice:(NSDictionary *)dataInfo
{
    JGJChatMsgListModel *listModel = [JGJChatMsgListModel new];
    
    //2.2.3添加
    listModel = [JGJChatMsgListModel mj_objectWithKeyValues:dataInfo];
    
    listModel.chatListType = (JGJChatListType )[dataInfo[@"chatListType"] integerValue];
    
    //设置文本内容
    NSString *textStr = dataInfo[@"text"];
    if (textStr) {
        listModel.msg_text = dataInfo[@"text"];
    }

    //设置图片
    NSArray *imgsArr = dataInfo[@"imgsAddressArr"];
    if (imgsArr.count) {
        listModel.msg_src = imgsArr;
    }
    
    //记账id
    if (listModel.chatListType == JGJChatListRecord) {
        listModel.bill_id = dataInfo[@"record_id"];
        listModel.msg_text = @"记了一笔工账";
    }
    
    //签到id
    if (listModel.chatListType == JGJChatListSign) {
        listModel.sign_id = dataInfo[@"sign_id"];
    }
    
    
    return listModel;
}

#pragma mark 配置图片消息
- (JGJChatMsgListModel *)cofigMsgWithPic:(NSDictionary *)audioInfo listModel:(JGJChatMsgListModel *)listModel{
    if (!listModel) {
        listModel = [JGJChatMsgListModel new];
    }
    
    listModel.chatListType = JGJChatListPic;
    
    if (audioInfo[@"msg_src"]) {
        listModel.msg_src = audioInfo[@"msg_src"];
    }
    
    if (audioInfo[@"picImage"]) {
        listModel.picImage = audioInfo[@"picImage"];
        listModel.pic_w_h = @[@(listModel.picImage.size.width),@(listModel.picImage.size.height)];
    }
    
    if ([NSString isEmpty:listModel.local_id]) {
        listModel.local_id = [JGJChatListTool localID];
    }
    
    return listModel;
}

#pragma mark - 添加没有数据的时候的默认界面
- (void )noDataDefaultView{
    [self noDataDefaultView:self.dataSourceArray.count];
}

- (void )noDataDefaultView:(NSInteger )dataCout{
    if (!self.chatNoDataDefaultView) {
        self.chatNoDataDefaultView = [[JGJChatNoDataDefaultView alloc] init];
        self.chatNoDataDefaultView.userInteractionEnabled = NO;
        self.chatNoDataDefaultView.delegate = self;

        self.chatNoDataDefaultView.backgroundColor = [UIColor whiteColor];
        if ([self.msgType isEqualToString:@"log"]) {
            
            self.chatNoDataDefaultView.helpBtn.hidden = NO;
            
            self.chatNoDataDefaultView.userInteractionEnabled = YES;
            
            self.chatNoDataDefaultView.helpBtn.userInteractionEnabled = YES;
            
        }
        self.chatNoDataDefaultView.backgroundColor = [UIColor whiteColor];
        
        self.tableView.backgroundColor = [UIColor whiteColor];
    }
    
    JGJChatMsgListModel *chatMsgListModel = [JGJChatMsgListModel new];
    chatMsgListModel.msg_type = self.msgType;
    
    BOOL needAdd = [self.chatNoDataDefaultView needAddViewWithListType:chatMsgListModel.chatListType];
    
    if (!dataCout && needAdd) {
        self.tableView.backgroundColor = [UIColor whiteColor];

        CGFloat bottom = TYIST_IPHONE_X ? 98 : 64;
        
        [self.view addSubview:_chatNoDataDefaultView];
        [self.chatNoDataDefaultView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.view).offset(-bottom);
            make.top.mas_equalTo(self.view).offset(60);
        }];
        [self.view layoutIfNeeded];
        
        if (self.workProListModel.isClosedTeamVc) {
            
            [self.chatNoDataDefaultView addSubview:self.clocedImageView];
            
        }
        
        self.chatNoDataDefaultView.chatListType = chatMsgListModel.chatListType;
    }else{
        if (self.chatNoDataDefaultView) {
            [self.chatNoDataDefaultView removeFromSuperview];
            self.chatNoDataDefaultView = nil;
        }
        self.tableView.backgroundColor = AppFontf1f1f1Color;

        if (self.workProListModel.isClosedTeamVc) {
            
            [self.view addSubview:self.clocedImageView];
            
        }
    }
    
}



- (UIImageView *)clocedImageView {
    
    if (!_clocedImageView) {
        
        NSString *closeType = [self.workProListModel.class_type isEqualToString:@"team"] ? @"pro_closedFlag_icon" : @"Chat_closedGroup";
        
        _clocedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:closeType]];
        
        _clocedImageView.bounds =CGRectMake(0, 0, 126, 71);
        
        _clocedImageView.center = self.view.center;
        
        _clocedImageView.y -= 71;
    }
    return _clocedImageView;
    
}

#pragma mark - 点击"查看详情"
- (void)detailNextBtnClick:(JGJChatListBaseCell *)chatListCell indexPath:(NSIndexPath *)indexPath{
#if 0  //此处调用了我的控制器
    JGJChatListAllDetailVc *allDetailVc = [JGJChatListAllDetailVc new];
    allDetailVc.jgjChatListModel = chatListCell.jgjChatListModel;
    allDetailVc.jgjChatListModel.pro_name = self.workProListModel.pro_name;
    allDetailVc.jgjChatListModel.group_name = self.workProListModel.group_name;
    
    self.skipToNextVc(allDetailVc);
#else
//    JGJNotifyCationDetailViewController *allDetailVc = [JGJNotifyCationDetailViewController new];
//    allDetailVc.jgjChatListModel = chatListCell.jgjChatListModel;
//    self.skipToNextVc(allDetailVc);
    JGJQualitySafeListModel *listModel = [JGJQualitySafeListModel new];
    
    listModel.msg_id = chatListCell.jgjChatListModel.msg_id;
    
    listModel.msg_type = chatListCell.jgjChatListModel.msg_type;
    
    JGJQualityDetailVc *detailVc = [JGJQualityDetailVc new];
    
    detailVc.proListModel = self.workProListModel;
    
    JGJQualitySafeCommonModel *commonModel = [JGJQualitySafeCommonModel new];
    
    detailVc.commonModel = commonModel;
    
    detailVc.listModel = listModel;
    
    if ([chatListCell.jgjChatListModel.msg_type isEqualToString:@"quality"]) {
        
        commonModel.type = JGJChatListQuality;
        
        commonModel.msg_type = @"quality";
        
        self.skipToNextVc(detailVc);
        
    }else if ([chatListCell.jgjChatListModel.msg_type isEqualToString:@"safe"]) {
        
        commonModel.type = JGJChatListSafe;
        
        commonModel.msg_type = @"safe";
        
        self.skipToNextVc(detailVc);
        
    } else if ([chatListCell.jgjChatListModel.msg_type isEqualToString:@"postcard"] || [chatListCell.jgjChatListModel.msg_type isEqualToString:@"local_postcard"]) {
        
        JGJChatRecruitMsgModel *model = chatListCell.jgjChatListModel.recruitMsgModel;
        BOOL isHaveRoleType = [NSString isEmpty:model.role_type] || [model.role_type integerValue] == 0  ? NO : YES;
        
        NSString *path = [NSString stringWithFormat:@"job/userinfo?role_type=%@&search=true&uid=%@",isHaveRoleType ? model.role_type : @(JLGisLeaderBool ? 2 : 1),model.uid];
        NSString *urlString = [NSString stringWithFormat:@"%@%@",JGJWebDiscoverURL,path];
        
        JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:(JGJWebTypeInnerURLType) URL:urlString];
        self.skipToNextVc(webVc);
    
    } else if ([chatListCell.jgjChatListModel.msg_type isEqualToString:@"recruitment"] || [chatListCell.jgjChatListModel.msg_type isEqualToString:@"local_recruitment"]) {
        JGJChatRecruitMsgModel *model = chatListCell.jgjChatListModel.recruitMsgModel;
        NSString *path = [NSString stringWithFormat:@"work/%@",model.pid];
        NSString *urlString = [NSString stringWithFormat:@"%@%@",JGJWebDiscoverURL,path];
        JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:(JGJWebTypeInnerURLType) URL:urlString];
        self.skipToNextVc(webVc);
        
    } else if ([chatListCell.jgjChatListModel.msg_type isEqualToString:@"link"]) {
        NSString *urlString = chatListCell.jgjChatListModel.shareMenuModel.url;
        JGJWebType urlType = JGJWebTypeInnerURLType;
        if ([NSString isEmpty:urlString]) {
            urlType = JGJWebTypeExternalThirdPartBannerType;
        }
        JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:(urlType) URL:urlString];
        self.skipToNextVc(webVc);
    
    }else {
        
        JGJDetailViewController *allDetailVc = [JGJDetailViewController new];
        chatListCell.jgjChatListModel.from_group_name = self.workProListModel.group_name;
        allDetailVc.chatRoomGo = YES;

        allDetailVc.IsClose = self.workProListModel.isClosedTeamVc;

        allDetailVc.workProListModel = self.workProListModel;
        
        //日志详情修改了msg_src这里得重新用个对象，可以copy对象但内部使用属性较多
        NSData *jgjChatListModelData = [NSKeyedArchiver archivedDataWithRootObject:chatListCell.jgjChatListModel];
        
        JGJChatMsgListModel *jgjChatListModel = [NSKeyedUnarchiver unarchiveObjectWithData:jgjChatListModelData];
        
         allDetailVc.jgjChatListModel = jgjChatListModel;
        
        self.skipToNextVc(allDetailVc);
    }
#endif
    
}

#pragma mark - JGJChatMsgBaseCellDelegate
- (void)chatListBaseCell:(JGJChatListBaseCell *)chatListCell showMenuType:(JGJShowMenuType)menuType {
    
    TYLog(@"menu===========");
    
    switch (menuType) {
            
        case JGJShowMenuResendType:{
            
            [self reSendMsgModel:chatListCell];
        }
            
            break;
            
        case JGJShowMenuDelType:{
            
            [self deleteMsgModel:chatListCell.jgjChatListModel];
            
        }
            
            break;
            
        case JGJShowMenuReCallType:{
            
            //直接在cell里面的模型处理即可
            
            JGJChatMsgListModel *recallMsg = chatListCell.jgjChatListModel;
            
            recallMsg.chatListType = JGJChatListRecall;
            
            recallMsg.msg_type = @"recall";
            
            recallMsg.cellHeight = 0; //撤回后重新计算高度
            
            recallMsg.msg_src = @[];
            
            recallMsg.msg_text = @"你 撤回一条消息";
            
            if (self.muSendMsgArray.count > 0) {
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"msg_id=%@",recallMsg.msg_id];
                
                NSArray *recallMsgs = [self.muSendMsgArray filteredArrayUsingPredicate:predicate];
                
                for (JGJChatMsgListModel *msgModel in recallMsgs) {
                    
                    if ([msgModel.msg_id isEqualToString:recallMsg.msg_id]) {
                        
                        msgModel.msg_type = recallMsg.msg_type;
                        
                        msgModel.msg_text = recallMsg.msg_text;
                        
                        msgModel.cellHeight = recallMsg.cellHeight;
                        
                        msgModel.msg_src = recallMsg.msg_src;
                    }
                    
                }
            }
            
//            chatListCell.jgjChatListModel = recallMsg;
            
            //本地更新撤回数据
            [JGJChatMsgDBManger updateMsgModelTableWithJGJChatMsgListModel:recallMsg propertyListType:JGJChatMsgDBUpdateRecallPropertyType];
            
//            [self replaceSourceArrObject:chatListCell.jgjChatListModel index:chatListCell.jgjChatListModel.msgIndexPath.row];
//
            [self.tableView reloadData];
            
        }
            
            break;
            
        case JGJShowMenuCopyType:{
            
            
            
            
        }
            
            break;
            
        default:
            break;
    }
    
}

#pragma mark - 保存当前撤回样式

- (void)chatListBaseCell:(JGJChatListBaseCell *)chatListCell cusMenuBtn:(UIButton *)cusMenuBtn {
    
    if ([chatListCell.jgjChatListModel.msg_type isEqualToString:@"pic"]) {
        
        [self hiddenCusMenuBtn:self.lastCusMenuBtn];
        
        self.cusMenuBtn = cusMenuBtn;
        
        self.lastCusMenuBtn = cusMenuBtn;
        
    }
}

#pragma mark - 修改消息
- (void)modifyMsg:(JGJChatListBaseCell *)chatListCell indexPath:(NSIndexPath *)indexPath{
    [self replaceSourceArrObject:chatListCell.jgjChatListModel index:indexPath.row];
}

- (void)deleteMsg:(JGJChatListBaseCell *)chatListCell indexPath:(NSIndexPath *)indexPath{
    
//    [self deleteSourceArrObject:chatListCell.jgjChatListModel index:indexPath.row];
}

- (void)reSendMsg:(JGJChatListBaseCell *)chatListCell indexPath:(NSIndexPath *)indexPath{
    
    [self reSendMsgModel:chatListCell];
    
}

#pragma mark - forwardChatListModelWithBaseCell 转发消息
- (void)forwardChatListModelWithBaseCell:(JGJChatListBaseCell *)chatListCell {
    
    JGJChatMsgListModel *jgjChatListModel = chatListCell.jgjChatListModel;
    jgjChatListModel.is_source = 2;
    JGJConversationSelectionVc *conversationVc = [[JGJConversationSelectionVc alloc] init];
    conversationVc.message = jgjChatListModel;
    
    
    if (self.skipToNextVc) {

        self.skipToNextVc(conversationVc);
    }
    
////    转发当前组显示
//
//    TYWeakSelf(self);
//
//    conversationVc.messageDidSend = ^(NSArray *messages) {
//
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"group_id=%@ AND class_type=%@",jgjChatListModel.group_id, jgjChatListModel.class_type];
//
//        NSArray *forwardMsgs = [messages filteredArrayUsingPredicate:predicate];
//
//        for (JGJChatMsgListModel *msgModel in forwardMsgs) {
//
//            [self addSourceArrWith:msgModel];
//
//        }
//
//    };
//
//    //转发成功回调O替换数据
//
//    conversationVc.messageSendSuccessed = ^(JGJChatMsgListModel *msgModel) {
//
//        if ([msgModel.group_id isEqualToString:jgjChatListModel.group_id] && [msgModel.class_type isEqualToString:jgjChatListModel.class_type]) {
//
//             [weakself replaceForwardMsgModel:msgModel];
//
//        }
//    };
    
}

/**
 消息分享或转发完成回调
 */
- (void)messageDidSend:(NSNotification *)noti
{
    // 转发当前组显示
    NSArray *messages = noti.object;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"group_id=%@ AND class_type=%@",self.workProListModel.group_id, self.workProListModel.class_type];
    
    NSArray *forwardMsgs = [messages filteredArrayUsingPredicate:predicate];
    
    for (JGJChatMsgListModel *msgModel in forwardMsgs) {
        
        [self addSourceArrWith:msgModel];
        
    }
    
}
/**
 消息分享或转发成功回调
 */
- (void)messageSendSuccessed:(NSNotification *)noti
{
    //转发成功回调O替换数据
    JGJChatMsgListModel *message = noti.object;
    if ([message.group_id isEqualToString:self.workProListModel.group_id] && [message.class_type isEqualToString:self.workProListModel.class_type]) {
        [self replaceForwardMsgModel:message];
    }
}


- (void)deleteMsgModel:(JGJChatMsgListModel *)msgModel {
    
    [self.dataSourceArray removeObject:msgModel];
    
    [self.muSendMsgArray removeObject:msgModel];
    
    [self.tableView reloadData];
    
    //删除当前消息
    
    TYLog(@"删除的消息---------%@----%@", msgModel.msg_id, msgModel.local_id);
    
    [JGJChatMsgDBManger delMsgModel:msgModel];
    
}

- (void)reSendMsgModel:(JGJChatListBaseCell *)cell {
    
//    msgModel.isFailed = YES;
//
//    msgModel.sendType = JGJChatListSendStart;
    
    JGJChatMsgListModel *msgModel = cell.jgjChatListModel;
    
    if ([msgModel.msg_type isEqualToString:@"pic"]) {
        
        JGJSendMessageTool *tool = [JGJSendMessageTool shareSendMessageTool];
        
        tool.workProListModel = self.workProListModel;
        
        msgModel.sendType = JGJChatListSending;
        
        cell.jgjChatListModel = msgModel;
        
        TYWeakSelf(self);
        
        [tool resendMsgModel:msgModel sendMessageSuccessBlock:^(JGJChatMsgListModel *msgModel) {
            
            [weakself replaceSendPicWithMsgModel:msgModel];
            
        }];
        
    }else {
        
         [self sendMsgToServicer:msgModel];
        
    }
    
}

//2.1.0-yj
- (void)audioStopPlay{
    NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in visiblePaths)
    {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if ([cell isKindOfClass:[JGJChatListBaseCell class]]) {
            JGJChatListBaseCell *baseCell = (JGJChatListBaseCell *)cell;
            [baseCell.audioButton stopPlay];
        }
    }
    
}

#pragma mark - 添加通用的参数
- (JGJChatMsgListModel *)cofigMineCommonData:(JGJChatMsgListModel *)listModel{
    listModel.read_info = self.read_info;
    listModel.belongType = JGJChatListBelongMine;
    listModel.head_pic = [TYUserDefaults objectForKey:JLGHeadPic];
    listModel.date = [NSDate stringFromDate:[NSDate date] format:chatMsgTimeFormat];
    
    //添加ID
    listModel.group_id = self.workProListModel.group_id;

    listModel.sendType = JGJChatListSendStart;
    
    if (!listModel.local_id) {
        
        listModel.local_id = [JGJChatListTool localID];
    
    }
    return listModel;
}

- (void)tableViewToBottom
{
#if 1
#pragma mark -解决键盘折叠那个问题 动画原先为NO 现在设置为YES LYQ
    NSInteger rows = self.dataSourceArray.count;
#pragma mark - 刘远强添加  解决网络问题导致偏移量设置出现问题
    
    CGPoint offset = self.tableView.contentOffset;
    CGRect bounds = self.tableView.bounds;
    CGSize size = self.tableView.contentSize;
    UIEdgeInsets inset = self.tableView.contentInset;
    CGFloat currentOffset = offset.y + bounds.size.height - inset.bottom;
    CGFloat maximumOffset = size.height;
    
    //当前距离在屏幕中间时接收到消息不滚动，键盘显示滚动到最新消息
    CGFloat topScroOffset = maximumOffset - currentOffset;
    
    if(((topScroOffset > 200) && !self.isCanScroBottom) || self.isMenuShow) {
        
        return;
        
    }
    
    //首次进入设置的YES,然后取反，一边键盘起作用
    self.isCanScroBottom = NO;
    
    [self.tableView reloadData];
    if (rows > 0) {
//        if (self.tableView.contentOffset.y<=10) {
//            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
//                                  atScrollPosition:UITableViewScrollPositionBottom
//                                          animated:NO];
//        }else{
//            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
//                                  atScrollPosition:UITableViewScrollPositionBottom
//                                          animated:NO];
//        }
        
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:NO];
    }
    
//    //先刷新获取最新的大小
//    [self.tableView reloadData];
//
//    CGSize contentSize = self.tableView.contentSize;
//
//    CGFloat tabH  = self.tableView.frame.size.height;
//
//    if (contentSize.height > tabH) {
//
//        CGPoint offset = CGPointMake(0, contentSize.height - tabH);
//
//        [self.tableView setContentOffset:offset animated:YES];
//    }
    
    
#else
    
#endif
}

- (void)setIsCanScroBottom:(BOOL)isCanScroBottom {
    
    _isCanScroBottom = isCanScroBottom;
    
    
    
}

#pragma mark - 懒加载
- (NSMutableArray *)dataSourceArray
{
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray array];
    }
    return _dataSourceArray;
}
#pragma mark - JGJChatWorkTypeAllInfoCellDelegate
- (void)chatWorkTypeAllInfoCellWithCell:(JGJChatWorkTypeAllInfoCell *)cell didSelectedType:(JGJChatProSelelctedType)workTypeViewType {
    UIViewController *detailVc = nil;
    NSString *proDetailStr = nil;
    
     //找工作、找项目
    JLGFindProjectModel *prodetailactive = cell.chatListModel.msg_prodetail.prodetailactive;
   JGJChatFindHelperModel *searchuser = cell.chatListModel.msg_prodetail.searchuser;//找帮手
    if (workTypeViewType == JGJChatWorkProDetailType) {
        
        //自己点击找工作、找项目、对方两个都有找工作找项目
        if ((cell.chatListModel.belongType == JGJChatListBelongMine) || (prodetailactive && searchuser)) {
            NSString *proUrlType = cell.chatListModel.msg_prodetail.prodetailactive.role_type == 1 ? @"work" : @"project";
            proDetailStr = [NSString stringWithFormat:@"%@%@/%@",JGJWebDiscoverURL, proUrlType,@(cell.chatListModel.msg_prodetail.prodetailactive.pid)];
            
        }else { //对方点击找帮手
            if (prodetailactive && !searchuser) {
                
                proDetailStr = [NSString stringWithFormat:@"%@job/userinfo?role_type=%@&uid=%@", JGJWebDiscoverURL,@(prodetailactive.role_type), cell.chatListModel.group_id];
            }
        }
        
    }else if (workTypeViewType == JGJChatWorkPerInfoDetailType) {
//        JGJPerInfoVc *perInfoVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJPerInfoVc"];
//        perInfoVc.jgjChatListModel.uid = cell.chatListModel.group_id;
//        perInfoVc.jgjChatListModel.group_id = cell.chatListModel.group_id;
//        perInfoVc.jgjChatListModel.class_type = @"singleChat";
//        detailVc = perInfoVc;
        
        if (searchuser) {
            
            proDetailStr = [NSString stringWithFormat:@"%@job/userinfo?role_type=%@&uid=%@", JGJWebDiscoverURL,@(searchuser.role_type), cell.chatListModel.group_id];
        }
        
    }else if (workTypeViewType == JGJChatMyIdcardType) {
        
        proDetailStr = [NSString stringWithFormat:@"%@%@",JGJWebDiscoverURL, @"my/idcard"];
    }
    
    JGJWebAllSubViewController *proDetailWebView = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeProDetailType URL:proDetailStr];
    detailVc = proDetailWebView;
    
    if (self.skipToNextVc) {
        self.skipToNextVc(detailVc);
    }
}

- (void)handleScrollTop:(UIScrollView *)scrollView {

    BOOL isCanScrolTop = [self.msgType isEqualToString:@"all"];
    
    if ((scrollView.contentOffset.y > TYGetViewH(self.tableView)) && !isCanScrolTop) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self scrollTopButton];
            
            [UIView animateWithDuration:0.2 animations:^{
                
                self.scrollTopButton.hidden = NO;
                self.scrollTopButton.alpha = 1;
            }];
            
        });
    }else {
        [UIView animateWithDuration:0.2 animations:^{
            
            self.scrollTopButton.hidden = YES;
            self.scrollTopButton.alpha = 0;
        }];
    }
}

- (UIButton *)scrollTopButton {
    
    if (!_scrollTopButton) {
        
        _scrollTopButton = [[UIButton alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth - 70, TYGetUIScreenHeight - 200, 50, 50)];
        [_scrollTopButton addTarget:self action:@selector(handleScrollTopButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollTopButton setImage:[UIImage imageNamed:@"scroll_top_normal"] forState:UIControlStateNormal];
        [self.view addSubview:_scrollTopButton];
    }
    
    return _scrollTopButton;
}

- (void)handleScrollTopButtonPressed:(UIButton *)sender {

    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    self.scrollTopButton.hidden = YES;
}


- (NSMutableArray *)muSendMsgArray {
    
    if (!_muSendMsgArray) {
        
        _muSendMsgArray = [NSMutableArray new];
    }
    
    return _muSendMsgArray;
    
}

- (NSMutableArray *)upMediaMsgModels {
    
    if (!_upMediaMsgModels) {
        
        _upMediaMsgModels = [NSMutableArray new];
    }
    
    return _upMediaMsgModels;
}

- (NSTimer *)progressTimer {
    
    if (!_progressTimer) {
        
        // 调用了scheduledTimer返回的定时器，已经自动被添加到当前runLoop中，而且是NSDefaultRunLoopMode
        //        _progressTimer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterVal target:self selector:@selector(freshProgress:) userInfo:nil repeats:YES];
        //
        //        // 修改模式
        //        [[NSRunLoop currentRunLoop] addTimer:_progressTimer forMode:NSRunLoopCommonModes];
    }
    
    return _progressTimer;
}

- (void)freshProgress:(NSTimer *)timer {
    
    if (self.handleUpLoadProgressBlock) {
        
        self.handleUpLoadProgressBlock();
    }
    
    TYLog(@"TimerEnd");
    
    if (self.upMediaMsgModels.count == 0) {
        
        [_progressTimer invalidate];
        
        _progressTimer = nil;
        
        TYLog(@"Timerinvalidate");
    }
}

- (CGFloat)timeInterVal {
    
    _timeInterVal = 0.3;
    
    if (self.upMediaMsgModels.count == 0) {
        
        [_progressTimer invalidate];
        
        _progressTimer = nil;
        
    }else {
        
        _timeInterVal = self.upMediaMsgModels.count * 0.3;
        
    }
    
    return _timeInterVal;
}

#pragma amrk - 初始化已读消息任务模型
- (NSMutableArray *)messageReadedToSenderTask {
    
    if (!_messageReadedToSenderTask) {
        
        _messageReadedToSenderTask = [NSMutableArray array];
    }
    
    return _messageReadedToSenderTask;
    
}

#pragma mark - 删除草稿信息
- (void)delSendMessageDraftInfo {
    
    JGJQuaSafeToolReplyModel *pubModel = [JGJQuaSafeToolReplyModel new];
    
    pubModel.group_id = self.workProListModel.group_id;
    
    pubModel.class_type = self.workProListModel.class_type;
    
    pubModel.unique_id = [NSString stringWithFormat:@"%@%@%@", @"chat",self.workProListModel.class_type, self.workProListModel.group_id];
    
    [JGJQuaSafeTool removeCollecReplyModel:pubModel];
    
}

#pragma mark - 保存聊天图片
- (void)saveChatSelPhotoImageWithAssets:(NSArray *)assets index:(NSInteger)index listModel:(JGJChatMsgListModel *)listModel {
    
    for (int i = 0 ; i < assets.count; i ++)
    {
        UIImage *image = [assets objectAtIndex:i];
        
        PHAsset *asset = assets[i];
        
        NSString *assetString = asset.localIdentifier;
        
        listModel.assetlocalIdentifier = asset.localIdentifier;
        
        [JGJChatMsgDBManger insertToChatMsgTableWithJGJChatMsgListModel:listModel propertyListType:JGJChatMsgDBUpdateAllPropertyType];
        
        TYLog(@"插入图片唯一标示localIdentifier=======%@", asset.localIdentifier);
        
    }
    
}

#pragma mark - JGJCusAddMediaViewDelegate 选择相册、拍摄、我的名片
- (void)cusAddMediaView:(JGJCusAddMediaView *)mediaView didSelBtnType:(JGJCusAddMediaViewBtnType)type {
    
    switch (type) {
            
        case JGJCusAddMediaViewPhotoAlbumBtnType: //相册
            
            break;
            
        case JGJCusAddMediaViewShootBtnType: //拍摄
            
            break;
            
        case JGJCusAddMediaViewPostCardType: //我的名片
            
            break;
            
        default:
            break;
    }
    
}

#pragma mark - 发送工作或者招聘消息

- (void)sendRecruitMsgModelWithIsClickPost:(BOOL)isClickPost {
    
    //用于先发消息，再发送名片。发送招工、名片、认证
    self.isClickPost = isClickPost;
    
    //添加通用的配置
    if (self.workProListModel.is_find_job || isClickPost) {
        
        JGJChatRecruitMsgModel *chatRecruitMsgModel = self.workProListModel.chatRecruitMsgModel;
        
        BOOL isVertify = NO;
        
        //不等于3是未认证
        
        if (![NSString isEmpty:chatRecruitMsgModel.verified]) {
            
            isVertify = ![chatRecruitMsgModel.verified isEqualToString:@"3"];
        }
        
        NSMutableArray *msg_types = @[@"recruitment"].mutableCopy;
        
        //click_type ：1名片 2工作 isClickPost YES发型名片
        if ([chatRecruitMsgModel.click_type isEqualToString:@"1"] && isClickPost) {//名片进来已认证发送两条信息。第一条招工信息、第二条名片信息
            
            msg_types = @[@"recruitment", @"postcard"].mutableCopy;
            
        }else if ([chatRecruitMsgModel.click_type isEqualToString:@"2"]) { //
            
            msg_types = @[@"recruitment"].mutableCopy;
        }else {
            
            msg_types = @[@"recruitment"].mutableCopy;
        }
        
        if (isVertify) {
            
            [msg_types addObject:@"auth"];
            
        }
        
        NSInteger count = msg_types.count;
        
        for (NSInteger index = 0; index < count; index++) {
            
            NSString *msg_type = msg_types[index];
            
            self.findJobTemporaryMsgModel.msg_type = msg_type;
            
            self.findJobTemporaryMsgModel.local_id = [JGJChatListTool localID];
            
            JGJChatMsgListModel *findJobMsgModel = [JGJChatMsgListModel new];
            
            findJobMsgModel.recruitMsgModel = self.findJobTemporaryMsgModel.recruitMsgModel;
            
            findJobMsgModel.is_find_job = self.findJobTemporaryMsgModel.is_find_job;
            
            if ([msg_type isEqualToString:@"auth"]) {
                
                NSString *chatname = findJobMsgModel.recruitMsgModel.group_name;
                
                if ([NSString isEmpty:chatname]) {
                    
                    chatname = [TYUserDefaults objectForKey:JGJUserName];
                    
                }
                
                if ([NSString isEmpty:chatname]) {
                    
                    chatname = self.workProListModel.group_name;
                    
                }
                
                findJobMsgModel.msg_text = chatname;
            }
            
            findJobMsgModel.msg_type = msg_types[index];
            
            findJobMsgModel.group_id = self.workProListModel.group_id;
            
            findJobMsgModel.class_type = self.workProListModel.class_type;
            
            findJobMsgModel.local_id = [JGJChatListTool localID];
            
            findJobMsgModel.belongType = JGJChatListBelongMine;
            
            //招工信息发送到服务器
            [self sendMsgToServicer:findJobMsgModel needToService:YES];
            
        }
        
        //发完之后清除找工作进入聊天的标识
        self.workProListModel.is_find_job = NO;
        
        if (self.isClickPost) {
            
            self.isClickPost = NO;
            
        }
    }
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

- (JGJCusAddMediaView *)mediaView {

    if (!_mediaView) {

        CGFloat height = [JGJCusAddMediaView meidaViewHeight] + JGJ_IphoneX_BarHeight;

        _mediaView = [[JGJCusAddMediaView alloc] initWithFrame:CGRectMake(0, TYGetUIScreenHeight, TYGetUIScreenWidth, height)];

        _mediaView.delegate = self;

    }

    return _mediaView;
}

@end
