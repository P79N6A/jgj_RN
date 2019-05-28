//
//  JGJJoinGroupVc.h
//  mix
//
//  Created by Tony on 2016/8/23.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJJoinGroupVc : UIViewController

@property (nonatomic, strong) JGJMyWorkCircleProListModel *proListModel;

//直接返回当前页面(我的项目班组扫码、创建班组使用)
@property (nonatomic, strong) UIViewController *popVc;

@end
