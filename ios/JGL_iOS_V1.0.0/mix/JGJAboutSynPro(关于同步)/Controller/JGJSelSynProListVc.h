//
//  JGJSelSynProListVc.h
//  mix
//
//  Created by yj on 2018/4/16.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JGJAboutSynProModel.h"

typedef void(^JGJSelSynProListVcBlock)(JGJSelSynProListModel *proModel, NSMutableArray *dataSource);

@interface JGJSelSynProListVc : UIViewController

@property (nonatomic, copy) JGJSelSynProListVcBlock proListVcBlock;

//当前项目
@property (nonatomic, strong) JGJSelSynProListModel *curProModel;

@property (nonatomic, strong) NSMutableArray *dataSource;

//返回的控制器
@property (nonatomic, weak) UIViewController *popTargetVc;
@end
