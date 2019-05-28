//
//  JGJQualityTopFilterView.h
//  mix
//
//  Created by yj on 2017/6/8.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    
    TopFilterViewAllType = 0,
    TopFilterViewWaitModifyType,
    TopFilterViewReviewType,
    
    TopFilterViewMyCommitType,
    
    TopFilterViewMyModifyType,
    
    TopFilterViewMyReviewType,
    
    TopFilterViewCusModifyType //自定义修改
    
} TopFilterViewType;

//区分质量、和质量检查检查（安全）
typedef enum : NSUInteger {
    
    TopFilterViewDefaultType, //质量安全
    
    TopFilterViewCheckType //质量安全筛选
    
} TopFilterViewCusCheckType;

typedef void(^TopFilterViewBlock)(TopFilterViewType);

@interface JGJQualityTopFilterView : UIView

@property (nonatomic, copy) TopFilterViewBlock topFilterViewBlock;

//上次选中的类型
@property (nonatomic, assign) TopFilterViewType lastFilterType;

//质量问题
@property (nonatomic, strong) JGJQualitySafeModel *qualitySafeModel;

//质量检查
@property (nonatomic, strong) JGJQuaSafeCheckModel *quaSafeCheckModel;

@property (nonatomic, assign) TopFilterViewCusCheckType topFilterViewCusCheckType;

@end
