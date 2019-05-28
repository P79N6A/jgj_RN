//
//  JGJAboutSynProModel.h
//  mix
//
//  Created by yj on 2018/4/16.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    
    JGJSyncDefaultType, 
    
    JGJSyncRecordWorkAndAccountsType, //同步记工记账
    
    JGJSyncRecordWorkType //同步记工
    
} JGJSyncType;

//同步成功回调
typedef void(^SynSuccessBlock)(id);

@interface JGJAboutSynProBaseModel : NSObject

@end

@interface JGJAboutSynProModel : JGJAboutSynProBaseModel

@end

@interface JGJSelSynProListModel : JGJAboutSynProBaseModel

@property (nonatomic, copy) NSString *pid;

@property (nonatomic, copy) NSString *pro_name;

@property (nonatomic, assign) BOOL isSel;

@end

//已同步的项目列表
@interface JGJSynedProListModel : JGJAboutSynProBaseModel

//同步数据的id
@property (nonatomic, copy) NSString *sync_id;

//同步类型
@property (nonatomic, copy) NSString *sync_type;

//同步项目名
@property (nonatomic, copy) NSString *pro_name;

//包ID （从“已同步项目列表”接口带过来）
@property (nonatomic, copy  ) NSString *tag_id;

//同步的项目id
@property (nonatomic, copy) NSString *pid;

//同步人的uid
@property (nonatomic, copy) NSString *uid;

//同步人的姓名
@property (nonatomic, copy) NSString *real_name;

@end

//已同步的项目
@interface JGJSynedProModel : JGJAboutSynProBaseModel

//同步数量
@property (nonatomic, copy) NSString *synced_num;

//展开
@property (nonatomic, assign) BOOL isExpand;

//同步项目列表
@property (nonatomic, strong) NSMutableArray *synced_list;

//同步人的信息
@property (nonatomic, strong) JGJSynBillingModel *user_info;

//同步人的名字
@property (nonatomic, copy) NSString *real_name;

//是否同步给我
@property (nonatomic, assign) BOOL is_syn_me;
@end
