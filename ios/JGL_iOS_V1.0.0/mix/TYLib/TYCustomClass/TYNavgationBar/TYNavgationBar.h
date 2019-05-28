//
//  TYNavgationBar.h
//  mix
//
//  Created by Tony on 16/1/8.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYNavgationBar : NSObject
//隐藏NavigationBar
+ (void)hiddenNavigationBarInVc:(UIViewController *)Vc WithColor:(UIColor *)backColor;
//显示NavigationBar
+ (void)showNavigationBarInVc:(UIViewController *)Vc;
@end
