//
//  JGJChatClearCacheModel.h
//  mix
//
//  Created by yj on 2018/8/27.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGJChatClearCacheModel : NSObject

@property (nonatomic, assign) NSInteger primary_key;//主键id

@property (nonatomic, copy) NSString *group_id;

@property (nonatomic, copy) NSString *class_type;

@property (nonatomic, copy) NSString *msg_id;

//用户唯一标识
@property (nonatomic, copy) NSString *user_unique;

@end
