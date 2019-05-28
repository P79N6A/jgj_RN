//
//  JGJMyChatGroupsNoDataView.h
//  mix
//
//  Created by yj on 2019/3/7.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JGJMyChatGroupsNoDataCreatGroupActionBlock)();

typedef void(^JGJMyChatGroupsNoDataSweepActionBlock)();

NS_ASSUME_NONNULL_BEGIN

@interface JGJMyChatGroupsNoDataView : UICollectionReusableView

//创建班组
@property (nonatomic, copy) JGJMyChatGroupsNoDataCreatGroupActionBlock creatGroupActionBlock;

//扫码
@property (nonatomic, copy) JGJMyChatGroupsNoDataSweepActionBlock sweepActionBlock;

@end

NS_ASSUME_NONNULL_END
