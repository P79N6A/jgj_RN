//
//  JGJWebUnSeniorPayVc.h
//  JGJCompany
//
//  Created by yj on 2017/8/24.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    
    JGJWebUnSeniorPayVcDefaultType,
    
    JGJWebUnSeniorPayVcEquipmentType, //设备
    
    JGJWebUnSeniorPayVcQualityCheckType, //质量检查
    
    JGJWebUnSeniorPayVcQualityStaType, //质量统计
    
    JGJWebUnSeniorPayVcSafeCheckType, //安全检查
    
    JGJWebUnSeniorPayVcSafeStaType, //安全统计
    
    JGJWebUnSeniorPayVcCheckType //检查
    
} JGJWebUnSeniorPayVcType;

typedef void(^WebUnSeniorPayVcBlock)(id);

@interface JGJWebUnSeniorPayVc : UIViewController

@property (nonatomic, strong) JGJMyWorkCircleProListModel *proListModel;

@property (nonatomic, copy) WebUnSeniorPayVcBlock webUnSeniorPayVcBlock;

@property (nonatomic, assign) JGJWebUnSeniorPayVcType webUnSeniorPayVcType;
@end
