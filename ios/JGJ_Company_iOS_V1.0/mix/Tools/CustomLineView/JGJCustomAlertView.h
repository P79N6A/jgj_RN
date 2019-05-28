//
//  JGJCustomAlertView.h
//  mix
//
//  Created by yj on 16/6/7.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^OnClickedBlock)();
@interface JGJCustomAlertView : UIView
@property (nonatomic, copy) OnClickedBlock onClickedBlock;
@property (weak, nonatomic) IBOutlet UILabel *message;
+ (JGJCustomAlertView *)customAlertViewShowWithMessage:(NSString *)msg;

+ (JGJCustomAlertView *)customAlertViewShowWithTitle:(NSString *)title message:(NSString *)msg titleColor:(UIColor *)titleColor messageColor:(UIColor *)messageColor;

+ (JGJCustomAlertView *)customAlertViewShowWithTitle:(NSString *)title message:(NSString *)msg titleColor:(UIColor *)titleColor messageColor:(UIColor *)messageColor titleFontSize:(CGFloat )titleFontSize messageFontSize:(CGFloat )messageFontSize iknowFontSize:(CGFloat )iknowFontSize;
+ (JGJCustomAlertView *)customAlertViewShowWithMessagecallphone:(NSString *)msg;

//加入变色弹框
+ (JGJCustomAlertView *)customAlertViewShowWithMessage:(NSString *)msg changeColorMsg:(NSString *)changeColorMsg;

- (void)dismiss;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@end
