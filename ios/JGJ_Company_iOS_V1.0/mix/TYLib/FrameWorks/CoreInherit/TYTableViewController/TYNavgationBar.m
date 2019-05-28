//
//  TYNavgationBar.m
//  mix
//
//  Created by Tony on 16/1/8.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "TYNavgationBar.h"

@implementation TYNavgationBar

+ (void)hiddenNavigationBarInVc:(UIViewController *)Vc{
    UIView *topView = [Vc.view viewWithTag:MAX_CANON];
    if (topView) {
        return;
    }
    
    //先隐藏再添加
    [Vc.navigationController setNavigationBarHidden:YES animated:YES];
    topView = [[UIView alloc] initWithFrame:SetRect(0, 0, GetUIScreenWidth, 20)];
    topView.tag = MAX_CANON;
#if 1
    topView.backgroundColor = JLGBlueColor;
#else
    topView.backgroundColor = [UIColor redColor];
#endif
    [Vc.view addSubview:topView];
}

+ (void)showNavigationBarInVc:(UIViewController *)Vc{
    UIView *topView = [Vc.view viewWithTag:MAX_CANON];
    if (topView) {
        //先去掉topView再显示
        [topView removeFromSuperview];
        [Vc.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

@end
