//
//  JGJFilterAccountMemberHeaderView.h
//  mix
//
//  Created by yj on 2018/1/10.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JGJFilterAccountMemberHeaderViewBlock)(id);

@interface JGJFilterAccountMemberHeaderView : UIView

@property (nonatomic, copy) JGJFilterAccountMemberHeaderViewBlock filterAccountMemberHeaderViewBlock;

//是否选中头部
@property (nonatomic, assign) BOOL isSelHeaderView;

//代理班组长
@property (nonatomic, strong) JGJMyWorkCircleProListModel *proListModel;

@end
