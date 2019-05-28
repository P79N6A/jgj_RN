//
//  JGJProicloudRootVc.h
//  JGJCompany
//
//  Created by yj on 2017/7/24.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJProicloudRootVc : UIViewController

@property (nonatomic, strong) JGJMyWorkCircleProListModel *proListModel;

//获取点击的目录
@property (strong, nonatomic) JGJProicloudListModel *cloudListModel;

@end
