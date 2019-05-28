//
//  UIViewController+isVisible.m
//  mix
//
//  Created by Tony on 2016/9/3.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "UIViewController+isVisible.h"

@implementation UIViewController (isVisible)
-(BOOL)isCurrentViewControllerVisible
{
    return (self.isViewLoaded && self.view.window);
}
@end
