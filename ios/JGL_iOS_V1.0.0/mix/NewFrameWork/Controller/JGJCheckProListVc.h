//
//  JGJCheckProListVc.h
//  mix
//
//  Created by YJ on 17/4/22.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HandleSelProModelBlock)(JGJMyWorkCircleProListModel *);

@interface JGJCheckProListVc : UIViewController

@property (nonatomic, copy) HandleSelProModelBlock handleSelProModelBlock;

@property (strong, nonatomic) JGJMyWorkCircleProListModel *proListModel; //设置当前选中的项目

@end
