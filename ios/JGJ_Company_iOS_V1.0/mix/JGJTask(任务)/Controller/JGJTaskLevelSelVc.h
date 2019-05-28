//
//  JGJTaskLevelSelVc.h
//  mix
//
//  Created by yj on 2017/6/5.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJTaskModel.h"
typedef enum : NSUInteger {
    
    JGJTaskLevelSelUrgeType, //发布任务紧急类型
    
    JGJTaskLevelSelSeriousType, //发布严重程度
    
    JGJTaskLevelFilterSeriousType, //筛选严重程度，质量安全使用
    
    JGJTaskLevelStatusType, //问题状态
    
    JGJTaskLevelTimelyModifyType, //及时整改
    
    JGJTaskLevelCheckStatusType, //检查状态类型
    
    JGJTaskLevelRectMsgTypeType //整改类型
    
} JGJTaskLevelSelType;

@class JGJTaskLevelSelVc;

@protocol JGJTaskLevelSelVcDelegate <NSObject>

@optional

- (void)taskLevelSelVc:(JGJTaskLevelSelVc *)levelSelVc selectedIndexPath:(NSIndexPath *)indexPath selectedModel:(JGJTaskLevelSelModel *)selModel;

@end

@interface JGJTaskLevelSelVc : UIViewController

//传入类型区分数据源
@property (nonatomic, assign) JGJTaskLevelSelType levelSelType;

//上次选中数据
@property (strong, nonatomic) NSIndexPath *lastIndexPath;

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, weak) id <JGJTaskLevelSelVcDelegate> delegate;

//选中的等级
@property (nonatomic, copy) NSString *selLevel;

@end
