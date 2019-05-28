//
//  JGJCheckAccountModulesView.h
//  mix
//
//  Created by yj on 2018/8/23.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    
    JGJCheckFlowButtontype, //记工流水
    
    JGJCheckStaButtontype, //记工统计
    
    JGJCheckUnCloseButtontype,//未结工人工资
    
    JGJCheckAccountButtontype //我要对账
    
} JGJCheckAccountModulesButtontype;

@class JGJCheckAccountModulesView;

@protocol JGJCheckAccountModulesViewDelegate <NSObject>

@optional

- (void)checkAccountModulesView:(JGJCheckAccountModulesView *)modulesView buttontype:(JGJCheckAccountModulesButtontype)buttonType;

@end

@interface JGJCheckAccountModulesView : UIView

@property (nonatomic, weak) id <JGJCheckAccountModulesViewDelegate> delegate;

@property (strong, nonatomic) JGJHomeWorkRecordTotalModel *recordTotalModel;

@end
