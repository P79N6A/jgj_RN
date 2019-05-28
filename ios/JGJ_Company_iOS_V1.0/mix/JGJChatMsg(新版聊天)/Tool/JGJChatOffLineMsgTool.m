//
//  JGJChatOffLineMsgTool.m
//  mix
//
//  Created by yj on 2018/8/25.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJChatOffLineMsgTool.h"

#import "JGJChatMsgDBManger.h"
#import "JGJChatMsgDBManger+JGJGroupDB.h"

#import "JGJMangerTool.h"

static JGJChatOffLineMsgTool *_tool;

static JGJMangerTool *timerTool = nil;

@interface JGJChatOffLineMsgTool()

@property (nonatomic, strong) NSArray *msglist;
@end

@implementation JGJChatOffLineMsgTool

+ (instancetype)shareChatOffLineMsgTool
{
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        
        _tool = [[self alloc] init];
    });
    
    return _tool;
    
}

#pragma mark - 获取离线消息
+ (void)getOfflineMessageListCallBack:(void(^)(NSArray *msglist))callBack {
    
//    if (!timerTool) {
//
//        timerTool = [[JGJMangerTool alloc] init];
//
//        timerTool.timeInterval = 1;
//
//        [timerTool startTimer];
//
//    }

//正在处理消息不能拉取离线消息
    if (JGJIsHandlingMsgBool) {
        
        TYLog(@"------正在处理消息不能拉取离线消息");
        
        return;
    }
    
    [JLGHttpRequest_AFN PostWithNapi:@"chat/get-offline-message-list" parameters:nil success:^(id responseObject) {
            
            TYLog(@"离线消息 = %@",responseObject);
            
            NSArray *msglist = [JGJChatMsgListModel mj_objectArrayWithKeyValuesArray:responseObject];
            
            _tool.msglist = msglist;
            
            //大于一定的条数,加个动画
            
            if (msglist.count > 300) {
                
                [TYLoadingHub showLoadingWithMessage:nil];
                
            }
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                [self insertDBWithMsgs:msglist type:JGJMsgCallBackReceivedType callBack:nil];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (callBack) {
                        
                        callBack(msglist);
                        
                        [TYLoadingHub hideLoadingView];
                        
                    }
                    
                });
                
                
            });
            
        } failure:^(NSError *error) {
            
            
        }];
    
}

+ (void)handleOfflineMsgs:(NSArray *)msgs type:(JGJMsgCallBackType)type callBack:(void(^)(NSArray *msglist))callBack{
    
    //开始处理数据
    
    [TYUserDefaults setBool:YES forKey:JGJIsHandlingMsg];
    
    TYLog(@"消息处理----开始 ==%@", @(JGJIsHandlingMsgBool));
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        [self insertDBWithMsgs:msgs type:type callBack:^(NSArray *msglist) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (callBack) {
                    
                    callBack(msglist);
                    
                    TYLog(@"离线方式回调1次--------%@", msglist);
                }
                
            });
            
            
        }];
        
    });
    
//    [self insertDBWithMsgs:msgs];
//
//    if (callBack) {
//
//        callBack(msgs);
//    }
    
}

+ (void)insertDBWithMsgs:(NSArray *)msgs type:(JGJMsgCallBackType)type callBack:(void(^)(NSArray *msglist))callBack {
    
    //聊聊表需要的最大消息
    
    NSMutableArray *maxMsgArr = [NSMutableArray array];
    
    NSMutableDictionary *lastDic = [NSMutableDictionary dictionary];
    
    TYLog(@"消息存表-------count----%@", @(msgs.count));
    
    for (NSInteger indx = 0; indx < msgs.count; indx++) {

        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        JGJChatMsgListModel *msgModel = msgs[indx];
        
        //图片收到的时候有个加载状态JGJChatListSendStart
        if ([msgModel.msg_type isEqualToString:@"pic"]) {
            
            msgModel.sendType = JGJChatListSendStart;
            
        }else {
            
            msgModel.sendType = JGJChatListSendSuccess;
        }
        
        //招聘消息 插入消息表
        
        if ([msgModel.msg_type isEqualToString:@"proDetail"] && msgModel.msg_prodetail) {
            
            msgModel.job_detail = [msgModel.msg_prodetail mj_JSONString];
            
        }else if ([msgModel.msg_type isEqualToString:@"recruitment"] || [msgModel.msg_type isEqualToString:@"postcard"] || [msgModel.msg_type isEqualToString:@"auth"]) {
            
            msgModel.msg_text_other = [msgModel.recruitMsgModel mj_JSONString];
            
        }else if ([msgModel.msg_type isEqualToString:@"link"]) {
            
            msgModel.msg_text_other = [msgModel.shareMenuModel mj_JSONString];
        }
        
        //延展字段
        msgModel.wcdb_extend = [msgModel.extend mj_JSONString];
        
        //用户信息
        
        msgModel.wcdb_user_info = [msgModel.user_info mj_JSONString];
        
        if (![lastDic[@"class_type"] isEqualToString:msgModel.class_type] || ![lastDic[@"group_id"] isEqualToString:msgModel.group_id]) {

            [self maxMsgDic:dic msgModel:msgModel];

            lastDic = dic;

            [maxMsgArr addObject:lastDic];

        }else {
            
            if ([msgModel.msg_id integerValue] > [lastDic[@"msg_id"] integerValue]) {
                
                [self maxMsgDic:lastDic msgModel:msgModel];
                
            }
            
        }
        
        
    }

    
    if (maxMsgArr.count > 0) {

        NSDictionary *maxGroupDic = [maxMsgArr mj_keyValues];
        
        NSArray *maxMsgs = [JGJChatMsgListModel mj_objectArrayWithKeyValuesArray:maxMsgArr];

        NSArray *maxGroupDics = [JGJChatMsgListModel mj_keyValuesArrayWithObjectArray:maxMsgs keys:@[@"class_type",@"group_id", @"msg_id"]];
        
        NSString *maxGroupIds = [maxGroupDics mj_JSONString];
        
        JGJChatMsgListModel *maxModel = msgs.lastObject;
        
        //回执收到的消息到服务器
        
        [JGJSocketRequest callbackServiceMaxMsgs:maxGroupIds maxMsgModel:maxModel type:type callback:^(JGJChatMsgListModel *msgModel) {
            
            TYLog(@"消息回执id===%@ count---%@ Thread---%@", maxGroupIds, @(msgs.count), [NSThread currentThread]);
            
        }];
        
        //回执聊聊列表处理
        
        [JGJSocketRequest callbackGroupServiceWithMaxMsgs:maxMsgs msgs:msgs type:type callback:^(NSArray *msgs) {
           
            TYLog(@"maxGroupDic-----%@  msgs----%@", maxGroupDic, msgs);
            
        }];
        
    }
    
    //处理完回到主线程，存表

    dispatch_async(dispatch_get_main_queue(), ^{

        [self handleSaveDBWithMsgs:msgs];

        if (callBack) {

            callBack(msgs);

        }
    });

//    测试数据结束

//    if (_tool.offLineCallBack) {
//
//        _tool.offLineCallBack(YES);
//
//    }
    
}

#pragma mark - 处理数据库
+ (void)handleSaveDBWithMsgs:(NSArray *)msgs {
    
    BOOL is_success = NO;
    
    //这里的处理是，程序挂起才拉离线显示到当前页面。页面是读的状态
    
    if (msgs.count < 300 && msgs.count > 0) {
        
        for (JGJChatMsgListModel *msgModel in msgs) {
            
            //在当前组页面，聊天页面会显示，离线数据
            
            [JGJSocketRequest receiveCurGroupOffineMsgs:@[msgModel] type:JGJMsgCallBackReceivedType];
            
            //单条插入
            
            [JGJChatMsgDBManger insertToChatMsgTableWithJGJChatMsgListModel:msgModel propertyListType:JGJChatMsgDBUpdateAllPropertyType];
            
        }
        
        //插入结束
        
        is_success = YES;
        
    }else {
        
        //批量存储结束
        
        is_success = [JGJChatMsgDBManger insertBatchMsgModels:msgs propertyListType:JGJChatMsgDBUpdateAllPropertyType];
        
    }
    
    if (is_success) {
        
        //处理完数据，回调服务器成功,移除正在处理数据的标识
        
        if (JGJIsHandlingMsgBool) {
            
            [TYUserDefaults removeObjectForKey:JGJIsHandlingMsg];
            
            TYLog(@"处理完消息--移除标识");
        }
        
        //清除首次启动获取离线标识
        
        if (JGJIslLaunchOfflineMsgBool) {
            
            [TYUserDefaults removeObjectForKey:JGJIslLaunchOfflineMsg];
            
        }
        
        TYLog(@"消息存表--------结束 ==%@", @(JGJIsHandlingMsgBool));
        
    }
    
}

+ (void)updateGroupListTheNewestMessage {
    
    // 获取聊聊列表所有组
    NSMutableArray *groupList = [[NSMutableArray alloc] initWithArray:[JGJChatMsgDBManger getAllGroupListModel]];
    for (int i = 0; i < groupList.count; i ++) {
        
        JGJChatGroupListModel *groupModel = groupList[i];
        [self dealChatListWithGroupModel:groupModel];
        
    }
    
}

+ (void)dealChatListWithGroupModel:(JGJChatGroupListModel *)groupModel {
    
    //1.获取当前组对应的消息表最新消息
    JGJChatMsgListModel *getNewestMsgModel = [[JGJChatMsgListModel alloc] init];
    
    getNewestMsgModel.group_id = groupModel.group_id;
    getNewestMsgModel.class_type = groupModel.class_type;
    getNewestMsgModel.sys_msg_type = groupModel.class_type;
    getNewestMsgModel.msg_id = groupModel.max_readed_msg_id;
    
    // 最新消息
    JGJChatMsgListModel *newestMsgModel = [JGJChatMsgDBManger maxMsgListModelWithChatMsgListModel:getNewestMsgModel];
    
    // 获取当前组的未读数
    NSString *unreadNum = [JGJChatMsgDBManger msgUnreadedNumWithMyMsgModel:getNewestMsgModel];
    
    // 2.将最新消息更新到聊聊列表对应的组
    if (newestMsgModel.msg_total_type == JGJChatNormalMsgType || newestMsgModel.msg_total_type == JGJChatMsgSystemType) {// 普通消息
        
        groupModel.last_msg_content = newestMsgModel.msg_text;
        
    }else {// 活动 招聘 工作类型消息
        
        groupModel.last_msg_content = newestMsgModel.workingNotify_msg_text;
    }
    
    groupModel.msg_text = newestMsgModel.msg_text;
    groupModel.last_msg_send_time = newestMsgModel.send_time;
    groupModel.last_send_uid = newestMsgModel.msg_sender;
    groupModel.last_msg_type = newestMsgModel.msg_type;
    groupModel.last_send_name = newestMsgModel.user_info.real_name;
    groupModel.chat_unread_msg_count = unreadNum;// 未读数
    groupModel.at_message = newestMsgModel.at_message;
    // 3.更新相应的组 最新消息
    BOOL updateSuccess = [JGJChatMsgDBManger updateNew_Chat_MsgToGroupTableWithGroupListModel:groupModel];
}

#pragma mark - 排序处理

+(NSArray *)sortMsgList:(NSArray *)msgList {
    
    NSArray *sortArray = [msgList sortedArrayUsingComparator:^NSComparisonResult(JGJChatMsgListModel  *obj1, JGJChatMsgListModel  *obj2) {

        if (![NSString isEmpty:obj1.msg_id] && ![NSString isEmpty:obj2.msg_id]) {

            NSComparisonResult result = [obj1.msg_id compare:obj2.msg_id];
        }

        return NSOrderedDescending;
    }];
    
    NSMutableArray *msgs = [NSMutableArray array];
    
    NSMutableSet *msg_ids = [NSMutableSet set];
    
    for (NSInteger idx = 0; idx < sortArray.count; idx++) {
        
        JGJChatMsgListModel *lastModel = sortArray[idx];
        
        if (![NSString isEmpty:lastModel.msg_id]) {
            
            if (![msg_ids containsObject:lastModel.msg_id]) {
                
                [msgs addObject:lastModel];
                
                [msg_ids addObject:lastModel.msg_id];
            }
        }
        
    }
    
    return msgs;
}

#pragma mark - 模型转换字典处理
+ (void)maxMsgDic:(NSMutableDictionary *)lastDic msgModel:(JGJChatMsgListModel *)msgModel {
    
    if (![NSString isEmpty:msgModel.class_type]) {
        
        lastDic[@"class_type"] = msgModel.class_type;
    }
    
    if (![NSString isEmpty:msgModel.group_id]) {
        
        lastDic[@"group_id"] = msgModel.group_id;
    }
    
    if (![NSString isEmpty:msgModel.at_message]) {
        
        lastDic[@"at_message"] = msgModel.at_message;
    }
    
    if (![NSString isEmpty:msgModel.msg_id]) {
        
        lastDic[@"msg_id"] = msgModel.msg_id;
        
    }
    
    if (![NSString isEmpty:msgModel.sys_msg_type]) {
        
        lastDic[@"sys_msg_type"] = msgModel.sys_msg_type;
        
    }
    
    if (![NSString isEmpty:msgModel.msg_text]) {
        
        lastDic[@"msg_text"] = msgModel.msg_text;
        
    }
    
    if (![NSString isEmpty:msgModel.msg_id]) {
        
        lastDic[@"msg_id"] = msgModel.msg_id;
        
    }
    
    if (![NSString isEmpty:msgModel.send_time]) {
        
        lastDic[@"send_time"] = msgModel.send_time;
        
    }
    
    if (![NSString isEmpty:msgModel.msg_sender]) {
        
        lastDic[@"msg_sender"] = msgModel.msg_sender;
        
    }
    
    if (![NSString isEmpty:msgModel.msg_type]) {
        
        lastDic[@"msg_type"] = msgModel.msg_type;
    }
    
    if (![NSString isEmpty:msgModel.real_name]) {
        
        lastDic[@"real_name"] = msgModel.real_name;
    }
    
    if (![NSString isEmpty:msgModel.at_message]) {
        
        lastDic[@"at_message"] = msgModel.at_message;
    }
    
    if (![NSString isEmpty:msgModel.user_info.uid]) {
        
        lastDic[@"user_info"] = [msgModel.user_info mj_keyValues];
    }
    
    if (![NSString isEmpty:msgModel.origin_group_id]) {
        
        lastDic[@"origin_group_id"] = msgModel.origin_group_id;
    }
    
    if (![NSString isEmpty:msgModel.origin_class_type]) {
        
        lastDic[@"origin_class_type"] = msgModel.origin_class_type;
    }
    if (![NSString isEmpty:msgModel.msg_sender]) {
        
        lastDic[@"msg_sender"] = msgModel.msg_sender;
    }
    if (![NSString isEmpty:msgModel.title]) {
        
        lastDic[@"title"] = msgModel.title;
    }
    if (![NSString isEmpty:msgModel.detail]) {
        
        lastDic[@"detail"] = msgModel.detail;
    }
}

@end
