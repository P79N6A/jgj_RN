//
//  JGJHelpCenterTitleView.h
//  JGJCompany
//
//  Created by yj on 2017/11/30.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    
    JGJHelpCenterTitleViewQualityType, //质量
    
    JGJHelpCenterTitleViewSafeType, //安全
    
    JGJHelpCenterTitleViewCheckType, //检查
    
    JGJHelpCenterTitleViewTaskType, //任务
    
    JGJHelpCenterTitleViewNotifyType, //通知
    
    JGJHelpCenterTitleViewSignType, //签到
    
    JGJHelpCenterTitleViewLogType, //项目日志
    
    JGJHelpCenterTitleViewGroupLogType,// 班组日志
    
    JGJHelpCenterTitleViewWeatherType, //晴雨表
    
    JGJHelpCenterTitleViewCloudType, //云盘
    
    JGJHelpCenterTitleViewDataBaseType, //资料库
    
    JGJHelpCenterTitleViewRecordBillingType, //记工账单
    
    JGJHelpCenterTitleViewUnWageType, //未结工资
    
    JGJHelpCenterSetAgencyType, //设置代班长
    
} JGJHelpCenterTitleViewType;

typedef void(^JGJHelpCenterTitleViewBlock)(id);

@interface JGJHelpCenterTitleView : UIView

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) BOOL iconHidden;

//帮助中心区分班组项目组
@property (nonatomic, strong) JGJMyWorkCircleProListModel *proListModel;

+(JGJHelpCenterTitleView *)helpCenterTitleView;

//当前页面类型
@property (nonatomic, assign) JGJHelpCenterTitleViewType titleViewType;

@property (nonatomic, copy) JGJHelpCenterTitleViewBlock helpCenterTitleViewBlock;

//直接进入帮助页面
-(JGJHelpCenterTitleView *)helpCenterActionWithTitleViewType:(JGJHelpCenterTitleViewType)titleViewType target:(UIViewController *)target;

@end
