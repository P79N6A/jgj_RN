//
//  JGJCusNavView.h
//  JGJCompany
//
//  Created by yj on 17/3/29.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJNetWorkingStatusHeaderView.h"
typedef enum : NSUInteger {
    JGJHomeQrcodeButtonType,
    JGJHomeCreatProButtonType,
    JGJHomeSynProButtonType,
    JGJHomeWorkInfoButtonType,
    JGJHomeRecordWorkpointsButtonType //记工报表
} JGJHomeButtonType;

typedef enum : NSUInteger {
    JGJCusNavViewMoreButtonType,
    JGJCusNavViewWorkInfoButtonType
} JGJCusNavViewButtonType;

@class JGJCusNavView;
@protocol JGJCusNavViewDelegate <NSObject>

- (void)customNavViewWithNavView:(JGJCusNavView *)navView didSelectedButtonType:(JGJCusNavViewButtonType)buttonType;

@end

typedef void(^JGJCusNavViewBlock)(void);

@interface JGJCusNavView : UIView

@property (weak, nonatomic) id <JGJCusNavViewDelegate> delegate;
@property (weak, nonatomic, readonly) IBOutlet UIButton *topMoreButton;

@property (strong, nonatomic) JGJWorkCircleMiddleInfoModel *unReadinfoModel; //用于传入未读数

@property (assign, nonatomic) CGFloat cusNavAlpha; //自定义导航栏透明度

@property (copy, nonatomic) JGJCusNavViewBlock cusNavViewBlock;

//设置顶部小铃铛
@property (nonatomic, strong) JGJMyWorkCircleProListModel *proListModel;

// 网络状态headerView
@property (nonatomic, strong) JGJNetWorkingStatusHeaderView *netWorkingHeader;
@property (nonatomic, assign) AFNetworkReachabilityStatus netWorkStatus;
@end
