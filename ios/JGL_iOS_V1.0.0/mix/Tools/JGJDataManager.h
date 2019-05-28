//
//  JGJDataManager.h
//  mix
//
//  Created by Json on 2019/4/16.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 好友来源类型
 */
typedef NS_ENUM(NSUInteger, JGJFriendAddFromType){
    JGJFriendAddFromGroupChat = 1, // 通过群聊添加
    JGJFriendAddFromContacts,// 通过通讯录添加
    JGJFriendAddFromtTeam, // 通过班组添加
    JGJFriendAddFromProject, // 通过项目添加
    JGJFriendAddFromWorkmateCommunity, // 通过工友圈添加
    JGJFriendAddFromFindJobs, // 通过找活招工添加
    JGJFriendAddFromQRCode, // 通过二维码添加
    JGJFriendAddFromTelephoneSearch, // 通过手机号搜索添加
    JGJFriendAddFromConnection, // 通过人脉关系添加
    JGJFriendAddFromSingleChat // 通过单聊(聊天)添加
};

@interface JGJDataManager : NSObject
/**
 * 好友来源
 */
@property (nonatomic, assign) JGJFriendAddFromType addFromType;

+ (instancetype)sharedManager;
@end

