//
//  JGJCCToolObject.h
//  mix
//
//  Created by Tony on 2018/6/26.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    
    RecommendToOtherAlertType = 0,
    GotoEvaluateAlertType,
    NewUserHelpAlertType
    
} HomeAlertViewType;

@interface JGJCCToolObject : NSObject

+ (void)judgeCountToAlertPopViewWithVC:(UIViewController *)vc dismissBlock:(void(^)())touchUpDismissBlock;

@end
