//
//  JGJMemeberMangerDetailVc.h
//  mix
//
//  Created by yj on 2018/4/18.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJMemeberMangerDetailVc : UIViewController

@property (nonatomic, strong) JGJSynBillingModel *memberModel;

//是否需要刷新
@property (nonatomic, assign) BOOL isFresh;

@end
