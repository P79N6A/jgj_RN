//
//  JGJChatMsgRequestModel.h
//  mix
//
//  Created by yj on 2018/8/27.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGJChatMsgRequestModel : NSObject

@property (nonatomic, copy) NSString *msg_id;

@property (nonatomic, copy) NSString *group_id;

@property (nonatomic, copy) NSString *class_type;

@property (nonatomic, assign) NSInteger pagesize;

@end
