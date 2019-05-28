//
//  JGJLogoutPopView.h
//  mix
//
//  Created by yj on 2018/1/11.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JGJLogoutPopViewBlock)(NSString *verCode);

typedef void(^JGJLogoutPopViewOkBlock)(void);

@interface JGJLogoutPopView : UIView

@property (copy, nonatomic) JGJLogoutPopViewBlock logoutPopViewBlock;

//确定按钮按下
@property (copy, nonatomic) JGJLogoutPopViewOkBlock logoutPopViewOkBlock;

//显示弹框
- (void)showPopView;

@end
