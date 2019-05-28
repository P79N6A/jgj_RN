//
//  UIButton+JGJUIButton.h
//  mix
//
//  Created by yj on 16/7/19.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (JGJUIButton)
//设置按钮不同状态的颜色
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;
//扩大按钮的 点击区域
- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;

//根据是否有头像显示姓名
- (void)setMemberPicButtonWithHeadPicStr:(NSString *)headPicStr memberName:(NSString  *)memberName memberPicBackColor:(UIColor *)memberPicBackColor;

- (void)setMemberPicButtonWithHeadPicStr:(NSString *)headPicStr memberName:(NSString  *)memberName memberPicBackColor:(UIColor *)memberPicBackColor membertelephone:(NSString *)telephone;


@end