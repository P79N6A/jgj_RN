//
//  JGJAccountShowTypeVc.h
//  mix
//
//  Created by yj on 2018/6/5.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JGJAccountShowTypeView.h"

@interface JGJAccountShowTypeVc : UIViewController

@property (nonatomic, strong) JGJAccountShowTypeModel *selTypeModel;

//传入类型
@property (nonatomic, assign) JGJAccountShowTypeViewType type;

@end
