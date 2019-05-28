//
//  JGJProFilterView.h
//  mix
//
//  Created by yj on 2018/1/3.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JGJBaseMenuView.h"

#import "JGJCusNavBar.h"

typedef void(^JGJProFilterViewBlock)(id);

typedef void(^JGJProFilterViewBackBlock)(void);

@interface JGJProFilterView : UIView

@property (copy, nonatomic) JGJProFilterViewBlock proFilterViewBlock;

//返回按钮
@property (copy, nonatomic) JGJProFilterViewBackBlock backBlock;

//全部的项目
@property (nonatomic, strong) NSArray *allPros;

//默认选中参数
@property (nonatomic, strong) JGJRecordWorkStaListModel *staListModel;

//当前选中的项目
@property (strong, nonatomic) JGJRecordWorkPointFilterModel *selProModel;

//清除选择的项目用
@property (nonatomic, strong, readonly) NSIndexPath *lastIndexPath;

@property (nonatomic, strong, readonly) JGJCusNavBar *cusNavBar;

@end
