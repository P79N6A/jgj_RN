//
//  JGJConRecomVc.h
//  mix
//
//  Created by yj on 2018/1/17.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JGJConRecomAddFriendSendSuccessBlock)(id);

@interface JGJConRecomVc : UIViewController

//发送成功回调，刷新按钮状态
@property (nonatomic, copy) JGJConRecomAddFriendSendSuccessBlock sendSuccessBlock;

//是否已查看新朋友
@property (nonatomic, assign) BOOL isCheckFreshFriend;

@end
