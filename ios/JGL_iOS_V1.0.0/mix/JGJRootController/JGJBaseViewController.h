//
//  JGJBaseViewController.h
//  mix
//
//  Created by yj on 2019/3/13.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JGJBaseViewController : UIViewController

//处理动态发现小红点

- (void)handleDynamicDot;

// app启动服务

- (void)appLaunchServiceSuccessBlock:(void (^)(id responseObject))success;

@end

NS_ASSUME_NONNULL_END
