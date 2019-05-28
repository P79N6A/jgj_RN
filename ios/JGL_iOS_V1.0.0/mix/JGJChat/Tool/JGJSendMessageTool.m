//
//  JGJSendMessageTool.m
//  mix
//
//  Created by yj on 2018/11/22.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJSendMessageTool.h"

#import "SDWebImageManager.h"

#import "AFNetworkReachabilityManager.h"

#import <Photos/PHAssetResource.h>

#import <Photos/Photos.h>

#import "JGJImage.h"

@implementation JGJSendMessageTool

static JGJSendMessageTool *_tool;

+ (instancetype)shareSendMessageTool
{
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        
        _tool = [[self alloc] init];

    });
    
    return _tool;
}


- (void)addPicMessage:(NSArray *)imagesArr assets:(NSArray *)assets sendMessageSelPicBlock:(JGJSendMessageSelPicBlock)selPicBlock sendMessageSuccessBlock:(JGJSendMessageSuccessBlock)sendMessageSuccessBlock {
    
    //用于发送服务器成功回调替换数据
    
    self.sendMsgSuccessBlock = sendMessageSuccessBlock;
    
    __block NSMutableArray *listModelsArr = [NSMutableArray array];
    TYWeakSelf(self);
    [imagesArr enumerateObjectsUsingBlock:^(UIImage  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TYStrongSelf(self);
        
        //2.2.0添加UIImage类型判断，只去image
        if ([obj isKindOfClass:[UIImage class]]) {
            
            NSMutableDictionary *dataInfo = @{@"chatListType":@(JGJChatListPic),@"text":@"",@"picImage":obj}.mutableCopy;
            
            JGJChatMsgListModel *listModel = [strongself cofigMsgWithPic:dataInfo listModel:nil];
            
            //未读人数，初始去掉自己
            listModel.unread_members_num = [self.workProListModel.members_num integerValue] - 1;
    
            //图片唯一标识
            
            if (assets.count > idx) {
                
                PHAsset *asset = assets[idx];
                
                listModel.assetlocalIdentifier = asset.localIdentifier;
                
            }
            
            //配置发送信息
            JGJChatUserInfoModel *user_info = [JGJChatUserInfoModel new];
            
            NSString *head_pic = [TYUserDefaults objectForKey:JLGHeadPic];
            
            NSString *name = [TYUserDefaults objectForKey:JGJUserName];
            
            NSString *uid = [TYUserDefaults objectForKey:JLGUserUid];
            
            user_info.head_pic = head_pic;
            
            user_info.real_name = name;
            
            user_info.uid = uid;
            
            listModel.user_info = user_info;
            
            listModel.user_name = name;
            
            listModel.head_pic = head_pic;
            
            listModel.group_id = self.workProListModel.group_id;
            
            listModel.class_type = self.workProListModel.class_type;
            
            NSString *myUid = [TYUserDefaults objectForKey:JLGUserUid];
            
            listModel.belongType = JGJChatListBelongMine;
            
            listModel.msg_sender = myUid;
            
            NSInteger local_id = [[JGJChatMsgDBManger localID] integerValue] + idx;
            
            listModel.local_id = [NSString stringWithFormat:@"%@", @(local_id)];
            
            //时间用的是10位，加1是为了避免图片消息重复发送时间重复
            
            NSInteger send_time = [[JGJChatMsgDBManger localTime] integerValue] + idx;
            
            listModel.send_time = [NSString stringWithFormat:@"%@", @(send_time)];

            listModel.sendType = JGJChatListSendStart;
            
            //选中图片回调显示 (添加消息,但是不发送到服务器)
            
            if (selPicBlock) {
                
                selPicBlock(listModel);
            }
            
            CGFloat pic_w = obj.size.width;
            
            CGFloat pic_h = obj.size.height;
            
            listModel.pic_w_h = @[@(pic_w), @(pic_h)];
            
            [listModelsArr addObject:@[dataInfo,listModel]];
            
            // 将消息存入数据库
            [strongself saveChatSelPhotoImageWithListModel:listModel];
            
        }
        
    }];
    
    [self requestWithArray:imagesArr listModelsArr:listModelsArr index:0 completion:nil];
    
}

#pragma mark - 重发图片消息，根据assetlocalIdentifier获取image再次发送

- (void)resendMsgModel:(JGJChatMsgListModel *)msgModel sendMessageSuccessBlock:(JGJSendMessageSuccessBlock)sendMessageSuccessBlock {
    
     UIImage *image = [JGJImage getImageFromPHAssetLocalIdentifier:msgModel.assetlocalIdentifier];
    
    if (image && msgModel) {
        
        NSMutableDictionary *dataInfo = @{@"chatListType":@(JGJChatListPic),@"text":@"",@"picImage":image}.mutableCopy;
        
        [self requestWithArray:@[image] listModelsArr:@[@[dataInfo,msgModel]] index:0 completion:nil];
        
        self.sendMsgSuccessBlock = sendMessageSuccessBlock;
        
    }
    
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
    
    [JLGHttpRequest_AFN uploadImageWithApi:@"jlupload/upload" parameters:nil image:imagesArr[index] progress:^(NSProgress *uploadProgress) {
        
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
        
        //socket传数据
        
        [strongself sendMsgToServicer:listModel needToService:YES];
        
        [strongself requestWithArray:imagesArr listModelsArr:listModelsArr index:index + 1 completion:completion];
        
    } failure:^(NSError *error) {
        
//        TYStrongSelf(self);
        
//        [strongself sendMessageFail:listModel];
        
//        [strongself requestWithArray:imagesArr listModelsArr:listModelsArr index:index + 1 completion:completion];
        
    }];
}

- (void)sendMsgToServicer:(JGJChatMsgListModel *)listModel needToService:(BOOL )needToService{
    
    //    //失败的消息删除元数据，重新发送，并添加显示
    //
    //    if (listModel.sendType == JGJChatListSendFail) {
    //
    //        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"local_id=%@",listModel.local_id];
    //
    //        NSArray *failMsgs = [self.dataSourceArray filteredArrayUsingPredicate:predicate];
    //
    //        if (failMsgs.count > 0) {
    //
    //            JGJChatMsgListModel *failMsg = failMsgs.firstObject;
    //
    //            [self.dataSourceArray removeObject:failMsg];
    //
    //            [self.tableView reloadData];
    //
    //            [JGJChatMsgDBManger delSendFailureMsgWithJGJChatMsgListModel:failMsg];
    //
    //        }
    //    }
    
    AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
    
    AFNetworkReachabilityStatus status = manger.networkReachabilityStatus;
    
    BOOL isReachableStatus = status == AFNetworkReachabilityStatusNotReachable;
    
    if (isReachableStatus) {
        
        [TYShowMessage showPlaint:@"当前网络不可用"];
        
        return;
        
    }
    
    if (self.workProListModel) {
        
        //如果都是空的话赋值当前组
        if ([NSString isEmpty:listModel.group_id] && [NSString isEmpty:listModel.class_type]) {
            
            listModel.group_id = self.workProListModel.group_id;
            
            listModel.class_type = self.workProListModel.class_type;
        }
        
        listModel.recruitMsgModel = self.workProListModel.chatRecruitMsgModel;
        listModel.is_find_job = self.workProListModel.is_find_job;
    }
    
    NSDictionary *parameters = [JGJSendMessageTool configParameters:listModel];
    
     TYLog(@"send-parameters-----%@", parameters);
    
    listModel.send_time = [JGJChatMsgDBManger localTime];
    ;
    
    NSString *myUid = [TYUserDefaults objectForKey:JLGUserUid];
    
    listModel.uid = myUid;
    
    listModel.msg_sender = myUid;
    
    //发消息先存入数据库
    
    [self sendMsgInsertMsgDBWithMsgModel:listModel];
    
    __weak typeof(self) weakSelf = self;
    
    if (needToService) {
        [JGJSocketRequest WebSocketWithParameters:parameters success:^(id responseObject) {
            
            JGJChatMsgListModel *chatMsgListModel= [JGJChatMsgListModel mj_objectWithKeyValues:responseObject];
            
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
            
            if (self.sendMsgSuccessBlock) {
                
                self.sendMsgSuccessBlock(chatMsgListModel);
                
            }
            
            //更新发送成功的图片消息
            
            [JGJChatMsgDBManger updateSendPicMsgWithMsgModel:chatMsgListModel];
            
        } failure:^(NSError *error, id values) {
            
            
        }];
    }
    
}

- (JGJChatMsgListModel *)cofigMsgWithPic:(NSDictionary *)audioInfo listModel:(JGJChatMsgListModel *)listModel{
    
    if (!listModel) {
        
        listModel = [JGJChatMsgListModel new];
    }
    
    listModel.chatListType = JGJChatListPic;
    
    listModel.msg_type = @"pic";
    
    if (audioInfo[@"msg_src"]) {
        
        listModel.msg_src = audioInfo[@"msg_src"];
        
    }
    
    if (audioInfo[@"picImage"]) {
        
        listModel.picImage = audioInfo[@"picImage"];
        
        listModel.pic_w_h = @[@(listModel.picImage.size.width),@(listModel.picImage.size.height)];
    }
    
    if ([NSString isEmpty:listModel.local_id]) {
        
        listModel.local_id = [JGJChatMsgDBManger localID];
        
    }
    
    if (![NSString isEmpty:listModel.local_id]) {
        
        if ([listModel.local_id isEqualToString:@"0"]) {
            
            listModel.local_id = [JGJChatMsgDBManger localID];
        }
        
    }
    
    return listModel;
}

+ (NSDictionary *)configParameters:(JGJChatMsgListModel *)listModel {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"ctrl"] = @"message";
    
    parameters[@"action"] = @"sendMessage";
    
    parameters[@"msg_type"] = listModel.msg_type;
    
    parameters[@"class_type"] = listModel.class_type;
    
    if (![NSString isEmpty:listModel.recruitMsgModel.is_resume]) {
        parameters[@"is_resume"] = listModel.recruitMsgModel.is_resume;
    }
    
    if (listModel.is_find_job) {
        
        parameters[@"is_find_job"] = @"1";
    }
    
    //没有类型,直接返回
    if ([NSString isEmpty:listModel.class_type] || [NSString isEmpty:listModel.group_id]) {
        
        return nil;
    }
    
    if (![NSString isEmpty:listModel.class_type]) {
        
        parameters[@"class_type"] = listModel.class_type;
    }
    
    if (![NSString isEmpty:listModel.group_id]) {
        
        parameters[@"group_id"] = listModel.group_id;
    }
    
    if (![NSString isEmpty:listModel.msg_text]) {
        
        //语音可不传
        parameters[@"msg_text"] = listModel.msg_text;
        
    }
    
    if (listModel.msg_src.count) {
        
        parameters[@"msg_src"] = listModel.msg_src;
    }
    
    if (![NSString isEmpty:listModel.voice_long]) {
        
        parameters[@"voice_long"] = listModel.voice_long;
        
    }
    
    if (listModel.pic_w_h) {
        
        parameters[@"pic_w_h"] = listModel.pic_w_h;
        
    }
    
    if (![NSString isEmpty:listModel.at_uid]) {
        
        parameters[@"at_uid"] = listModel.at_uid;
        
    }
    
    if (![NSString isEmpty:listModel.local_id]) {
        
        parameters[@"local_id"] = listModel.local_id;
        
    }else {
        
        parameters[@"local_id"] = [JGJChatMsgDBManger localID];
        
        listModel.local_id = parameters[@"local_id"];
        
    }
    
    if (![NSString isEmpty:listModel.msg_type]) {
        
        //招聘进入聊天4.0.1添加
        
        if ([listModel.msg_type isEqualToString:@"postcard"] || [listModel.msg_type isEqualToString:@"recruitment"]) {
            
//            parameters[@"is_find_job"] = @"1";
            
            parameters[@"msg_text_other"] = [listModel.recruitMsgModel mj_JSONString];
            
            parameters[@"msg_type"] = listModel.msg_type;
            
        }
        
        if ([listModel.msg_type isEqualToString:@"link"]) {
            
            parameters[@"msg_text_other"] = listModel.msg_text_other;
            
            parameters[@"msg_type"] = listModel.msg_type;
            
            parameters[@"is_source"] = @(1);
        }
    }
    
//    分享数据  is_source => 1
//    转发数据  is_source => 2
    if (listModel.is_source > 0) {
        
        parameters[@"is_source"] = @(listModel.is_source);
        
    }
    
    
    return parameters.copy;
}

#pragma mark - 保存聊天图片 主要保存 图片在相册的唯一标识 assetlocalIdentifier
- (void)saveChatSelPhotoImageWithListModel:(JGJChatMsgListModel *)listModel {
    
    if (![NSString isEmpty:listModel.assetlocalIdentifier]) {
        
        [JGJChatMsgDBManger insertToSendPicMsgTableWithMsgListModel:listModel];
        
        TYLog(@"插入图片唯一标示localIdentifier=======%@", listModel.assetlocalIdentifier);
    }
    
}

//发送消息
+ (instancetype)sendMsgModel:(JGJChatMsgListModel *)msgModel successBlock:(JGJSendMessageSuccessBlock)successBlock {
    
    _tool = [JGJSendMessageTool shareSendMessageTool];
    
    _tool.sendMsgSuccessBlock = successBlock;
    
    [_tool sendMsgToServicer:msgModel needToService:YES];
    
    return _tool;
}

//发送消息组

+ (instancetype)sendMsgs:(NSArray *)msgs successBlock:(JGJSendMessageSuccessBlock)successBlock {
    
    _tool = [JGJSendMessageTool shareSendMessageTool];
    
    _tool.sendMsgSuccessBlock = successBlock;
    
    for (JGJChatMsgListModel *msgModel in msgs) {
        
        if ([msgModel isKindOfClass:[JGJChatMsgListModel class]]) {
            
            [_tool sendMsgToServicer:msgModel needToService:YES];
            
        }
    
    }
    
    return _tool;
}

#pragma mark - 点击发送的时候存入数据库，根据local_id替换消息
- (void)sendMsgInsertMsgDBWithMsgModel:(JGJChatMsgListModel *)msgModel {
    
    JGJChatUserInfoModel *user_info = [[JGJChatUserInfoModel alloc] init];
    
    user_info.real_name = self.myMsgModel.user_name;
    
//    msgModel.members_num = self.workProListModel.members_num;
    
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
    
    else if ([msgModel.msg_type isEqualToString:@"recruitment"] || [msgModel.msg_type isEqualToString:@"postcard"] || [msgModel.msg_type isEqualToString:@"auth"] || [msgModel.msg_type isEqualToString:@"link"]) {
        
        [JGJChatMsgDBManger insertAllPropertyChatMsgListModel:msgModel];
        
    }else {
        
        [JGJChatMsgDBManger insertToSendMessageMsgTableWithJGJChatMsgListModel:msgModel propertyListType:JGJChatMsgDBUpdateAllPropertyType];
    }
    
}


+ (void)uploadImages:(NSArray <UIImage *>*)images success:(void (^)(NSArray *))success failure:(void(^)(NSError *))failure{
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN newUploadImagesWithApi:@"file/upload" parameters:nil imagearray:images otherDataArray:nil dataNameArray:nil success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        NSArray *urls = (NSArray *)responseObject;
        
        if (success) {
            
            success(urls);
        }
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        if (failure) {
            failure(error);
        }
        
    }];
    
}

@end
