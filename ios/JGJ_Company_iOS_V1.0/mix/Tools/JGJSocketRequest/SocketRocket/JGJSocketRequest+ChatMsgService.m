//
//  JGJSocketRequest+ChatMsgService.m
//  mix
//
//  Created by yj on 2018/8/15.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJSocketRequest+ChatMsgService.h"
#import "JGJChatGetOffLineMsgInfo.h"
#import "JGJChatMsgDBManger.h"

#import "JGJChatMsgDBManger+JGJGroupDB.h"
#import "JGJChatMsgDBManger+JGJIndexDB.h"
#import "JGJMangerTool.h"

#import "JGJChatOffLineMsgTool.h"
#import "JGJChatMsgDBManger+JGJIndexDB.h"
#import "JGJChatGetOffLineMsgInfo.h"

#import "JGJSocketRequest+GroupService.h"

static JGJMangerTool *timerTool = nil;

static JGJMangerTool *callBackTimer = nil;

static NSString *is_readed_key = @"is_readed_key";

static NSString *read_msg_model_key = @"read_msg_model_key";

static NSString *message_readed_callback_key = @"message_readed_callback_key";

static NSString *received_msg_callback_key = @"received_msg_callback_key";

static NSString *contactList_callback_key = @"contactList_callback_key";

//别人查看消息服务器回执
static NSString *messageReadedToSender = @"messageReadedToSender";

//发送消息
static NSString *sendMessage = @"sendMessage";
//红点消息
static NSString *reddotMessage = @"reddotMessage";
//接收消息
static NSString *receiveMessage = @"receiveMessage";

//撤回消息
static NSString *recallMessage = @"recallMessage";

//接收消息组
static NSString *receMsgArr_key = @"receMsgArr_key";

//回执服务器的消息组
static NSString *callBackServiceMsgArr_key = @"callBackServiceMsgArr_key";

static NSString *last_msg_id_key = @"last_msg_id_key";

static JGJSocketRequest *shareSocket = nil;

@interface JGJSocketRequest()



//正在读的当前组消息获取当前的group_id 和class_type


//接收总的消息
@property (nonatomic, strong) NSMutableArray *receMsgArr;

//回执服务器的消息组
@property (nonatomic, strong) NSMutableArray *callBackServiceMsgArr;

//上一条消息回执id
@property (nonatomic, copy) NSString *last_msg_id;

@end

@implementation JGJSocketRequest (ChatMsgService)

/**
 *接收自己发送的质量安全消息
 */
+(void)receiveMySendMsgWithMsgs:(NSArray *)msgs action:(NSString *)action{
    
    //插入消息到数据库
    [self insertDBMsgs:msgs action:action];
    
    //自己发的质量、安全本地添加 标记已读
    
    if (msgs.count == 1) {
        
        [self readedMsgModel:msgs.firstObject isReaded:YES];
        
        // 离开聊天页面 把聊天页面的最后一条消息 更新到聊聊列表中
        JGJChatMsgListModel *msgModel = msgs.firstObject;
        JGJChatGroupListModel *upadteGroupModel = [[JGJChatGroupListModel alloc] init];
        
        upadteGroupModel.group_id = msgModel.group_id;
        upadteGroupModel.class_type = msgModel.class_type;
        upadteGroupModel.user_id = [TYUserDefaults objectForKey:JLGUserUid];
        
        upadteGroupModel.last_send_uid = msgModel.msg_sender;
        upadteGroupModel.last_msg_type = msgModel.msg_type;
        upadteGroupModel.last_msg_send_time = msgModel.send_time;
        upadteGroupModel.list_sort_time = msgModel.send_time;
        upadteGroupModel.last_send_name = msgModel.user_info.real_name;
        upadteGroupModel.sys_msg_type = msgModel.sys_msg_type;
        upadteGroupModel.max_asked_msg_id = msgModel.msg_id;
        upadteGroupModel.msg_text = msgModel.msg_text;
        upadteGroupModel.at_message = msgModel.at_message;
        upadteGroupModel.last_msg_content = msgModel.msg_text;
        upadteGroupModel.title = msgModel.title;
        [JGJChatMsgDBManger updateNew_Chat_Msg_No_Chat_Unread_Msg_CountToGroupTableWithGroupListModel:upadteGroupModel];
        
    }
}

+(void)insertWebSocketReceiveChatMsg:(id)receive {
    
    TYLog(@"receivemsgs = %@",receive);
    
    NSArray *receiveArr = (NSArray *)receive[@"result"];
    
    if ([receive[@"action"] isEqualToString:messageReadedToSender]) {
        
        if ([receiveArr isKindOfClass:[NSArray class]]) {
            
            NSArray *messageReads = [JGJChatMsgListModel mj_objectArrayWithKeyValuesArray:receive[@"result"]];
            
            if (messageReads.count > 0) {
                
                [self messageReadedToSenderWithMsgModels:messageReads];
                
            }
            
        }
        
    }
    
    NSString *action = receive[@"action"];
    
    //处理线面三种情况
    if (!([action isEqualToString:sendMessage] || [action isEqualToString:receiveMessage] || [action isEqualToString:recallMessage])) {
        
        if ([action isEqualToString:reddotMessage]) {
            
            if ([receive[@"result"][@"msg_type"] isEqualToString:@"reply"]) {
                
                JGJIndexDataModel *indexModel = [JGJChatMsgDBManger getTheIndexModelInIndexTable];
                if ([receive[@"result"][@"group_id"] isEqualToString:indexModel.group_id] && [receive[@"result"][@"class_type"] isEqualToString:indexModel.class_type]) {
                    
                    indexModel.work_message_num = [NSString stringWithFormat:@"%ld",[indexModel.work_message_num integerValue] + 1];
                    BOOL updateSuccess = [JGJChatMsgDBManger updateIndexModelToIndexTable:indexModel];
                    
                    if (updateSuccess) {
                        
                        [JGJChatGetOffLineMsgInfo refreshIndexTbToHomeVC];
                    }
                }
                
            }
        }
        return;
    }
    
    //初始化定时器
    if (!timerTool) {

        timerTool = [[JGJMangerTool alloc] init];

        timerTool.timeInterval = 0.1;

    }

    [timerTool startTimer];
    
    NSArray *msgs = nil;
    
    if ([receive[@"result"] isKindOfClass:[NSArray class]]) {
        
        msgs = [JGJChatMsgListModel mj_objectArrayWithKeyValuesArray:receiveArr];
        
    }else {// 红点返的是NSDictionary对象
        
        msgs = @[[JGJChatMsgListModel mj_objectWithKeyValues:receive]];
    }
    
    //sendMessage 返回一个数据转换
    if ([receive[@"result"] isKindOfClass:[NSDictionary class]]) {
        
        JGJChatMsgListModel *msgModel = [JGJChatMsgListModel mj_objectWithKeyValues:receive[@"result"]];
        
        if (msgModel) {
            
            msgs = @[msgModel];
        }

    }
        
    TYLog(@"收到一批数据------ = %@",msgs);
    
    //消息小于20个才处理，筛选班组信息，这里后台做处理不给企业端推个人端信息
    
    if (msgs.count < 20) {
        
        msgs = [JGJChatMsgDBManger filterGroupMsgs:msgs];
        
    }

    
    if (!shareSocket) {
        
        shareSocket = [JGJSocketRequest shareSocketConnect];
    }
    
    if (!shareSocket.receMsgArr) {
        
        shareSocket.receMsgArr = [NSMutableArray array];
    }
    
    //处理接收的消息
    
    if (msgs.count > 0) {
        
        [self handleReceiveGroupMsgs:msgs action:action];
        
    }

    //处理接收到的撤回消息
    
    [self callBackServiceRecallSuccessWithMsgs:msgs];
}


+(void)handleReceiveGroupMsgs:(NSArray *)msgs action:(NSString *)action {
    
    //只要是最后条是在读，都回执读消息，后台返回成功，调未读人数接口
    
    BOOL is_read = [self readMsgWithMsgModel:msgs.lastObject];
    
    JGJMsgCallBackType type = is_read ? JGJMsgCallBackReadedType :JGJMsgCallBackReceivedType;
    
    //处理receiveMessage
    
    if ([action isEqualToString:receiveMessage]) {
        
        //用离线插入离线消息到数据库，并且回执消息给服务器
        
        TYLog(@"开始的处理状态----%@", @(JGJIsHandlingMsgBool));
        
        //回执给聊聊处理
        
        [self handleSaveDBSuccessCallBackGroupWithMsgs:msgs action:action type:type];
        
        if (!JGJIsHandlingMsgBool) {
            
            TYWeakSelf(self);
            
            //msglist这里是批量消息处理结束返回
            
            [JGJChatOffLineMsgTool handleOfflineMsgs:msgs type:type callBack:^(NSArray *msglist) {
            
                //普通消息延时处理
                
                if (msglist.count > 0) {
                    
                    TYLog(@"处理离线成功----显示消息");
                    
                    NSString *group_id = shareSocket.readMsgModel.group_id;
                    
                    NSString *class_type = shareSocket.readMsgModel.class_type;
                    
                    if (![NSString isEmpty:group_id] && ![NSString isEmpty:class_type]) {
                        
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"group_id=%@ && class_type=%@",group_id, class_type];
                        
                        NSArray *readGroupMsgs = [msglist filteredArrayUsingPredicate:predicate];
                        
                        if (readGroupMsgs.count > 0) {
                            
                            [shareSocket.receMsgArr addObjectsFromArray:readGroupMsgs];
                            
                            //收到消息开启定时器，显示消息
                            
                            [timerTool startTimer];
                            
                        }
                        
                    }
                    
                    //间隔timer 时间显示消息
                    
                    NSInteger maxLength = 5;
                    
                    timerTool.toolTimerBlock = ^{
                        
                        if (shareSocket.receMsgArr.count > 0) {
                            
                            NSArray *subArr = shareSocket.receMsgArr;
                            
                            NSInteger receMsgCount = shareSocket.receMsgArr.count;
                            
                            if (receMsgCount >= maxLength) {
                                
                                subArr = [shareSocket.receMsgArr subarrayWithRange:NSMakeRange(0, maxLength)];
                                
                                shareSocket.receMsgArr = [shareSocket.receMsgArr subarrayWithRange:NSMakeRange(maxLength, receMsgCount - maxLength)].mutableCopy;
                                
                            }
                            
                            //插入消息到数据库,最多长度maxLength
                            
                            if (subArr.count > 0 && subArr.count == maxLength) {
                                
                                [weakself insertDBMsgs:subArr action:action];
                                
                                //                                TYLog(@"subArr.count > 0 && subArr.count == maxLength--------1111");
                                
                            }else if (subArr.count > 0 && subArr.count < maxLength) {
                                
                                [weakself insertDBMsgs:subArr action:action];
                                
                                [shareSocket.receMsgArr removeAllObjects];
                                
                                [timerTool inValidTimer];
                                
                                TYLog(@"subArr.count > 0 && subArr.count < maxLength");
                                
                            }else {
                                
                                [shareSocket.receMsgArr removeAllObjects];
                                
                                [timerTool inValidTimer];
                                
                                TYLog(@"inValidTimer--------3333");
                                
                            }
                            
//                            //小于maxLength插入显示全部清除，临时数据
//
//                            if (receMsgCount < maxLength) {
//
//                                [shareSocket.receMsgArr removeAllObjects];
//
//                                [timerTool inValidTimer];
//                            }
//
                            
                        }else {
                            
                            [timerTool inValidTimer];
                            
                            TYLog(@"处理消息结束了inValidTimer--");
                        }
                        
                    };
                    
                }
                
            }];
            
        }
        
    }else {
        
        //处理sendMessage
        
        if (msgs.count > 0) {
            
            [self insertDBMsgs:@[msgs.lastObject] action:action];
            
            //回执发送消息给聊聊
            [self callbackGroupServiceWithMaxMsgs:msgs msgs:msgs type:type callback:^(NSArray *msgs) {

                TYLog(@"回执发送消息给聊聊---%@ action == %@", msgs, action);
            }];
            
        }
        
    }
}

#pragma mark - 存数据库成功回执聊聊处理
+(BOOL)handleSaveDBSuccessCallBackGroupWithMsgs:(NSArray *)msgs action:(NSString *)action type:(JGJMsgCallBackType)type {
    
    //收到工作消息聊聊单独处理
    
    if (msgs.count > 0) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sys_msg_type!=%@", @"normal"];
        
        NSArray *workMsgs = [msgs filteredArrayUsingPredicate:predicate];
        
        [self callbackGroupServiceWithMsgs:msgs workMsgs:workMsgs type:type callback:^(NSArray *msgs) {
            
            
        }];
        
        //工作消息和总消息相等，直接处理。不需要等待数据库处理完
        
        if (workMsgs.count == msgs.count) {
            
            return NO;
        }
        
    }
    
    return YES;
}

// 回执聊聊表收到显示的消息

+(void)callbackGroupServiceWithMaxMsgs:(NSArray *)maxMsgs msgs:(NSArray *)msgs type:(JGJMsgCallBackType)type callback:(void(^)(NSArray *msgs))callBack {
    
    //回执给聊聊处理
    [self receiveMsgCallBackGroup:msgs maxMsgs:maxMsgs type:type];
    
}

/**
 *接收离线消息页面显示
 */
+(void)receiveCurGroupOffineMsgs:(NSArray *)msgs type:(JGJMsgCallBackType)type {
    
    if (msgs.count > 0) {
        
        NSString *group_id = shareSocket.readMsgModel.group_id;
        
        NSString *class_type = shareSocket.readMsgModel.class_type;
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"group_id=%@ && class_type=%@",group_id, class_type];
        
        //把当前组的消息获取出来，并显示
        
        NSArray *readGroupMsgs = [msgs filteredArrayUsingPredicate:predicate];
        
        if (JGJSuspendlOfflineMsgBool) {
            
            [self insertDBMsgs:readGroupMsgs action:receiveMessage];
        }
        
    }
    
}

// 回执聊聊表工作消息收到显示的消息
+(void)callbackGroupServiceWithMsgs:(NSArray *)msgs workMsgs:(NSArray *)workMsgs type:(JGJMsgCallBackType)type callback:(void(^)(NSArray *msgs))callBack {

    
    NSMutableArray *maxMsgArr = [NSMutableArray array];
    
    NSMutableDictionary *lastDic = [NSMutableDictionary dictionary];
    
    for (NSInteger indx = 0; indx < workMsgs.count; indx++) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        JGJChatMsgListModel *msgModel = workMsgs[indx];
        
        msgModel.sendType = JGJChatListSendSuccess;
        
        //延展字段
        msgModel.wcdb_extend = [msgModel.extend mj_JSONString];
        
        msgModel.wcdb_user_info = [msgModel.user_info mj_JSONString];
        
        if (![lastDic[@"class_type"] isEqualToString:msgModel.class_type] || ![lastDic[@"group_id"] isEqualToString:msgModel.group_id]) {
            
            [JGJChatOffLineMsgTool maxMsgDic:dic msgModel:msgModel];
            
            lastDic = dic;
            
            [maxMsgArr addObject:lastDic];
            
        }else {
            
            if ([msgModel.msg_id integerValue] > [lastDic[@"msg_id"] integerValue]) {
                
                [JGJChatOffLineMsgTool maxMsgDic:lastDic msgModel:msgModel];
                
            }
            
        }
        
        [JGJChatMsgDBManger insertToChatMsgTableWithJGJChatMsgListModel:msgModel propertyListType:JGJChatMsgDBUpdateAllPropertyType];
        
    }
    
    if (workMsgs.count == msgs.count && workMsgs.count > 0 && maxMsgArr.count > 0) {
        
        NSDictionary *maxGroupDic = [maxMsgArr mj_keyValues];
        
        NSArray *maxMsgs = [JGJChatMsgListModel mj_objectArrayWithKeyValuesArray:maxMsgArr];
        
        NSArray *maxGroupDics = [JGJChatMsgListModel mj_keyValuesArrayWithObjectArray:maxMsgs keys:@[@"class_type",@"group_id", @"msg_id"]];
        
        NSString *maxGroupIds = [maxGroupDics mj_JSONString];
        
        [self callbackServiceMaxMsgs:maxGroupIds maxMsgModel:msgs.lastObject type:type callback:^(JGJChatMsgListModel *msgModel) {
           
            TYLog(@"工作消息回执成功了---%@", maxGroupIds);
            
        }];
        
        
    }
    
    
    if (callBack) {
        
        callBack(workMsgs);
        
    }
    
}

#pragma mark - 转换模型

+(NSString *)dicWithMsgs:(NSArray *)msgs {
    
    NSMutableArray *maxMsgs = [NSMutableArray array];
    
    for (NSInteger index = 0; index < msgs.count; index++) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        JGJChatMsgListModel *msgModel = msgs[index];
        
        if (![NSString isEmpty:msgModel.msg_id]) {
            
            dic[@"msg_id"] = msgModel.msg_id;
            
            if (![NSString isEmpty:msgModel.class_type]) {
                
                dic[@"class_type"] = msgModel.class_type;
            }
            
            if (![NSString isEmpty:msgModel.group_id]) {
                
               dic[@"group_id"] = msgModel.group_id;
            }
            
            [maxMsgs addObject:dic];
        }
    }
    
    NSString *msgsId = [maxMsgs mj_JSONString];
    
    return msgsId;
}

#pragma mark - 回执收到的消息
+(void)callbackServiceMaxMsgs:(NSString *)msgs maxMsgModel:(JGJChatMsgListModel *)maxMsgModel type:(JGJMsgCallBackType)type callback:(void(^)(JGJChatMsgListModel *msgModel))callBack {
    
    NSString *callBackType = type == JGJMsgCallBackReadedType ? @"readed" : @"received";
    
    TYWeakSelf(self);
    
    if ([NSString isEmpty:msgs]) {
        
        return;
    }
    
    //    回执类型（readed 已读 / received 接收 ）
    // msgModel.msg_total_type == JGJChatNormalMsgType 代表正常聊天消息，否则代表工作 招聘 活动类型消息
    
    NSDictionary *parameters = @{@"ctrl" : @"message",
                                 @"action" : @"getCallBackOperationMessage",
                                 @"msg_info" : msgs,
                                 @"type"  : callBackType
                                 };
        
    [JGJSocketRequest WebSocketWithParameters:parameters success:^(id responseObject) {
        
        if (callBack) {
            
            callBack(maxMsgModel);
        }
        
    } failure:^(NSError *error, id values) {
        
        
    }];
    
}


+ (void)updateMsgDBWithMsgModel:(JGJChatMsgListModel *)msgModel {
    
    JGJChatMsgListModel *existMsgModel = [JGJChatMsgDBManger msgModel:msgModel];
    
    if ([existMsgModel.msg_id isEqualToString:msgModel.msg_id]) {
        
       [JGJChatMsgDBManger insertToChatMsgTableWithJGJChatMsgListModel:existMsgModel propertyListType:JGJChatMsgDBUpdateAllPropertyType];
        
    }
    
}

//#pragma mark - 已读消息回执
//+(void)messageReadedWithMsgModel:(JGJChatMsgListModel *)msgModel type:(JGJMsgCallBackType)type callback:(void(^)(JGJChatMsgListModel *msgModel))callBack {
//
//    [self callbackServiceMsgModel:msgModel type:JGJMsgCallBackReadedType callback:callBack];
//
//}

#pragma mark - 更新 聊聊列表 是否已读的最大消息id 和确认收到的最大消息id
+(void)updateGoupDBWithMsgModel:(JGJChatMsgListModel *)msgModel type:(JGJMsgCallBackType)type {
    
    JGJChatGroupListModel *groupListModel = [JGJChatMsgDBManger getChatGroupListModelWithGroup_id:msgModel.group_id classType:msgModel.class_type];
    
    switch (type) {
            
        case JGJMsgCallBackReadedType:{
            
            TYLog(@"更新聊聊表=====max_read_msg_id  %@  %@  %@  %@", msgModel.msg_text, msgModel.class_type, msgModel.group_id, msgModel.msg_id);
            
            //确认收到且已读
            msgModel.is_readed = @"1";

            [JGJChatMsgDBManger updateMsgRowPropertyWithJGJChatMsgListModel:msgModel propertyListType:JGJChatMsgDBUpdateIsReadedPropertyType];
        }
            
            break;
            
        case JGJMsgCallBackReceivedType:{
            
            TYLog(@"更新聊聊表=====max_asked_msg_id %@", msgModel.msg_text);
            
            //确认已收到
            msgModel.is_received = @"1";

            [JGJChatMsgDBManger updateMsgRowPropertyWithJGJChatMsgListModel:msgModel propertyListType:JGJChatMsgDBUpdateIsReceivedPropertyType];
        }
            
            break;
            
        default:
            break;
    }
    
}

//进入页面是否正在读消息，读状态回执最后一条给服务器，当前把最大的消息id赋值给聊聊表
+(void)readedMsgModel:(JGJChatMsgListModel *)msgModel isReaded:(BOOL)isReaded{
    
    shareSocket = [JGJSocketRequest shareSocketConnect];

    shareSocket.is_readed = isReaded ? @"1" : @"0";
    
    shareSocket.readMsgModel = msgModel;
    
    if (timerTool && !isReaded) {
        
        [timerTool inValidTimer];
        
        timerTool = nil;
        
    }
    
    if (shareSocket.is_readed && ![NSString isEmpty:msgModel.class_type] && ![NSString isEmpty:msgModel.group_id] && ![NSString isEmpty:msgModel.msg_id]) {
        
        if (![msgModel.is_readed isEqualToString:@"1"]) {
         
            if (![self isWorkOrActivityOrRrecruitTypeWithMsgListModel:msgModel]) {
                
                NSString *msgIds = [self dicWithMsgs:@[msgModel]];
                
                [self callbackServiceMaxMsgs:msgIds maxMsgModel:msgModel type:JGJMsgCallBackReadedType callback:^(JGJChatMsgListModel *msgModel) {
                    
                    TYLog(@"进入页面最大的消息已经读了 ---%@----%@", msgModel.msg_text, msgModel.msg_id);
                    
                }];
                
            }
            
        }

        //更新最大接收的消息id
        [JGJChatMsgDBManger updateMax_Asked_Msg_IdInGroupTableWithGroup_id:msgModel.group_id class_type:msgModel.class_type msg_id:msgModel.msg_id];

        //进入页面再次更新最大已读的消息id
        [JGJChatMsgDBManger updateMax_Readed_Msg_IdInGroupTableWithGroup_id:msgModel.group_id class_type:msgModel.class_type msg_id:msgModel.msg_id];

        //清除最后一条消息的@ [质量问题] [安全问题]等标识
        [JGJChatMsgDBManger updateAt_MessageToGroupTable:@"" group_id:msgModel.group_id class_type:msgModel.class_type];
        msgModel.at_message = @"";

        [JGJChatMsgDBManger updateGroupMsgRowPropertyWithJGJChatMsgListModel:msgModel propertyListType:(JGJChatMsgDBUpdateAtMessagePropertyType)];

        //清除聊聊列表未读数
        JGJChatGroupListModel *groupModel = [[JGJChatGroupListModel alloc] init];

        groupModel.class_type = msgModel.class_type;

        groupModel.group_id = msgModel.group_id;
        BOOL clearSuccess = [JGJChatMsgDBManger cleadGroupUnReadMsgCountWithModel:groupModel];

        // 清除首页的群消息未读数
        JGJIndexDataModel *indexModel = [[JGJIndexDataModel alloc] init];
        indexModel.group_id = msgModel.group_id;
        indexModel.class_type = msgModel.class_type;
        indexModel.chat_unread_msg_count = @"0";
        BOOL clearIndexSuccee = [JGJChatMsgDBManger updateIndexChatMsgUnreadToIndexTable:indexModel];
     
        
        // 离开聊天页面 把聊天页面的最后一条消息 更新到聊聊列表中
        JGJChatGroupListModel *upadteGroupModel = [[JGJChatGroupListModel alloc] init];
        
        upadteGroupModel.group_id = msgModel.group_id;
        upadteGroupModel.class_type = msgModel.class_type;
        upadteGroupModel.user_id = [TYUserDefaults objectForKey:JLGUserUid];
        
        upadteGroupModel.last_send_uid = msgModel.msg_sender;
        upadteGroupModel.last_msg_type = msgModel.msg_type;
        upadteGroupModel.last_msg_send_time = msgModel.send_time;
        upadteGroupModel.list_sort_time = msgModel.send_time;
        upadteGroupModel.last_send_name = msgModel.user_info.real_name;
        upadteGroupModel.sys_msg_type = msgModel.sys_msg_type;
        upadteGroupModel.max_asked_msg_id = msgModel.msg_id;
        upadteGroupModel.is_delete = NO;// 把收到消息的项目标记为 未删除
        upadteGroupModel.msg_text = msgModel.msg_text;
        upadteGroupModel.at_message = msgModel.at_message;
        upadteGroupModel.last_msg_content = msgModel.msg_text;
        upadteGroupModel.title = msgModel.title;
        upadteGroupModel.chat_unread_msg_count = @"0";
        
        upadteGroupModel.recruitMsgTitle = msgModel.recruitMsgModel.pro_title;
        upadteGroupModel.linkMsgTitle = msgModel.shareMenuModel.title;
        upadteGroupModel.linkMsgContent = msgModel.shareMenuModel.describe;
        [JGJChatMsgDBManger updateNew_Chat_MsgToGroupTableWithGroupListModel:upadteGroupModel];
    }

}

+ (BOOL)isWorkOrActivityOrRrecruitTypeWithMsgListModel:(JGJChatMsgListModel *)msgModel {
    
    if ([msgModel.group_id isEqualToString:@"-1"] || [msgModel.group_id isEqualToString:@"-2"] || [msgModel.group_id isEqualToString:@"-3"]) {
        
        return YES;
        
    }else {
        
        return NO;
    }
    
}
/**
 *接收自己发送的质量安全消息用
 */
+(void)receiveMySendMsgModel:(JGJChatMsgListModel *)msgModel isReaded:(BOOL)isReaded {
    
    shareSocket = [JGJSocketRequest shareSocketConnect];
    
    shareSocket.is_readed = isReaded ? @"1" : @"0";
    
    shareSocket.readMsgModel = msgModel;
}

#pragma mark - 接收别人读了，我发的的消息用于更新未读数
+(void)messageReadedToSenderWithMsgModels:(NSArray *)msgModels{
    
    for (JGJChatMsgListModel *msgModel in msgModels) {
        
        if (shareSocket.messageReadedCallback && [msgModel.type isEqualToString:@"readed"] && [self readMsgWithMsgModel:msgModel]) {
            
            shareSocket.messageReadedCallback(msgModel);
            
        }
    }
    
}

- (void)setIs_readed:(NSString *)is_readed {

    objc_setAssociatedObject(self, &is_readed_key, is_readed, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)is_readed {

    
    return objc_getAssociatedObject(self, &is_readed_key);
}

-(void)setReadMsgModel:(JGJChatMsgListModel *)readMsgModel {
    
   
    objc_setAssociatedObject(self, &read_msg_model_key, readMsgModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(JGJChatMsgListModel *)readMsgModel {
    
    
    return objc_getAssociatedObject(self, &read_msg_model_key);
}

- (void)setMessageReadedCallback:(MessageReadedCallback)messageReadedCallback {
    
    objc_setAssociatedObject(self, &message_readed_callback_key, messageReadedCallback, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
}

- (MessageReadedCallback)messageReadedCallback {
    
    return objc_getAssociatedObject(self, &message_readed_callback_key);
}

- (void)setReceivedMsgCallback:(ReceivedMsgCallback)receivedMsgCallback {
    
     objc_setAssociatedObject(self, &received_msg_callback_key, receivedMsgCallback, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (ReceivedMsgCallback)receivedMsgCallback {
    
      return objc_getAssociatedObject(self, &received_msg_callback_key);
}

- (ContactListMsgCallBack)contactListCallBack {
    
    return objc_getAssociatedObject(self, &contactList_callback_key);
}

- (void)setContactListCallBack:(ContactListMsgCallBack)contactListCallBack {
    
    objc_setAssociatedObject(self, &contactList_callback_key, contactListCallBack, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


- (void)setReceMsgArr:(NSMutableArray *)receMsgArr {
    
    objc_setAssociatedObject(self, &receMsgArr_key, receMsgArr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSMutableArray *)receMsgArr {
    
    return objc_getAssociatedObject(self, &receMsgArr_key);
}

- (void)setCallBackServiceMsgArr:(NSMutableArray *)callBackServiceMsgArr {
    
    objc_setAssociatedObject(self, &callBackServiceMsgArr, callBackServiceMsgArr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSMutableArray *)callBackServiceMsgArr {
    
    return objc_getAssociatedObject(self, &callBackServiceMsgArr_key);
}

- (void)setLast_msg_id:(NSString *)last_msg_id {
    
    objc_setAssociatedObject(self, &last_msg_id_key, last_msg_id, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)last_msg_id{
    
     return objc_getAssociatedObject(self, &last_msg_id_key);
}

#pragma mark - 插入消息
+(void)insertDBMsgs:(NSArray *)msgs action:(NSString *)action {
    
    NSMutableArray *msgArr = msgs.mutableCopy;
    
    for (int i = 0; i < msgArr.count; i ++) {

        JGJChatMsgListModel *msgModel = msgs[i];
        
        //收到的消息都是成功
        if ([msgModel.msg_type isEqualToString:@"pic"]) {
            
            msgModel.sendType = JGJChatListSendStart;
            
        }else {
            
            msgModel.sendType = JGJChatListSendSuccess;
        }
        
        //撤回消息处理

        if ([msgModel.msg_type isEqualToString:@"recall"]) {

//            JGJChatMsgListModel *oriRecallMsgModel = [JGJChatMsgDBManger msgModel:msgModel];

            NSString *myUid = [TYUserDefaults objectForKey:JLGUserUid];

            if ([msgModel.msg_sender isEqualToString:myUid]) {

                msgModel.msg_text = @"你 撤回一条消息";

            }else {

                msgModel.msg_text = [NSString stringWithFormat:@"%@ %@", msgModel.user_info.real_name,@"撤回一条消息"];
            }

            msgModel.msg_type = msgModel.msg_type;

            msgModel.sys_msg_type = msgModel.sys_msg_type?:@"system";
            
        }
        
        BOOL is_success = NO;
        
        TYLog(@"sendMessage-------%@------%@  %@", msgModel.msg_text, msgModel.msg_type, msgModel.msg_id);
        
        if ([action isEqualToString:sendMessage] && ![msgModel.msg_type isEqualToString:@"recall"]) {
            
            //招聘消息 插入消息表
            
            if ([msgModel.msg_type isEqualToString:@"proDetail"] && msgModel.msg_prodetail) {
                
                msgModel.job_detail = [msgModel.msg_prodetail mj_JSONString];
            }
            
            is_success = [JGJChatMsgDBManger insertToSendMessageMsgTableWithJGJChatMsgListModel:msgModel propertyListType:JGJChatMsgDBUpdateSendMsgSuccessPropertyType];
            
        }else if ([msgModel.msg_type isEqualToString:@"recall"]) {
            
//             is_success = [self insertDBMsgWithChatMsgListModel:msgModel action:action];
            
            is_success = [JGJChatMsgDBManger updateRecallWithMsgModel:msgModel propertyListType:JGJChatMsgDBUpdateRecallPropertyType];
            
            TYLog(@"recall-------%@------%@  %@", msgModel.msg_text, msgModel.msg_type, msgModel.msg_id);
        }
        
        if (is_success) {
            
            TYLog(@"插入消息表sendMessageSuccess----%@ ---%@", msgModel.msg_text, msgModel.msg_id);
        }
        
//        if ([action isEqualToString:sendMessage] || [msgModel.msg_type isEqualToString:@"recall"]) {
//
//            //插入消息表
//
//            is_success = [self insertDBMsgWithChatMsgListModel:msgModel action:action];
//
//            TYLog(@"插入消息表sendMessageSuccess----%@ ---%@", msgModel.msg_text, msgModel.msg_id);
//
//        }
        
//       页面需要显示的聊天数据
        
        [self callBackMsgWithMsgModel:msgModel action:action];
        
        if ([action isEqualToString:recallMessage]) {
            
            [shareSocket.receMsgArr removeObject:msgModel];
            
        }
        
    }
    
}

// 更新消息列表
+ (BOOL)insertDBMsgWithChatMsgListModel:(JGJChatMsgListModel *)msgModel action:(NSString *)action{
    
    //接收到消息标记成功
    msgModel.sendType = JGJChatListSendSuccess;
    
    if (msgModel.chatListType == JGJChatListAudio) {
        
        msgModel.isplayed = NO;
    }
    
    //本地更新撤回数据,这里只插入新消息本地发质量、安全、日志等
    
    BOOL update = [JGJChatMsgDBManger insertToChatMsgTableWithJGJChatMsgListModel:msgModel propertyListType:JGJChatMsgDBUpdateRecallPropertyType];
    
    return update;
}

#pragma mark - 回调当前组接收的消息
+ (void)callBackMsgWithMsgModel:(JGJChatMsgListModel *)msgModel action:(NSString *)action{
    
    //如果是发送消息的回执就更新msg_id和未读人数
    
    if ([action isEqualToString:sendMessage]) {
        
        return;
    }
    
    BOOL is_can_receive = shareSocket.receivedMsgCallback && [self readMsgWithMsgModel:msgModel] && [action isEqualToString:receiveMessage];
    
//不存在且是当前在聊的组回调回去,并且是接收状态
    
//    msgModel.work_message 0、2普通消息
    
    if (is_can_receive && [msgModel.sys_msg_type isEqualToString:@"normal"]) {
        
        shareSocket.receivedMsgCallback(msgModel);
        
    }
    
}

#pragma mark - 是否在在读当前组的消息
+(BOOL)readMsgWithMsgModel:(JGJChatMsgListModel *)msgModel {

    JGJChatMsgListModel *readMsgModel = shareSocket.readMsgModel;
    
    if ([NSString isEmpty:msgModel.group_id] || [NSString isEmpty:msgModel.class_type]) {
        
        return NO;
    }
    
    BOOL is_read = NO;
    if ([shareSocket.is_readed isEqualToString:@"1"] && [readMsgModel.class_type isEqualToString:msgModel.class_type] && [readMsgModel.group_id isEqualToString:msgModel.group_id]) {
        
        is_read = YES;
    }

    return is_read;
}

#pragma mark - 获取聊天消息未读人数
+ (void)chatMessageReadedNumWithMyMsgs:(NSArray *)myMsgs callback:(void(^)(NSArray *msgs))callBack{
    
    JGJChatMsgListModel *msgModel = nil;
    
    BOOL is_can = NO;
    
    NSMutableArray *msgIds = [[NSMutableArray alloc] init];
    
    for (JGJChatMsgListModel *myMsgModel in myMsgs) {
        
        is_can = NO;
        
        is_can = [NSString isEmpty:myMsgModel.class_type];
        
        is_can = [NSString isEmpty:myMsgModel.group_id];
        
        is_can = [NSString isEmpty:myMsgModel.msg_id] || [myMsgModel.msg_id isEqualToString:@"0"];
        
        if (!is_can) {
            
            msgModel = myMsgModel;
            
            [msgIds addObject:msgModel.msg_id];
        }
    }
    
    if (msgIds.count == 0) {
        
        return;
    }
    
    NSString *msg_ids = [msgIds componentsJoinedByString:@","];
    
    NSString *group_id = msgModel.group_id?:@"";
    
    NSString *class_type = msgModel.class_type?:@"";
    
    NSString *msg_id = msg_ids?:@"";
    
    NSDictionary *parameters = @{@"msg_id" : msg_id,
                                 
                                 @"group_id" : group_id,
                                 
                                 @"class_type" : class_type
                                 };
    
    [JLGHttpRequest_AFN PostWithNapi:@"chat/get-message-readed-num" parameters:parameters success:^(id responseObject) {
        
        NSArray *msgs = [JGJChatMsgListModel mj_objectArrayWithKeyValuesArray:responseObject];
        
        for (JGJChatMsgListModel *msgModel in myMsgs) {
            
            if (![NSString isEmpty:msgModel.msg_id]) {
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"msg_id==%@",msgModel.msg_id];
                
                NSArray *unreadMsgs = [msgs filteredArrayUsingPredicate:predicate];
                
                if (unreadMsgs.count > 0) {
                    
                    JGJChatMsgListModel *un_readMsgModel = unreadMsgs.firstObject;
                    
                    msgModel.unread_members_num = un_readMsgModel.unread_members_num;
                                        
                    [JGJChatMsgDBManger updateSendMessageUnreadNumWithMsgModel:un_readMsgModel];
                    
                }
                
            }
            
        }
        
        if (callBack) {
            
            callBack(myMsgs);
        }
        
    } failure:^(NSError *error) {
       
        
    }];
    
}

#pragma mark -下拉消息回执给服务器

+(void)pullRoamMsgCallBackServiceWithMsgs:(NSArray *)msgs proListModel:(JGJMyWorkCircleProListModel *)proListModel {
    
    if (msgs.count == 0) {
        
        return;
    }
    
    NSString *myUid = [TYUserDefaults objectForKey:JLGUserUid];
    
    JGJChatMsgListModel *msgModel = [JGJChatMsgListModel new];
    
    msgModel.msg_total_type = JGJChatNormalMsgType;
    
    msgModel.class_type = proListModel.class_type;
    
    msgModel.group_id = proListModel.group_id;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"msg_sender != %@ && is_readed != %@", myUid, @"1"];
    
    NSArray *unreadMsgs = [msgs filteredArrayUsingPredicate:predicate];
    
    NSMutableArray *msgArray = [NSMutableArray new];
    
    for (NSInteger indx = 0; indx < unreadMsgs.count; indx ++) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        JGJChatMsgListModel *msg = unreadMsgs[indx];
        
        //拉下来的消息标识已读
        
        msg.is_readed = @"1";
        
        if (![NSString isEmpty:msg.msg_id]) {
            
            dic[@"msg_id"] = msg.msg_id;
            
            if (![NSString isEmpty:msg.class_type]) {
                
                dic[@"class_type"] = msg.class_type;
            }
            
            if (![NSString isEmpty:msg.group_id]) {
                
                dic[@"group_id"] = msg.group_id;
            }
            
            [msgArray addObject:dic];
        }
    }
    
    if (msgArray.count > 0) {
        
        NSString *msgIds = [msgArray mj_JSONString];
        
        [JGJSocketRequest callbackServiceMaxMsgs:[msgArray mj_JSONString] maxMsgModel:msgArray.lastObject type:JGJMsgCallBackReadedType callback:^(JGJChatMsgListModel *msgModel) {
            
            TYLog(@"聊天界面消息已读回执了");
        }];
        
    }
    
    TYLog(@"unreadMsgs====%@", [msgArray mj_keyValues]);
    
}

/**
 *消息显示的timer开始，App息屏后进入前台使用
 */
+(void)receiveMsgTimerStart {
    
    //初始化定时器
    timerTool = [[JGJMangerTool alloc] init];
    
    timerTool.timeInterval = 0.2;
    
    [timerTool startTimer];
    
}

#pragma mark - 回执服务器收到的消息撤回成功
+ (void)callBackServiceRecallSuccessWithMsgs:(NSArray *)msgs {
    
    NSMutableArray *recallMsgs = [NSMutableArray array];
    
    for (JGJChatMsgListModel *msgModel in msgs) {
        
        if ([msgModel.msg_type isEqualToString:@"recall"]) {
            
            [recallMsgs addObject:msgModel];
            
            [self callBackMsgWithMsgModel:msgModel action:recallMessage];
            
            //这里更新的话只更新JGJChatMsgDBUpdateRecallPropertyType
            
            [JGJChatMsgDBManger insertToChatMsgTableWithJGJChatMsgListModel:msgModel propertyListType:JGJChatMsgDBUpdateRecallPropertyType];
            
        }
        
    }
    
    if (recallMsgs.count == 0) {
        
        return;
    }
    
    NSString *recallMsgJsons = [JGJSocketRequest recallDicWithMsgs:recallMsgs];
    
    if ([NSString isEmpty:recallMsgJsons]) {
        
        return;
    }
    
    NSDictionary *parameters = @{@"ctrl" : @"message",
                                 @"action" : @"getCallBackOperationMessage",
                                 @"msg_info" : recallMsgJsons,
                                 @"type"  : @"recall"
                                 };
    
    [JGJSocketRequest WebSocketWithParameters:parameters success:^(id responseObject) {
        
        TYLog(@"recallresponseObject-------%@ recallMsgJsons-----%@", responseObject, recallMsgJsons);
        
    } failure:^(NSError *error, id values) {
        
        
    }];
    
}

+(NSString *)recallDicWithMsgs:(NSArray *)msgs {
    
    NSMutableArray *recallMsgs = [NSMutableArray array];
    
    for (NSInteger index = 0; index < msgs.count; index++) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        JGJChatMsgListModel *msgModel = msgs[index];
        
        if (![NSString isEmpty:msgModel.msg_id]) {
            
            dic[@"msg_id"] = msgModel.msg_id;
            
            if (![NSString isEmpty:msgModel.class_type]) {
                
                dic[@"class_type"] = msgModel.class_type;
            }
            
            if (![NSString isEmpty:msgModel.group_id]) {
                
                dic[@"group_id"] = msgModel.group_id;
            }
            
            if (![NSString isEmpty:msgModel.msg_sender]) {
                
                dic[@"msg_sender"] = msgModel.msg_sender;
            }
            
            [recallMsgs addObject:dic];
        }
    }
    
    NSString *msgsId = [recallMsgs mj_JSONString];
    
    return msgsId;
}

@end
