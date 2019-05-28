//
//  JGJComTool.h
//  mix
//
//  Created by yj on 2018/1/26.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGJComTool : NSObject

+ (instancetype)showCloseProImageViewWithTargetView:(UIView *)targetView classtype:(NSString *)classtype isClose:(BOOL)isClose;

//关闭的项目提示
+ (void)showCloseProPopViewWithClasstype:(NSString *)classtype;

+ (void)changeRoleWithType:(NSInteger)roleType successBlock:(void(^)())successBlock;

+ (CABasicAnimation *)opacityForever_Animation:(float)time; //永久闪烁的动画
@end
