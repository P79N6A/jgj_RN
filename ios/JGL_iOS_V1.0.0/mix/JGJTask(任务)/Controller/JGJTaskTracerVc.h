//
//  JGJTaskTracerVc.h
//  mix
//
//  Created by yj on 2017/6/1.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JGJGroupChatSelelctedMemberHeadView.h"
typedef enum : NSUInteger {
    
    JGJTaskJoinTracerType = 1, //任务参与者
    
    JGJTaskExecutorTracerType, //执行人
    
    JGJNoticeExecutorTracerType,//通知接收人
    
    JGJLogExecutorTracerType, //日志接收人
    
} JGJTaskTracerType;

@class JGJTaskTracerVc;

@protocol JGJTaskTracerVcDelegate <NSObject>

@optional

- (void)taskTracerVc:(JGJTaskTracerVc *)principalVc didSelelctedMembers:(NSArray *)members;

- (void)taskTracerVc:(JGJTaskTracerVc *)principalVc didSelelctedMembers:(NSArray *)members isSelectedAllMembers:(BOOL)isSelectedAllMembers;

@end

@interface JGJTaskTracerVc : UIViewController

@property (nonatomic, strong) JGJMyWorkCircleProListModel *proListModel;

@property (strong, nonatomic) NSMutableArray *taskTracerModels; //任务追踪者模型

@property (strong, nonatomic) JGJGroupChatSelelctedMemberHeadView *headerView;

@property (assign, nonatomic) BOOL selectedButtonStatus; //选中头部状态按钮的状态

@property (assign, nonatomic) BOOL taskEditeStatus; //选中头部状态按钮的状态

//任务详情参与者
@property (strong, nonatomic) NSArray *joinMembers;

//已经存在的人员
@property (strong, nonatomic) NSArray *existedMembers;

//任务详情存在的参与者 2.3.2任务参与者
@property (assign, nonatomic) JGJTaskTracerType taskTracerType;

@property (weak, nonatomic) id <JGJTaskTracerVcDelegate> delegate;
@end
