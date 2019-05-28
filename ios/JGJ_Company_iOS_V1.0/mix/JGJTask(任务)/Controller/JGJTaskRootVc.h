//
//  JGJTaskRootVc.h
//  mix
//
//  Created by yj on 2017/5/31.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JGJTaskModel.h"

typedef enum : NSUInteger {
    WaitDealTaskType, //待处理
    CompletedTaskType, //已完成
    MyMangeTaskType, //我负责的
    MyJoinTaskType, //我参与的
    MyComitTaskType, //我提交的
} JGJSelTaskType;

@interface JGJTaskRootVc : UIViewController

@property (nonatomic, strong) JGJMyWorkCircleProListModel *proListModel;

//区分质量和安全日志通知等
@property (strong, nonatomic) JGJQualitySafeCommonModel *commonModel;

- (void)freshWaitTask;

@property (nonatomic, assign) JGJSelTaskType taskType;

@end

