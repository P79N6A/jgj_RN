//
//  JGJDetailUnReadInfoVc.m
//  JGJCompany
//
//  Created by yj on 2017/11/30.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJDetailUnReadInfoVc.h"

@interface JGJDetailUnReadInfoVc ()

@end

@implementation JGJDetailUnReadInfoVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"已读详情";
}

#pragma mark - 获取未读数据接口
- (void)messageReadedWithChatListModel:(JGJChatMsgListModel *)chatListModel {
    
    NSDictionary *parameters ;
    if ([chatListModel.msg_type?:@"" isEqualToString:@"log"]) {
        
        parameters = @{@"msg_id": chatListModel.msg_id?:@"",@"msg_type":_chatRoom?@"":@"log"};

    }else{
        
        parameters = @{@"msg_id": chatListModel.msg_id?:@""};
    }
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/quality/getReplyMemberList" parameters:parameters success:^(id responseObject) {
        
        ChatMsgList_Read_info *readInfo = [ChatMsgList_Read_info new];
        
        NSArray *unread_user_Arr = responseObject[@"unrelay_members"];
        
        NSArray *unread_user_list = [ChatMsgList_Read_User_List mj_objectArrayWithKeyValuesArray:unread_user_Arr];
        
        NSArray *read_user_Arr = responseObject[@"members"];
        
        NSArray *read_user_list = [ChatMsgList_Read_User_List mj_objectArrayWithKeyValuesArray:read_user_Arr];
        
        readInfo.unread_user_list = unread_user_list;
        
        readInfo.readed_user_list = read_user_list;
        
        [self subSetReadInfo:readInfo];
        
    } failure:^(NSError *error) {
       
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
