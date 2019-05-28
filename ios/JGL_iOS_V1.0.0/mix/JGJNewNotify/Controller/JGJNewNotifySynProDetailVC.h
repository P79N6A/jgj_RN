//
//  JGJNewNotifySynProDetailVC.h
//  mix
//
//  Created by yj on 16/8/25.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    CreatProDefaultSynType = 0,
    CreatProSynType
} NotifySynProType;
@interface JGJNewNotifySynProDetailVC : UIViewController
@property (nonatomic, strong)  JGJSynBillingModel *synBillingModel;
@property (nonatomic, strong) JGJNewNotifyModel *notifyModel;
@property (assign, nonatomic) NotifySynProType proSynType;
@end
