//
//  JGJTaskPrincipalVc.h
//  mix
//
//  Created by yj on 2017/6/1.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    JGJMemberSelPerformerType, //选择执行者
    
    JGJMemberSelPrincipalType, //质量安全整改负责人
    
    JGJMemberFilterRecirdMemeberType, //筛选记录整改负责人
    
    JGJMemberCommitMemeberType, //质量安全问题提交人
    
    JGJMemberUndertakeMemeberType, //质量负责人
    
    JGJQualityDetailModifyMemeberType, //质量详情整改负责人
    
    JGJMemberCheckExecMemeberType, //质量检查执行人
    
    JGJMemberCheckPlanCommitMemeberType, //质量检查计划提交人
    
    JGJModifyTaskPrincipalType, //修改任务负责人
    
    JGJPubCheckPlanSelMemberType, //发布检查计划选择负责人
    
    JGJRectNotifySelMemberType, //整改通知负责人
    
    JGJAgencySelMemberType //代理班组长

} JGJMemberSelType;

@class JGJTaskPrincipalVc;

@protocol JGJTaskPrincipalVcDelegate <NSObject>

@optional

- (void)taskPrincipalVc:(JGJTaskPrincipalVc *)principalVc didSelelctedMemberModel:(JGJSynBillingModel *)memberModel;

@end

@interface JGJTaskPrincipalVc : UIViewController

@property (nonatomic, strong) JGJMyWorkCircleProListModel *proListModel;

@property (nonatomic, strong) NSArray *principalModels;

@property (strong, nonatomic) NSIndexPath *lastIndexPath; //上次选中的负责人位置

@property (assign, nonatomic) JGJMemberSelType memberSelType;//人员类型

@property (nonatomic, strong) JGJSynBillingModel *principalModel; //负责人

@property (weak, nonatomic) id <JGJTaskPrincipalVcDelegate> delegate;

//存储当前排序数据
@property (strong, nonatomic) NSArray *cacheSortContactsModels;
@end
