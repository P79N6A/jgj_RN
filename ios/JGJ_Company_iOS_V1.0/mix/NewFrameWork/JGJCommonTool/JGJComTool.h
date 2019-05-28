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

@end
