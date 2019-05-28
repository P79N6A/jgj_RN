//
//  JGJTabBarViewController.h
//  mix
//
//  Created by Tony on 2016/8/16.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJWebAllSubViewController.h"

typedef void(^JGJTabBarClickChatBlock)();

@interface JGJTabBarViewController : UITabBarController
<
    UITabBarControllerDelegate
>
@property (nonatomic, assign) SelectedWorkType  workType;//确定类型

@property (nonatomic, strong) NSMutableDictionary *viewControllersDic;

@property (nonatomic, strong) NSMutableArray *vcsArr;//存放vc;

@property (nonatomic, assign) NSInteger selectedIndexVc; //当前选中的控制器

//双击聊聊回顶部回调
@property (nonatomic, copy) JGJTabBarClickChatBlock clickChatBlock;

//主要用于页面消失的时候，是否显示导航栏。这里用于首页切换身份

@property (nonatomic, assign) BOOL is_HiddenNav;

/**
 *  子类设置字典
 */
- (void)subVcSetDic;

/**
 *  检查是否有对应的权限
 *
 *  @return YES:有权限，NO:无权限
 */
- (BOOL )checkIsRight;

/**
 *  检查聊聊对应的权限
 *
 *  @return YES:有权限，NO:无权限
 */
- (BOOL )checkDidSeledtedGroupChatIsRight;

@end
