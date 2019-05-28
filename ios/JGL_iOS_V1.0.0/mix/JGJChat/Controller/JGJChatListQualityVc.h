//
//  JGJChatListQualityVc.h
//  mix
//
//  Created by Tony on 2016/8/30.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatListBaseVc.h"

@interface JGJChatListQualityVc : JGJChatListBaseVc

//区分质量和安全
@property (strong, nonatomic) JGJQualitySafeCommonModel *commonModel;

@property (nonatomic, strong) JGJMyWorkCircleProListModel *proListModel;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *quaityConstance;

//类型使用
@property (nonatomic, strong) JGJQualitySafeListRequestModel *requestModel;

//筛选类型
@property (nonatomic, assign) QuaSafeFilterType filterType;

//是否刷新列表
@property (nonatomic, assign) BOOL isFreshTabView;

//刷新列表
- (void)freshTableView;

//子类获取数据
- (void)subLoadNetData;

@end
