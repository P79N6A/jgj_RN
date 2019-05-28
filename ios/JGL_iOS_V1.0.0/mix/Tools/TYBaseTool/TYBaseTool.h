//
//  TYBaseTool.h
//  HuduoduoDebug
//
//  Created by jizhi on 15/6/25.
//  Copyright © 2015年 Tony. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYBaseTool : NSObject

+ (void)setGlobalStatus;

//获取唯一设备号
+(NSString *) getKeychainIdentifier;

//转换高度
+ (CGFloat )transiTionHeight:(CGFloat )height;

+(void)setupGlobalNavTheme;


+(void)setupNavByNarBar:(UINavigationBar *)navBar BybarTintColor:(UIColor *)barTintColor tintColor:(UIColor *)tintColor titleColor:(UIColor *)titleColor;

+ (UIButton *)getLeftButtonByTitle:(NSString *)title titleNormalColor:(UIColor *)titleNormalColor titleHighlightColor:(UIColor *)titleHighlightColor normalImage:(UIImage *)normalImage highlightImage:(UIImage *)highlightImage;

/**
 *  设置本地推送
 *
 *  @param userInfo 传入数据
 */
+ (void)registerLocalNotification:(NSDictionary *)userInfo;

/**
 *  根据推送消息跳转界面
 *
 *  @param navVc    navVc
 *  @param userInfo 传入参数
 */
+ (void)notificationNav:(UINavigationController *)navVc PushToVc:(NSDictionary *)userInfo;
/**
 *  根据推送消息跳转记多天
 *
 *  @param navVc    navVc
 *  @param userInfo 传入参数
 */
+ (void)notificationNav:(UINavigationController *)navVc PushToMoreVc:(NSDictionary *)userInfo;
/**
 *  根据推送消息跳转到通知这些的详情
 *
 *
 *
 */
+ (void)notificationNav:(UINavigationController *)navVc PushToNoticationDetail:(NSDictionary *)userInfo;
@end
