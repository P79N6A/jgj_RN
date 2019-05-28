//
//  HomeVC.h
//  mix
//
//  Created by celion on 16/3/22.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UITabBar+JGJTabBar.h"

#import "JGJFeedBackView.h"

@interface HomeVC : UIViewController

@property (nonatomic, copy) NSString *imageName;//顶部图片名字
@property (weak,   nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) JGJMyWorkCircleProListModel *proListModel; //设置当前选中的项目

@property (assign, nonatomic) BOOL isCanScroBottom;

@property (nonatomic, strong) JGJFeedBackView *feedBackView;

//显示动态红点
- (void)showDynamicMsgRed;

@end
