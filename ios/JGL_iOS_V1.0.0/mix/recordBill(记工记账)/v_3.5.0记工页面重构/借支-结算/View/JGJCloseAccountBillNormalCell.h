//
//  JGJCloseAccountBillNormalCell.h
//  mix
//
//  Created by Tony on 2019/1/7.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZGGetBillModel.h"

@interface JGJCloseAccountBillNormalCell : UITableViewCell

@property (nonatomic, assign) BOOL is_Home_ComeIn;// 是否首页进入
@property (nonatomic,assign) BOOL markBillMore;//一天记多人跳转进来
@property (nonatomic, assign) BOOL isAgentMonitor;// 是否为代班长
@property (nonatomic, assign) NSInteger cellTag;

@property (nonatomic,strong) YZGGetBillModel *yzgGetBillModel;

- (void)startTwinkleAnimation;// 文字 箭头闪烁效果动画
- (void)stopTwinkleAnimation;
@end
