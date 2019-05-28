  //
//  PopBox_NormalView.h
//  HuDuoDuoCustomer
//
//  Created by Tony on 15/8/26.
//  Copyright (c) 2015年 celion. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopBoxNormalViewDelegate <NSObject>
@optional
/*
 * 取消调用这个接口
 */
-(void)PopBoxNormalViewCancel;

/*
 * 确定调用这个接口
 */
-(void)PopBoxNormalViewConfirm;

@end

@interface PopBox_NormalView : UIView
@property (weak, nonatomic) id<PopBoxNormalViewDelegate> delegate;

//设置显示的内容
- (void)setPopBoxNormalMessage:(NSString *)message cancelButtonTitle:(NSString *)cancelString destructiveButtonTitle:(NSString *)destructiveString;
@end