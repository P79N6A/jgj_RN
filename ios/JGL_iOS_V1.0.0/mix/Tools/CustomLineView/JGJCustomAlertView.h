//
//  JGJCustomAlertView.h
//  mix
//
//  Created by yj on 16/6/7.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^OnClickedBlock)();
typedef void(^TouchDismissBlock)();
@interface JGJCustomAlertView : UIView
@property (nonatomic, copy) OnClickedBlock onClickedBlock;
@property (nonatomic, copy) TouchDismissBlock touchDismissBlock;

@property (weak, nonatomic) IBOutlet UILabel *message;
+ (JGJCustomAlertView *)customAlertViewShowWithMessage:(NSString *)msg;

+ (JGJCustomAlertView *)customAlertViewShowWithTitle:(NSString *)title message:(NSString *)msg titleColor:(UIColor *)titleColor messageColor:(UIColor *)messageColor;

+ (JGJCustomAlertView *)customAlertViewShowWithTitle:(NSString *)title message:(NSString *)msg titleColor:(UIColor *)titleColor messageColor:(UIColor *)messageColor titleFontSize:(CGFloat )titleFontSize messageFontSize:(CGFloat )messageFontSize iknowFontSize:(CGFloat )iknowFontSize;
+ (JGJCustomAlertView *)customAlertViewShowWithMessagecallphone:(NSString *)msg;

+ (JGJCustomAlertView *)customAlertViewShowWithMessage:(NSString *)msg changeColorMsg:(NSString *)changeColorMsg;

//返回JGJCustomAlertView自定义添加
+ (JGJCustomAlertView *)showMessageWithMsg:(NSString *)msg;

- (void)dismiss;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containViewHeight;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIView *contentLineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertViewCenterY;

@end
