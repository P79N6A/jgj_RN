//
//  JGJPublishTaskVc.h
//  mix
//
//  Created by yj on 2017/5/31.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JLGAddProExperienceViewController.h"

#import "JGJTaskModel.h"

@interface JGJPublishTaskVc : JLGAddProExperienceViewController

@property (nonatomic, strong) JGJMyWorkCircleProListModel *proListModel;

@property (strong, nonatomic) NSMutableArray *taskTracerModels; //任务追踪者模型

@property (strong, nonatomic) NSMutableArray *allTaskTracerModels;//全部任务追踪者模型，用于保存状态

@property (assign, nonatomic) BOOL selectedButtonStatus; //选中头部状态按钮的状态

@property (nonatomic, strong) JGJSynBillingModel *principalModel; //负责人

@property (strong, nonatomic) NSArray *principalModels;//负责人全部模型

@property (strong, nonatomic) NSIndexPath *lastIndexPath; //上次选中的

@property (strong, nonatomic) NSIndexPath *lastLevelIndexPath; //上次选中的严重程度

//完成时间和紧急程度
@property (nonatomic, strong) NSMutableArray *taskTimeLevelModels;

//保存选择紧急程度页面状态
@property (nonatomic, strong) NSArray *taskLevelModels;

- (void)freshIndexSection:(NSInteger)section row:(NSInteger)row;

@end
