//
//  UIViewController+isVisible.h
//  mix
//
//  Created by Tony on 2016/9/3.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (isVisible)
/**
 *  是否是显示的Vc
 *
 *  @return YES,是显示的，NO,不是显示的
 */
-(BOOL)isCurrentViewControllerVisible;
@end
