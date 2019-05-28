//
//  JGJContractorMakeAccountNormalCell.h
//  mix
//
//  Created by Tony on 2019/1/5.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZGGetBillModel.h"

@interface JGJContractorMakeAccountNormalCell : UITableViewCell

@property (nonatomic, assign) BOOL is_Home_ComeIn;// 是否首页进入
@property (nonatomic,assign) BOOL markBillMore;//一天记多人跳转进来
@property (nonatomic, assign) BOOL isAgentMonitor;// 是否为代班长
@property (nonatomic, assign) NSInteger cellTag;

@property (nonatomic,strong) YZGGetBillModel *yzgGetBillModel;

@property (nonatomic, assign) NSInteger subentryAccount;// 分项数量

@property (nonatomic, assign) NSInteger subentryType;// 承包 还是 分包 0 - 承包， 1 - 分包
- (void)startTwinkleAnimation;// 文字 箭头闪烁效果动画
- (void)stopTwinkleAnimation;
@end

