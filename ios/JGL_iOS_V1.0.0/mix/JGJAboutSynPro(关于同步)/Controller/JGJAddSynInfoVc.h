//
//  JGJAddSynInfoVc.h
//  mix
//
//  Created by yj on 2018/4/16.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJAddSynInfoVc : UIViewController

@property (nonatomic, assign) JGJSyncType syncType;

/** 同步对象 */
@property (nonatomic, strong) JGJNewNotifyModel *notifyModel;

@property (nonatomic, copy) SynSuccessBlock synSuccessBlock;

@end
