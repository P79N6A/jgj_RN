//
//  JGJQuaSafeTool.h
//  JGJCompany
//
//  Created by yj on 2017/7/22.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    
    JGJQuaSafeToolQuaClassType, //质量
    
    JGJQuaSafeToolSafeClassType //安全

} JGJQuaSafeToolClassType;

@interface JGJQuaSafeToolReplyModel : NSObject

//项目id
@property (nonatomic, copy) NSString *group_id;

//当前类型
@property (nonatomic, copy) NSString *class_type;

//当前类型独立信息id 质量的id, 安全的id
@property (nonatomic, copy) NSString *unique_id;

//收藏的消息
@property (nonatomic, strong) NSArray *colInfos;

//发布或者回复的消息
@property (nonatomic, copy) NSString *replyText;

//质量安全的模块之类
@property (nonatomic, copy) NSString *subClassType;
@end

@interface JGJQuaSafeTool : NSObject


/**
 *  收藏一个信息
 */
+ (BOOL)addCollectReplyModel:(JGJQuaSafeToolReplyModel *)replyModel;

/**
 *  取消收藏一个信息
 */
+ (BOOL)removeCollecReplyModel:(JGJQuaSafeToolReplyModel *)replyModel;

/**
 *  消息是否收藏
 */

+ (BOOL)isExistReplyModel:(JGJQuaSafeToolReplyModel *)replyModel;

/**
 *  返回查到的数据
 */
+ (JGJQuaSafeToolReplyModel *)replyModel:(JGJQuaSafeToolReplyModel *)replyModel;

/**
 *  更新数据
 */
+ (BOOL)updateReplyModel:(JGJQuaSafeToolReplyModel *)replyModel;

/**
 *删表
 */
+ (BOOL)deleteTable;

/**
 *  点击的地址 点击地址的View（获取当前控制器） target当前控制，push使用。curView和target有一个就可以
 */
+ (void)linkHandlerWithLinkUrl:(NSString *)linkUrl  curView:(UIView *)curView target:(UIViewController *)target;
@end
