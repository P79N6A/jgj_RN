//
//  JGJVideoListVc.h
//  mix
//
//  Created by yj on 2018/3/23.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJVideoListCell.h"

#import "JGJWebAllSubViewController.h"

typedef void(^JGJNavHiddenBlock)();

@interface JGJVideoListVc : UIViewController

@property (nonatomic, strong) JGJVideoListModel *listModel;

//视频评论
@property (nonatomic, copy) WVJBResponseCallback responseCallback;

//导航栏回调先隐藏
@property (nonatomic, copy) JGJNavHiddenBlock navHiddenBlock;
@end
