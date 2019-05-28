//
//  JGJProiCloudMoveFileVc.h
//  JGJCompany
//
//  Created by yj on 2017/7/25.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJProiCloudMoveFileVc : UIViewController

@property (nonatomic, strong) JGJMyWorkCircleProListModel *proListModel;

//获取点击的目录
@property (strong, nonatomic) JGJProicloudListModel *cloudListModel;

//选择要删除的文件
@property (nonatomic, strong) NSMutableArray *selFiles;

@end
