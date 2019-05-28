//
//  CLCTCCUIConfigure.h
//  CL_ShanYanSDK
//
//  Created by wanglijun on 2018/10/30.
//  Copyright © 2018 wanglijun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//电信配置
@interface CLCTCCUIConfigure : NSObject
//要拉起授权页的vc(注：SDK不持有接入方VC)
@property (nonatomic,weak)UIViewController * viewController;
//viewController/navigationController至少传一个
//要拉起授权页的导航,（如果为空则使用viewController present方式弹出授权页）
@property (nonatomic,weak)UINavigationController * navigationController;
//LOGO图片,可选
@property (nonatomic,strong)UIImage * logoImg;
/**
 是否隐藏 其他登录方式按钮，默认显示  隐藏：YES 显示：NO ,可选
 “其他登录方式”按钮显示时需在拉起授权页面添加回调方法:
 -(void)otherLoginWayBtnCliced:(UIButton *)sender{}
 */
@property (nonatomic, assign) BOOL otherWayHidden;


@end


//移动配置
@interface CLCMCCUIConfigure : NSObject
//调一键登录的vc,必传(注：SDK不持有接入方VC)
@property (nonatomic,weak)UIViewController * viewController;
//LOGO图片,可选
@property (nonatomic,strong) UIImage * logoImg;
/**
 是否隐藏 其他登录方式按钮  隐藏：YES 显示：NO  ,可选
 是否隐藏 其他登录方式按钮，默认显示  隐藏：YES 显示：NO ,可选
 “其他登录方式”按钮显示时需在拉起授权页面添加回调方法:
 -(void)otherLoginWayBtnCliced:(UIButton *)sender{}
 */
@property (nonatomic, assign) BOOL otherWayHidden;



@end


//联通配置
@interface CLCUCCUIConfigure : NSObject
//调一键登录的vc,必传(注：CL_ShanYanSDK不持有联通授权页VC)
@property (nonatomic,weak)UIViewController * viewController;
/**LOGO图片*/
@property (nonatomic,strong)UIImage *  UAPageContentLogo;
/**
 是否隐藏 其他登录方式按钮  隐藏：YES 显示：NO  ,可选
 是否隐藏 其他登录方式按钮，默认显示  隐藏：YES 显示：NO ,可选
 “其他登录方式”按钮显示时需在拉起授权页面添加回调方法:
 -(void)otherLoginWayBtnCliced:(UIButton *)sender{}
 */
@property (nonatomic, assign) BOOL otherWayHidden;



@end

NS_ASSUME_NONNULL_END
