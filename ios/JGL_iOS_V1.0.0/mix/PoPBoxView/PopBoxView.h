//
//  PopBoxView.h
//  HuDuoDuoCustomer
//
//  Created by Tony on 15/8/26.
//  Copyright (c) 2015年 celion. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopBoxViewDelegate <NSObject>
@optional
/*
 * 取消调用这个接口
 */
-(void)PopBoxViewCancel;

/*
 * 确定调用这个接口
 */
-(void)PopBoxViewConfirm;

@end

@interface PopBoxView : UIView
@property (weak, nonatomic) id<PopBoxViewDelegate> delegate;

#pragma mark - 需要指定view

/**
 * 添加一般的提示框,不修改显示的内容
 */
+ (id)showBoxNormalTo:(UIView *)view delegate:(id)customClass;

/**
 * 添加有小人的提示框,不修改显示的内容
 */
+ (id)showBoxPeopleTo:(UIView *)view delegate:(id)customClass;

/**
 * 添加一般的提示框
 */
+ (id)showBoxNormalTo:(UIView *)view delegate:(id)customClass message:(NSString *)message;

/**
 * 添加一般的提示框
 */
+ (id)showBoxNormalTo:(UIView *)view delegate:(id)customClass message:(NSString *)message cancelButtonTitle:(NSString *)cancelString destructiveButtonTitle:(NSString *)destructiveString;

/**
 * 添加有小人的提示框
 */
+ (id)showBoxPeopleTo:(UIView *)view delegate:(id)customClass message:(id )message;

/**
 * 隐藏提示框
 */
+ (BOOL)hidePopForView:(UIView *)view;

@end
