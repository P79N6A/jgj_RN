//
//  JGJMemberFilterView.h
//  mix
//
//  Created by yj on 2018/1/3.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JGJBaseMenuView.h"

#import "JGJFilterAccountMemberHeaderView.h"

#import "JGJCusNavBar.h"

#define MemberDes (JLGisLeaderBool ? @"全部工人" : @"全部班组长")

typedef void(^JGJMemberFilterViewBlock)(id);

typedef void(^JGJProFilterViewBackBlock)(void);

@interface JGJMemberFilterView : UIView

@property (strong, nonatomic) JGJMemberFilterViewBlock memberFilterViewBlock;

//返回按钮
@property (copy, nonatomic) JGJProFilterViewBackBlock backBlock;

//全部的班组长
@property (nonatomic, strong) NSArray *allMembers;

//默认选中参数
@property (nonatomic, strong) JGJRecordWorkStaListModel *staListModel;

//当前选中的人员
@property (strong, nonatomic) JGJSynBillingModel *selMemberModel;

//点击灰色部分清除选择的成员
@property (nonatomic, strong, readonly) NSIndexPath *lastIndexPath;

//清除全部人员
@property (nonatomic, strong) JGJFilterAccountMemberHeaderView *headerView;

//代理班组长
@property (nonatomic, strong) JGJMyWorkCircleProListModel *proListModel;

@property (nonatomic, strong, readonly) JGJCusNavBar *cusNavBar;

- (instancetype)initWithFrame:(CGRect)frame proListModel:(JGJMyWorkCircleProListModel *)proListModel;

@end
